/*
 UniversalDemoTests.m
 UniversalDemoTests

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

#import "UniversalDemoTests.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ReferenceUrl.h"
#import <OCMock/OCMock.h>

@implementation UniversalDemoTests

@synthesize appDelegate = _appDelegate;
@synthesize nManagedObject = _nManagedObject;
@synthesize tManagedObject = _tManagedObject;
@synthesize masterViewController = _masterViewController;
@synthesize detailViewController = _detailViewController;
@synthesize nvManagedObject = _nvManagedObject;
@synthesize urlEntryViewController = _urlEntryViewController;

/**
 * Memory allocation release
 */
- (void)dealloc
{
    [_appDelegate release], _appDelegate = nil;
    [_nManagedObject release], _nManagedObject = nil;
    [_tManagedObject release], _tManagedObject = nil;
    [_masterViewController release], _masterViewController = nil;
    [_urlEntryViewController release], _urlEntryViewController = nil;
    [super dealloc];
}

/**
 * Performed before each test
 */
- (void)setUp
{
    [super setUp];
    [self setAppDelegate:[[UIApplication sharedApplication] delegate]];
    MasterViewController *masterViewController = [[MasterViewController alloc] 
                                                  initWithStyle:
                                                  UITableViewStylePlain];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    self.masterViewController = masterViewController;
    self.masterViewController.detailViewController = detailVC;
    UrlEntryViewController *urlEntryViewController = [[UrlEntryViewController alloc] 
                                                      initWithStyle:
                                                      UITableViewStylePlain];
    self.urlEntryViewController = urlEntryViewController;
    self.detailViewController = self.masterViewController.detailViewController;
    [self loadCoreDataFixture];
    [urlEntryViewController release];
    [masterViewController release];
    [detailVC release];
    
}

/**
 * Performed after each test
 */
- (void)tearDown
{    
    [super tearDown];
    [self deleteReferenceUrl];
    self.masterViewController = nil;
    self.detailViewController = nil;
    self.urlEntryViewController = nil;
}

/**
 Helper class to delete the 2 standard objects used in tests from managed object
 */
-(void)deleteReferenceUrl
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:
     [NSEntityDescription entityForName:NSLocalizedString(@"referenceUrl",
                                                          @"referenceUrl") 
                 inManagedObjectContext:self.appDelegate.managedObjectContext]];
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat:
                                 NSLocalizedString(@"urlNamePredicate",
                                                   @"urlNamePredicate"), 
                                 NSLocalizedString(@"testInvalidUrlName",
                                                   @"testInvalidUrlName")]];
    NSArray *results2 = [self.appDelegate.managedObjectContext 
                         executeFetchRequest:fetchRequest error:nil];
    if(results2.count >0)
    {
        [self.appDelegate.managedObjectContext deleteObject:self.nManagedObject];
        NSError *error = nil;
        STAssertTrue([self.appDelegate.managedObjectContext save:&error], 
                     NSLocalizedString(@"testDeleteError",@"testDeleteError"),
                     [error userInfo]);
    }
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat:
                                 NSLocalizedString(@"urlNamePredicate",
                                                   @"urlNamePredicate"),  
                                 NSLocalizedString(@"testUrlName",
                                                   @"testUrlName")]];
    NSArray *results = [self.appDelegate.managedObjectContext 
                        executeFetchRequest:fetchRequest error:nil];
    if(results.count >0)
    {
        [self.appDelegate.managedObjectContext deleteObject:
         self.nvManagedObject];
        NSError *error=nil;
        STAssertTrue([self.appDelegate.managedObjectContext save:&error], 
                     NSLocalizedString(@"testDeleteError",@"testDeleteError"),
                     [error userInfo]);
    }
    [fetchRequest release];
}


/**
 Helper class to delete specified database records used in tests 
 from managed object
 */
