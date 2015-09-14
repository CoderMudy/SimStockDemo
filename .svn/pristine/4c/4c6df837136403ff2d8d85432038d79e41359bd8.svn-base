//
//  AllInPay.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AllInPay.h"
#import <CommonCrypto/CommonCrypto.h>

#import "WFAccountInterface.h"

@implementation AllInPay

+ (NSString *)formatPaa:(NSArray *)array {
  NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
  NSMutableString *paaStr = [[NSMutableString alloc] init];
  for (int i = 0; i < array.count; i++) {
    [paaStr appendFormat:@"%@=%@&", array[i + 1], array[i]];
    mdic[array[i + 1]] = array[i];
    i++;
  }
  NSString *signMsg = [self md5:[paaStr substringToIndex:paaStr.length - 1]];
  mdic[@"signMsg"] = signMsg.uppercaseString;
  /// 注意这里一定要去除key，通联后台持有，不传入支付插件
  if (mdic[@"key"]) {
    [mdic removeObjectForKey:@"key"];
  }
  NSError *error;
  NSData *data =
      [NSJSONSerialization dataWithJSONObject:mdic
                                      options:NSJSONWritingPrettyPrinted
                                        error:&error];
  NSString *jsonStr = [[NSString alloc] initWithBytes:[data bytes]
                                               length:[data length]
                                             encoding:NSUTF8StringEncoding];
  [paaStr setString:jsonStr];
  return paaStr;
}

+ (NSString *)md5:(NSString *)string {
  const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];
  CC_LONG strLen =
      (CC_LONG)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
  unsigned char *result = calloc(CC_MD5_DIGEST_LENGTH, sizeof(unsigned char));
  CC_MD5(str, strLen, result);

  NSMutableString *hash = [NSMutableString string];
  for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
    [hash appendFormat:@"%02x", result[i]];
  }

  free(result);

  return hash;
}

+ (NSString *)formatPaaNoKey:(NSArray *)array {
  NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
  NSMutableString *paaStr = [[NSMutableString alloc] init];
  for (int i = 0; i < array.count; i++) {
    [paaStr appendFormat:@"%@=%@&", array[i + 1], array[i]];
    mdic[array[i + 1]] = array[i];
    i++;
  }
  /// 注意这里一定要去除key，通联后台持有，不传入支付插件
  if (mdic[@"key"]) {
    [mdic removeObjectForKey:@"key"];
  }
  NSError *error;
  NSData *data =
  [NSJSONSerialization dataWithJSONObject:mdic
                                  options:NSJSONWritingPrettyPrinted
                                    error:&error];
  NSString *jsonStr = [[NSString alloc] initWithBytes:[data bytes]
                                               length:[data length]
                                             encoding:NSUTF8StringEncoding];
  [paaStr setString:jsonStr];
  return paaStr;
}

+ (NSString *)makePaaWithParameter:(WFAllInPaymentPayData *)parameter {
  NSArray *paaDic = @[
    parameter.inputCharset,
    @"inputCharset",
    parameter.receiveUrl,
    @"receiveUrl",
    parameter.version,
    @"version",
    parameter.signType,
    @"signType",
    parameter.merchantId,
    @"merchantId",
    parameter.orderNo,
    @"orderNo",
    parameter.orderAmount,
    @"orderAmount",
    parameter.orderCurrency,
    @"orderCurrency",
    parameter.orderDatetime,
    @"orderDatetime",
    parameter.productName,
    @"productName",
    parameter.signMsg,
    @"signMsg",
    parameter.payType,
    @"payType",
  ];

  NSString *paaStr = [self formatPaaNoKey:paaDic];

  return paaStr;
}

/** 测试用代码 */
+ (NSString *)randomPaa {
  NSInteger amount = arc4random() % 50000 + 1; //以分为计算单位
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
  NSDate *workDate = [NSDate dateWithTimeIntervalSinceReferenceDate:
                                 [NSDate timeIntervalSinceReferenceDate]];
  NSString *timeStr = [dateFormatter stringFromDate:workDate];
  NSString *orderStr = [NSString
      stringWithFormat:@"%@%@", timeStr,
                       [NSString stringWithFormat:@"%04ld", (long)amount]];

  NSArray *paaDic = @[
    @"1",
    @"inputCharset",
    @"http://www",
    @"receiveUrl",
    @"v1.0",
    @"version",
    @"1",
    @"signType",
    @"100020091218001",
    @"merchantId",
    orderStr,
    @"orderNo",
    @"52013",
    @"orderAmount",
    @"0",
    @"orderCurrency",
    timeStr,
    @"orderDatetime",
    @"呵呵",
    @"productName",
    @"<USER>201504141001736</USER>",
    @"ext1",
    @"27",
    @"payType",
    @"1234567890",
    @"key",
  ];

  NSString *paaStr = [self formatPaa:paaDic];

  return paaStr;
}

@end
