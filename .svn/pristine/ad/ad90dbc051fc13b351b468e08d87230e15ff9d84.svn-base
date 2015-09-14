//
//  YouguuSchema.m
//  SimuStock
//
//  Created by Mac on 15/1/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "YouguuSchema.h"
#import "CompetitionDetailsViewController.h"
#import "HomepageViewController.h"
#import "event_view_log.h"
//#import "sysMessageViewController.h"
#import "MessageSystemViewController.h"

#import "FoundMasterPurchViewConroller.h"
#import "MarketListViewController.h"
#import "WBDetailsViewController.h"

#import "NetShoppingMallBaseViewController.h"
#import "NSURL+QueryComponent.h"
#import "TrendViewController.h"
#import "VipSectionViewController.h"
#import "NetLoadingWaitRevocableView.h"
#import "SimuHomeMatchData.h"
#import "SimuHavePrizeViewController.h"

@implementation YouguuSchema

+ (void)forwardPageFromNoticfication:(NSDictionary *)userInfo {
  if (userInfo == nil)
    return;
  [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userInfo"];
  NSString *forword = userInfo[@"forword"];
  if (forword) {
    //    NSUInteger type = [userInfo[@"type"] integerValue];
    //    if (!(type == BPushAllExpert || type == BPushSoonerOrLaterTheNewspaper
    //    ||
    //          type == BPushOptimalGuXiaobianPost)) {
    //      if (![SimuUtil isLogined]) {
    //        return;
    //      }
    //    }
    NSURL *url = [NSURL URLWithString:[forword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (url) {
      [YouguuSchema handleYouguuUrl:url];
    }
  }
}

/** 处理优顾协议的跳转 */
+ (void)handleYouguuUrl:(NSURL *)url {
  //非youguu协议的url，不处理，直接返回
  if (![@"youguu" isEqualToString:[url scheme]]) {
    return;
  }
  NSLog(@"scheme: %@", [url scheme]);
  NSLog(@"host: %@", [url host]);
  NSLog(@"fragment: %@", [url queryComponents]);
  NSString *host = [url host];
  NSDictionary *dic = [url queryComponents];
  if ([@"homepage" isEqualToString:host]) { //牛人主页
    [HomepageViewController showWithUserId:dic[@"uid"] titleName:dic[@"nickname"] matchId:@"1"];
  } else if ([@"homepageactivity" isEqualToString:host]) { //比赛牛人跳转
    [HomepageViewController showWithUserId:dic[@"uid"]
                                 titleName:dic[@"nickname"]
                                   matchId:dic[@"matchid"]];
  } else if ([@"stockmatch" isEqualToString:host]) { //炒股比赛
    /// 请求比赛信息
    // 1. show indicator
    [[NetLoadingWaitRevocableView sharedInstance] startAnimating];
    // 2. request match info
    [YouguuSchema requestMatchInfo:dic];
  } else if ([@"notion_stock_list" isEqualToString:host]) { //跳转概念股票列表

    NSString *stockcode = dic[@"notion_code"];
    NSString *stockname = dic[@"notion_name"];

    MarketListViewController *marketListVC =
        [[MarketListViewController alloc] initIndustryNotionCode:stockcode
                                          withIndustryNotionName:stockname];
    marketListVC.page = searchSkip;
    [AppDelegate pushViewControllerFromRight:marketListVC];
  } else if ([@"industry_stock_list" isEqualToString:host]) { //跳转行业股票列表

    NSString *stockcode = dic[@"industry_code"];
    NSString *stockname = dic[@"industry_name"];

    MarketListViewController *marketListVC =
        [[MarketListViewController alloc] initIndustryNotionCode:stockcode
                                          withIndustryNotionName:stockname];
    marketListVC.page = searchSkip;
    [AppDelegate pushViewControllerFromRight:marketListVC];
  } else if ([@"weibo_content" isEqualToString:host]) { //聊股正文页
    [WBDetailsViewController showTSViewWithTStockId:@([dic[@"tstockid"] longLongValue])];
  } else if ([@"store" isEqualToString:host]) { //商城
    [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
      NSString *goodsType = dic[@"goods_type"];
      if (goodsType == nil) {
        //商城界面
        [AppDelegate pushViewControllerFromRight:[[NetShoppingMallBaseViewController alloc] initWithPageType:Mall_Buy_Diamond_Mode]];
        //纪录日志
        [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"22"];
      } else if ([@"2" isEqualToString:goodsType]) {
        //资金卡页面
        [AppDelegate pushViewControllerFromRight:[[FoundMasterPurchViewConroller alloc] init]];
      } else {
        //商城界面
        [AppDelegate pushViewControllerFromRight:[[NetShoppingMallBaseViewController alloc] initWithPageType:Mall_Buy_Props]];
        //纪录日志
        [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"22"];
      }
    }];
  } else if ([@"match_detail" isEqualToString:host]) { //炒股比赛详情页
    CompetitionDetailsViewController *competitionDetailsVC = [[CompetitionDetailsViewController alloc] init];
    competitionDetailsVC.matchID = dic[@"match_id"];
    competitionDetailsVC.titleName = dic[@"match_name"];
    [AppDelegate pushViewControllerFromRight:competitionDetailsVC];
  } else if ([@"stock_detail" isEqualToString:host]) { //个股详情页
    [TrendViewController showDetailWithStockCode:dic[@"stock_code"]
                                   withStockName:dic[@"stock_name"]
                                   withFirstType:dic[@"first_type"]
                                     withMatchId:@"1"
                                   withStartPage:TPT_Trend_Mode];
  } else if ([@"system_message_list" isEqualToString:host]) {
    [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
      //系统消息列表页
      MessageSystemViewController *myInformationVC = [[MessageSystemViewController alloc] init];
      [AppDelegate pushViewControllerFromRight:myInformationVC];
    }];
  } else if ([@"vip_news" isEqualToString:host]) {
    [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
      //高级VIP页面
      VipSectionViewController *advancedVIPVC = [[VipSectionViewController alloc] init];
      [AppDelegate pushViewControllerFromRight:advancedVIPVC];
    }];
  }
  //  else if ([@"superman_track_msg" isEqualToString:host]) {
  //    [FullScreenLogonViewController
  //        checkLoginStatusWithCallBack:^(BOOL isLogined) {
  //          //跳转交易登录
  //          //跳转到追
  //          TraceMessageViewController *traceMsgVC =
  //              [[TraceMessageViewController alloc] init];
  //          [AppDelegate pushViewControllerFromRight:traceMsgVC];
  //        }];
  //  }
}