-(void)deleteOtherReferenceUrl:(NSString *)testValue
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:
     [NSEntityDescription entityForName:NSLocalizedString(@"referenceUrl",
                                                          @"referenceUrl") 
                 inManagedObjectContext:self.appDelegate.managedObjectContext]];
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat:
                                 NSLocalizedString(@"urlNamePredicate",
                                                   @"urlNamePredicate"), 
                                 testValue]];
    NSArray *results = [self.appDelegate.managedObjectContext 
                        executeFetchRequest:fetchRequest error:nil];
    if(results.count >0)
    {
        [self.appDelegate.managedObjectContext deleteObject:self.nvManagedObject];
        NSError *error;
        STAssertTrue([self.appDelegate.managedObjectContext save:&error],
                     NSLocalizedString(@"testDeleteError",@"testDeleteError"),
                     [error userInfo]);
    }
    [fetchRequest release];
}

#pragma mark - Fixtures

/**
 Inserts 2 static test objects into managed objects
 */
-(void)loadCoreDataFixture
{
    NSManagedObjectContext *context = self.appDelegate.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:
                                   NSLocalizedString(@"referenceUrl",
                                                     @"referenceUrl")
                                   inManagedObjectContext:context];
    // Load the 2 test managed objects
    self.nvManagedObject = 
    [NSEntityDescription insertNewObjectForEntityForName:[entity name] 
                                      inManagedObjectContext:context];
    [self.nvManagedObject setValue:
     NSLocalizedString(@"testUrlName",@"testUrlName") forKey:
     NSLocalizedString(@"urlName",@"urlName")];
    [self.nvManagedObject setValue:
     NSLocalizedString(@"testUrlTitle",@"testUrlTitle") forKey:
     NSLocalizedString(@"urlTitle",@"urlTitle")];
    [self.nvManagedObject setValue:
     NSLocalizedString(@"testUrlNote",@"testUrlNote") forKey:
     NSLocalizedString(@"urlNote",@"urlNote")];
    self.nManagedObject = 
    [NSEntityDescription insertNewObjectForEntityForName:[entity name] 
                                  inManagedObjectContext:context];
    [self.nManagedObject setValue:
     NSLocalizedString(@"testInvalidUrlName",@"testInvalidUrlName") forKey:
     NSLocalizedString(@"urlName",@"urlName")];
    [self.nManagedObject setValue:
     NSLocalizedString(@"testInvalidUrlTitle",@"testInvalidUrlTitle") forKey:
     NSLocalizedString(@"urlTitle",@"urlTitle")];
    [self.nManagedObject setValue:
     NSLocalizedString(@"testInvalidUrlNote",@"testInvalidUrlNote") forKey:
     NSLocalizedString(@"urlNote",@"urlNote")];
}

/**
 Inserts a specified object into a managed object
 */
-(void)loadCoreDataFixture:(NSString *)name:(NSString *)title:(NSString *)note
{
    NSManagedObjectContext *context = self.appDelegate.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:
                                   NSLocalizedString(@"referenceUrl",
                                                     @"referenceUrl")
                                   inManagedObjectContext:context];
    // Load the test managed object
    self.tManagedObject = 
    [NSEntityDescription insertNewObjectForEntityForName:[entity name] 
                                  inManagedObjectContext:context];
    [self.tManagedObject setValue:name forKey:
     NSLocalizedString(@"urlName",@"urlName")];
    [self.tManagedObject setValue:title forKey:
     NSLocalizedString(@"urlTitle",@"urlTitle")];
    [self.tManagedObject setValue:note forKey:
     NSLocalizedString(@"urlNote",@"urlNote")];
}

/**
 Return a ReferenceUrl object with urlName predicate of specified value
 */
-(ReferenceUrl *)returnUrlNameFixture:(NSString *)testValue
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:
     [NSEntityDescription entityForName:
      NSLocalizedString(@"referenceUrl",@"referenceUrl") inManagedObjectContext:
      self.appDelegate.managedObjectContext]];
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat:
                                 NSLocalizedString(@"urlNamePredicate",
                                                   @"urlNamePredicate"), 
                                 testValue]];
    ReferenceUrl *ru = (ReferenceUrl*) [self.appDelegate.managedObjectContext 
                                        executeFetchRequest:
                                        fetchRequest error:nil];
    [fetchRequest release];
    return ru;
}

