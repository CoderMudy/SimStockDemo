//
//  MyChestsListWrapper.h
//  SimuStock
//
//  Created by moulin wang on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequester.h"

@class HttpRequestCallBack;

/**商品数组*/
@interface MyPropsListItem : NSObject

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

#pragma mark----------(3)（取得用户宝箱内所有用钻石）myChest----------
@interface MyChestsMyChestlistListWrapper : JsonRequestObject <Collectionable>
/**数据数组*/
@property(strong, nonatomic) NSMutableArray *MyChestdataArray;
/**钻石余额*/
@property(copy, nonatomic) NSString *result;
/**金币余额*/
@property(copy, nonatomic) NSString *coins;

/** 请求数据 */
+ (void)requestPositionDataWithCallback:(HttpRequestCallBack *)callback;
@end

#pragma mark----------(5)使用商品（钻石商城新接口）useProps----------
@interface MyChestsUsePropslistListWrapper : JsonRequestObject
/**返回值*/
@property(copy, nonatomic) NSString *result;
/** 数据数组*/
@property(strong, nonatomic) NSMutableArray *UsePropsdataArray;
/** 请求数据 */
+ (void)requestPositionDataWithGetAK:(NSString *)GetAK
                       withGetUserID:(NSString *)UserID
                     withGetUserName:(NSString *)UserName
                  withClickedPropsID:(NSString *)PropsID
                        withCallback:(HttpRequestCallBack *)callback;
@end
