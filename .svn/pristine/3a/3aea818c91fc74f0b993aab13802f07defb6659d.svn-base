//
//  simuSellViewController.m
//  SimuStock
//
//  Created by Mac on 14-7-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "simuSellViewController.h"
#import "SelectPositionStockViewController.h"
#import "ProfitAndStopClientVC.h"

@interface simuSellViewController () {

  //创建界面的 大小
  CGRect cretatFrame;
  
  //记录导航栏下标
  NSInteger indext;
  
}

@property(strong, nonatomic) ProfitAndStopClientVC *profitStopClien;

@end

@implementation simuSellViewController

- (id)initWithStockCode:(NSString *)stockCode
          withStockName:(NSString *)stockName
            withMatchId:(NSString *)matchId
          withAccountId:(NSString *)accountId
   withStockSellBuyType:(StockBuySellType)type
          withTitleName:(NSString *)titleName
          withTargetUid:(NSString *)targetUid {
  if (self = [super init]) {
    self.tempStockCode = [StockUtil sixStockCode:stockCode];
    self.tempStockName = stockName;
    self.scv_marichid = matchId;
    self.accountId = accountId;
    self.titleName = titleName;
    self.sellType = type;
    self.targetUid = targetUid;
  }
  return self;
}

- (void)resetWithStockCode:(NSString *)stockCode withStockName:(NSString *)stockName {
  self.tempStockCode = [StockUtil sixStockCode:stockCode];
  self.tempStockName = stockName;

  self.buyVC.stockBuySellView.stockCodeTF.text = self.tempStockCode;
  self.buyVC.stockBuySellView.stockNameTF.text = self.tempStockName;
  //止盈止损
  _profitStopClien.tempStockCode = self.tempStockCode;
  _profitStopClien.tempStockName = self.tempStockName;
  _profitStopClien.scv_profitAndStopView.stockCodeLabel.text = self.tempStockCode;
  _profitStopClien.scv_profitAndStopView.stockNameLabel.text = self.tempStockName;
  _profitStopClien.scv_profitAndStopView.stockInfoDefaultLab.hidden = YES;
  if (pageIndex == 2) {
    [self.profitStopClien clickTheStopButton];
  }
  [self.buyVC externalSupplyRefreshMethod:NO];
}