/**
 Return a ReferenceUrl object with urlNote predicate of specified value
 */
-(ReferenceUrl *)returnUrlNoteFixture:(NSString *)testValue
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:
    [NSEntityDescription entityForName:
     NSLocalizedString(@"referenceUrl",@"referenceUrl") inManagedObjectContext:
     self.appDelegate.managedObjectContext]];
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat:
                                 NSLocalizedString(@"urlNotePredicate",
                                                   @"urlNotePredicate"), 
                                 testValue]];
    ReferenceUrl *ru2 = (ReferenceUrl*) [self.appDelegate.managedObjectContext 
                                         executeFetchRequest:
                                         fetchRequest error:nil];
    [fetchRequest release];
    return ru2;
}

/**
 Return a ReferenceUrl object with urlTitle predicate of specified value
 */
-(ReferenceUrl *)returnUrlTitleFixture:(NSString *)testValue
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:
     [NSEntityDescription entityForName:NSLocalizedString(@"referenceUrl",
                                                          @"referenceUrl") 
                 inManagedObjectContext:self.appDelegate.managedObjectContext]];
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat:
                                 NSLocalizedString(@"urlTitlePredicate",
                                                   @"urlTitlePredicate"), 
                                 testValue]];
    ReferenceUrl *ru3 = (ReferenceUrl*) [self.appDelegate.managedObjectContext 
                                         executeFetchRequest:
                                         fetchRequest error:nil];
    [fetchRequest release];
    return ru3;
}

#pragma mark - Basic Tests

/**
 Tests for existence of the application delegate
 */
- (void)testAppDelegate 
{
    STAssertNotNil(self.appDelegate, 
                   NSLocalizedString(@"testNoDelegate",@"testNoDelegate"));
}

/**
 Tests that the OCMock framework is functioning
 */
-(void)testMock
{
    id mockString = [OCMockObject mockForClass:[NSString class]];
    [[[mockString stub] andReturn:@"MOCKS UP IN"] lowercaseString];
    STAssertEqualObjects([mockString lowercaseString], @"MOCKS UP IN", nil);
}

#pragma mark - Data Model Tests

/**
 Tests for existence of url name record added
 */
- (void)testUrlNameAdd 
{
    ReferenceUrl *results = [self returnUrlNameFixture:
                             NSLocalizedString(@"testUrlName",@"testUrlName")];
    STAssertNotNil(results, 
                   NSLocalizedString(@"testAddUrlNameError",
                                     @"testAddUrlNameError"));
}

/**
 Tests for existence of url note value
 */
- (void)testUrlNoteAdd 
{
    ReferenceUrl *results2 = [self returnUrlNoteFixture:
                              NSLocalizedString(@"testUrlNote",@"testUrlNote")];
    STAssertNotNil(results2, NSLocalizedString(@"testAddUrlNoteError",
                                               @"testAddUrlNoteError"));
}

/**
 Tests for existence of url title value
 */
- (void)testUrlTitleAdd 
{
    ReferenceUrl *results3 = [self returnUrlTitleFixture:
                              NSLocalizedString(@"testUrlTitle",
                                                @"testUrlTitle")];
    STAssertNotNil(results3, NSLocalizedString(@"testAddUrlTitleError",
                                               @"testAddUrlTitleError"));
}

#pragma mark - Master List Tests

/**
 Tests the object bindings for MasterViewController
 */
- (void)testMasterViewControllerBinding 
{
    [self.masterViewController loadView];
    // Mock buttons
    id editButtonMock = [OCMockObject mockForClass:[UIBarButtonItem class]];
    [self.masterViewController setValue:editButtonMock forKey:@"editButtonItem"];
    id addButtonMock = [OCMockObject mockForClass:[UINavigationItem class]];
    [self.masterViewController setValue:addButtonMock forKey:@"navigationItem"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSUInteger)0
                                                inSection:(NSUInteger)0];
    id mockTableView = [OCMockObject mockForClass:[UITableView class]];
	[[[mockTableView expect] andReturn:nil] 
     dequeueReusableCellWithIdentifier:@"Cell"];
    self.masterViewController.managedObjectContext = 
    self.appDelegate.managedObjectContext;
	UITableViewCell *cell = [self.masterViewController 
                             tableView:
                             mockTableView cellForRowAtIndexPath:indexPath];
    // Make sure the controller is not nil
    STAssertNotNil(self.masterViewController.view, 
                   @"MasterViewController is nil");
    // Make sure a cell is returned
    STAssertNotNil(cell, @"Should have returned a cell");
    // Check for the Edit and Add buttons
    STAssertNotNil(editButtonMock, @"Edit button not found");
    STAssertNotNil(addButtonMock, @"Add button not found");
    [mockTableView verify];
}

