//
//  CallMe.h
//  SimuStock
//
//  Created by moulin wang on 14-12-23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MessageUnReadStatus : NSManagedObject

@property(nonatomic, retain) NSString *uid;
@property(nonatomic, retain) NSString *type;
@property(nonatomic, retain) NSString *msgId;
@property(nonatomic, assign) BOOL read;

@end
