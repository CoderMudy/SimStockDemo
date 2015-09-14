//
//  ProcessInputData.m
//  SimuStock
//
//  Created by moulin wang on 14-8-20.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ProcessInputData.h"
#import "UILabel+SetProperty.h"
#define NUMBERS @"0123456789"
#define Numbers_Point @"0123456789."
@implementation ProcessInputData
//返回数字
+ (NSString *)processDigitalData:(NSString *)str {
  //判断输入的是否都是数字
  NSCharacterSet *num;
  num =
      [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
  NSString *filtered = [[str componentsSeparatedByCharactersInSet:num]
      componentsJoinedByString:@""];
  if ([filtered hasPrefix:@"0"]) {
    if (filtered.length == 1) {
      filtered = @"";
    } else {
      filtered =
          [filtered substringWithRange:NSMakeRange(1, filtered.length - 1)];
    }
  }
  return filtered;
}
//返回数字可以带小数点
+ (NSString *)numbersAndPunctuationData:(NSString *)str
                             decimalNum:(NSInteger)decimalNum {
  //判断输入的是否都是数字
  NSCharacterSet *num;
  num = [[NSCharacterSet
      characterSetWithCharactersInString:Numbers_Point] invertedSet];
  NSString *filtered = [[str componentsSeparatedByCharactersInSet:num]
      componentsJoinedByString:@""];

  //整数

  //小数
  // 1.点在最前，前面补零
  // 2.点在最后，后面直接取整，类似123.
  // 3.点后面有超过3位，截取2位
  //整数情况
  if ([filtered rangeOfString:@"."].length == 0) {
    if (filtered.length > 3) {
      //如果是0开头，截取后两位
      if ([filtered hasPrefix:@"0"]) {
        // filtered = [self forNumberClearZero:filtered];
        filtered = [filtered substringWithRange:NSMakeRange(1, 2)];
      } else {
        filtered = [filtered substringWithRange:NSMakeRange(0, 3)];
      }
      // 10~99，00~09
    } else if (filtered.length > 1) {
      if ([filtered hasPrefix:@"0"]) {
        filtered =
            [filtered substringWithRange:NSMakeRange(1, filtered.length - 1)];
      }
    }
    //小数情况，且.开头
  } else if (filtered.length == 1 && [filtered isEqualToString:@"."]) {
    //如果小数点开头，自动补零
    filtered = @"0.";

    //正常小数情况：12.345
  } else if ([filtered rangeOfString:@"."].length != 0) {
    int x = 0;
    if (decimalNum == 2) {
      x = 6;
    } else if (decimalNum == 3) {
      x = 7;
    }
    if (filtered.length > x) {
      filtered = [filtered substringWithRange:NSMakeRange(0, x)];
    }
    //以小数点分割
    NSArray *arr = [filtered componentsSeparatedByString:@"."];
    //正常小数
    if ([arr count] >= 2) {
      filtered = @"";
      //如果是.99类似小数
      if ([arr[0] isEqualToString:@""]) {
        filtered = @"0";
        //如果小数点前有3位
      } else if ([arr[0] length] <= 3) {
        filtered = arr[0];
        //如果小数点前大于3位
      } else if ([arr[0] length] > 3) {
        filtered = [arr[0] substringWithRange:NSMakeRange(0, 3)];
      }

      //小数点后面 123.类似情况
      if ([arr[1] isEqualToString:@""]) {
        filtered = [filtered stringByAppendingFormat:@"."];
        // 123.1 1213.12
      } else if ([arr[1] length] <= decimalNum) {
        filtered = [filtered stringByAppendingFormat:@".%@", arr[1]];

        //如果类似123.123
      } else if ([arr[1] length] > decimalNum) {
        filtered = [filtered
            stringByAppendingFormat:
                @".%@", [arr[1] substringWithRange:NSMakeRange(0, decimalNum)]];
      }
    }
  }

  if (filtered) {
    return filtered;
  } else {
    return @"";
  }
}

//返回的数字 可以保留2位有效小数
+ (NSString *)numbersAndTwoPunctuation:(NSString *)str
                  andValidDecimalDigit:(int)number {
  NSCharacterSet *num;
  //过滤字符串里的非数字和小数点的内容
  num = [[NSCharacterSet
      characterSetWithCharactersInString:Numbers_Point] invertedSet];
  NSString *filtered = [[str componentsSeparatedByCharactersInSet:num]
      componentsJoinedByString:@""];
  //判断是小数 ： 12.22
  if ([filtered rangeOfString:@"."].location != NSNotFound) {
    //包含小数点时 0.112 1.22 21.21
    //排除 0002.4 这种情况
    //以小数点 "." 为中心 将字符串分割成2个字符串
    NSArray *array = [filtered componentsSeparatedByString:@"."];
    if (array) {
      // str1 为小数点 前面的部分 即整数部分 排除：0022 这种情况
      NSString *str1 = array[0];
      //调用方法
      filtered = [self forNumberClearZero:str1];
      // str2 为小数点 后面的部分 要求保留 几位有效数字
      NSString *str2 = array[1];
      if (str2 == nil) {
      } else if (str2.length >= (number + 1)) {
        NSString *c = [str2 substringWithRange:NSMakeRange(0, number)];
        filtered = [filtered stringByAppendingFormat:@".%@", c];
        return filtered;
      } else {
        filtered = [filtered stringByAppendingFormat:@".%@", str2];
        return filtered;
      }
    }
  } else {
    filtered = [self forNumberClearZero:filtered];
  }
  return filtered;
}

//判断整数部分的方法 作用 去除类似这样的数字： 0003  000452
+ (NSString *)forNumberClearZero:(NSString *)num {
  if (num.length >= 1) {
    for (int i = 0; i < num.length; i++) {
      NSString *a = [num substringWithRange:NSMakeRange(i, 1)];
      if (![a isEqualToString:@"0"]) {
        NSString *b = [num substringWithRange:NSMakeRange(i, num.length - i)];
        return b;
      }
    }
  }
  return @"0";
}

/** 转换NSString的时间格式：yyyy-MM-dd到yyyy年MM月dd日 */
+ (NSString *)convertDateString:(NSString *)string {
  if (string == nil && [string isEqualToString:@""]) {
    return @"";
  }
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  NSDate *date = [dateFormatter dateFromString:string];
  [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
  string = [dateFormatter stringFromDate:date];
  return string;
}

/**
 * 转换NSString的时间格式：yyyy-MM-dd到yyyy年MM月dd日-yyyy年MM月dd日或MM月dd日-MM月dd日
 */
+ (NSString *)convertDateStringToSimpleAWithStartDay:(NSString *)startDay
                                           andEndDay:(NSString *)endDay {
  if (startDay == nil && [startDay isEqualToString:@""] &&
      !(startDay.length == 10) && endDay == nil &&
      [endDay isEqualToString:@""] && !(endDay.length == 10)) {
    return @"";
  }
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  NSDate *startDate = [dateFormatter dateFromString:startDay];
  NSDate *endDate = [dateFormatter dateFromString:endDay];
  if ([[startDay substringToIndex:4]
          isEqualToString:[endDay substringToIndex:4]]) {
    [dateFormatter setDateFormat:@"MM月dd日"];
  } else {
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
  }
  NSString *startStr = [dateFormatter stringFromDate:startDate];
  NSString *endStr = [dateFormatter stringFromDate:endDate];
  return [NSString stringWithFormat:@"%@-%@", startStr, endStr];
}

/** 转换NSString的时间格式：yyyy年MM月dd日-yyyy年MM月dd日或MM月dd日-MM月dd日 */
+ (NSString *)convertDateStringToSimpleBWithStartDay:(NSString *)startDay
                                           andEndDay:(NSString *)endDay {
  if (startDay == nil && [startDay isEqualToString:@""] &&
      !(startDay.length == 11) && endDay == nil &&
      [endDay isEqualToString:@""] && !(endDay.length == 11)) {
    return @"";
  }

  startDay = [ProcessInputData removeZeroInMonthAndDay:startDay];
  endDay = [ProcessInputData removeZeroInMonthAndDay:endDay];

  if ([[startDay substringToIndex:4]
          isEqualToString:[endDay substringToIndex:4]]) {
    startDay = [startDay substringFromIndex:5];
    endDay = [endDay substringFromIndex:5];
  } else {
    startDay = [startDay substringFromIndex:2];
    endDay = [endDay substringFromIndex:2];
  }
  return [NSString stringWithFormat:@"%@-%@", startDay, endDay];
}

+ (NSString *)removeZeroInMonthAndDay:(NSString *)string {
  /// 注意这里一定要先去除天的0再去除月的0
  if ([[string substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"0"]) {
    string = [string stringByReplacingCharactersInRange:NSMakeRange(8, 1)
                                             withString:@""];
  }
  if ([[string substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"0"]) {
    string = [string stringByReplacingCharactersInRange:NSMakeRange(5, 1)
                                             withString:@""];
  }
  return string;
}

/** 转化NSString的金额格式(分到元) */
+ (NSString *)convertMoneyString:(NSString *)string {
  if (string == nil) {
    return @"--";
  }
  if ([string isEqualToString:@"--"]) {
    return @"--";
  }
  if (string == nil || [string isEqualToString:@""] ||
      [string isEqualToString:@"0.00"]) {
    return @"0.00";
  }

  string = [NSString stringWithFormat:@"%f", ([string doubleValue] / 100)];

  ///保留原始符号
  BOOL sign = [string doubleValue] >= 0 ? YES : NO;
  string =
      [ProcessInputData numbersAndTwoPunctuation:string andValidDecimalDigit:2];

  if (!sign) {
    string = [NSString stringWithFormat:@"-%@", string];
  }

  //  if ([string hasSuffix:@"00"]) {
  //    string = [string
  //        stringByReplacingCharactersInRange:NSMakeRange((string.length - 3),
  //        3)
  //                                withString:@""];
  //  } else if ([string hasSuffix:@"0"]) {
  //    string = [string
  //        stringByReplacingCharactersInRange:NSMakeRange((string.length - 1),
  //        1)
  //                                withString:@""];
  //  }
  return string;
}

/** 把小数变成整数 */
+ (NSString *)convertDecimalConversionInteger:(NSString *)decimal {
  if ([decimal isEqualToString:@"--"]) {
    return @"--";
  }
  NSCharacterSet *num;
  //过滤字符串里的非数字和小数点的内容
  num = [[NSCharacterSet
      characterSetWithCharactersInString:Numbers_Point] invertedSet];
  NSString *filtered = [[decimal componentsSeparatedByCharactersInSet:num]
      componentsJoinedByString:@""];
  //判断是否为小数
  if ([filtered rangeOfString:@"."].location != NSNotFound) {
    //小数
    NSArray *array = [filtered componentsSeparatedByString:@"."];
    NSString *str1 = array[0];
    filtered = [self forNumberClearZero:str1];
    return filtered;
  } else {
    return [self forNumberClearZero:filtered];
  }
}

/** 格式化 数字 */
+ (NSString *)numbersFormatterWithString:(NSString *)numString {
  if (numString.length <= 0 || !numString) {
    return nil;
  }

  //以.截取成两个字符串
  NSArray *array = [numString componentsSeparatedByString:@"."];
  NSString *str1 = array[0];
  NSString *str2 = array[1];
  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
  [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
  NSString *string = [numberFormatter stringFromNumber:@([str1 integerValue])];
  NSString *completeNum = [NSString stringWithFormat:@"%@.%@", string, str2];
  return completeNum;
}

/** 将浮点数 转化成 %数  当数据 为空时 返回 -- */
+ (NSString *)floatingPointNumberIntoPercentage:(NSString *)number
                               withDecimalDigit:(DecimalDigitNumber)digitNum {
  NSString *string = nil;
  if (number.length != 0 && number) {
    switch (digitNum) {
    case DecimalDigitTwoNumber:
      string =
          [NSString stringWithFormat:@"%0.2f%%", [number floatValue] * 100];
      break;
    case DecimalDigitZeroNumber:
      string =
          [NSString stringWithFormat:@"%0.0f%%", [number floatValue] * 100];
      break;
    }
  } else if (number.length == 0 || number == nil) {
    return @"--";
  }
  return string;
}

/** 将小数转化成 整数 或者 保留2位小数 为空时 返回 --  */
+ (NSString *)floatingTransformedIntegerOrTwoFloat:(NSString *)number
                                   withDecimaDigit:
                                       (DecimalDigitNumber)digitNum {
  if (number.length == 0 || number == nil) {
    return @"--";
  }
  NSString *string = nil;
  switch (digitNum) {
  case DecimalDigitZeroNumber:
    //整数
    string = [NSString stringWithFormat:@"%0.0f", [number floatValue]];
    break;
  case DecimalDigitTwoNumber:
    //保留2位小数
    string = [NSString stringWithFormat:@"%0.2f", [number floatValue]];
    break;
  }
  return string;
}
/** 将大于 1W 的数据 转化成 1.00 万 */
+ (NSString *)digitalFormatNumber:(NSInteger)numberd {
  CGFloat num = 0;
  if (numberd > 0) {
    if ( numberd >= 10000) {
      num = numberd  * 0.0001;
      return [NSString stringWithFormat:@"%0.2f万", num];
    } else {
      return [NSString stringWithFormat:@"%ld",(long)numberd];
    }
  }
  return @"0";
}

/** 将带有%号的 数据 把%号变小 */
+ (void)attributedTextWithString:(NSString *)textNumber
                       withColor:(UIColor *)color
                     withUILabel:(UILabel *)label {
  NSString *fristString =
  [textNumber substringWithRange:NSMakeRange(0, textNumber.length - 1)];
  NSString *secondString = [NSString stringWithFormat:@"%%"];
  
  [label setAttributedTextWithFirstString:fristString
                             andFirstFont:[UIFont
                                           systemFontOfSize:Font_Height_17_0]
                            andFirstColor:color
                          andSecondString:secondString
                            andSecondFont:[UIFont systemFontOfSize:
                                           (Font_Height_17_0 * 0.5)]
                           andSecondColor:color];
}


@end