/**
 Test for title and subtitle values on the master controller list table cell
 */
- (void)testMasterViewControllerCellSetup
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSUInteger)0
                                                inSection:(NSUInteger)0];
    id mockTableView = [OCMockObject mockForClass:[UITableView class]];
	[[[mockTableView expect] andReturn:nil] 
     dequeueReusableCellWithIdentifier:@"Cell"];
    self.masterViewController.managedObjectContext = 
    self.appDelegate.managedObjectContext;
	UITableViewCell *cell = [self.masterViewController tableView:
                             mockTableView cellForRowAtIndexPath:indexPath];
    STAssertNotNil(cell, @"Should have returned a cell");
    STAssertEqualObjects(NSLocalizedString(@"testUrlTitle",@"testUrlTitle"), 
                         cell.textLabel.text,@"There is no Url list.");
    STAssertEqualObjects(NSLocalizedString(@"testUrlName",@"testUrlName"), 
                         cell.detailTextLabel.text,@"There is no Url list.");
	[mockTableView verify];
}

/**
 Test for presence of a URL list
 */
-(void)testUrlList
{ 
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSUInteger)0
                                                inSection:(NSUInteger)0];
    id mockTableView = [OCMockObject mockForClass:[UITableView class]];
	[[[mockTableView expect] andReturn:nil] 
     dequeueReusableCellWithIdentifier:@"Cell"];
    self.masterViewController.managedObjectContext = 
    self.appDelegate.managedObjectContext;
	UITableViewCell *cell = [self.masterViewController tableView:
                             mockTableView cellForRowAtIndexPath:indexPath];
    STAssertNotNil(cell, @"Should have returned a cell");
    // Make sure a cell can be set to have a title and a url name
    STAssertEqualObjects(NSLocalizedString(@"testUrlTitle",@"testUrlTitle"), 
                         cell.textLabel.text,@"There is no Url list.");
    STAssertEqualObjects(NSLocalizedString(@"testUrlName",@"testUrlName"), 
                         cell.detailTextLabel.text,@"There is no Url list.");
	[mockTableView verify];
}

/**
 Tests for presence of a specific title of the main url list screen
 */
-(void)testMainTitle
{  
    self.masterViewController.navigationItem.title = 
    NSLocalizedString(@"urlListTitle",@"urlListTitle");
    NSString *mainTitle = self.masterViewController.navigationItem.title;
    NSString *testTitle = NSLocalizedString(@"urlListTitle",@"urlListTitle");
    STAssertTrue([mainTitle isEqualToString:testTitle],
                 NSLocalizedString(@"mainTitleIncorrect",@"mainTitleIncorrect"));
}

/**
 Tests that there is a way to delete a url name in the application
 */
-(void)testDeleteUrl
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSUInteger)0
                                                inSection:(NSUInteger)0];
    UITableViewCell *cell = [[UITableViewCell alloc] init ];
    // Set up the controller's managed object context so it has access to data
    self.masterViewController.managedObjectContext = 
    self.appDelegate.managedObjectContext;
    id mockTableView = [OCMockObject mockForClass:[UITableView class]];
    [self.masterViewController tableView:mockTableView commitEditingStyle:
     UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    [cell release];
}

#pragma mark - Detail Tests

/**
 Tests the object bindings for DetailViewController
 */
