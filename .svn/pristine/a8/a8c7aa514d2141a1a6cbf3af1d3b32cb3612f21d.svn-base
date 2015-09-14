//
//  RankingListItem.h
//  SimuStock
//
//  Created by jhss on 13-9-3.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseRequestObject.h"

@class UserListItem;
@class HttpRequestCallBack;

@interface RankingListItem : NSObject <ParseJson>

@property(copy, nonatomic) NSString *mAttention;
@property(copy, nonatomic) NSString *mExponent;
/** 粉丝数 */
@property(copy, nonatomic) NSString *mFansCount;
/** 头像 */
@property(copy, nonatomic) NSString *mHeadPic;
/** 发表聊股数 */
@property(copy, nonatomic) NSString *mIStockCount;
/** 用户昵称 */
@property(copy, nonatomic) NSString *mNickName;
/** 持仓数 */
@property(copy, nonatomic) NSString *mPositionCount;
/** 盈利 */
@property(copy, nonatomic) NSString *mProfit;
/** 盈利率 */
@property(copy, nonatomic) NSString *mProfitRate;
/** 排名 */
@property(copy, nonatomic) NSString *mRank;
/** 成功率 */
@property(copy, nonatomic) NSString *mSuccessRate;
/** 交易次数 */
@property(copy, nonatomic) NSString *mTradeCount;
/** 用户Id */
@property(copy, nonatomic) NSString *mUserID;
/** VIP类型 */
@property(copy, nonatomic) NSString *mVipType;
/** 月榜周榜的总盈利率 */
@property(copy, nonatomic) NSString *exponent;

/** 用户评级数据 */
@property(nonatomic, strong) UserListItem *userListItem;

@end

/** 类说明：牛人排名数据 */
@interface MasterRankList : JsonRequestObject

/** 牛人排名数组*/
@property(strong, nonatomic) NSMutableArray *dataArray;

@property(strong, nonatomic) RankingListItem *myRankInfo;

/** 请求牛人排名数据 */
+ (void)requestMasterRankListWithType:(int)type
                           withFromId:(NSString *)start
                           withReqnum:(NSString *)reqnum
                         withCallback:(HttpRequestCallBack *)callback;

@end
