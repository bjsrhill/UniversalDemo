/*
 AppDelegate.m
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


#import "AppDelegate.h"
#import "MasterViewController.h"

@implementation AppDelegate

@synthesize window = window_;
@synthesize managedObjectContext = managedObjectContext_;
@synthesize managedObjectModel = managedObjectModel_;
@synthesize persistentStoreCoordinator = persistentStoreCoordinator_;

/**
 Tells the delegate when the application has launched and may have additional 
 launch options to handle
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:
(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) 
    {
        UISplitViewController *splitViewController = 
        (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = 
        [splitViewController.viewControllers lastObject];
        splitViewController.delegate = 
        (id)navigationController.topViewController;
        
        UINavigationController *masterNavigationController = 
        [splitViewController.viewControllers objectAtIndex:0];
        MasterViewController *controller = 
        (MasterViewController *)masterNavigationController.topViewController;
        controller.managedObjectContext = self.managedObjectContext;
    } 
    else 
    {
        UINavigationController *navigationController = 
        (UINavigationController *)self.window.rootViewController;
        MasterViewController *controller = 
        (MasterViewController *)navigationController.topViewController;
        controller.managedObjectContext = self.managedObjectContext;
    }
    return YES;
}

/**
 Tells the delegate when the application is about to terminate
 */
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the 
    // application terminates.
    [self saveContext];
}

/**
 Attempts to commit unsaved changes in the managed object context to the 
 persistent store
 */
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && 
            ![managedObjectContext save:&error])
        {
            
            if ([managedObjectContext hasChanges] && 
                ![managedObjectContext save:&error])
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
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent
 store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext_ != nil)
    {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel_ != nil)
    {
        return managedObjectModel_;
    }
    NSURL *modelURL = [[NSBundle mainBundle] 
                       URLForResource:@"UniversalDemo" withExtension:@"momd"];
    managedObjectModel_ = [[NSManagedObjectModel alloc] 
                            initWithContentsOfURL:modelURL];
    return managedObjectModel_;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the 
 application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator_ != nil)
    {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] 
                       URLByAppendingPathComponent:@"UniversalDemo.sqlite"];
    
    //* Performing automatic lightweight migration by passing the following 
    // dictionary as the options parameter: 
    [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
     NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], 
     NSInferMappingModelAutomaticallyOption, nil];
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] 
                                    initWithManagedObjectModel:
                                    [self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:
          NSSQLiteStoreType configuration:nil URL:
          storeURL options:nil error:&error])
    {         
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:
                                  NSLocalizedString(@"persistentError",
                                                    @"persistentError")  
                                  message:nil delegate:nil cancelButtonTitle:
                                  NSLocalizedString(@"ok",@"ok") 
                                  otherButtonTitles:nil];
		[alertView show];
    }    
    return persistentStoreCoordinator_;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory 
                                                   inDomains:NSUserDomainMask] 
            lastObject];
}
@end
