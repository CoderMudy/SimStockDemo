//
//  MyAttentionInfoItem.h
//  SimuStock
//
//  Created by jhss on 13-12-17.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseRequestObject.h"
#import "UserListItem.h"

@class HttpRequestCallBack;

@interface MyAttentionInfoItem : BaseRequestObject2 <ParseJson>

@property(copy, nonatomic) NSString *mProfit;

@property(copy, nonatomic) NSString *mIsAttention;

/** 用户评级数据 */
@property(nonatomic, strong) UserListItem *userListItem;

/** 搜索牛人JSON解析 */
- (void)searchStockHeroJsonToObject:(NSDictionary *)dic;

/** 我的粉丝JSON解析 */
- (void)fanJsonToObject:(NSDictionary *)dic;

@end

/** 类说明：关注列表数据 */
@interface MyAttentionList : JsonRequestObject <Collectionable>

/** 我的用户Id */
@property(strong, nonatomic) NSString *myUserId;

/** 关注列表数组*/
@property(strong, nonatomic) NSMutableArray *dataArray;
/** 请求关注列表 */
+ (void)requestPositionDataWithParams:(NSDictionary *)dic
                         withCallback:(HttpRequestCallBack *)callback;

@end

/** 类说明：粉丝列表数据 */
@interface MyFansList : JsonRequestObject <Collectionable>

/** 粉丝列表数组*/
@property(strong, nonatomic) NSMutableArray *dataArray;
/** 请求粉丝列表 */
+ (void)requestFansWithParams:(NSDictionary *)dic
                 withCallback:(HttpRequestCallBack *)callback;

@end

@interface StockFriendsListWrapper : JsonRequestObject <Collectionable>

/** 反馈列表数组*/
@property(strong, nonatomic) NSMutableArray *dataArray;
/** 请求反馈列表 */
+ (void)requestStockFriendsWithParams:(NSDictionary *)dic
                          wthCallback:(HttpRequestCallBack *)callback;

@end