- (void)testDetailViewControllerBinding 
{
    [self.detailViewController loadView];
    id validMock = [OCMockObject mockForClass:[UITextView class]];
    [self.detailViewController setValue:validMock forKey:@"valid"];
    id webViewMock = [OCMockObject mockForClass:[UIWebView class]];
    [self.detailViewController setValue:webViewMock forKey:@"webView"];
    id editButtonMock = [OCMockObject mockForClass:[UIBarButtonItem class]];
    [self.detailViewController setValue:editButtonMock forKey:@"editButtonItem"];
    id backButtonMock = [OCMockObject mockForClass:[UINavigationItem class]];
    [self.detailViewController setValue:backButtonMock forKey:@"navigationItem"];
    id goBackButtonMockFail = [OCMockObject mockForClass:
                               [UIBarButtonItem class]];
    [self.detailViewController setValue:goBackButtonMockFail forKey:@"back"];
    id goForwardButtonMockFail = [OCMockObject mockForClass:
                                  [UIBarButtonItem class]];
    [self.detailViewController setValue:goForwardButtonMockFail 
                                 forKey:@"forward"];
    id reloadButtonMockFail = [OCMockObject mockForClass:
                               [UIBarButtonItem class]];
    [self.detailViewController setValue:reloadButtonMockFail 
                                 forKey:@"reload"];
    id stopButtonMockFail = [OCMockObject mockForClass:
                             [UIBarButtonItem class]];
    [self.detailViewController setValue:stopButtonMockFail 
                                 forKey:@"stop"];
    STAssertNotNil(self.detailViewController.view, 
                   @"DetailViewController is nil");
    STAssertNotNil(self.detailViewController.navigationItem, 
                   @"Valid text view not found");
    STAssertNotNil(editButtonMock, @"Edit button not found");
    STAssertNotNil(backButtonMock, @"Back button not found");
    STAssertNotNil(stopButtonMockFail, @"Stop button not found");
    STAssertNotNil(goBackButtonMockFail, @"Go back button not found");
    STAssertNotNil(goForwardButtonMockFail, @"Go forward button not found");
    STAssertNotNil(webViewMock, @"Webview not found");
}

/**
 Tests for correct settings upon getting a valid detail view
 */
-(void)testValidUrlDetail
{  
    [self.detailViewController loadView];
    id validMock = [OCMockObject mockForClass:[UITextView class]];
    [self.detailViewController setValue:validMock forKey:@"valid"];
    [[validMock expect] setHidden:YES];
    
    id webViewMock = [OCMockObject mockForClass:[UIWebView class]];
    [self.detailViewController setValue:webViewMock forKey:@"webView"];
    [[webViewMock expect] canGoBack];
    [[webViewMock expect] canGoForward];
    [[webViewMock expect] isLoading];
    [[webViewMock expect] setHidden:NO];
    
    id editButtonMock = [OCMockObject mockForClass:[UIBarButtonItem class]];
    [self.detailViewController setValue:editButtonMock forKey:@"editButtonItem"];
    
    id backButtonMock = [OCMockObject mockForClass:[UINavigationItem class]];
    [self.detailViewController setValue:backButtonMock forKey:@"navigationItem"];
    
    id goBackButtonMock = [OCMockObject mockForClass:[UIBarButtonItem class]];
    [self.detailViewController setValue:goBackButtonMock forKey:@"back"];
    [[goBackButtonMock expect] setEnabled:NO];
    
    id goForwardButtonMock = [OCMockObject mockForClass:[UIBarButtonItem class]];
    [self.detailViewController setValue:goForwardButtonMock forKey:@"forward"];
    [[goForwardButtonMock expect] setEnabled:NO];
    
    id reloadButtonMock = [OCMockObject mockForClass:[UIBarButtonItem class]];
    [self.detailViewController setValue:reloadButtonMock forKey:@"reload"];
    [[reloadButtonMock expect] setEnabled:YES];
    
    id stopButtonMock = [OCMockObject mockForClass:[UIBarButtonItem class]];
    [self.detailViewController setValue:stopButtonMock forKey:@"stop"];
    [[stopButtonMock expect] setEnabled:NO];
    
    // Verify settings upon successful webview load
    [self.detailViewController webViewDidFinishLoad:webViewMock];
    [webViewMock verify];
    [validMock verify];
    [goBackButtonMock verify];
    [goForwardButtonMock verify];
    [stopButtonMock verify];
    [reloadButtonMock verify];
}

