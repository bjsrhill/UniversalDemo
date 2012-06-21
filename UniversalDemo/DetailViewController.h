/*
 DetailViewController.h
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

#import <UIKit/UIKit.h>
#import "UrlEntryViewController.h"

@class UrlEntryViewController;

@interface DetailViewController : UIViewController 
<UISplitViewControllerDelegate, UIWebViewDelegate>

@property (strong, nonatomic) id detailItem;
@property (assign, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (assign, nonatomic) IBOutlet UITextView *valid;
@property (assign, nonatomic) IBOutlet UIBarButtonItem* back;
@property (assign, nonatomic) IBOutlet UIBarButtonItem* forward;
@property (assign, nonatomic) IBOutlet UIBarButtonItem* reload;
@property (assign, nonatomic) IBOutlet UIBarButtonItem* stop;

-(void)configureView;
-(void)configureButtons;
-(void)invalidWebView:(NSError *)error;
-(void)validWebView;
-(IBAction)goBack:(id)sender;
-(IBAction)goForward:(id)sender;
-(IBAction)reload:(id)sender;
-(IBAction)stop:(id)sender;
- (void)enableReloadButton;
- (void)disableReloadButton;
@end
