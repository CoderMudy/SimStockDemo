//
//  simuBuyViewController.m
//  SimuStock
//
//  Created by Mac on 14-7-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "simuBuyViewController.h"
#import "SchollWebViewController.h"
#import "SelectStocksViewController.h"

@interface simuBuyViewController ()

@end
@implementation simuBuyViewController
//点击标签回调
- (void)changeToIndex:(NSInteger)index {
  CGRect lineFrame = topToolbarView.maxlineView.frame;
  self.buyVC.stockBuySellView.isOriginalView = NO;
  [self.buyVC.stockBuySellView textfieldResignFirstRsp];
  if (index == 0) {
    lineFrame.origin.x = 0.0f;
    //设置线的frame
    topToolbarView.maxlineView.frame = lineFrame;
    [self.buyVC showMarketFixedShareButtonWithBool:YES];
    [self.buyVC sendFramePriceAmountWithBuySell:StockBuyType
                                 wihtMarkeFixed:MarketPriceType];
  } else {
    lineFrame.origin.x = CGRectGetWidth(topToolbarView.bounds) * 0.5;
    topToolbarView.maxlineView.frame = lineFrame;

    [self.buyVC showMarketFixedShareButtonWithBool:NO];
    [self.buyVC sendFramePriceAmountWithBuySell:StockBuyType
                                 wihtMarkeFixed:FixedPriceType];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //[_indicatorView startAnimating];
  //创建导航栏上的内容
  [self ResetTopToolBarView];
  [self resetIndicateView];
  //创建 市价 和 限价
  topToolbarView = [[TopToolBarView alloc]
            initWithFrame:CGRectMake(0, 0, _clientView.bounds.size.width, TOP_TABBAR_HEIGHT)
                DataArray:@[ @"市价", @"限价" ]
      withInitButtonIndex:0];
  topToolbarView.delegate = self;
  UIView *line = [[UIView alloc]
      initWithFrame:CGRectMake(CGRectGetWidth(topToolbarView.bounds) * 0.5,
                               CGRectGetMinY(topToolbarView.frame) + 5, 0.5,
                               CGRectGetHeight(topToolbarView.bounds) - 10)];
  line.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  [topToolbarView addSubview:line];
  [_clientView addSubview:topToolbarView];

  //创建买入页面
  CGFloat bottomToolBarHeight =
      self.stockSellBuyType == StockBuySellOrdinaryType
          ? 0.0f
          : BOTTOM_TOOL_BAR_HEIGHT;
  CGRect buSellFrame = CGRectMake(
      0, CGRectGetMaxY(topToolbarView.frame), CGRectGetWidth(_clientView.frame),
      CGRectGetHeight(_clientView.bounds) -
          CGRectGetMaxY(topToolbarView.frame) - bottomToolBarHeight);

  self.buyVC = [[BaseBuySellVC alloc] initWithFrame:buSellFrame
                                      withStockCode:self.tempStockCode
                                      withStockName:self.tempStockName
                                        withMatchId:self.matchId
                                      withAccountId:self.accoundId
                                      withTargetUid:self.targetUid
                                    withBuySellType:StockBuyType
                                withMarketFixedType:MarketPriceType
                            withStockBuySellForUser:self.stockSellBuyType];
  self.buyVC.indicatorView = _indicatorView;
  self.buyVC.view.frame = buSellFrame;
  [self.buyVC sendFramePriceAmountWithBuySell:StockBuyType
                               wihtMarkeFixed:MarketPriceType];
  [_clientView addSubview:self.buyVC.view];
  [self addChildViewController:self.buyVC];
}

#pragma mark
#pragma mark 创建各个控件
//创建上导航栏控件
- (void)ResetTopToolBarView {
  //上标题栏
  if ([self.titleName isEqualToString:@""]) {
    self.titleName = @"买入";
  }
  [_topToolBar resetContentAndFlage:self.titleName Mode:TTBM_Mode_Leveltwo];
  [self createButtonTradingRules];
}
- (void)resetIndicateView {
  if (_indicatorView) {
    _indicatorView.frame =
        CGRectMake(self.view.bounds.size.width - 80,
                   _topToolBar.bounds.size.height - 45, 40, 45);
  }
}
//创建交易规则按钮
- (void)createButtonTradingRules {
  UIButton *rulesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  rulesBtn.frame = CGRectMake(self.view.bounds.size.width - 40,
                              _topToolBar.bounds.size.height - 45, 40, 45);
  [rulesBtn setImage:[UIImage imageNamed:@"交易规则图标"]
            forState:UIControlStateNormal];
  [rulesBtn setImage:[UIImage imageNamed:@"交易规则图标"]
            forState:UIControlStateHighlighted];
  [rulesBtn
      setBackgroundImage:[UIImage imageNamed:@"导航按钮按下态效果.png"]
                forState:UIControlStateHighlighted];
  [rulesBtn addTarget:self
                action:@selector(rulesButtonPress:)
      forControlEvents:UIControlEventTouchUpInside];
  [_topToolBar addSubview:rulesBtn];
}
- (void)rulesButtonPress:(UIButton *)btn {
  [SchollWebViewController startWithTitle:@"交易规则" withUrl:Trading_Rules];
}
- (void)refreshButtonPressDown {
  [self.buyVC externalSupplyRefreshMethod:NO];
}

- (void)leftButtonPress {
  [self.buyVC.stockBuySellView textfieldDealloc];
  [super leftButtonPress];
}

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
    self.matchId = matchId;
    self.accoundId = accountId;
    self.titleName = titleName;
    self.stockSellBuyType = type;
    self.targetUid = targetUid;
  }
  return self;
}

- (void)resetWithStockCode:(NSString *)stockCode
             withStockName:(NSString *)stockName {
  self.tempStockCode = [StockUtil sixStockCode:stockCode];
  self.tempStockName = stockName;
  self.buyVC.stockBuySellView.stockCodeTF.text = self.tempStockCode;
  self.buyVC.stockBuySellView.stockNameTF.text = self.tempStockName;
  [self.buyVC externalSupplyRefreshMethod:NO];
}

+ (void)buyStockInMatch:(NSString *)matchId {
  OnStockSelected callback =
      ^(NSString *stockCode, NSString *stockName, NSString *firstType) {
        [simuBuyViewController buyStockWithStockCode:stockCode
                                       withStockName:stockName
                                         withMatchId:matchId];
      };
  SelectStocksViewController *searchV =
      [[SelectStocksViewController alloc] initStartPageType:BuyStockPage
                                               withCallBack:callback];
  [AppDelegate pushViewControllerFromRight:searchV];
}

+ (void)buyStockWithStockCode:(NSString *)stockCode
                withStockName:(NSString *)stockName
                  withMatchId:(NSString *)matchId {
  simuBuyViewController *isvc_buyVC =
      [[simuBuyViewController alloc] initWithStockCode:stockCode
                                         withStockName:stockName
                                           withMatchId:matchId
                                         withAccountId:@""
                                  withStockSellBuyType:StockBuySellOrdinaryType
                                         withTitleName:@""
                                         withTargetUid:@""];
  [AppDelegate pushViewControllerFromRight:isvc_buyVC];
}

@end
