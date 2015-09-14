//
//  BankInitDrawData.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/22.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BankInitDrawData.h"

@implementation BankInitDrawData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  [self setValuesForKeysWithDictionary:dic];

  _stringArray = [[NSMutableArray alloc] initWithCapacity:9];
  //现金
  [_stringArray addObject:[NSString stringWithFormat:@"%.2f", _cash]];
  //税后提现，单条数据查询的税后金额为空
  //根据现金来计算
  _taxBalance =
      _cash > 802 ? (_cash - 2 - (_cash - 2 - 800) * 0.2f) : _cash - 2;
  [_stringArray addObject:[NSString stringWithFormat:@"%.2f", _taxBalance]];
  //昵称
  [_stringArray addObject:_nickName ? _nickName : @""];
  //手机
  [_stringArray addObject:_phone ? _phone : @""];
  //姓名
  [_stringArray addObject:_realName ? _realName : @""];
  //身份证号
  [_stringArray addObject:_certNo ? _certNo : @""];
  //开户银行
  [_stringArray addObject:_bankName ? _bankName : @""];
  //银行卡
  [_stringArray addObject:_bankAccount ? _bankAccount : @""];
}

+ (void)requestBankInitDrawData:(HttpRequestCallBack *)callback {
  NSString *url =
      [pay_address stringByAppendingString:@"pay/bank/counter/initDraw"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[BankInitDrawData class]
             withHttpRequestCallBack:callback];
}

+ (void)requestGetWalletFlowData:(NSString *)tradeFee
                    withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [pay_address
      stringByAppendingFormat:@"pay/bank/counter/getWalletFlow?tradeFee=%@",
                              tradeFee];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[BankInitDrawData class]
             withHttpRequestCallBack:callback];
}

@end