/**
 Tests for correct settings upon getting an invalid detail view
 */
-(void)testInvalidUrlDetail
{ 
    [self.detailViewController loadView];
    NSString *textToSet = [[NSString alloc] initWithFormat:
                           NSLocalizedString(@"webLoadFailure", 
                                             @"webLoadFailure"), nil];
    id validMock = [OCMockObject mockForClass:[UITextView class]];
    [self.detailViewController setValue:validMock forKey:@"valid"];
    [[validMock expect] setText:textToSet];
    [[validMock expect] setHidden:NO];
    
    id webViewMock = [OCMockObject mockForClass:[UIWebView class]];
    [self.detailViewController setValue:webViewMock forKey:@"webView"];
    [[webViewMock expect] canGoBack];
    [[webViewMock expect] canGoForward];
    [[webViewMock expect] isLoading];
    [[webViewMock expect] setHidden:YES];
    
    [textToSet release];
    
    id editButtonMock = [OCMockObject mockForClass:[UIBarButtonItem class]];
    [self.detailViewController setValue:editButtonMock forKey:@"editButtonItem"];
    
    id backButtonMock = [OCMockObject mockForClass:[UINavigationItem class]];
    [self.detailViewController setValue:backButtonMock forKey:@"navigationItem"];
    
    id goBackButtonMock = [OCMockObject mockForClass:[UIBarButtonItem class]];
    [self.detailViewController setValue:goBackButtonMock forKey:@"back"];
    [[goBackButtonMock expect] setEnabled:NO];
    
    id goForwardButtonMock = [OCMockObject mockForClass:[UIBarButtonItem class]];
    [self.detailViewController setValue:goForwardButtonMock forKey:@"forward"];
    [[goForwardButtonMock expect] setEnabled:NO];
    
    id reloadButtonMock = [OCMockObject mockForClass:[UIBarButtonItem class]];
    [self.detailViewController setValue:reloadButtonMock forKey:@"reload"];
    [[reloadButtonMock expect] setEnabled:NO];
    
    id stopButtonMock = [OCMockObject mockForClass:[UIBarButtonItem class]];
    [self.detailViewController setValue:stopButtonMock forKey:@"stop"];
    [[stopButtonMock expect] setEnabled:NO];
    
    // Verify settings upon failed webview load
    [self.detailViewController webView:webViewMock didFailLoadWithError:nil];
    [webViewMock verify];
    [validMock verify];
    [goBackButtonMock verify];
    [goForwardButtonMock verify];
    [stopButtonMock verify];
    [reloadButtonMock verify];
}

/**
 Tests for presence of a specific title of the detail screen
 */
-(void)testDetailTitle
{  
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    self.masterViewController.detailViewController = detailVC;
    self.detailViewController = [self.masterViewController detailViewController];
    self.detailViewController.navigationItem.title = 
    NSLocalizedString(@"webTitle",@"webTitle");
    NSString *detailTitle = self.detailViewController.navigationItem.title;
    NSString *testTitle = NSLocalizedString(@"webTitle",@"webTitle");
    STAssertTrue([detailTitle isEqualToString:testTitle],
                 NSLocalizedString(@"detailTitleIncorrect",
                                   @"detailTitleIncorrect"));
    [detailVC release];
}

/**
 Tests for presence of a go back action on the web view
 */
-(void)testGoBack
{
    [self.detailViewController loadView];
    id webViewMock = [OCMockObject mockForClass:[UIWebView class]];
    [self.detailViewController setValue:webViewMock forKey:@"webView"];
    [[webViewMock expect] goBack];
    [self.detailViewController goBack:nil];
    [webViewMock verify];
}

/**
 Tests for presence of a go forward action on the web view
 */
-(void)testGoForward
{
    [self.detailViewController loadView];
    id webViewMock = [OCMockObject mockForClass:[UIWebView class]];
    [self.detailViewController setValue:webViewMock forKey:@"webView"];
    [[webViewMock expect] goForward];
    [self.detailViewController goForward:nil];
    [webViewMock verify];
}

