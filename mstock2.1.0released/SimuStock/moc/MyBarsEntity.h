//
//  MyBarsEntity.h
//  SimuStock
//
//  Created by Yuemeng on 14/12/19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/** 我关注的股吧表 */
@interface MyBarsEntity : NSManagedObject

@property(nonatomic, retain) NSNumber *barid;
@property(nonatomic, retain) NSString *uid;

@end