//点击标签回调
- (void)changeToIndex:(NSInteger)index {
  pageIndex = index;
  CGFloat xFloat = topToolbarView.bounds.size.width / 3;
  CGRect lineFrame = topToolbarView.maxlineView.frame;
  self.buyVC.stockBuySellView.isOriginalView = NO;
  [self.buyVC.stockBuySellView textfieldResignFirstRsp];
  [self.profitStopClien textFieldDealloc];
  if (index == 0) {
    //市价页面
    _buyVC.view.hidden = NO;
    self.buyVC.stockBuySellView.isOriginalView = NO;
    if (_buyVC.profitStopViewBool) {
      [_buyVC externalSupplyRefreshMethod:YES];
    }
    [self.buyVC showMarketFixedShareButtonWithBool:YES];
    [self.buyVC sendFramePriceAmountWithBuySell:StockSellType wihtMarkeFixed:MarketPriceType];
    openMembershipVC.view.hidden = YES;
    self.profitStopClien.view.hidden = YES;
    lineFrame.origin.x = 0.0f;
    //设置线的frame
    topToolbarView.maxlineView.frame = lineFrame;
  } else if (index == 1) {
    //限价页面 NO
    _buyVC.view.hidden = NO;
    self.buyVC.stockBuySellView.isOriginalView = NO;
    if (_buyVC.profitStopViewBool) {
      [_buyVC externalSupplyRefreshMethod:YES];
    }
    [self.buyVC showMarketFixedShareButtonWithBool:NO];
    [self.buyVC sendFramePriceAmountWithBuySell:StockSellType wihtMarkeFixed:FixedPriceType];
    openMembershipVC.view.hidden = YES;
    self.profitStopClien.view.hidden = YES;
    lineFrame.origin.x = xFloat;
    topToolbarView.maxlineView.frame = lineFrame;
  } else if (index == 2) {
    lineFrame.origin.x = xFloat * 2;
    topToolbarView.maxlineView.frame = lineFrame;
    _buyVC.view.hidden = YES;
    openMembershipVC.view.hidden = NO;
    self.profitStopClien.view.hidden = NO;
    [self.profitStopClien clickTheStopButton];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //创建导航栏上的内容
  [self resetTopToolBarView];
  [self ResetIndicatorView];

  //创建分割框
  //创建 市价 和 限价
  topToolbarView = [[TopToolBarView alloc] initWithFrame:CGRectMake(0, 0, _clientView.bounds.size.width, TOP_TABBAR_HEIGHT)
                                               DataArray:@[ @"市价", @"限价", @"止盈止损" ]
                                     withInitButtonIndex:0];
  topToolbarView.delegate = self;
  [_clientView addSubview:topToolbarView];

  CGFloat xFloat = topToolbarView.bounds.size.width / 3;
  UIView *line =
      [[UIView alloc] initWithFrame:CGRectMake(xFloat, 5, 0.5, CGRectGetHeight(topToolbarView.bounds) - 10)];
  line.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  [topToolbarView addSubview:line];

  UIView *line2 =
      [[UIView alloc] initWithFrame:CGRectMake(xFloat * 2, 5, 0.5, CGRectGetHeight(topToolbarView.bounds) - 10)];
  line2.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  [topToolbarView addSubview:line2];

  //创建买入页面
  CGFloat bottomToolBarHeight = self.sellType == StockBuySellOrdinaryType ? 0.0f : BOTTOM_TOOL_BAR_HEIGHT;

  cretatFrame = CGRectMake(0, CGRectGetMaxY(topToolbarView.frame), CGRectGetWidth(_clientView.frame),
                           CGRectGetHeight(_clientView.bounds) -
                               CGRectGetMaxY(topToolbarView.frame) - bottomToolBarHeight);

  _buyVC = [[BaseBuySellVC alloc] initWithFrame:cretatFrame
                                  withStockCode:self.tempStockCode
                                  withStockName:self.tempStockName
                                    withMatchId:self.scv_marichid
                                  withAccountId:self.accountId
                                  withTargetUid:self.targetUid
                                withBuySellType:StockSellType
                            withMarketFixedType:MarketPriceType
                        withStockBuySellForUser:self.sellType];
  self.buyVC.indicatorView = _indicatorView;
  self.buyVC.view.frame = cretatFrame;
  [self.buyVC sendFramePriceAmountWithBuySell:StockSellType wihtMarkeFixed:MarketPriceType];
  [_clientView addSubview:self.buyVC.view];
  [self addChildViewController:self.buyVC];

  if (_sellType == StockBuySellOrdinaryType) {
    //判断是否为会员
    if ([[SimuUtil getUserVipType] isEqualToString:@"2"] || [[SimuUtil getUserVipType] isEqualToString:@"1"]) {
      //创建 止盈止损界面
      [self createProfitStopClien];
    } else {
      openMembershipVC =
          [[OpenMembershipViewController alloc] initWithNibName:@"OpenMembershipViewController"
                                                         bundle:nil];
      openMembershipVC.view.frame =
          CGRectMake(0, CGRectGetMaxY(topToolbarView.frame), CGRectGetWidth(_clientView.bounds),
                     CGRectGetHeight(_clientView.bounds) - CGRectGetMaxY(topToolbarView.frame));
      openMembershipVC.view.hidden = YES;
      [_clientView addSubview:openMembershipVC.view];
      [self addChildViewController:openMembershipVC];
    }
  } else if (_sellType == StockBuySellExpentType) {
    //创建 止盈止损界面
    [self createProfitStopClien];
  }
}

#pragma mark-- 创建止盈止损
- (void)createProfitStopClien {
  //创建止盈止损
  self.profitStopClien = [[ProfitAndStopClientVC alloc] initWithAccountId:self.accountId
                                                            withTargetUid:self.targetUid
                                                            WithStockCode:self.tempStockCode
                                                            withStockName:self.tempStockName
                                                              withMatchId:self.scv_marichid
                                                         withUserOrExpert:self.sellType];

  self.profitStopClien.view.frame = cretatFrame;
  self.profitStopClien.view.hidden = YES;
  self.profitStopClien.indicatorView = _indicatorView;
  __weak simuSellViewController *weakSelf = self;
  self.profitStopClien.indiactorStatrAnimation = ^() {
    [weakSelf.indicatorView startAnimating];
  };
  self.profitStopClien.indiactorStopAnimation = ^() {
    [weakSelf.indicatorView stopAnimating];
  };
  self.profitStopClien.sellBtnClickBlock = ^() {
    [weakSelf.buyVC clearAllDataForSubView];
    [weakSelf.buyVC.stockBuySellView textfieldDealloc];

  };
  [_clientView addSubview:self.profitStopClien.view];
  [self addChildViewController:self.profitStopClien];
}

- (void)leftButtonPress {
  [self.buyVC.stockBuySellView textfieldDealloc];
  [super leftButtonPress];
}

#pragma mark
#pragma mark 创建各个控件
//创建上导航栏控件
- (void)resetTopToolBarView {
  //上标题栏
  if ([self.titleName isEqualToString:@""]) {
    self.titleName = @"卖出";
  }
  [_topToolBar resetContentAndFlage:self.titleName Mode:TTBM_Mode_Leveltwo];
  [self createButtonTradingRules];
}
//创建交易规则按钮
- (void)createButtonTradingRules {
  UIButton *rulesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  rulesBtn.frame = CGRectMake(self.view.bounds.size.width - 40, _topToolBar.bounds.size.height - 45, 40, 45);
  [rulesBtn setImage:[UIImage imageNamed:@"交易规则图标"] forState:UIControlStateNormal];
  [rulesBtn setImage:[UIImage imageNamed:@"交易规则图标"] forState:UIControlStateHighlighted];
  [rulesBtn setBackgroundImage:[UIImage imageNamed:@"导航按钮按下态效果.png"]
                      forState:UIControlStateHighlighted];
  [rulesBtn addTarget:self
                action:@selector(rulesButtonPress:)
      forControlEvents:UIControlEventTouchUpInside];
  [_topToolBar addSubview:rulesBtn];
}
- (void)rulesButtonPress:(UIButton *)btn {
  [SchollWebViewController startWithTitle:@"交易规则" withUrl:Trading_Rules];
}

#pragma mark
//创建联网指示器
- (void)ResetIndicatorView {
  if (_indicatorView) {
    _indicatorView.frame =
        CGRectMake(_topToolBar.bounds.size.width - 80, _topToolBar.bounds.size.height - 45, 40, 45);
  }
}
#pragma mark 刷新
#pragma mark-------SimuIndicatorDelegate-----------
- (void)refreshButtonPressDown {

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
    return;
  }
  [_indicatorView startAnimating];
  if (pageIndex == 2) {
    if (self.profitStopClien) {
      [self.profitStopClien refreshButtonPressDownSDFS];
    } else {
      [_indicatorView stopAnimating];
    }
  } else {
    [self.buyVC externalSupplyRefreshMethod:NO];
  }
}

