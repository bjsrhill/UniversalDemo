/*
 MasterViewController.m
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

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ReferenceUrl.h"

@implementation MasterViewController

@synthesize detailViewController = detailViewController_;
@synthesize fetchedResultsController = fetchedResultsController_;
@synthesize managedObjectContext = managedObjectContext_;
@synthesize urlEntryViewController = urlEntryViewController_;

#pragma mark - View lifecycle

/**
 Called after the controller’s view is loaded into memory.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detailViewController = (DetailViewController *)
    [[self.splitViewController.viewControllers lastObject] topViewController];
    NSManagedObjectContext *context = 
    [self.fetchedResultsController managedObjectContext];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSManagedObject *selectedObject = 
    [[self fetchedResultsController] objectAtIndexPath:indexPath];
    self.detailViewController.managedObjectContext=context;
    self.detailViewController.managedObject=selectedObject;
    // Set up the edit button.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
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
    // Return YES for supported orientations
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
 Prepares the receiver for service after it has been loaded from an Interface 
 Builder archive, or nib file.
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) 
    {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
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

/**
 Notifies the view controller that a segue is about to be performed.
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSManagedObjectContext *context = 
    [self.fetchedResultsController managedObjectContext];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSManagedObject *selectedObject = [[self fetchedResultsController] 
                                       objectAtIndexPath:indexPath];
    if ([[segue identifier] isEqualToString:@"addUrl"] || 
        [[segue identifier] isEqualToString:@"detailUrl"] ) 
    {
        [[segue destinationViewController] setManagedObjectContext:context];
        [[segue destinationViewController] setManagedObject:selectedObject];
        self.detailViewController.managedObject=selectedObject;
        [[segue destinationViewController] setDetailItem:selectedObject];
    }
}

#pragma mark - Table configuration

/**
Asks the data source to return the number of sections in the table view.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

/**
 Tells the data source to return the number of rows in a given section of a 
 table view. (required)
 */
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = 
    [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

/**
 Asks the data source for a cell to insert in a particular location of the table
 view. (required)
 */
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:
                UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

/**
 Tells the delegate that the specified row is now selected
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) 
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        NSManagedObject *selectedObject = [[self fetchedResultsController] 
                                           objectAtIndexPath:indexPath];
        self.detailViewController.detailItem = selectedObject;
        self.detailViewController.managedObject = selectedObject;
        self.detailViewController.managedObjectContext = 
        self.managedObjectContext;
    }
}

/**
 Asks the data source to commit the insertion or deletion of a specified row in 
 the receiver.
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = 
        [self.fetchedResultsController managedObjectContext];
        NSManagedObject *currentObject = 
        [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSManagedObject *selectedObj = self.detailViewController.managedObject;
        if(currentObject == selectedObj)
        {
            self.detailViewController.managedObject = nil;
        }
        [context deleteObject:[self.fetchedResultsController 
                               objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) 
        {
            // Handle error.
			UIAlertView *alertView = [[UIAlertView alloc] 
                                      initWithTitle:
                                      NSLocalizedString(@"errorCommitingChanges",
                                                        @"errorCommitingChanges")  
                                      message:nil delegate:nil 
                                      cancelButtonTitle:
                                      NSLocalizedString(@"ok",@"ok") 
                                      otherButtonTitles:nil];
			[alertView show];        
        }
    }   
}

/**
 Asks the data source whether a given row can be moved to another location in 
 the table view.
 */
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:
(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

/**
 Configure contents of the table cell
 */
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.fetchedResultsController 
                                      objectAtIndexPath:indexPath];
    cell.textLabel.text = [[managedObject valueForKey:
                            @"urlTitle"] description];
    cell.detailTextLabel.text =[[managedObject valueForKey:
                                 @"urlName"] description];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController_ != nil) 
    {
        return fetchedResultsController_;
    }
    // Set up the fetched results controller.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:
                                   @"ReferenceUrl" inManagedObjectContext:
                                   self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] 
                                        initWithKey:@"urlTitle" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    NSFetchedResultsController *aFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:
     fetchRequest managedObjectContext:self.managedObjectContext 
                                          sectionNameKeyPath:nil 
                                          cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    fetchedResultsController_ = aFetchedResultsController;
	NSError *error = nil;
	if (![fetchedResultsController_ performFetch:&error]) 
    {
	    // Handle error.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:
                                  NSLocalizedString(@"errorCommitingChanges",
                                                    @"errorCommitingChanges")  
                                                            message:nil 
                                                           delegate:nil 
                                                  cancelButtonTitle:
                                  NSLocalizedString(@"ok",@"ok") 
                                                  otherButtonTitles:nil];
        [alertView show];    
	}
    return fetchedResultsController_;
}    

/**
 Notifies the receiver that the fetched results controller is about to start 
 processing of one or more changes due to an add, remove, move, or update.
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

/**
 Notifies the receiver of the addition or removal of a section.
 */
- (void)controller:(NSFetchedResultsController *)controller 
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:
(NSFetchedResultsChangeType)type
{
    switch(type) 
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet 
                                            
                                            indexSetWithIndex:sectionIndex] 
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet 
                                            indexSetWithIndex:sectionIndex] 
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

/**
 Notifies the receiver that a fetched object has been changed due to an add, 
 remove, move, or update.
 */
- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:
(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) 
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:
             [NSArray arrayWithObject:newIndexPath] 
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:
             [NSArray arrayWithObject:indexPath] 
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView 
                                 cellForRowAtIndexPath:indexPath] 
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:
             [NSArray arrayWithObject:indexPath] 
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:
             [NSArray arrayWithObject:newIndexPath]withRowAnimation:
             UITableViewRowAnimationFade];
            break;
    }
}

/**
 Notifies the receiver that the fetched results controller has completed 
 processing of one or more changes due to an add, remove, move, or update.
 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}
@end
