//
//  SimTradeStatus.m
//  SimuStock
//
//  Created by Mac on 14-8-25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuTradeStatus.h"
#import "SimuUtil.h"
#import "JsonFormatRequester.h"

@implementation SimuTradeStatus {
  ///是否正在请求倒计时数据
  BOOL isRequesting;

  ///距开市、闭市的倒计时时间，单位：秒
  int64_t countDownSeconds;
}

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  NSDictionary *result = [dic objectForKey:@"result"];
  self.result = [[result objectForKey:@"status"] intValue];
  self.desc = [result objectForKey:@"desc"];
  self.serverTime = [[result objectForKey:@"serverTime"] longLongValue];
  self.openCountDown = [[result objectForKey:@"openCountDown"] longLongValue];
  self.closeCountDown = [[result objectForKey:@"closeCountDown"] longLongValue];

  if ([dic objectForKey:@"mtime"] == nil) {
    self.mtime = [[NSDate date] timeIntervalSince1970];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dictionary =
        [[NSMutableDictionary alloc] initWithDictionary:dic];
    [dictionary setValue:[NSNumber numberWithLongLong:self.mtime]
                  forKey:@"mtime"];
    [userDefaults setObject:dictionary forKey:@"SimuTradeStatus"];
    [userDefaults synchronize];
  } else {
    self.mtime = [[dic objectForKey:@"mtime"] longLongValue];
  }
}

+ (SimuTradeStatus *)instance {
  static SimuTradeStatus *instance = nil;
  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
      instance = [[SimuTradeStatus alloc] init];

      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
      NSDictionary *dic = [userDefaults objectForKey:@"SimuTradeStatus"];

      if (dic) {
        int64_t ctime = [[NSDate date] timeIntervalSince1970];
        int64_t mtime = [[dic objectForKey:@"mtime"] longLongValue];
        if ((ctime - mtime) < 1000 * 60 * 60) {
          [instance jsonToObject:dic];
        }
      }
  });
  return instance;
}

- (TradeStatus)getExchangeStatus {

  int64_t ctime = [[NSDate date] timeIntervalSince1970];
  int64_t diff = (ctime - self.mtime) * 1000;

  if (diff > 1000 * 60 * 10) { //缓存的对象生命超过10分钟
    [self requestExchangeStatus:nil];
  }

  if (diff > 1000 * 60 * 60) { //缓存的对象生命超过1小时
    self.exchangeStatusDesc = [[NSMutableAttributedString alloc]
        initWithString:@"开盘时间读取中"];
    self.exchangeStatusDescForBuySell =
        [[NSMutableAttributedString alloc] initWithString:@""];
    countDownSeconds = 20;
    return TradeStatusUnknown;
  }

  if (self.result == -2) { // -2：非交易日
    countDownSeconds = (self.openCountDown - diff) / 1000;
    return [self closedStatus:(self.openCountDown - diff)];
  }

  if (self.result == -1) { //-1非交易时间
    if (diff >= self.openCountDown) {
      self.exchangeStatusDesc =
          [[NSMutableAttributedString alloc] initWithString:@"开盘中"];
      self.exchangeStatusDescForBuySell =
          [[NSMutableAttributedString alloc] initWithString:@""];
      [self requestExchangeStatus:nil]; //状态变化，重新请求一次，更新数据
      countDownSeconds = (self.closeCountDown - diff) / 1000;
      return TradeOpenning;
    } else {
      countDownSeconds = (self.openCountDown - diff) / 1000;
      return [self closedStatus:(self.openCountDown - diff)];
    }
  }

  if (self.result == 0) { // 0：交易时间
    if (diff >= self.closeCountDown) {
      [self requestExchangeStatus:nil]; //状态变化，重新请求一次，更新数据
      //无法计算“距开发还有多少时间”，只能显示“闭市中”
      self.exchangeStatusDesc =
          [[NSMutableAttributedString alloc] initWithString:@"闭市中"];
      self.exchangeStatusDescForBuySell =
          [[NSMutableAttributedString alloc] initWithString:@"闭市中"];
      countDownSeconds = (self.openCountDown - diff) / 1000;
      return TradeClosed;
    } else {
      self.exchangeStatusDesc =
          [[NSMutableAttributedString alloc] initWithString:@"开盘中"];
      self.exchangeStatusDescForBuySell =
          [[NSMutableAttributedString alloc] initWithString:@""];
      countDownSeconds = (self.closeCountDown - diff) / 1000;
      return TradeOpenning;
    }
  }

  countDownSeconds = (self.openCountDown - diff) / 1000;
  return [self closedStatus:(self.openCountDown - diff)];
}

