//
//  GoldCoinNumData.h
//  SimuStock
//
//  Created by jhss_wyz on 15/8/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

@interface GoldCoinNumData : JsonRequestObject

/** 用户ID */
@property(copy, nonatomic) NSString *uid;
/** 持有金币 */
@property(copy, nonatomic) NSString *coinBalance;
/** 用户头像 */
@property(copy, nonatomic) NSString *headpic;

+ (void)requestGoldCoinNumWithCallback:(HttpRequestCallBack *)callback;

@end
