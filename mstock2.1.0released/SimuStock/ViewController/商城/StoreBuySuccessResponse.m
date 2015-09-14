//
//  StoreBuySuccessResponse.m
//  SimuStock
//
//  Created by Mac on 15/7/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StoreBuySuccessResponse.h"
#import "JsonFormatRequester.h"

@implementation StoreBuySuccessResponse {
  NSInteger callCount;
  NSInteger callDayCount;
}

///客户端在有网情况下，每隔3分钟调用一次
static CGFloat TimeInterval = 60.f * 3;
///如果接口调用超时，每隔5分钟调用一次
static CGFloat TimeIntervalOnTimeount = 60.f * 5;
///每天最多调用20次，最多调用3天
static NSInteger MAX_NumPerDays = 20;
static NSInteger MAX_CheckDays = 3;

- (instancetype)initWithEBPurchase:(EBPurchase *)purchase receipt:(NSData *)transactionReceipt {
  if (self = [super init]) {
    callCount = 0;
    callDayCount = 0;
    _sendRequestSuccess = NO;
    self.purchase = purchase;
    self.transactionReceipt = transactionReceipt;
    __weak StoreBuySuccessResponse *weakSelf = self;
    _timer = [[TimerUtil alloc] initWithTimeInterval:TimeInterval
                                    withTimeCallBack:^{
                                      [weakSelf sendBuySuccessNotify];
                                    }];
  }
  return self;
}

- (void)sendBuySuccessNotify {
  if (_sendRequestSuccess) {
    return;
  }

  __weak StoreBuySuccessResponse *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onSuccess = ^(NSObject *obj) {
    [weakSelf onSuccess:obj];
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *ex) {
    weakSelf.validateCallBack.onError(obj, ex);
    if (obj) {
      [weakSelf onServerReceived];
    } else {
      [weakSelf failedOnTimeout:NO];
    }
  };

  callback.onFailed = ^{
    [weakSelf failedOnTimeout:YES];
  };
  [StoreBuySuccessResponse sendBuySuccessNotifyWithEBPurchase:_purchase
                                                      receipt:_transactionReceipt
                                                 withCallback:callback];
}

- (void)onError {
}

- (void)onSuccess:(NSObject *)obj {
  if (callCount == 0 && callDayCount == 0 && _validateCallBack) {
    _validateCallBack.onSuccess(obj);
  }
  [self onServerReceived];
}

- (void)onServerReceived {
  self.sendRequestSuccess = YES;
  [self.timer stopTimer];
}

- (void)failedOnTimeout:(BOOL)timeout {
  if (callCount < MAX_NumPerDays) {
    callCount++;
    [_timer setTimeinterval:timeout ? TimeIntervalOnTimeount : TimeInterval];
  } else if (callDayCount < MAX_CheckDays) {
    callCount = 0;
    callDayCount++;
    [_timer setTimeinterval:60 * 60 * 24];
  } else {
    [_timer stopTimer];
  }
}

+ (void)sendBuySuccessNotifyWithEBPurchase:(EBPurchase *)purchase
                                   receipt:(NSData *)transactionReceipt
                              withCallback:(HttpRequestCallBack *)callback {

  NSString *url =
      [NSString stringWithFormat:@"%@pay/iosNotify/%@/%@", pay_address, purchase.orderListNumber, purchase.orderListNumber];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request createHttpRequestWithUrl:url WithRequestMethod:@"POST" withRequestParameters:nil];
  [request.httpRequest appendPostData:transactionReceipt];
  [request.httpRequest setTimeOutSeconds:120];
  request.requestObjectClass = [StoreBuySuccessResponse class];
  request.httpRequestCallback = callback;
  [[BaseRequester getRequestCache] addObject:request];

  ASINetworkQueue *networkQueue = [BaseRequester sharedQueue];
  [networkQueue addOperation:request.httpRequest];
  [networkQueue go];
}

@end
