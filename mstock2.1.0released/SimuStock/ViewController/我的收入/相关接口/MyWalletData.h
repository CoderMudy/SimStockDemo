//
//  MyWalletData.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"

/*
 *  我的钱包
 */
@interface MyWalletData : JsonRequestObject
///账号余额
@property(nonatomic) double balance;
///累积收入
@property(nonatomic) double income;
///累积支出
@property(nonatomic) double cumOutCash;
///累积提现
@property(nonatomic) double cumExchangeDiamond;
//"申请提现"按钮显示状态。
// 1：申请提现
// 0：提现处理中
// TODO:这里的状态暂时不需要
@property(nonatomic) int drawStatus;

+ (void)requestMyWalletDataWithCallback:(HttpRequestCallBack *)callback;

@end
