//
//  ExchangeDiamondInitData.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"

/*
 *  兑换钻石初始化接口，取得兑换比例，最大可兑换金额等
 */
@interface ExchangeDiamondInitData : JsonRequestObject
///兑换比例
@property(nonatomic) int ratio;
///最大可兑换金额,整数
@property(nonatomic) int maxValue;

+ (void)requestExchangeDiamondInitData:(HttpRequestCallBack *)callback;

@end
