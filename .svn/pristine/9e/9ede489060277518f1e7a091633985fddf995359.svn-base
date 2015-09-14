//
//  StockUtil.m
//  SimuStock
//
//  Created by Mac on 14-10-25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "StockUtil.h"
#import "StockDBManager.h"

@implementation SecuritiesInfo

- (instancetype)init {
  if (self = [super init]) {
    _otherInfoDic = [[NSMutableDictionary alloc] init];
  }
  return self;
}

@end

@implementation StockUtil

#define RED_COLOR [Globle colorFromHexRGB:Color_Red]
#define GREEN_COLOR [Globle colorFromHexRGB:Color_Green]
#define NORMOL_COLOR [Globle colorFromHexRGB:Color_Text_Common]
//原股票红绿色
//#define RED_COLOR [Globle colorFromHexRGB:@"#c32224"]
//#define GREEN_COLOR [Globle colorFromHexRGB:@"#08853d"]
//#define NORMOL_COLOR [Globle colorFromHexRGB:@"#454545"]

+ (NSString *)eightStockCode:(NSString *)stockCode {
  if ([stockCode length] == 6) {
    if ([stockCode hasPrefix:@"6"]) {
      return [@"11" stringByAppendingString:stockCode];
    } else {
      return [@"21" stringByAppendingString:stockCode];
    }
  }
  return stockCode;
}

+ (NSString *)sixStockCode:(NSString *)stockCode {
  if ([stockCode length] == 8) {
    return [stockCode substringFromIndex:2];
  }
  return stockCode;
}

+ (NSString *)getPriceFormatWithFirstType:(NSString *)firstType {
  return [StockUtil isFund:firstType] ? @"%.3f" : @"%.2f";
}

+ (NSString *)getPriceFormatWithTradeType:(NSInteger)tradeType {
  return 1 == tradeType ? @"%.3f" : @"%.2f";
}

+ (BOOL)isMarketIndex:(NSString *)firstType {
  return [firstType isEqualToString:FIRST_TYPE_INDEX];
}

+ (UIColor *)getColorByProfit:(NSString *)profit {
  @try {
    if ([@"--" isEqualToString:profit]) {
      return NORMOL_COLOR;
    }
    
    float profitFloat = [profit floatValue];
    return [self getColorByFloat:profitFloat];
  } @catch (NSException *ex) {
    NSLog(@"ex:%@", ex);
    return NORMOL_COLOR;
  }
}

+ (UIColor *)getColorByFloat:(float)value {
  if (value > 0.00001f) {
    return RED_COLOR;
  } else if (value < -0.00001f) {
    return GREEN_COLOR;
  } else {
    return NORMOL_COLOR;
  }
}

/// Added by Yuemeng 如果价格相等，则取上一个颜色
+ (UIColor *)getColorByFloatAndLastColor:(float)value {
  static UIColor *lastColor;
  if (value > 0.00001f) {
    lastColor = RED_COLOR;
    return RED_COLOR;
  } else if (value < -0.00001f) {
    lastColor = GREEN_COLOR;
    return GREEN_COLOR;
  } else {
    if (!lastColor) {
      lastColor = NORMOL_COLOR;
    }
    return lastColor;
  }
}

+ (UIColor *)getColorByChangePercent:(NSString *)changePercent {
  if ([@"--" isEqualToString:changePercent]) {
    return NORMOL_COLOR;
  }
  if ([changePercent rangeOfString:@"-"].length > 0) {
    return GREEN_COLOR;
  } else if ([changePercent isEqualToString:@"0.00%"]) {
    return NORMOL_COLOR;
  } else {
    return RED_COLOR;
  }
}

+ (UIColor *)getColorByText:(NSString *)text {
  if ([@"--" isEqualToString:text]) {
    return NORMOL_COLOR;
  } else if ([text hasSuffix:@"%"]) {
    return [self getColorByChangePercent:text];
  } else {
    return [self getColorByProfit:text];
  }
}

+ (int)digitalNumFromStockCode:(NSString *)code {
  int num = 2;
  if (code == nil || code.length != 8) {
    return num;
  }
  NSString *stockCode = [code substringFromIndex:2];
  if ([code startsWith:@"1"]) {
    if ([stockCode startsWith:@"900"] || [stockCode startsWith:@"500"] ||
        [stockCode startsWith:@"51"]) {
      num = 3;
    }
  } else if ([code startsWith:@"2"]) {
    if ([stockCode startsWith:@"20"] || [stockCode startsWith:@"15"] ||
        [stockCode startsWith:@"16"] || [stockCode startsWith:@"18"]) {
      num = 3;
    }
  }
  return num;
}

/**
 * 上证一级分类对应的代码规则
 */
static NSDictionary *LEVELFIRSTMAP_SH;

/**
 * 上证二级分类对应的代码规则
 */
static NSDictionary *LEVELSECONDMAP_SH;

/**
 * 深证一级分类对应的代码规则
 */
static NSDictionary *LEVELFIRSTMAP_SZ;
/**
 * 深证二级分类对应的代码规则
 */
static NSDictionary *LEVELSECONDMAP_SZ;