+ (void)sellStockInMatch:(NSString *)matchId {
  OnStockSelected callback = ^(NSString *stockCode, NSString *stockName, NSString *firstType) {
    [simuSellViewController sellStockWithStockCode:stockCode
                                     withStockName:stockName
                                       withMatchId:matchId];
  };
  SelectPositionStockViewController *searchV =
      [[SelectPositionStockViewController alloc] initWithMatchId:matchId
                                               withStartPageType:OtherSellPage
                                                   withAccountId:nil
                                                   withTargetUid:nil
                                                withUserOrExpert:StockBuySellOrdinaryType
                                                    withCallBack:callback];

  [AppDelegate pushViewControllerFromRight:searchV];
}

+ (void)sellStockWithStockCode:(NSString *)stockCode
                 withStockName:(NSString *)stockName
                   withMatchId:(NSString *)matchId {

  simuSellViewController *isvc_buyVC =
      [[simuSellViewController alloc] initWithStockCode:[StockUtil sixStockCode:stockCode]
                                          withStockName:stockName
                                            withMatchId:matchId
                                          withAccountId:@""
                                   withStockSellBuyType:StockBuySellOrdinaryType
                                          withTitleName:@""
                                          withTargetUid:@""];
  [AppDelegate pushViewControllerFromRight:isvc_buyVC];
}

@end
