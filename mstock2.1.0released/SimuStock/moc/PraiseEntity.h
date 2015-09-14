//
//  PraiseEntity.h
//  SimuStock
//
//  Created by Yuemeng on 14/12/17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/** 已赞聊股 表 */
@interface PraiseEntity : NSManagedObject

/** 赞的股聊 */
@property(nonatomic, retain) NSNumber *tid;
/** 当前赞的用户 */
@property(nonatomic, retain) NSString *uid;

@end
