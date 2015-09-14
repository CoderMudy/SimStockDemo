//
//  simuUserConterListWrapper.h
//  SimuStock
//
//  Created by moulin wang on 14-11-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"

#pragma mark ----------（1）取得用户宝箱内所有用钻石兑换的商品----------
@class HttpRequestCallBack;
@interface simuUserConterPropsMyChestListWrapper : JsonRequestObject
/** 数据数组*/
@property(strong, nonatomic) NSMutableArray *PropsMyChestdataArray;
/** 钻石和金币数组*/
@property(strong, nonatomic) NSMutableArray *CoinsdataArray;
/** 请求数据 */
+ (void)requestPositionDataWithCallback:(HttpRequestCallBack *)callback;
/**钻石余额*/
@property (copy,nonatomic)NSString * result;
/**金币余额*/
@property (copy,nonatomic)NSString * coins;
/**数据项*/
@property(copy, nonatomic) NSString *mCoinsCount;
@property(copy, nonatomic) NSString *mMaxVipDays;
@property(copy, nonatomic) NSString *mMessage;
@property(copy, nonatomic) NSString *mMidVipDays;
@property(copy, nonatomic) NSString *mPboxID;
@property(copy, nonatomic) NSString *mPboxName;
@property(copy, nonatomic) NSString *mPboxPic;
@property(copy, nonatomic) NSString *mPboxType;
@property(copy, nonatomic) NSString *mPboxTotal;
@property(copy, nonatomic) NSString *mUID;
@property(copy, nonatomic) NSString *mStatus;
@end
#pragma mark ----------（2）使用商品----------
@interface simuUserConteruseUsePropsListWrapper : JsonRequestObject
/** 数据数组*/
@property(strong, nonatomic) NSMutableArray *PropsdataArray;
@property (copy,nonatomic)NSString * result;
/** 请求数据 */
+ (void)requestPositionDataWithGetAK:(NSString *)GetAK
                       withGetUserID:(NSString *)UserID
                     withGetUserName:(NSString *)UserName
                  withClickedPropsID:(NSString *)PropsID
                        withCallback:(HttpRequestCallBack *)callback ;
@end