+ (void)initialize {
  // 上证
  LEVELFIRSTMAP_SH = @{
                       
                       FIRST_TYPE_INDEX : @"000",        // 指数
                       FIRST_TYPE_STKA : @"600,601,603", // A股
                       FIRST_TYPE_STKB : @"900",         // B股
                       FIRST_TYPE_FND : @"500,51",       // 基金
                       FIRST_TYPE_BND : @"009,010,019,020,100,104,105,106,107,113,120,121,122,126,"
                       @"129,130", // 国债
                       FIRST_TYPE_OPT : @"580,582"
                       }; // 权证
  
  // 深圳
  LEVELFIRSTMAP_SZ = @{
                       
                       FIRST_TYPE_INDEX : @"39",     // 指数
                       FIRST_TYPE_STKA : @"00,30",   // A股
                       FIRST_TYPE_STKB : @"20",      // B股
                       FIRST_TYPE_FND : @"15,16,18", // 基金
                       FIRST_TYPE_BND : @"10,11,12", // 国债
                       FIRST_TYPE_OPT : @"08,28,38", // 权证
                       
                       };
  
  LEVELSECONDMAP_SZ = @{
                        
                        SECOND_TYPE_GEM : @"30",  // 创业板
                        SECOND_TYPE_SMB : @"002", // 中小板
                        SECOND_TYPE_ETF : @"15",  // ETF
                        SECOND_TYPE_LOF : @"16"   // LOF
                        
                        };
}

+ (int)getLevelSecond:(NSString *)code {
  if (code == nil || code.length != 8) {
    return 0;
  }
  NSString *stockCode = [code substringFromIndex:2];
  NSDictionary *codeMap;
  if ([code startsWith:@"1"]) { // 上证代码
    codeMap = LEVELSECONDMAP_SH;
  } else { // 深证代码
    codeMap = LEVELSECONDMAP_SZ;
  }
  for (NSString *key in codeMap) {
    NSString *value = codeMap[key];
    
    NSArray *codeSegments = [value componentsSeparatedByString:@","];
    for (NSString *codeSegment in codeSegments) {
      if ([stockCode startsWith:codeSegment]) {
        return 1; // NSNumber in[temp_code intValue];
      }
    }
  }
  
  return 0;
}

+ (BOOL)isFund:(NSString *)firstType {
  return [firstType isEqualToString:FIRST_TYPE_FND];
}

/**
 * 返回股票代码对应的一级分类
 *
 * @param code 八位股票代码
 * @return 一级分类代码
 */

+ (int)getLevelFirst:(NSString *)code {
  if (code == nil || code.length != 8) {
    return 0;
  }
  NSString *stockCode = [code substringFromIndex:2];
  NSDictionary *codeMap;
  if ([code startsWith:@"1"]) { // 上证代码
    codeMap = LEVELFIRSTMAP_SH;
  } else { // 深证代码
    codeMap = LEVELFIRSTMAP_SZ;
  }
  for (NSString *key in codeMap) {
    NSString *value = codeMap[key];
    
    NSArray *codeSegments = [value componentsSeparatedByString:@","];
    for (NSString *codeSegment in codeSegments) {
      if ([stockCode startsWith:codeSegment]) {
        return 1; // NSNumber in[temp_code intValue];
      }
    }
  }
  
  return 0;
}

+ (NSString *)formatAmount:(double)amount isVolum:(BOOL)isVolum {
  if (isVolum) {
    if (amount <= 10000) {
      return [NSString stringWithFormat:@"%.0f手", amount];
    } else if (amount <= 10000 * 10000) {
      return [NSString stringWithFormat:@"%.1f万手", amount / 10000.f];
    } else if (amount <= 10000ll * 10000 * 1000) {
      return
      [NSString stringWithFormat:@"%.2f亿手", amount / (10000ll * 10000)];
    } else {
      return [NSString
              stringWithFormat:@"%.2f千亿手", amount / (10000ll * 10000 * 1000)];
    }
  } else {
    if (amount <= 10000) {
      return [NSString stringWithFormat:@"%.0f", amount];
    } else if (amount <= 10000 * 10000) {
      return [NSString stringWithFormat:@"%.1f万", amount / 10000.f];
    } else if (amount <= 10000ll * 10000 * 1000) {
      return [NSString stringWithFormat:@"%.2f亿", amount / (10000ll * 10000)];
    } else {
      return [NSString
              stringWithFormat:@"%.2f千亿", amount / (10000ll * 10000 * 1000)];
    }
  }
}

///转换112233格式为11:22:33
+ (NSString *)timeFromNSIntegerWithSec:(NSInteger)time {
  
  NSInteger h = time / 10000;
  NSInteger m = (time - h * 10000) / 100;
  NSString *hours = [NSString stringWithFormat:@"%ld", (long)h];
  NSString *minutes = [NSString stringWithFormat:@"%ld", (long)m];
  
  if (h < 10) {
    hours = [NSString stringWithFormat:@"0%@", hours];
  }
  
  if (m < 10) {
    minutes = [NSString stringWithFormat:@"0%@", minutes];
  }
  return [[NSString stringWithFormat:@"%@:%@", hours, minutes] copy];
}

