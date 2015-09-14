//
//  HomeAssetInfoSuperView.m
//  SimuStock
//
//  Created by Jhss on 15/7/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "HomeAssetInfoSuperView.h"
#import "UIButton+Hightlighted.h"
#import "StockUtil.h"
#import "StockPersonTransactionViewController.h"

@implementation HomeAssetInfoSuperView

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    UIView *containerView =
        [[[UINib nibWithNibName:@"HomeAssetInfoSuperView" bundle:nil] instantiateWithOwner:self
                                                                                   options:nil] objectAtIndex:0];
    CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    containerView.frame = newFrame;
    [self addSubview:containerView];
  }
  return self;
}

- (void)awakeFromNib {

  [self.transactionDetailsBtn buttonWithTitle:@"查看交易明细"
                           andNormaltextcolor:Color_Blue_but
                     andHightlightedTextColor:Color_Blue_but];
  [self.transactionDetailsBtn buttonWithNormal:@"#EBEBEB" andHightlightedColor:@"dddddd"];
  __weak HomeAssetInfoSuperView *weakSelf = self;
  [_transactionDetailsBtn setOnButtonPressedHandler:^{
    if (self.userInformationData.matchID != nil) {
      [weakSelf clickTradeButtonMethod];
    }
  }];
  //添加手势
  [self addTapGesture];
}

//在assetInfoSuperView添加tap手势
- (void)addTapGesture {
  UITapGestureRecognizer *singleTap =
      [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTradeButtonMethod)];

  singleTap.numberOfTapsRequired = 1;
  singleTap.numberOfTouchesRequired = 1;
  [self addGestureRecognizer:singleTap];
}

- (void)clickTradeButtonMethod {
  if (_userInformationData.userInfoData.userid && _userInformationData.matchID) {
    self.transactionDetailsBtn.backgroundColor = [UIColor clearColor];
    __weak HomeAssetInfoSuperView *weakSelf = self;
    [self performBlock:^{
      StockPersonTransactionViewController *showViewController =
          [[StockPersonTransactionViewController alloc] initWithUserID:weakSelf.userInformationData.userInfoData.userid
                                                          withUserName:weakSelf.userInformationData.userInfoData.nickName
                                                           withMatchID:weakSelf.userInformationData.matchID];
      [AppDelegate pushViewControllerFromRight:showViewController];
    } withDelaySeconds:0.2f];
  }
}

#pragma mark 总资产、总排名、持股市值、浮动盈亏、资金余额、聊股数
- (void)bindTotalAssetsAndOtherDisplayRelatedData:(HomePageTableHeaderData *)informationDic {
  self.userInformationData = informationDic;

  self.totalRankLabel.text =
      [self stringSimplifyAddByString:[self valueJudgmentsOnTheAir:informationDic.rankData.tRank]];
  //  //记录总排名（分享）
  //  _userRanking = [_tRankLab.text integerValue];

  self.stockValueLabel.text =
      [self stringSimplifyByString:[self valueJudgmentsOnTheAir:informationDic.userInfoData.cgsz]];
  NSString *fdykLabStr =
      [self stringSimplifyByString:[self valueJudgmentsOnTheAir:informationDic.userInfoData.fdyk]];
  self.profitAndLossLabel.text = fdykLabStr;
  self.profitAndLossLabel.textColor = [StockUtil getColorByText:fdykLabStr];

  self.fundBalanceLabel.text =
      [self stringSimplifyByString:[self valueJudgmentsOnTheAir:informationDic.userInfoData.balance]];
  self.totalAssetsLabel.text =
      [self stringSimplifyByString:[self valueJudgmentsOnTheAir:informationDic.userInfoData.totalAssets]];

  self.chatNumberLabel.text = [self valueJudgmentsOnTheAir:informationDic.userInfoData.stockNum];
  //成功率
  NSString *successRate = [self valueJudgmentsOnTheAir:informationDic.tradeData.sucRate];
  if ([successRate isEqualToString:@"0.0f00000"]) {
    successRate = [NSString stringWithFormat:@"--"];
  } else {
    successRate = [NSString stringWithFormat:@"%0.2f%%", [informationDic.tradeData.sucRate floatValue] * 100];
  }
  self.successRateLabel.text = successRate;
  //平均持股天数
  NSString *avgDays = [self valueJudgmentsOnTheAir:informationDic.tradeData.avgDays];
  if ([avgDays isEqualToString:@"0.0f00000"]) {
    avgDays = [NSString stringWithFormat:@"--"];
  } else {
    avgDays = [NSString stringWithFormat:@"%0.1f", [informationDic.tradeData.avgDays floatValue]];
  }
  self.holdTimeLabel.text = avgDays;
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

#pragma mark - 万、亿结尾
- (NSString *)stringSimplifyByString:(NSString *)string {
  CGFloat floatNum = 0;
  BOOL hasMinus = NO;
  if ([string hasPrefix:@"-"]) {
    hasMinus = YES;
    string = [string substringFromIndex:1];
    floatNum = [string floatValue];
  } else {
    floatNum = [string floatValue];
  }
  if (floatNum > 10000) { //万
    floatNum = floatNum / 10000;
    string = [NSString stringWithFormat:@"%.2f万", floatNum];
  }
  return hasMinus ? [NSString stringWithFormat:@"-%@", string] : string;
}
- (void)performBlock:(void (^)())block withDelaySeconds:(float)delayInSeconds {
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end