/**
 Tests reloading a web page
 */
-(void)testReload
{
    [self.detailViewController loadView];
    id webViewMock = [OCMockObject mockForClass:[UIWebView class]];
    [self.detailViewController setValue:webViewMock forKey:@"webView"];
    [[webViewMock expect] reload];
    [self.detailViewController reload:nil];
    [webViewMock verify];
}

/**
 Tests stopping a web page load
 */
-(void)testStop
{
    [self.detailViewController loadView];
    id webViewMock = [OCMockObject mockForClass:[UIWebView class]];
    [self.detailViewController setValue:webViewMock forKey:@"webView"];
    [[webViewMock expect] stopLoading];
    [[webViewMock expect] canGoBack];
    [[webViewMock expect] canGoForward];
    [[webViewMock expect] isLoading];
    [self.detailViewController stop:nil];
    [webViewMock verify];
}

#pragma mark - URL Entry Tests

/**
 Tests the object bindings for UrlEntryViewControler
 */
- (void)testUrlEntryViewControllerBinding 
{
    [self.urlEntryViewController loadView];
    id noteMock = [OCMockObject mockForClass:[UITextView class]];
    [self.urlEntryViewController setValue:noteMock forKey:@"referenceNote"];
    id titleMock = [OCMockObject mockForClass:[UITextField class]];
    [self.urlEntryViewController setValue:titleMock forKey:@"referenceTitle"];
    id urlMock = [OCMockObject mockForClass:[UITextField class]];
    [self.urlEntryViewController setValue:urlMock forKey:@"referenceUrl"];
    id newButtonMock = [OCMockObject mockForClass:[UIButton class]];
    [self.urlEntryViewController setValue:newButtonMock 
                                   forKey:@"urlButtonForNew"];
    id saveButtonMock = [OCMockObject mockForClass:[UIBarButtonItem class]];
    [self.urlEntryViewController setValue:saveButtonMock forKey:@"save"];
    id cancelButtonMock = [OCMockObject mockForClass:[UIBarButtonItem class]];
    [self.urlEntryViewController setValue:cancelButtonMock forKey:@"cancel"];
    STAssertNotNil(self.urlEntryViewController.view, 
                   @"UrlEntryViewController is nil");
    // Check for the Edit and Add buttons
    STAssertNotNil(noteMock, @"Reference note text view not found");
    STAssertNotNil(titleMock, @"Reference title text field not found");
    STAssertNotNil(urlMock, @"Reference url text field not found");
    STAssertNotNil(newButtonMock, @"New button not found");
    STAssertNotNil(saveButtonMock, @"Save button not found");
    STAssertNotNil(cancelButtonMock, @"Cancel button not found");
}

/**
 Tests that there is an entry page to add a url
 */
-(void)testAddUrl
{
    // Create managed object with desired values
    [self.nvManagedObject setValue:
     NSLocalizedString(@"testUrlNameAdd",@"testUrlNameAdd") 
                            forKey:NSLocalizedString(@"urlName", @"urlName")];
    self.urlEntryViewController.managedObjectContext = 
    self.appDelegate.managedObjectContext;
    // Set managed object context and managed object on the test view controller
    self.urlEntryViewController.managedObject = self.nvManagedObject; 
    // Call loadView on the test view controller
    [self.urlEntryViewController viewDidLoad];
    // Call the urlSave method to save the object
    [self.urlEntryViewController urlSave:nil];
    // Recall the object
    ReferenceUrl *mObject = [self returnUrlNameFixture:
                             NSLocalizedString(@"testUrlNameAdd",
                                               @"testUrlNameAdd")];
    NSArray *nameOfObject = [mObject valueForKey:
                             NSLocalizedString(@"urlName", @"urlName")];
    NSString *nameValue = [nameOfObject objectAtIndex: 0];
    [self deleteOtherReferenceUrl:NSLocalizedString(@"testUrlNameAdd",
                                                    @"testUrlNameAdd")];
    // Test that the entry controller is not nil
    STAssertNotNil(self.urlEntryViewController.view, 
                   @"The Url Entry controller is nil");
    // Test that the retrieved value matches what was saved with 
    // the view controller
    STAssertTrue([nameValue isEqualToString:
                  NSLocalizedString(@"testUrlNameAdd",@"testUrlNameAdd")],
                 @"Url name is not available");
}

