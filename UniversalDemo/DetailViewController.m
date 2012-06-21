/*
 DetailViewController.m
 UniversalDemo

 Created by Beverly S Hill on 8/29/11.
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

#import "DetailViewController.h"
#import "UrlEntryViewController.h"

@interface DetailViewController()
@property (nonatomic) BOOL success;
@end

@implementation DetailViewController

@synthesize detailItem = detailItem_;
@synthesize masterPopoverController = masterPopoverController_;
@synthesize webView = webView_;
@synthesize managedObject = managedObject_;
@synthesize managedObjectContext = managedObjectContext_;
@synthesize success = success_;
@synthesize valid = valid_;
@synthesize back = back_;
@synthesize forward = forward_;
@synthesize reload = reload_;
@synthesize stop = stop_;

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
    if (self.masterPopoverController != nil) 
    {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }  
    // Update the view.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) 
    {
        [self configureView];   
    }
}

/**
 Parse the specified URL value and append http:// if necessary, and 
 request the web page
 */
- (void)loadAddress
{
    NSString *processTxt = [NSString stringWithFormat:@"%@",
                            [self.detailItem valueForKey:
                             NSLocalizedString(@"urlName", @"urlName")]];
    NSURL* url = [NSURL URLWithString:processTxt];
    // check url scheme for leading http://
    if(!url.scheme)
    {
        // append http:// if necessary
        NSString* modifiedURLString = [NSString stringWithFormat:
                                       NSLocalizedString(@"loadPrefix", 
                                                         @"loadPrefix"), url];
        url = [NSURL URLWithString:modifiedURLString];
    }
    // make the NSURL request
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    self.valid.hidden=YES;
    [self.webView loadRequest:request];
}

/**
 Update the user interface for the detail item.
 */
- (void)configureView
{
    if (self.detailItem) 
    {
        // if the url name isn't blank, load the web page
        if ([self.detailItem valueForKey:
             NSLocalizedString(@"urlName", @"urlName")] != nil) 
        {
            [self loadAddress];
        }
    }
}

/**
 Sent after a web view starts loading content
 */
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // started loading, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // enable/disable browser buttons
    [self configureButtons];
    [self disableReloadButton];
}

/**
 Sent after a web view finishes loading a frame.
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self validWebView];
    // completed loading, remove the activity indicator from the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([self success]==YES) 
    {
        // enable the refresh button since a web page has successfully loaded
        [self enableReloadButton];
    }
    else
    {
        // disable the refresh button since a web page has 
        // not successfully loaded
        [self disableReloadButton];
    }
}

/**
 Actions taken when web view completed loading content
 */
-(void)validWebView
{
    self.success = YES;
    self.valid.hidden=YES;
    self.webView.hidden=NO;
    // enable/disable browser buttons
    [self configureButtons];
}

/**
 Sent if a web view failed to load content
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self invalidWebView:error];
    // completed loading, remove the activity indicator from the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self disableReloadButton];
}

/**
 Actions taken when web view failed to load content
 */
-(void)invalidWebView:(NSError *)error
{
    // failure loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // set the success to NO since the web page didn't load properly
    self.success = NO;
    // enable/disable browser buttons
    [self configureButtons];
    self.valid.hidden=NO;
    self.webView.hidden=YES;
    [self.valid setText:[[NSString alloc] initWithFormat:
                         NSLocalizedString(@"webLoadFailure", 
                                           @"webLoadFailure"), 
                         [error localizedDescription]]];
}

#pragma mark - View lifecycle

/**
 Called after the controller’s view is loaded into memory
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
    if (![[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) 
    {
        [self configureView];   
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
}

/**
 Notifies the view controller that its view is about to be dismissed, 
 covered, or otherwise hidden from view.
 */
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

/**
 Notifies the view controller that its view was dismissed, covered, 
 or otherwise hidden from view.
 */
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/**
 Returns a Boolean value indicating whether the view controller supports the 
 specified orientation.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } 
    else 
    {
        return YES;
    }
}

/**
 Notifies the view controller that a segue is about to be performed.
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAddUrl"]) 
    {
        if (self.masterPopoverController) 
        {
            // Popover still visible. Hide it
            [self.masterPopoverController dismissPopoverAnimated:YES];
        }
        NSManagedObject *selectedObject = [self detailItem];
        [[segue destinationViewController] setDetailItem:selectedObject];
        [[segue destinationViewController] setManagedObject:self.managedObject];
        [[segue destinationViewController] setManagedObjectContext:
                                           self.managedObjectContext];
    }
}

/**
 Sent to the view controller when the application receives a memory warning.
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Split view

/**
 Tells the delegate that the specified view controller is about to be hidden.
 */
- (void)splitViewController:(UISplitViewController *)splitController 
     willHideViewController:(UIViewController *)viewController 
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Url List", @"Url List");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

/**
 Tells the delegate that the specified view controller is about to be 
 shown again.
 */
- (void)splitViewController:(UISplitViewController *)splitController 
     willShowViewController:(UIViewController *)viewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, 
    // invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - Webview Navigation

/**
 Loads the previous location in the back-forward list
 */
-(IBAction)goBack:(id)sender
{
    [self.webView goBack]; 
    self.success=YES;
}

/**
 Loads the next location in the back-forward list
 */
-(IBAction)goForward:(id)sender
{
    [self.webView goForward];
    self.success=YES;
}

/**
 Reloads the current page
 */
-(IBAction)reload:(id)sender
{
    [self.webView reload];
    self.success=YES;
}

/**
 Stops the loading of any web content managed by the receiver
 */
-(IBAction)stop:(id)sender
{
    [self.webView stopLoading];
    [self configureButtons];
    self.success=NO;
    [self enableReloadButton];
}

/**
 Sets enabling/disabling of back, forward, and stop buttons
 */
-(void)configureButtons
{
    self.back.enabled = self.webView.canGoBack;
    self.forward.enabled = self.webView.canGoForward;
    self.stop.enabled = self.webView.isLoading;
}

/**
 Enable the web reload button
 */
- (void)enableReloadButton
{
    self.reload.enabled = YES;
}

/**
 Disable the web reload button
 */
- (void)disableReloadButton
{
    self.reload.enabled = NO;
}
@end
