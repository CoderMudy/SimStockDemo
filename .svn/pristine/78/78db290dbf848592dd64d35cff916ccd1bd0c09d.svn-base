//
//  StockMatchListItem.h
//  SimuStock
//
//  Created by jhss on 14-5-6.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/**
 *  比赛列表基本数据
 */
@interface StockMatchListItem : BaseRequestObject2 <ParseJson>

@property(copy, nonatomic) NSString *matchDescp;
@property(copy, nonatomic) NSString *wapRegUrl;
@property(copy, nonatomic) NSString *userId;
@property(copy, nonatomic) NSString *matchLogo;
@property(copy, nonatomic) NSString *openTime;
@property(copy, nonatomic) NSString *closeTime;
@property(copy, nonatomic) NSString *matchId;
@property(copy, nonatomic) NSString *creator;
@property(copy, nonatomic) NSString *matchName;
@property(copy, nonatomic) NSString *type;
@property(copy, nonatomic) NSString *uid;
@property(copy, nonatomic) NSString *mainUrl;
/** 是否调整web页 */
@property(assign, nonatomic) BOOL wapJump;

@property(nonatomic) NSInteger createFlag;
@property(nonatomic) NSInteger matchNum;
@property(nonatomic) NSInteger signupFee;
@property(nonatomic) NSInteger createFee;

@property(nonatomic) BOOL inviteFlag;
@property(nonatomic) BOOL isWapReg;
@property(nonatomic) BOOL isSenior;
@property(nonatomic) BOOL isReward;
@property(nonatomic) BOOL signupFlag;
@property(nonatomic) BOOL isMine;

@end

/** 类说明：比赛的列表 */
@interface StockMatchList : JsonRequestObject <Collectionable>

/** 比赛列表数组*/
@property(strong, nonatomic) NSMutableArray *dataArray;

/** 请求搜索比赛的列表 */
+ (void)requestSearchStockMatchWithQuery:(NSString *)queryString
                           withPageIndex:(NSInteger)pageIndex
                            withPageSize:(NSString *)pageSize
                            withCallback:(HttpRequestCallBack *)callback;
/** 请求我的比赛的列表 */
+ (void)requestMyStockMatchListWithDictionary:(NSDictionary *)dic
                                 withCallback:(HttpRequestCallBack *)callback;
/** 请求所有比赛的列表 */
+ (void)requestAllStockMatchListWithDictionary:(NSDictionary *)dic
                                  withCallback:(HttpRequestCallBack *)callback;
/** 搜索比赛 */
+ (void)requestSeatchStockMatchListWithDictionary:(NSDictionary *)dic
                                     withCallback:(HttpRequestCallBack *)callback;
@end