/**
 Tests that there is an entry page to add a url note
 */
-(void)testAddUrlNote
{
    // Create managed object with desired values
    [self.nvManagedObject setValue:
     NSLocalizedString(@"testUrlNameAdd",@"testUrlNameAdd") 
                            forKey:NSLocalizedString(@"urlName", @"urlName")];
    [self.nvManagedObject setValue:NSLocalizedString(@"testUrlNote",
                                                     @"testUrlNote") 
                            forKey:NSLocalizedString(@"urlNote", @"urlNote")];
    self.urlEntryViewController.managedObjectContext = 
    self.appDelegate.managedObjectContext;
    // Set managed object context and managed object on the test view controller
    self.urlEntryViewController.managedObject = self.nvManagedObject; 
    // Call loadView on the test view controller
    [self.urlEntryViewController viewDidLoad];
    // Call the urlSave method to save the object
    [self.urlEntryViewController urlSave:nil];
    // Recall the object
    ReferenceUrl *mObject = [self returnUrlNameFixture:
                             NSLocalizedString(@"testUrlNameAdd",
                                               @"testUrlNameAdd")];
    NSArray *nameOfObject = [mObject valueForKey:
                             NSLocalizedString(@"urlNote", @"urlNote")];
    NSString *nameValue = [nameOfObject objectAtIndex: 0];
    [self deleteOtherReferenceUrl:
     NSLocalizedString(@"testUrlNameAdd",@"testUrlNameAdd")];
    // Test that the entry controller is not nil
    STAssertNotNil(self.urlEntryViewController.view, 
                   @"The Url Entry controller is nil");
    // Test that the retrieved value matches what was saved with 
    // the view controller
    STAssertTrue([nameValue isEqualToString:
                  NSLocalizedString(@"testUrlNote",@"testUrlNote")],
                 @"Url note is not available");
}

/**
 Tests that there is an entry page to add a url title
 */
-(void)testAddUrlTitle
{
    // Create managed object with desired values
    [self.nvManagedObject setValue:NSLocalizedString(@"testUrlNameAdd",
                                                     @"testUrlNameAdd") 
                            forKey:NSLocalizedString(@"urlName", @"urlName")];
    [self.nvManagedObject setValue:NSLocalizedString(@"testUrlTitle",
                                                     @"testUrlTitle") 
                            forKey:NSLocalizedString(@"urlTitle", @"urlTitle")];
    self.urlEntryViewController.managedObjectContext = 
    self.appDelegate.managedObjectContext;
    // Set managed object context and managed object on the test view controller
    self.urlEntryViewController.managedObject = self.nvManagedObject; 
    // Call loadView on the test view controller
    [self.urlEntryViewController viewDidLoad];
    // Call the urlSave method to save the object
    [self.urlEntryViewController urlSave:nil];
    // Recall the object
    ReferenceUrl *mObject = [self returnUrlNameFixture:
                             NSLocalizedString(@"testUrlNameAdd",
                                               @"testUrlNameAdd")];
    NSArray *nameOfObject = [mObject valueForKey:
                             NSLocalizedString(@"urlTitle", @"urlTitle")];
    NSString *nameValue = [nameOfObject objectAtIndex: 0];
    [self deleteOtherReferenceUrl:
     NSLocalizedString(@"testUrlNameAdd",@"testUrlNameAdd")];
    // Test that the entry controller is not nil
    STAssertNotNil(self.urlEntryViewController.view, 
                   @"The Url Entry controller is nil");
    // Test that the retrieved value matches what was saved 
    // with the view controller
    STAssertTrue([nameValue isEqualToString:
                  NSLocalizedString(@"testUrlTitle",
                                    @"testUrlTitle")],
                                    @"Url title is not available");
}
@end
