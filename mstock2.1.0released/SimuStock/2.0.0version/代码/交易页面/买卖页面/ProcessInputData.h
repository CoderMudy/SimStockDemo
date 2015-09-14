//
//  ProcessInputData.h
//  SimuStock
//
//  Created by moulin wang on 14-8-20.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

//枚举 保留2位有效小数的百分数 和 没有小数位的百分数
typedef NS_ENUM(NSInteger, DecimalDigitNumber) {
  DecimalDigitTwoNumber = 1,
  DecimalDigitZeroNumber = 2
};

@interface ProcessInputData : NSObject
/** 返回数字 */
+ (NSString *)processDigitalData:(NSString *)str;
/** 返回数字可以带小数点 */
+ (NSString *)numbersAndPunctuationData:(NSString *)str
                             decimalNum:(NSInteger)decimalNum;
/**返回的数字 可以保留2位有效小数  */
+ (NSString *)numbersAndTwoPunctuation:(NSString *)str
                  andValidDecimalDigit:(int)number;
/** 判断整数部分的方法 作用 去除类似这样的数字： 0003  000452 */
+ (NSString *)forNumberClearZero:(NSString *)num;

/** 转换NSString的时间格式：yyyy-MM-dd到yyyy年MM月dd日 */
+ (NSString *)convertDateString:(NSString *)string;

/**
 转换NSString的时间格式
 入參：均为yyyy-MM-dd格式
 返回：@“”或者yyyy年MM月dd日－yyyy年MM月dd日或者MM月dd日－MM月dd日
 开始与结束年份相同时则不显示年，不同则显示
 */
+ (NSString *)convertDateStringToSimpleAWithStartDay:(NSString *)startDay
                                           andEndDay:(NSString *)endDay;

/**
 转换NSString的时间格式
 入參：均为yyyy年MM月dd日格式
 返回：@“”或者yyyy年MM月dd日－yyyy年MM月dd日或者MM月dd日－MM月dd日
 开始与结束年份相同时则不显示年，不同则显示
 月份开头是0时，去除0
 */
+ (NSString *)convertDateStringToSimpleBWithStartDay:(NSString *)startDay
                                           andEndDay:(NSString *)endDay;

/**
 转换NSString的时间格式
 入參：均为yyyy年MM月dd日格式
 返回：去除月份及日期开头的0
 */
+ (NSString *)removeZeroInMonthAndDay:(NSString *)string;

/** 转化NSString的金额格式(分到元) */
+ (NSString *)convertMoneyString:(NSString *)string;

/** 把小数变成整数 */
+ (NSString *)convertDecimalConversionInteger:(NSString *)decimal;
/** 格式化数字 如:12325.00 转化为 12,325.00 */
+ (NSString *)numbersFormatterWithString:(NSString *)numString;

/** 将浮点数 转化成 %数  */
+ (NSString *)floatingPointNumberIntoPercentage:(NSString *)number
                               withDecimalDigit:(DecimalDigitNumber)digitNum;

/** 将小数转化成 整数 或者 保留2位小数 为空时 返回 --  */
+ (NSString *)floatingTransformedIntegerOrTwoFloat:(NSString *)number
                                   withDecimaDigit:(DecimalDigitNumber)digitNum;


/** 将大于 1W 的数据 转化成 1.00 万 */
+ (NSString *)digitalFormatNumber:(NSInteger)numberd;

/** 将带有%号的 数据 把%号变小 */
+ (void)attributedTextWithString:(NSString *)textNumber
                       withColor:(UIColor *)color
                     withUILabel:(UILabel *)label;

@end
