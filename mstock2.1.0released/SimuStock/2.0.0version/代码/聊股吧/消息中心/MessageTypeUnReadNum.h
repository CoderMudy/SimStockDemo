//
//  MesCenter.h
//  SimuStock
//
//  Created by moulin wang on 14-12-26.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MessageTypeUnReadNum : NSManagedObject

@property(nonatomic, retain) NSString *uid;
@property(nonatomic, retain) NSString *type;
@property(nonatomic, assign) int16_t unReadNum;

@end
