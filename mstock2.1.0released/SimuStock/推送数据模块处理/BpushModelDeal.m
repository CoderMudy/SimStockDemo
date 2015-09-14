//
//  BpushModelDeal.m
//  SimuStock
//
//  Created by Mac on 15/4/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BpushModelDeal.h"
#import "AppDelegate.h"
#import "SimuUtil.h"
#import "StockUtil.h"
#import "NSURL+QueryComponent.h"
#import "StockWarningController.h"
#import "TopNewShowPushLabel.h"
// static BpushModelDeal * newShowBpushModel;
@implementation BpushModelDeal
///返回应用内部推送动画的文本内容
+ (void)BPushTextAnimationWithMessgate:(NSDictionary *)userInfo {
  NSNumber *number = userInfo[@"type"];
  if (number == nil)
    return;
  BPushTypeMNCG type = (BPushTypeMNCG)[number integerValue];
  BOOL ispush = [BpushModelDeal PushStatisticsAndStorage:userInfo andType:type];
  if (ispush == NO) {
    return;
  }
  NSString *alert = userInfo[@"aps"][@"alert"];
  NSString *alertMsg = [NSString stringWithFormat:@"%@", alert];
  if (type == BPushAllExpert && type == BPushExpertTraceMessage) {
    UIAlertView *alertView = [[UIAlertView alloc]
            initWithTitle:@"通知"
                  message:alertMsg
                 delegate:(AppDelegate *)([UIApplication sharedApplication]
                                              .delegate)
        cancelButtonTitle:@"关闭"
        otherButtonTitles:@"查看", nil];
    alertView.tag = 1000;
    [alertView show];
  } else {
    if (type == BPushTongAccountProfitability) {
      alertMsg = [@"盈利通知:" stringByAppendingString:alertMsg];
    } else if (type == BPushTheSystemMessage) {
      NSString * alertFilterMsg =[BpushModelDeal flattenHTML:alertMsg trimWhiteSpace:NO];
      alertMsg = [@"系统消息:" stringByAppendingString:alertFilterMsg];
    } else if (type == BPushSoonerOrLaterTheNewspaper) {
      alertMsg = [@"股市要闻:" stringByAppendingString:alertMsg];
    } else if (type == BPushStockPricesEarlyWarning || type == BPushMarketTransaction) {
      alertMsg = [BpushModelDeal getStockCodeAndName:userInfo];
      alertMsg = [@"股价预警:" stringByAppendingString:alertMsg];
    } else if (type == BPushMasterPlanMessageTrace) {
      alertMsg = [@"追踪消息:" stringByAppendingString:alertMsg];
    }
    [TopNewShowPushLabel setBpushMessageContent:alertMsg
                                  andDictionary:userInfo];
  }
  return;
}

+(NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim
{
  NSScanner *theScanner = [NSScanner scannerWithString:html];
  NSString *text = nil;
  
  while ([theScanner isAtEnd] == NO) {
    // find start of tag
    [theScanner scanUpToString:@"<" intoString:NULL] ;
    // find end of tag
    [theScanner scanUpToString:@">" intoString:&text] ;
    // replace the found tag with a space
    //(you can filter multi-spaces out later if you wish)
    html = [html stringByReplacingOccurrencesOfString:
            [ NSString stringWithFormat:@"%@>", text]
                                           withString:@""];
  }
  
  return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}

///系统消息与股票预警推送统计和数据存储
+ (BOOL)PushStatisticsAndStorage:(NSDictionary *)userInfo
                         andType:(BPushTypeMNCG)type {
  if (type == BPushStockPricesEarlyWarning || type == BPushMarketTransaction) {
    ///在应用里面收到应用推送
    YLBpushType bpushType = UserStockWarning;
    [UserBpushInformationNum increaseUnReadCountWithMessageType:bpushType];
    [self saveStockWarningData:userInfo];
    if (![SimuUtil isLogined]) {
      return NO;
    }
  } else if (type == BPushTheSystemMessage) { ///系统消息统计、
    YLBpushType bpushType = UserSystemMessageCount;
    ///在应用里面收到应用推送
    [UserBpushInformationNum increaseUnReadCountWithMessageType:bpushType];
  }
//  else if (type == BPushMasterPlanMessageTrace) { ///牛人计划追踪消息统计、
//    YLBpushType bpushType = UserTraceMessage;
//    ///在应用里面收到应用推送
//    [UserBpushInformationNum increaseUnReadCountWithMessageType:bpushType];
//  }
  return YES;
}

///股价预警数据存储coredata数据库
+ (void)saveStockWarningData:(NSDictionary *)userInfo {
  NSString *forword = userInfo[@"forword"];
  NSURL *url =
      [NSURL URLWithString:[forword stringByAddingPercentEscapesUsingEncoding:
                                        NSUTF8StringEncoding]];
  NSDictionary *dicStockInfo = [url queryComponents];
  if (userInfo && dicStockInfo.count > 0) {
    NSString *ruid = [NSString stringWithFormat:@"%@", userInfo[@"ruid"]];
    ///股价预警信息
    NSString *msg = userInfo[@"aps"][@"alert"];
    ///股价发送时间
    NSString *sendtime = userInfo[@"sendTime"];
    NSString *stockcode = dicStockInfo[@"stock_code"];
    NSString *stockname = dicStockInfo[@"stock_name"];
    NSNumber *FirstType = @([dicStockInfo[@"first_type"] integerValue]);

    ///把股价预警数据存入coredata数据库
    [[StockWarningController sharedManager] addCoredataWithUid:ruid
                                                       Withmsg:msg
                                                  WithsendTime:sendtime
                                                 WithfirstType:FirstType
                                                  andStockName:stockname
                                                  andStockCode:stockcode];
  }
}
///获取股票预警的股票代码和名称
+ (NSString *)getStockCodeAndName:(NSDictionary *)userInfo {
  NSString *alert = userInfo[@"aps"][@"alert"];
  NSString *forword = userInfo[@"forword"];
  NSURL *url =
      [NSURL URLWithString:[forword stringByAddingPercentEscapesUsingEncoding:
                                        NSUTF8StringEncoding]];
  NSDictionary *dicStockInfo = [url queryComponents];
  if (userInfo && dicStockInfo.count > 0) {
    NSString *stockcode = dicStockInfo[@"stock_code"];
    NSString *stockname = dicStockInfo[@"stock_name"];
    ///内部推送动画显示，股票名称
    NSString *stockWarningStr =
        [NSString stringWithFormat:@"%@(%@)\n", stockname,
                                   [StockUtil sixStockCode:stockcode]];
    return [stockWarningStr stringByAppendingString:alert];
  }
  return nil;
}

//#pragma mark
//#pragma mark alertViewdelegate
//- (void)alertView:(UIAlertView *)alertView
//    clickedButtonAtIndex:(NSInteger)buttonIndex {
//  if (alertView.tag == 1000) {
//    if (buttonIndex == 1) {
//      NSString *loginSuccess = [SimuUtil getSesionID];
//      if ([loginSuccess length] > 0) {
//        [[NSNotificationCenter defaultCenter]
//            postNotificationName:NotifactionLoginSuccess
//                          object:nil userInfo:self.dic_UserInfo];
//      }
//    }
//  }
//}

@end
