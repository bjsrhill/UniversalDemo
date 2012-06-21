/*
 ReferenceUrl.h
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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ReferenceUrl : NSManagedObject

@property (strong, nonatomic) NSString * urlName;
@property (strong, nonatomic) NSString * urlNote;
@property (strong, nonatomic) NSString * urlTitle;

@end
