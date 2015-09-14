//
//  StoreBuySuccessResponse.h
//  SimuStock
//
//  Created by Mac on 15/7/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "EBPurchase.h"
#import "TimerUtil.h"

@class HttpRequestCallBack;

@interface StoreBuySuccessResponse : JsonRequestObject
/** 支付成功后，来自苹果的反馈，含有订单号 */
@property(nonatomic, strong) EBPurchase *purchase;
/** 支付成功后，来自苹果的事务数据 */
@property(nonatomic, strong) NSData *transactionReceipt;
/** 定时器，支付失败后，定时发送请求*/
@property(nonatomic, strong) TimerUtil *timer;
/** 是否发送苹果订单号至youguu服务器成功 */
@property(nonatomic, assign) BOOL sendRequestSuccess;
/** 验证成功，通知观察者*/
@property(strong, nonatomic) HttpRequestCallBack *validateCallBack;

- (instancetype)initWithEBPurchase:(EBPurchase *)purchase
                           receipt:(NSData *)transactionReceipt;
/** 发送苹果商店购买道具成功至youguu服务端*/
- (void)sendBuySuccessNotify;

/** 发送苹果商店购买道具成功至youguu服务端*/
+ (void)sendBuySuccessNotifyWithEBPurchase:(EBPurchase *)purchase
                                   receipt:(NSData *)transactionReceipt
                              withCallback:(HttpRequestCallBack *)callback;

@end
