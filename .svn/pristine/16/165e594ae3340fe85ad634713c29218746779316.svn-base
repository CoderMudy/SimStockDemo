//
//  PraiseList.h
//  SimuStock
//
//  Created by jhss on 14-12-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"
#import "UserListItem.h"

@interface PraiseList : JsonRequestObject<Collectionable>
/** 用户详情 */
@property(strong, nonatomic) UserListItem *writer;
/** [int]点赞用户 */
@property(strong, nonatomic) NSNumber *uid;
/** 描述 */
@property(copy, nonatomic) NSString *des;
/** [long]排序id */
@property(strong, nonatomic) NSNumber *seq;
/** [long] 聊股id */
@property(strong, nonatomic) NSNumber *tweetid;
/** long 时间 */
@property(strong, nonatomic) NSNumber *ctime;

/** 赞列表 */
@property(strong, nonatomic) NSMutableArray *dataArray;

/** 请求赞列表信息 */
+ (void)getPraiseListsWithTweetDic:(NSDictionary *)dic
                      withCallback:(HttpRequestCallBack *)callback;

@end