/** 返回是否需要每秒刷新一次，例如：距开盘一分钟之内，距收盘一分钟之内 */
- (BOOL)needRefreshBySecond {
  TradeStatus status = [self getExchangeStatus];
  switch (status) {
  case TradeStatusUnknown: {
    return YES;
  }
  case TradeClosed: {
    return countDownSeconds <= 65;
  }
  case TradeOpenning: {
    return countDownSeconds <= 65;
  }
  }
  return YES;
}

- (TradeStatus)closedStatus:(int64_t)countDownMilliSeconds {
  NSString *str_time = [self formatTimeBySeconds:countDownMilliSeconds / 1000];
  NSString *textcontent = [@"距开盘还有:" stringByAppendingString:str_time];
  NSMutableAttributedString *string =
      [[NSMutableAttributedString alloc] initWithString:textcontent];
  NSRange range = [textcontent rangeOfString:str_time];
  [string addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:Color_Red]
                 range:range];
  self.exchangeStatusDesc = string;
  self.exchangeStatusDescForBuySell = string;

  return TradeClosed;
}

- (NSString *)formatTimeBySeconds:(int64_t)time_seconds {
  //秒钟换算成时间
  NSString *str_time = nil;
  if (60 * 60 * 24 < time_seconds) {
    //大于一天
    long days = time_seconds / (60 * 60 * 24);
    long m_hours = (time_seconds % (60 * 60 * 24)) / (60 * 60);
    str_time = [NSString stringWithFormat:@"%2ld天%2ld小时", days, m_hours];
  } else if (60 * 60 < time_seconds) {
    //时间大于一个小时
    long m_hours = time_seconds / (60 * 60);
    long minute = time_seconds % (60 * 60) / 60;
    str_time = [NSString stringWithFormat:@"%2ld小时%2ld分钟", m_hours, minute];
  } else if (60 < time_seconds) {
    //大于一分钟
    long minute = time_seconds / 60;
    str_time = [NSString stringWithFormat:@"%2ld分钟", minute];
  } else {
    str_time = [NSString stringWithFormat:@"%2lld秒", time_seconds];
  }
  return str_time;
}

- (NSMutableAttributedString *)getExchangeStatusDescription {
  [self getExchangeStatus];
  return self.exchangeStatusDesc;
}

- (NSMutableAttributedString *)getExchangeStatusDescriptionForBuySell {
  [self getExchangeStatus];
  return self.exchangeStatusDescForBuySell;
}

//取得距离开盘还有多长时间数据
- (void)requestExchangeStatus:(void(^)())onRefreshCallBack {
  if (isRequesting) {
    return;
  }
  isRequesting = YES;
  NSLog(@"requestExchangeStatus begin");

  JsonFormatRequester *requester = [[JsonFormatRequester alloc] init];
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onSuccess = ^(NSObject *obj) {
      isRequesting = NO;
      SimuTradeStatus *status = (SimuTradeStatus *)obj;
      SimuTradeStatus *instance = [SimuTradeStatus instance];
      instance.result = status.result;
      instance.desc = status.desc;
      instance.serverTime = status.serverTime;
      instance.openCountDown = status.openCountDown;
      instance.closeCountDown = status.closeCountDown;
      instance.mtime = status.mtime;
      if (onRefreshCallBack) {
        onRefreshCallBack();
      }
  };
  callback.onFailed = ^() {
      //什么也不做
      isRequesting = NO;
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
      //什么也不做
      isRequesting = NO;
  };

  [requester
      asynExecuteWithRequestUrl:
          [data_address stringByAppendingString:@"youguu/simtrade/status"]
              WithRequestMethod:@"GET"
          withRequestParameters:nil
         withRequestObjectClass:[SimuTradeStatus class]
        withHttpRequestCallBack:callback];
}

@end
