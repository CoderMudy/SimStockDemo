//
//  AllInPay.h
//  SimuStock
//
//  Created by jhss_wyz on 15/4/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WFAllInPaymentPayData;

@interface AllInPay : NSObject

/** 格式化通联支付请求数据 */
+ (NSString *)formatPaa:(NSArray *)array;
/** 得到string的MD5摘要 */
+ (NSString *)md5:(NSString *)string;

+ (NSString *)makePaaWithParameter:(WFAllInPaymentPayData *)parameter;

/** 测试用代码 */
+ (NSString *)randomPaa;

@end
