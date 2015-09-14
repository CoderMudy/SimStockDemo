
//
//  WeiboUtil.m
//  SimuStock
//
//  Created by Mac on 14/12/9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "WeiboUtil.h"
#import "WeiboText.h"
#import "StockUtil.h"

#import "FTCoreTextView.h"

static const CGFloat kBasicTextSize = 14.0f;

// static const CGFloat kLineHeightMultiple= 1.3f;

@implementation WeiboUtil

+ (void)addTextStylesToTextView:(FTCoreTextView *)coreTextView {
  //  Define styles
  FTCoreTextStyle *defaultStyle = [[FTCoreTextStyle alloc] init];
  defaultStyle.name = FTCoreTextTagDefault;
  defaultStyle.textAlignment = FTCoreTextAlignementLeft;
  defaultStyle.font = [UIFont systemFontOfSize:kBasicTextSize];

  UIColor *commonPressColor = [Globle colorFromHexRGB:@"#06c0ef"]; //蓝色按下态
  FTCoreTextStyle *userStyle =
      [FTCoreTextStyle styleWithName:FTCoreTextTagLink];
  userStyle.name = @"user";
  userStyle.color = [Globle colorFromHexRGB:Color_Blue_but];
  userStyle.pressedColor = commonPressColor;
  userStyle.font = [UIFont systemFontOfSize:kBasicTextSize];

  FTCoreTextStyle *stockStyle =
      [FTCoreTextStyle styleWithName:FTCoreTextTagLink];
  stockStyle.name = @"stock";
  stockStyle.color = [Globle colorFromHexRGB:Color_Stock_Code]; //黄色
  stockStyle.pressedColor = [Globle colorFromHexRGB:@"#ffd200"]; //黄色按下态
  stockStyle.font = [UIFont systemFontOfSize:kBasicTextSize];

  FTCoreTextStyle *topicStyle =
      [FTCoreTextStyle styleWithName:FTCoreTextTagLink];
  topicStyle.name = @"topic";
  topicStyle.color = [Globle colorFromHexRGB:Color_Blue_but];
  topicStyle.pressedColor = commonPressColor;
  topicStyle.font = [UIFont systemFontOfSize:kBasicTextSize];

  FTCoreTextStyle *matchStyle =
      [FTCoreTextStyle styleWithName:FTCoreTextTagLink];
  matchStyle.name = @"match";
  matchStyle.color = [Globle colorFromHexRGB:Color_Blue_but];
  matchStyle.pressedColor = commonPressColor;
  matchStyle.font = [UIFont systemFontOfSize:kBasicTextSize];

  FTCoreTextStyle *stockBarStyle =
      [FTCoreTextStyle styleWithName:FTCoreTextTagLink];
  stockBarStyle.name = @"stockbar";
  stockBarStyle.color = [Globle colorFromHexRGB:Color_Blue_but];
  stockBarStyle.pressedColor = commonPressColor;
  stockBarStyle.font = [UIFont systemFontOfSize:kBasicTextSize];

  FTCoreTextStyle *aStyle = [FTCoreTextStyle styleWithName:FTCoreTextTagLink];
  aStyle.name = @"a";
  aStyle.underlined = NO;
  aStyle.color = [Globle colorFromHexRGB:Color_Blue_but];
  aStyle.pressedColor = commonPressColor;
  aStyle.font = [UIFont systemFontOfSize:kBasicTextSize];

  [coreTextView changeDefaultTag:FTCoreTextTagLink toTag:@"a"];

  //  Apply styles
  [coreTextView addStyles:@[
    defaultStyle,
    userStyle,
    stockStyle,
    topicStyle,
    matchStyle,
    stockBarStyle,
    aStyle
  ]];
}

