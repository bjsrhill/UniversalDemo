//
//  ReferenceUrl.h
//  UniversalDemo
//
//  Created by Beverly S Hill on 10/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ReferenceUrl : NSManagedObject

@property (nonatomic, retain) NSString * urlName;
@property (nonatomic, retain) NSString * urlNote;
@property (nonatomic, retain) NSString * urlTitle;

@end