///** 获取比赛类型网络请求 */
+ (void)requestMatchInfo:(NSDictionary *)dic {
  if (![SimuUtil isExistNetwork]) {
    [NetLoadingWaitRevocableView stopAnimating];
    [NewShowLabel showNoNetworkTip];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    if ([[NetLoadingWaitRevocableView sharedInstance] isCanceled]) {
      return YES;
    } else {
      [NetLoadingWaitRevocableView stopAnimating];
      return NO;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    SimuHomeMatchData *matchData = (SimuHomeMatchData *)obj;
    SimuHomeMatchData *detailsData = matchData.dataArray[0];
    if ([@"0" isEqualToString:detailsData.wapJump]) {
      /// 一般比赛直接跳转比赛详情页
      CompetitionDetailsViewController *competitionDetailsVC = [[CompetitionDetailsViewController alloc] init];
      competitionDetailsVC.matchID = detailsData.matchID;
      competitionDetailsVC.titleName = detailsData.matchName;
      competitionDetailsVC.mType = detailsData.matchType;
      [AppDelegate pushViewControllerFromRight:competitionDetailsVC];
    } else {
      /// 有奖比赛直接跳转比赛详情WEB页
      SimuHavePrizeViewController *havePrizeVC =
          [[SimuHavePrizeViewController alloc] initWithTitleName:detailsData.matchName
                                                     withMatchID:detailsData.matchID
                                                   withMatchType:detailsData.matchType
                                                     withMainUrl:detailsData.mainURL];
      [AppDelegate pushViewControllerFromRight:havePrizeVC];
    }
  };

  [SimuHomeMatchData requestSimuHomeMatchDataWithMid:dic[@"matchid"] withCallback:callback];
}

@end