+ (NSArray *)parseWeiboRichContext:(NSString *)content {
  if (!content) {
    return nil;
  }

  NSRange searchedRange = NSMakeRange(0, [content length]);
  NSString *pattern = @"[^<>]+|<(\"[^\"]*\"|'[^']*'|[^'\">])*>|[^<]+|[^>]+";
  NSError *error = nil;

  NSRegularExpression *regex =
      [NSRegularExpression regularExpressionWithPattern:pattern
                                                options:0
                                                  error:&error];
  NSArray *matches =
      [regex matchesInString:content options:0 range:searchedRange];

  NSMutableArray *result = [[NSMutableArray alloc] init];

  for (NSTextCheckingResult *match in matches) {
    NSString *matchText = [content substringWithRange:[match range]];

    if ([matchText hasPrefix:@"<stock"] &&
        ![matchText hasPrefix:@"<stockbar"]) {
      StockWeiboText *text = [[StockWeiboText alloc] init];
      NSString *stockCode = [self getAttrValueWithSource:matchText
                                             withElement:@"stock"
                                                withAttr:@"code"];
      NSString *stockName = [self getAttrValueWithSource:matchText
                                             withElement:@"stock"
                                                withAttr:@"name"];
      text.stockCode = stockCode;
      text.stockName = stockName;

      NSString *sixCode = [StockUtil sixStockCode:stockCode];
      text.content = [NSString stringWithFormat:@"%@(%@)", stockName, sixCode];
      [result addObject:text];
    } else if ([matchText hasPrefix:@"<user"]) {
      UserWeiboText *text = [[UserWeiboText alloc] init];
      NSString *uid = [self getAttrValueWithSource:matchText
                                       withElement:@"user"
                                          withAttr:@"uid"];
      NSString *nickname = [self getAttrValueWithSource:matchText
                                            withElement:@"user"
                                               withAttr:@"nick"];
      text.uid = uid;
      text.nickname = nickname;
      text.content = [nickname replaceAll:@"ིིུུུ" with:@""];
      [result addObject:text];
    } else if ([matchText hasPrefix:@"<atuser"]) {
      AtUserWeiboText *text = [[AtUserWeiboText alloc] init];
      NSString *uid = [self getAttrValueWithSource:matchText
                                       withElement:@"atuser"
                                          withAttr:@"uid"];
      NSString *nickname = [self getAttrValueWithSource:matchText
                                            withElement:@"atuser"
                                               withAttr:@"nick"];
      text.uid = uid;
      text.nickname = [nickname replaceAll:@"ིིུུུ" with:@""];
      text.content = [@"@" stringByAppendingString:text.nickname];
      [result addObject:text];
    } else if ([matchText hasPrefix:@"<a"] &&
               ![matchText startsWith:@"<atuser"]) {
      UrlWeiboText *text = [[UrlWeiboText alloc] init];
      NSString *url = [self getAttrValueWithSource:matchText
                                       withElement:@"a"
                                          withAttr:@"href"];

      NSString *title = [self getAttrValueWithSource:matchText
                                         withElement:@"a"
                                            withAttr:@"alt"];
      url = url ? url : @"";

      title = title ? title : @"";

      if ([url startsWith:@"http://"] || [url startsWith:@"https://"]) {
        // do nothing
      } else if ([url startsWith:@"youguu://"]) {
        text.content = title ? title : @"聊股链接";
      } else {
        url = [@"http://" stringByAppendingString:url];
      }

      text.title = title ? title : @"聊股链接";
      text.url = url;
      [result addObject:text];
    } else if ([matchText hasPrefix:@"<font"]) {

      NSString *textString = [self getAttrValueWithSource:matchText
                                              withElement:@"font"
                                                 withAttr:@"text"];
      NSString *textStyle = [self getAttrValueWithSource:matchText
                                             withElement:@"font"
                                                withAttr:@"style"];
      NSString *textColorString = [self getAttrValueWithSource:matchText
                                                   withElement:@"font"
                                                      withAttr:@"color"];
      NSString *textSizeString = [self getAttrValueWithSource:matchText
                                                  withElement:@"font"
                                                     withAttr:@"size"];

      UIColor *textColor;
      float textSize = 0;

      NSString *floatString;

      BOOL hasError = NO;
      @try {
        textColor = [Globle colorFromHexRGB:textColorString];
        if (textSizeString) {
          textSizeString = [textSizeString toLowerCase];
          if (textSizeString && ![@"" equals:textSizeString]) {
            floatString =
                [textSizeString substringFromIndex:0
                                           toIndex:[textSizeString length] - 2];
            if ([textSizeString endsWith:@"px"]) {
              textSize =
                  [floatString floatValue] / [[UIScreen mainScreen] scale];
            } else {
              //默认为point单位
              textSize = [floatString floatValue];
            }
          }
        }
      }
      @catch (NSException *exception) {
        textSizeString = nil;
        floatString = nil;
        hasError = YES;
      }

      if (hasError || textString == nil) { //匹配一般文字
        WeiboText *text = [[WeiboText alloc] init];
        text.content = matchText;
        [result addObject:text];
      } else {
        FontWeiboText *text = [[FontWeiboText alloc] init];
        if (textSizeString && textSizeString.length > 0) {
          text.textSize = textSize;
        }
        text.content = textString;
        if (textStyle && [textStyle indexOfString:@"bold"] != -1) {
          text.isBold = YES;
        } else {
          text.isBold = NO;
        }
        text.textColor = textColor;

        [result addObject:text];
      }
    } else if ([matchText hasPrefix:@"<match"]) {
      MatchWeiboText *text = [[MatchWeiboText alloc] init];

      NSString *matchId = [self getAttrValueWithSource:matchText
                                      withElement:@"match"
                                         withAttr:@"id"];
      NSString *matchName = [self getAttrValueWithSource:matchText
                                             withElement:@"match"
                                                withAttr:@"text"];
      NSString *isReward = [self getAttrValueWithSource:matchText
                                             withElement:@"match"
                                                withAttr:@"isReward"];
      NSString *isSenior = [self getAttrValueWithSource:matchText
                                             withElement:@"match"
                                                withAttr:@"isSenior"];
      NSString *matchType = [self getAttrValueWithSource:matchText
                                             withElement:@"match"
                                                withAttr:@"type"];

      text.matchId = matchId;
      text.matchName = matchName;
      text.content = matchName;
      text.isReward = isReward;
      text.isSenior = isSenior;
      text.matchType = matchType;
      [result addObject:text];
    } else if ([matchText hasPrefix:@"<stockbar"]) {
      StockBarWeiboText *text = [[StockBarWeiboText alloc] init];

      NSString *barId = [self getAttrValueWithSource:matchText
                                         withElement:@"stockbar"
                                            withAttr:@"id"];
      NSString *matchName = [self getAttrValueWithSource:matchText
                                             withElement:@"stockbar"
                                                withAttr:@"text"];

      text.barId = @([barId longLongValue]);
      text.barName = matchName;
      text.content = matchName;
      [result addObject:text];
    } else {

      NSRange searchedRangeTopic = NSMakeRange(0, [matchText length]);
      NSString *patternTopic = @"#[^#]{1,20}#"; // topic 匹配
      NSError *error = nil;

      NSRegularExpression *regexTopic =
          [NSRegularExpression regularExpressionWithPattern:patternTopic
                                                    options:0
                                                      error:&error];
      NSArray *matchesTopic = [regexTopic matchesInString:matchText
                                                  options:0
                                                    range:searchedRangeTopic];
      NSInteger start = 0;
      for (NSTextCheckingResult *match in matchesTopic) {
        NSRange range = [match range];
        if (range.location != start) {
          NSString *notMatchTextTopic = [matchText
              substringWithRange:NSMakeRange(start, range.location - start)];
          //匹配一般文字和emoji表情
          WeiboText *text = [[WeiboText alloc] init];
          text.content = notMatchTextTopic;
          [result addObject:text];
        }
        //匹配Topic形式
        NSString *matchTextTopic = [matchText substringWithRange:range];
        TopicWeiboText *text = [[TopicWeiboText alloc] init];
        text.topic = [matchTextTopic
            substringWithRange:NSMakeRange(1, [matchTextTopic length] - 2)];
        text.content = matchTextTopic;
        [result addObject:text];
        start = range.location + range.length;
      }
      if (start != [matchText length] - start) {
        NSString *notMatchTextTopic = [matchText
            substringWithRange:NSMakeRange(start, [matchText length] - start)];
        //匹配一般文字和emoji表情
        WeiboText *text = [[WeiboText alloc] init];
        text.content = notMatchTextTopic;
        [result addObject:text];
      }
    }
  }
  return result;
}

