//
//  WBCoreDataUtil.h
//  SimuStock
//
//  Created by Yuemeng on 14/12/17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 股聊coreData工具类 */
@interface WBCoreDataUtil : NSObject

/** 存储已赞聊股 */
+ (void)insertPraiseTid:(NSNumber *)tid;
/** 查询传入聊股是否存在 */
+ (BOOL)fetchPraiseTid:(NSNumber *)tid;
/** 删除已赞聊股 */
+ (void)deletePraiseTid:(NSNumber *)tid;

/** 存储已收藏聊股 */
+ (void)insertCollectTid:(NSNumber *)tid;
/** 查询传入聊股是否存在 */
+ (BOOL)fetchCollectTid:(NSNumber *)tid;
/** 删除已收藏聊股 */
+ (void)deleteCollectTid:(NSNumber *)tid;

/** 存储已加入barid */
+ (void)insertBarId:(NSNumber *)barid;
/** 查询barid是否关注 */
+ (BOOL)fetchBarId:(NSNumber *)barid;
/** 退出吧barid */
+ (void)deleteBarId:(NSNumber *)barid;
/** 清空相关用户整个表 */
+ (void)clearBarIds;

@end
