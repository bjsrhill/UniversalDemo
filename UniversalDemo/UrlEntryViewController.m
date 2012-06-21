/*
 UrlEntryViewController.m
 UniversalDemo

 Created by Beverly S Hill on 10/2/11.
 Copyright (c) 2012 Beverly S Hill. All rights reserved.
 
 This work is being made available under a Creative Commons
 Attribution license: http://creativecommons.org/licenses/by/3.0/
 
 You are free to use this work and any derivatives of this work in
 personal and/or commercial products and projects as long as the above
 copyright is maintained and the original author is attributed.
 
 The is experimental software and is provided "as is", without warranty of 
 any kind, express or implied, including, but not limited to, the warranties of
 merchantability, fitness for a particular purpose or non-infringement.
 In no event shall the authors be held liable for any claim, damages or
 other liability arising from the use of the software.
*/

#import "UrlEntryViewController.h"

@implementation UrlEntryViewController

@synthesize referenceUrl = referenceUrl_;
@synthesize referenceTitle = referenceTitle_;
@synthesize referenceNote = referenceNote_;
@synthesize managedObject = managedObject_;
@synthesize managedObjectContext = managedObjectContext_;
@synthesize detailItem = detailItem_;
@synthesize save = save_;
@synthesize cancel = cancel_;
@synthesize urlButtonForNew = urlButtonForNew_;
@synthesize urlNewButton = urlNewButton_;
@synthesize toolbar = toolbar_;

// TODO: Check for existence of url's in save
#pragma mark -

#pragma mark - Managing the detail item

/**
 Set the item that displays on the detail view
 */
- (void)setDetailItem:(id)newDetailItem
{
    if (detailItem_ != newDetailItem) 
    {
        detailItem_ = newDetailItem;
    }
}

#pragma mark - View lifecycle

/**
 Called after the controller’s view is loaded into memory.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // If this is an edited record, show existing values
    if ([self.managedObject valueForKey:
         NSLocalizedString(@"urlName", @"urlName")] != nil && 
        [self.managedObject valueForKey:
         NSLocalizedString(@"urlName", @"urlName")] != @"") 
    {
        [self.referenceUrl setText:[self.managedObject 
                                    valueForKey:
                                    NSLocalizedString(@"urlName", 
                                                      @"urlName")]];
        [self.referenceTitle setText:[self.managedObject 
                                      valueForKey:
                                      NSLocalizedString(@"urlTitle", 
                                                        @"urlTitle")]];
        [self.referenceNote setText:[self.managedObject 
                                     valueForKey:
                                     NSLocalizedString(@"urlNote", 
                                                       @"urlNote")]];
    }
    // If this is not an existing record, set placeholders
    else
    {
        [self.referenceUrl setPlaceholder:
         NSLocalizedString(@"enterURL", @"enterURL")];
        [self.referenceTitle setPlaceholder:
         NSLocalizedString(@"enterTitle", @"enterTitle")];
        // New button is not needed since there is not an existing record
        [self removeNewButton];
    }
}

/**
 Removes New button from toolbar or navigation bar
 */
-(void)removeNewButton
{
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.toolbar.items];
    if (items.count >= 2) 
    {
        [items removeObjectAtIndex:2];
        [self.toolbar setItems:items animated:YES];
    }
    else
    {
        self.urlButtonForNew.hidden = TRUE;
    }
}

/**
 Called when the controller’s view is released from memory.
 */
- (void)viewDidUnload
{
    [super viewDidUnload];
}

/**
 Notifies the view controller that its view is about to be become visible.
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

/**
 Notifies the view controller that its view was added to a window.
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.referenceTitle becomeFirstResponder];
}

/**
 Notifies the view controller that its view is about to be dismissed, covered, 
 or otherwise hidden from view.
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

/**
 Notifies the view controller that its view was dismissed, covered, or 
 otherwise hidden from view.
 */
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

/**
 Returns a Boolean value indicating whether the view controller supports the 
 specified orientation.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == 
        UIUserInterfaceIdiomPhone) 
    {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } 
    else 
    {
        return YES;
    }
}

/**
 Sent to the view controller when the application receives a memory warning.
 */
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Save, New and Cancel methods

/**
 Action to cancel the reference entry popup or view controller
 */