+ (NSString *)timeFromNSIntegerWithoutSec:(NSInteger)date {
  NSMutableString *dateStr = [NSMutableString stringWithFormat:@"%ld", (long)date];
  if (dateStr.length == 3) {
    [dateStr insertString:@"0" atIndex:0];
  }
  [dateStr insertString:@":" atIndex:2];
  return dateStr;
}


///转换20150427格式为04-27
+ (NSString *)dateFromNSInteger:(NSInteger)date {
  NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)date];
  //永远取最后4位
  NSMutableString *timeMStr = [[NSMutableString alloc]
                               initWithString:[timeStr substringWithRange:NSMakeRange(timeStr.length - 4,
                                                                                      4)]];
  [timeMStr insertString:@"-" atIndex:2];
  return [timeMStr copy];
}

///整数手换算万、亿单位，保留2位小数
+ (NSString *)handsStringFromVolume:(int64_t)volume needsHand:(BOOL)needsHand {
  
  NSString *hands;
  if (llabs(volume) >= 100000000) {
    //大于亿，以亿为单位
    hands = [SimuUtil formatDecimal:(volume / 100000)ForDeciNum:2 ForSign:YES];
    hands = [hands stringByAppendingString:(needsHand ? @"亿手" : @"亿")];
  } else if (llabs(volume) >= 10000) {
    //大于万，以万为单位
    hands = [SimuUtil formatDecimal:(volume / 10)ForDeciNum:2 ForSign:YES];
    hands = [hands stringByAppendingString:(needsHand ? @"万手" : @"万")];
  } else {
    hands = (volume == 0)
    ? @"0"
    : [NSString stringWithFormat:(needsHand ? @"%lld手" : @"%lld"),
       volume];
  }
  return hands;
}

+ (NSString *)handsStringFromDouble:(double)volume needsHand:(BOOL)needsHand {
  NSString *hands;
  if (fabs(volume) >= 100000000) {
    //大于亿，以亿为单位
    hands = [SimuUtil formatDecimal:(volume / 100000)ForDeciNum:2 ForSign:YES];
    hands = [hands stringByAppendingString:(needsHand ? @"亿手" : @"亿")];
  } else if (fabs(volume) >= 10000) {
    //大于万，以万为单位
    hands = [SimuUtil formatDecimal:(volume / 10)ForDeciNum:2 ForSign:YES];
    hands = [hands stringByAppendingString:(needsHand ? @"万手" : @"万")];
  } else {
    hands = (volume == 0)
    ? @"0"
    : [NSString stringWithFormat:(needsHand ? @"%.2f手" : @"%.2f"),
       volume];
  }
  return hands;
}

///整数手换算万、亿单位， 指定保留位数
+ (NSString *)handsStringForS5B5FromVolume:(int64_t)volume {
  
  NSString *hands;
  //亿结尾，直接用亿
  if (llabs(volume) >= 100000000) {
    hands = [NSString stringWithFormat:@"%lld亿", llabs(volume) / 100000000];
    //百万以上，用万结尾
  } else if (llabs(volume) >= 1000000) {
    hands = [NSString stringWithFormat:@"%lld万", llabs(volume) / 10000];
  } else {
    hands = [NSString stringWithFormat:@"%lld", volume];
  }
  return hands;
}

#pragma mark - 获取当前时间
+ (NSString *)getCurrentTime:(NSInteger)index {
  if (index < 121) {
    NSInteger startMin = 9 * 60 + 30;
    NSInteger curMin = startMin + index;
    NSInteger hour = curMin / 60;
    NSInteger minutes = curMin % 60;
    NSString *time = [NSString
                      stringWithFormat:@"%2.2ld : %2.2ld", (long)hour, (long)minutes];
    return time;
  } else {
    NSInteger startMin = 13 * 60;
    NSInteger curMin = startMin + index - 120;
    NSInteger hour = curMin / 60;
    NSInteger minutes = curMin % 60;
    NSString *time = [NSString
                      stringWithFormat:@"%2.2ld : %2.2ld", (long)hour, (long)minutes];
    return time;
  }
}

+ (NSString *)queryFirstTypeWithStockCode:(NSString *)stockCode
                            withStockName:(NSString *)stockName {
  NSArray *array;
  //通过8位股票代码查询
  if ([stockCode length] == 8) {
    array = [StockDBManager searchFromDataBaseWith8CharCode:stockCode
                                          withRealTradeFlag:YES];
  }
  //通过股票名称查询
  if (array == nil || [array count] == 0) {
    array = [StockDBManager searchFromDataBaseWithName:stockName
                                     withRealTradeFlag:YES];
  }
  
  //通过股票代码片段查询，可能会出现混淆的情况
  if (array == nil || [array count] == 0) {
    array = [StockDBManager searchStockWithQueryText:stockCode
                                   withRealTradeFlag:YES];
  }
  if (array && [array count] > 0) {
    StockFunds *stock = array[0];
    return [stock.firstType stringValue];
  } else {
    //找不到,置为未指定
    return FIRST_TYPE_UNSPEC;
  }
}

@end
