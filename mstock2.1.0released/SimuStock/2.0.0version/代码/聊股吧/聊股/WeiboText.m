//
//  WeiboText.m
//  SimuStock
//
//  Created by Mac on 14/11/27.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "WeiboText.h"
#import "TrendViewController.h"
#import "HomepageViewController.h"
#import "CompetitionDetailsViewController.h"
#import "YouguuSchema.h"
#import "MatchWeiboViewController.h"
#import "StockBarDetailViewController.h"
#import "WBCoreDataUtil.h"
#import "SimuHavePrizeViewController.h"
#import "SimuHomeMatchData.h"
#import "NetLoadingWaitRevocableView.h"

const NSString *URL_SHOW_CONTEXT = @" 网页链接";

@implementation WeiboText

- (instancetype)init {
  self = [super init];
  if (self) {
    self.type = WeiboTextType_Text;
    self.isClickable = NO;
    self.tag = @"_default";
  }
  return self;
}

- (void)onClick{};

@end

@implementation UrlWeiboText

- (instancetype)init {
  self = [super init];
  if (self) {
    self.type = WeiboTextType_HtmlLink;
    self.isClickable = YES;
    self.tag = @"a";
    self.content = [URL_SHOW_CONTEXT copy];
  }
  return self;
}

- (void)onClick { // TODO
  if (self.url == nil) {
    return;
  }
  NSURL *url = [NSURL URLWithString:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  if (url == nil) {
    return;
  }
  if ([@"youguu" isEqualToString:url.scheme]) {
    //跳转页面
    [YouguuSchema handleYouguuUrl:url];
  } else {
    [SchollWebViewController startWithTitle:@"网页链接" withUrl:self.url];
  }
};

@end

@implementation StockWeiboText

- (instancetype)init {
  self = [super init];
  if (self) {
    self.type = WeiboTextType_Stock;
    self.isClickable = YES;
    self.tag = @"stock";
  }
  return self;
}

- (void)onClick {
  [TrendViewController showDetailWithStockCode:self.stockCode
                                 withStockName:self.stockName
                                 withFirstType:FIRST_TYPE_UNSPEC
                                   withMatchId:@"1"];
};

@end

@implementation UserWeiboText
- (instancetype)init {
  self = [super init];
  if (self) {
    self.type = WeiboTextType_User;
    self.isClickable = YES;
    self.tag = @"user";
  }
  return self;
}

- (void)onClick {
  [HomepageViewController showWithUserId:self.uid titleName:self.nickname matchId:@"1"];
};

@end

@implementation AtUserWeiboText

- (instancetype)init {
  self = [super init];
  if (self) {
    self.type = WeiboTextType_AtUser;
    self.isClickable = YES;
    self.tag = @"user";
  }
  return self;
}

- (void)onClick {
  [HomepageViewController showWithUserId:self.uid titleName:self.nickname matchId:@"1"];
};

@end

@implementation FontWeiboText
- (instancetype)init {
  self = [super init];
  if (self) {
    self.type = WeiboTextType_Font;
    self.isClickable = NO;
    self.tag = @"font";
  }
  return self;
}

@end

@implementation MatchWeiboText
- (instancetype)init {
  self = [super init];
  if (self) {
    self.type = WeiboTextType_Match;
    self.isClickable = YES;
    self.tag = @"match";
    self.requestCount = 0;
  }
  return self;
}

- (void)onClick {
  if (!self.matchType || !self.wapJump || ([self.wapJump isEqualToString:@"1"] && !self.mainURL)) {
    if (self.requestCount > 10) {
      /// 防止要跳转但是url没有造成死循环
      self.requestCount = 0;
      return;
    }
    /// 如果无法判断是否是有奖比赛则调取比赛类型接口
    [self requestMatchInfo];
    return;
  }
  self.requestCount = 0;
  if ([self.wapJump isEqualToString:@"1"]) {
    /// 如果是有奖比赛就跳转新比赛详情页
    [self pushSimuHavePrizeViewController];
    return;
  }
  CompetitionDetailsViewController *competitionDetailsVC = [[CompetitionDetailsViewController alloc] init];
  competitionDetailsVC.matchID = self.matchId;
  competitionDetailsVC.titleName = self.matchName;
  competitionDetailsVC.mType = self.matchType;
  [AppDelegate pushViewControllerFromRight:competitionDetailsVC];
};

/** 跳转有奖比赛 */
- (void)pushSimuHavePrizeViewController {
  SimuHavePrizeViewController *havePrizeVC =
      [[SimuHavePrizeViewController alloc] initWithTitleName:self.matchName
                                                 withMatchID:self.matchId
                                               withMatchType:self.matchType
                                                 withMainUrl:self.mainURL];
  [AppDelegate pushViewControllerFromRight:havePrizeVC];
}

/** 获取比赛类型网络请求 */
- (void)requestMatchInfo {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  __weak MatchWeiboText *weakSelf = self;
  [NetLoadingWaitRevocableView startAnimating];
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    MatchWeiboText *strongSelf = weakSelf;
    if (strongSelf && ![[NetLoadingWaitRevocableView sharedInstance] isCanceled]) {
      [NetLoadingWaitRevocableView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    if (weakSelf) {
      [weakSelf bindSimuHomeMatchInfo:(SimuHomeMatchData *)obj];
    }
  };

  [SimuHomeMatchData requestSimuHomeMatchDataWithMid:self.matchId withCallback:callback];
}

- (void)bindSimuHomeMatchInfo:(SimuHomeMatchData *)matchData {
  if (matchData.dataArray.count > 0) {
    SimuHomeMatchData *detailsData = matchData.dataArray[0];
    self.isReward = detailsData.isReward;
    self.mainURL = detailsData.mainURL;
    self.wapJump = detailsData.wapJump;
    self.matchType = detailsData.matchType;
    self.matchName = detailsData.matchName;
    self.matchId = detailsData.matchID;
    self.requestCount += 1;
    [self onClick];
  }
}

@end

@implementation StockBarWeiboText
- (instancetype)init {
  self = [super init];
  if (self) {
    self.type = WeiboTextType_StockBar;
    self.isClickable = YES;
    self.tag = @"stockbar";
  }
  return self;
}

- (void)onClick {
  StockBarDetailViewController *stockBarDetailVC = [[StockBarDetailViewController alloc] init];
  stockBarDetailVC.barTitle = self.barName;
  stockBarDetailVC.barId = self.barId;
  stockBarDetailVC.isFollowed = [WBCoreDataUtil fetchBarId:self.barId];
  [AppDelegate pushViewControllerFromRight:stockBarDetailVC];
};

@end

@implementation TopicWeiboText
- (instancetype)init {
  self = [super init];
  if (self) {
    self.type = WeiboTextType_Topic;
    self.isClickable = YES;
    self.tag = @"topic";
  }
  return self;
}

- (void)onClick {
  MatchWeiboViewController *matchWeiboVC =
      [[MatchWeiboViewController alloc] initWithFrame:CGRectNull withTitle:self.topic];
  [AppDelegate pushViewControllerFromRight:matchWeiboVC];
};

@end