-(IBAction)urlCancel:(id)sender
{
    [self.managedObjectContext rollback];
    if (self.navigationController) 
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
       [self dismissModalViewControllerAnimated:YES];
    }
}

/**
 Action to clear values for add
 */
-(IBAction)urlNew:(id)sender
{
    [self.referenceUrl setText:nil];
    [self.referenceTitle setText:nil];
    [self.referenceNote setText:nil];
    [self.referenceUrl setPlaceholder:
     NSLocalizedString(@"enterURL", @"enterURL")];
    [self.referenceTitle setPlaceholder:
     NSLocalizedString(@"enterTitle", @"enterTitle")];
    self.managedObject=nil;
}

/**
 Action to save a url entry
 */
-(IBAction)urlSave:(id)sender
{
    // Create a new instance of the entity managed by the fetched results 
    // controller.
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:
                                   NSLocalizedString(@"referenceUrl", 
                                                     @"referenceUrl")
                                   inManagedObjectContext:context];
    // see if this is a new object, or one to edit
    if (self.managedObject == nil) 
    {
        NSManagedObject *nManagedObject = 
        [NSEntityDescription insertNewObjectForEntityForName:[entity name] 
                                      inManagedObjectContext:context];
        // If appropriate, configure the new managed object.
       [self configureManagedObject:nManagedObject];
    }
    // there is a record to be edited, so put the current values into 
    // the managed object
    else
    {
        // first check to see if the url name has been changed. if so, 
        // need to check for exists
        if (![[self.managedObject valueForKey:
               NSLocalizedString(@"urlName", @"urlName")] 
              isEqualToString:[self.referenceUrl text]]) 
        {
            // Check for existence of url names in the database
            // configure the managed object.
            [self configureManagedObject:self.managedObject];
        }
        // url name hasn't changed, so update the managed object
        else
        {
            // configure the managed object.
            [self configureManagedObject:self.managedObject];
        }
    }
    NSError *error=nil;
    if (![context save:&error]) 
	{
        NSString *message = nil;
        NSArray* detailedErrors = [[error userInfo] 
                                   objectForKey:NSDetailedErrorsKey];
        if(detailedErrors != nil && [detailedErrors count] > 0) 
        {
            NSString *tempMessage;
            for(NSError* detailedError in detailedErrors) 
            {
                tempMessage=[[detailedError userInfo] 
                             valueForKey:
                             NSLocalizedString(@"errorString", @"errorString")];
                if (tempMessage != nil) 
                {
                    message=tempMessage;
                    [self.managedObjectContext rollback];
                    [self validationErrorAlert:message];
                }   
            }
        }
        else
        {
            NSDictionary *userInfo = [error userInfo];
            message = [userInfo valueForKey:
                       NSLocalizedString(@"errorString", @"errorString")];
            [self.managedObjectContext rollback];
            [self validationErrorAlert:message];
        }
    }
    // save succeeded
    else
    {
        if (self.navigationController) 
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}

/**
 Sets managed object with values from the input text fields
 */
-(void)configureManagedObject:(NSManagedObject *)mo
{
    if (self.referenceUrl) 
    {
        [mo setValue:[self.referenceUrl text] forKey:
         NSLocalizedString(@"urlName", @"urlName")];
    }
    if (self.referenceTitle) 
    {
        [mo setValue:[self.referenceTitle text] forKey:
         NSLocalizedString(@"urlTitle", @"urlTitle")];
    }
    if (self.referenceNote) 
    {
        [mo setValue:[self.referenceNote text] forKey:
         NSLocalizedString(@"urlNote", @"urlNote")];
    }
}

#pragma mark -
#pragma mark Alert methods

/**
 Alert for validation errors
 */
-(void)validationErrorAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:
                          NSLocalizedString(@"validationError", 
                                            @"Validation Error") 
                                                    message:message 
                                                   delegate:self 
                                          cancelButtonTitle:
                          NSLocalizedString(@"cancelLabel", 
                                            @"cancelLabel")  
                                          otherButtonTitles:
                          NSLocalizedString(@"changeLabel", 
                                            @"changeLabel"), nil];
    [alert show];
    return;
}

/**
 Alert delegation
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (buttonIndex == [alertView cancelButtonIndex]) 
	{
        [self urlCancel:self];
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

/**
 Asks the delegate if the text field should process the pressing of the 
 return button.
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return NO;
}
@end
