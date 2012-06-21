/*
 UrlEntryViewController.h
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

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@class MasterViewController;

@interface UrlEntryViewController : UITableViewController <UITextFieldDelegate, 
UIPopoverControllerDelegate,UITextViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *referenceUrl;
@property (weak, nonatomic) IBOutlet UITextField  *referenceTitle;
@property (weak, nonatomic) IBOutlet UITextView *referenceNote;
@property (weak, nonatomic) IBOutlet UIBarItem *save;
@property (weak, nonatomic) IBOutlet UIBarItem *cancel;
@property (weak, nonatomic) IBOutlet UIButton *urlButtonForNew;
@property (weak, nonatomic) IBOutlet UIButton *urlNewButton;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
-(void)removeNewButton;
-(IBAction)urlCancel:(id)sender;
-(IBAction)urlNew:(id)sender;
-(IBAction)urlSave:(id)sender;
-(void)validationErrorAlert:(NSString *)message;
-(void)configureManagedObject:(NSManagedObject *)mo;
@end