+ (NSArray *)parseTextAndEmojiFaces:(NSString *)text {
  NSRange searchedRange = NSMakeRange(0, [text length]);
  NSString *emoji = @"([\ue001-\ue05a\ue101-\ue15a\ue201-\ue253\ue401-"
      @"\ue44c\ue501-\ue537]{1})";
  NSString *pattern =
      [emoji stringByAppendingString:@"|([^\ue001-\ue05a\ue101-\ue15a\ue201-"
             @"\ue253\ue401-\ue44c\ue501-\ue537]+)"];
  NSError *error = nil;

  NSRegularExpression *regex =
      [NSRegularExpression regularExpressionWithPattern:pattern
                                                options:0
                                                  error:&error];
  NSArray *matches = [regex matchesInString:text options:0 range:searchedRange];

  NSMutableArray *result = [[NSMutableArray alloc] init];

  for (NSTextCheckingResult *match in matches) {
    NSString *matchText = [text substringWithRange:[match range]];
    //匹配Emoji形式
    if ([matchText matches:@"^[\ue001-\ue05a\ue101-\ue15a\ue201-\ue253\ue401-"
                   @"\ue44c\ue501-\ue537]$"]) {
      WeiboText *text = [[WeiboText alloc] init];
      text.content = matchText;
      [result addObject:text];
    } else {
      //匹配一般文字
      WeiboText *text = [[WeiboText alloc] init];
      text.content = matchText;
      [result addObject:text];
    }
  }

  return result;
}

