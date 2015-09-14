//
//  HomePageProfitSuperView.m
//  SimuStock
//
//  Created by Jhss on 15/7/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "HomePageProfitSuperView.h"
#import "StockTradeList.h"

@implementation HomePageProfitSuperView

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    UIView *containerView =
        [[[UINib nibWithNibName:@"HomePageProfitSuperView" bundle:nil]
            instantiateWithOwner:self
                         options:nil] objectAtIndex:0];
    CGRect newFrame =
        CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    containerView.frame = newFrame;
    [self addSubview:containerView];
  }
  return self;
}
- (void)awakeFromNib {
  self.lineDown.constant = 0.5f;
  self.lineTop.constant = 0.5f;
}

- (void)bindPersonalRankInfoData:(HomePageTableHeaderData *)informationDic {
  
  if ([informationDic.userInfoData.userid isEqualToString:[SimuUtil getUserID]]) {
    self.isWhoEarningsLabel.text = @"我的收益";
  }else{
  self.isWhoEarningsLabel.text = @"TA的收益";
  }
  NSString *profitRateStr =
      [self valueJudgmentsOnTheAir:informationDic.userInfoData.profitRate];
  if ([profitRateStr hasPrefix:@"-"]) {
    self.totalProfitRate.textColor = [Globle colorFromHexRGB:Color_Green];
  }
  self.totalProfitRate.text = profitRateStr;
  //  //记录总盈利率
  //  _endProfitRate = [profitRateStr floatValue];
  //  _topNicknameLab.text = self.titleName;

  //周盈利率
  NSString *wProfitStr =
      [self valueJudgmentsOnTheAir:informationDic.rankData.wProfit];
  if ([wProfitStr hasPrefix:@"-"]) {
    self.weekProfitLabel.textColor = [Globle colorFromHexRGB:Color_Green];
  }
  self.weekProfitLabel.text = wProfitStr;
  //周排行
  self.weekRankNumLabel.text =
      [self stringSimplifyAddByString:
                [self valueJudgmentsOnTheAir:informationDic.rankData.wRank]];
  //周上升名次
  NSString *wRiseStr =
      [self valueJudgmentsOnTheAir:informationDic.rankData.wRise];
  if ([wRiseStr hasPrefix:@"-"]) {
    [self.weekImageView setImage:[UIImage imageNamed:@"下降箭头"]];
  }
  self.weekRankRiseLabel.text =
      [wRiseStr hasPrefix:@"-"] ? [wRiseStr substringFromIndex:1] : wRiseStr;

  //月盈利率
  NSString *mProfitStr =
      [self valueJudgmentsOnTheAir:informationDic.rankData.mProfit];
  if ([mProfitStr hasPrefix:@"-"]) {
    self.monthProfitLabel.textColor = [Globle colorFromHexRGB:Color_Green];
  }
  self.monthProfitLabel.text = mProfitStr;
  //月排行
  self.monthRankNumLabel.text =
      [self stringSimplifyAddByString:
                [self valueJudgmentsOnTheAir:informationDic.rankData.mRank]];
  //周上升名次
  NSString *mRiseStr =
      [self valueJudgmentsOnTheAir:informationDic.rankData.mRise];
  if ([mRiseStr hasPrefix:@"-"]) {
    [self.monthImageView setImage:[UIImage imageNamed:@"下降箭头"]];
  }
  self.monthRankRiseLabel.text =
      [mRiseStr hasPrefix:@"-"] ? [mRiseStr substringFromIndex:1] : mRiseStr;

  //盈利曲线
  [self showmyhistoryprofitAuserId:informationDic.userInfoData.userid
                           matchID:informationDic.matchID];
}

//盈利曲线接口
- (void)showmyhistoryprofitAuserId:(NSString *)userId
                           matchID:(NSString *)matchID {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak HomePageProfitSuperView *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    HomePageProfitSuperView *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    __weak HomePageProfitSuperView *strongSelf = weakSelf;
    if (strongSelf) {
      PCProfitLine *tradeInfo = (PCProfitLine *)obj;
      if (tradeInfo) {
        SimuProfitLinePageData *linepagedata = tradeInfo.dataArray[0];
        [self homeSimuProfitLineData:linepagedata];
      }
    }
  };
  callback.onFailed = ^() {
    NSLog(@"onfailed");
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    NSLog(@"onerror");
  };
  [PCProfitLine showmyhistoryprofitAuserId:userId
                                   matchID:matchID
                              withCallback:callback];
}
//利率曲线
- (void)homeSimuProfitLineData:(SimuProfitLinePageData *)linepagedata {
  //利率曲线

  [self.profitCurveView setPagedata:linepagedata];
}

#pragma mark 对空做判断
- (NSString *)valueJudgmentsOnTheAir:(NSString *)str {
  if (!str || [str isEqualToString:@""]) {
    return @"0";
  }
  return str;
}
#pragma mark - 万+、亿+结尾
///注意，传入数必须是整数
- (NSString *)stringSimplifyAddByString:(NSString *)string {
  if (string.length > 8) { //亿+
    string = [string substringToIndex:string.length - 8];
    string = [NSString stringWithFormat:@"%@亿+", string];
  } else if (string.length > 4) { //万
    string = [string substringToIndex:string.length - 4];
    string = [NSString stringWithFormat:@"%@万+", string];
  }
  return string;
}

@end