+ (NSString *)getAttrValueWithSource:(NSString *)source
                         withElement:(NSString *)element
                            withAttr:(NSString *)attr {
  //  source = @"<atuser uid='3559971' nick='leon0904' />";
  NSRange searchedRange = NSMakeRange(0, [source length]);
  NSString *pattern = [[[[@"<" stringByAppendingString:element]
      stringByAppendingString:@"[^<>]*?\\s+"] stringByAppendingString:attr]
      stringByAppendingString:@"=((\"([^\"]*?)\")|('([^']*?)')).*?>"];
  NSError *error = nil;

  NSRegularExpression *regex = [NSRegularExpression
      regularExpressionWithPattern:pattern
                           options:NSRegularExpressionDotMatchesLineSeparators
                             error:&error];

  NSArray *matches =
      [regex matchesInString:source options:0 range:searchedRange];
  if (matches && [matches count] > 0) {
    NSTextCheckingResult *match = matches[0];
    if (match.numberOfRanges < 6) {
      return nil;
    }

    NSRange group1 = [matches[0] rangeAtIndex:3];
    if (group1.location == NSNotFound) {
      group1 = [matches[0] rangeAtIndex:5];
    }
    if (group1.location == NSNotFound) {
      return nil;
    }
    NSString *value = [source substringWithRange:group1];
    return value;
  }

  //上述常规方法无法解析时，采用字符串截取的方式再次解析一次
  NSInteger index = [source indexOfString:attr];
  if (index > 0) {
    NSInteger start =
        [source indexOfString:@"\"" fromIndex:index + attr.length + 1];
    if (start > 0) {
      NSInteger end = [source indexOfString:@"\"" fromIndex:start + 1];
      return [source substringFromIndex:start + 1 toIndex:end];
    }
  }
  return nil;
}

@end
