//
//  FirmSaleViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-9-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "FirmSaleViewController.h"

#import "RealTradeBuySellEntrustResult.h"
#import "FirmSaleSearchStockVC.h"
#import "FirmSaleSellStockVC.h"

#import "WFCapitalByOrSellOut.h"

//买入卖出统计接口
#import "FirmBySellStatisticsInterface.h"

@implementation FirmSaleViewController

- (id)initWithBuyOrSell:(BOOL)isBuy withFrame:(CGRect)frame withFirmOrCapital:(BOOL)firmOrCapital {
  self = [super initWithFrame:frame];
  if (self) {
    _isBuy = isBuy;
    _firmOrCapital = firmOrCapital;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  InputWidth = (WIDTH_OF_SCREEN - LeftMargin - RightMargin * 2) * 2 / 3;
  B5S5Width = (WIDTH_OF_SCREEN - LeftMargin - RightMargin * 2) / 3;
  //创建上导航栏
  [self.topToolBar resetContentAndFlage:@"股票交易" Mode:TTBM_Mode_Leveltwo];
  [self.indicatorView startAnimating];
  [self createViews];
}

#pragma mark------视图部分-------
#pragma mark
- (void)createViews {
  [self createBuyOrSellInputView];
  [self createReal_TimeQuotesView];
  [self creatPositionsView];
}
//创建买入卖出数量视图
- (void)createBuyOrSellInputView {
  self.firmSaleBuyOrSellInputView =
      [[FirmSaleBuyOrSellInputView alloc] initWithFrame:CGRectMake(LeftMargin, TopMargin, InputWidth, Height)
                                                  isBuy:_isBuy];
  if (_firmOrCapital) {
    if (self.positionRes) {
      NSDictionary *dic = @{
        @"stockCode" : _positionRes.stockCode,
        @"stockName" : _positionRes.stockName
      };
      [self updataDataAssignment:dic];
      [self getEntrustAmountWithStockCode:self.positionRes.stockCode stockPrice:@""];
      self.positionRes = nil;
    }
  } else {
    if (self.stockListData) {
      NSDictionary *dic = @{
        @"stockCode" : _stockListData.stockCode,
        @"stockName" : _stockListData.stockName
      };
      [self updataDataAssignment:dic];
      [self capitalByStockWithStockCode:self.stockListData.stockCode
                         withStockPrice:@""
                     withAddAndSubtract:NO];
      self.stockListData = nil;
    }
  }
  //选择股票回调
  //买入页面选择
  __weak FirmSaleViewController *weakSelf = self;
  //判断是否是配资
  __block BOOL isCapital = _firmOrCapital;
  if (_isBuy) {
    _firmSaleBuyOrSellInputView.selectStockButtonClickBlock = ^(void) {
      FirmSaleViewController *strongSelf = weakSelf;
      if (strongSelf) {
        FirmSaleSearchStockVC *searchVC = [[FirmSaleSearchStockVC alloc] init];
        searchVC.searchStockCodeBlock = ^(NSString *stockCode, NSString *stockName, NSString *firstType) {
          NSString *sixStockCode = [StockUtil sixStockCode:stockCode];
          NSDictionary *inputParameters = @{
            @"stockCode" : sixStockCode,
            @"stockName" : stockName
          };
          [strongSelf updataDataAssignment:inputParameters];
          NSLog(@"买入点击选择股票");
          if (isCapital) { //实盘
            [strongSelf getEntrustAmountWithStockCode:sixStockCode stockPrice:@""];
          } else { //配资
            [strongSelf capitalByStockWithStockCode:sixStockCode
                                     withStockPrice:@""
                                 withAddAndSubtract:NO];
          }
        };

        //新的添加方式
        [AppDelegate pushViewControllerFromRight:searchVC];
      }
    };
    //卖出页面选择
  } else {
    _firmSaleBuyOrSellInputView.selectStockButtonClickBlock = ^(void) {
      FirmSaleViewController *strongSelf = weakSelf;
      if (strongSelf) {
        //区分下 在实盘 还是 配资
        if (isCapital == YES) {
          //实盘
          FirmSaleSellStockVC *sellVC = [[FirmSaleSellStockVC alloc] initWithCapital:YES];
          sellVC.getStockCodeBlock = ^(NSObject *obj) {
            PositionResult *result = (PositionResult *)obj;
            NSDictionary *inputParameters = @{
              @"stockCode" : result.stockCode,
              @"stockName" : result.stockName
            };
            [strongSelf updataDataAssignment:inputParameters];
            [strongSelf getEntrustAmountWithStockCode:result.stockCode stockPrice:@""];
          };
          //新的添加方式
          [AppDelegate pushViewControllerFromRight:sellVC];
        } else {
          //配资
          FirmSaleSellStockVC *sellVC = [[FirmSaleSellStockVC alloc] initWithCapital:NO];
          sellVC.getStockCodeBlock = ^(NSObject *obj) {
            WFfirmStockListData *capitalStock = (WFfirmStockListData *)obj;
            NSDictionary *inputParameters = @{
              @"stockCode" : capitalStock.stockCode,
              @"stockName" : capitalStock.stockName
            };
            [strongSelf updataDataAssignment:inputParameters];
            [strongSelf capitalByStockWithStockCode:capitalStock.stockCode
                                     withStockPrice:@""
                                 withAddAndSubtract:NO];
          };
          //新的添加方式
          [AppDelegate pushViewControllerFromRight:sellVC];
        }
      }
    };
  }

  //加减按钮回调
  _firmSaleBuyOrSellInputView.computeEntrustAmountBlock =
      ^(NSString *stockCode, NSString *stockPrice, BOOL addAndSubtract) {
        FirmSaleViewController *strongSelf = weakSelf;
        if (strongSelf) {
          NSLog(@"加减按钮点击");
          //区分 是在实盘点击 还是配资实盘点击
          [strongSelf.indicatorView startAnimating];
          if (isCapital == YES) {
            //实盘
            [strongSelf getEntrustAmountWithStockCode:stockCode stockPrice:stockPrice];
          } else {
            //配资
            [strongSelf capitalByStockWithStockCode:stockCode
                                     withStockPrice:stockPrice
                                 withAddAndSubtract:addAndSubtract];
          }
        }
      };
  //买入卖出回调按钮
  //买入
  __block BOOL isEnd = _firmOrCapital;
  if (_isBuy) {
    _firmSaleBuyOrSellInputView.buyOrSellButtonClickBlock =
        ^(NSString *stockCode, NSString *price, NSString *amount, NSString *stockName) {
          FirmSaleViewController *strongSelf = weakSelf;
          if (strongSelf) {
            NSLog(@"点击买入");
            if (isEnd == YES) {
              //实盘 买入
              [strongSelf buyStockWithStockCoke:stockCode
                                          price:price
                                         amount:amount
                                  withStockName:stockName];
            } else if (isEnd == NO) {
              //配资买入
              [strongSelf excellentCareWithCapitalStockByOrSellOutWithIdentifier:YES
                                                                   withStockCode:stockCode
                                                                       withPrice:price
                                                                      withAmount:amount];
            }
          }
        };
    //卖出
  } else {
    _firmSaleBuyOrSellInputView.buyOrSellButtonClickBlock =
        ^(NSString *stockCode, NSString *price, NSString *amount, NSString *stockName) {
          FirmSaleViewController *strongSelf = weakSelf;
          if (strongSelf) {
            NSLog(@"点击卖出");
            if (isEnd == YES) {
              //实盘 卖出
              [strongSelf sellStockWithStockCoke:stockCode
                                       stockName:strongSelf.firmSaleBuyOrSellInputView.stockNameLabel.text
                                           price:price
                                          amount:amount];
            } else if (isEnd == NO) {
              //配资 卖出
              [strongSelf excellentCareWithCapitalStockByOrSellOutWithIdentifier:NO
                                                                   withStockCode:stockCode
                                                                       withPrice:price
                                                                      withAmount:amount];
            }
          }
        };
  }
  [self.clientView addSubview:_firmSaleBuyOrSellInputView];
}

static CGFloat LeftMargin = 10.f;
static CGFloat RightMargin = 10.f;
static CGFloat TopMargin = 11.f;
static CGFloat BottomMargin = 11.f;
static CGFloat InputWidth = 192.f;
static CGFloat B5S5Width = 192.0f;
static CGFloat Height = 180;

//创建实时行情视图
- (void)createReal_TimeQuotesView {
  _upDateView =
      [[UpDateMarketView alloc] initWithFrame:CGRectMake(LeftMargin + InputWidth + RightMargin, TopMargin, B5S5Width, Height)];
  [self.clientView addSubview:_upDateView];
}

//创建持仓视图
- (void)creatPositionsView {
  self.fsPositions = _fsPositions = [[FSPositionsViewController alloc]
                    initSale:@"sale"
                        rect:CGRectMake(0.0, TopMargin + Height + BottomMargin, self.view.bounds.size.width,
                                        self.view.bounds.size.height - topToolBarHeight - TopMargin - Height - BottomMargin)
      withFirmOfferOrCapital:_firmOrCapital];
  //点击持仓cell回调
  __weak FirmSaleViewController *weakSelf = self;
  __block BOOL isFirmCapital = _firmOrCapital;
  _fsPositions.plancountZqdm = ^(NSObject *obj, BOOL addAndSubtract) {
    FirmSaleViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView startAnimating];
      if (isFirmCapital) {
        //实盘
        PositionResult *posRes = (PositionResult *)obj;
        NSDictionary *inputParameters = @{
          @"stockCode" : posRes.stockCode,
          @"stockName" : posRes.stockName
        };
        [strongSelf updataDataAssignment:inputParameters];
        [strongSelf getEntrustAmountWithStockCode:posRes.stockCode stockPrice:@""];
      } else {
        //配资
        WFfirmStockListData *capitalStock = (WFfirmStockListData *)obj;
        NSDictionary *inputParameters = @{
          @"stockCode" : capitalStock.stockCode,
          @"stockName" : capitalStock.stockName
        };
        [strongSelf updataDataAssignment:inputParameters];
        [strongSelf capitalByStockWithStockCode:capitalStock.stockCode
                                 withStockPrice:@""
                             withAddAndSubtract:addAndSubtract];
      }
    }
  };
  __weak SimuIndicatorView *myindicate = self.indicatorView;
  _fsPositions.beginRefreshCallBack = ^{
    [myindicate startAnimating];
  };
  _fsPositions.endRefreshCallBack = ^() {
    [myindicate stopAnimating];
  };
  [self addChildViewController:_fsPositions];
  [self.clientView addSubview:_fsPositions.view];
}

#pragma mark------网络请求-------
#pragma mark-- 刷新按钮
- (void)refreshButtonPressDown {
  if (_firmOrCapital) {
    //实盘
    [self.indicatorView startAnimating];
    [self updataData];
  } else {
    //配资
    if (_firmSaleBuyOrSellInputView.stockNameLabel.text) {
      [self.indicatorView startAnimating];
      [self capitalByStockWithStockCode:_firmSaleBuyOrSellInputView.stockCodeLabel.text
                         withStockPrice:@""
                     withAddAndSubtract:NO];
    }
    [_upDateView clearData];
    [_fsPositions refreshButtonPressDown];
  }
}

//实盘 委托数量
- (void)getEntrustAmountWithStockCode:(NSString *)stockCode stockPrice:(NSString *)stockPrice {
  [self.indicatorView startAnimating];
  __weak FirmSaleViewController *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    FirmSaleViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *object) {
    FirmSaleViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindRealTradeStockPriceInfo:(RealTradeStockPriceInfo *)object
                               withStockPrice:stockPrice];
    }
  };

  //计算委托数量
  [RealTradeStockPriceInfo computeEntrustAmountWithStockCode:stockCode
                                            withEntrustPrice:stockPrice
                                                       isBuy:_isBuy
                                                WithCallback:callback];
}

#pragma mark - 配资股票界面查询股票行情
//配资界面 买入股票查询
- (void)capitalByStockWithStockCode:(NSString *)stockCode
                     withStockPrice:(NSString *)stockPrice
                 withAddAndSubtract:(BOOL)addAndSubtract {
  [_indicatorView startAnimating];
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [_indicatorView stopAnimating];
    return;
  }
  __weak FirmSaleViewController *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^() {
    FirmSaleViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    //绑定数据
    FirmSaleViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf capitalBindWithStockInfoData:(WFStockByInfoData *)obj
                                withStockPrice:stockPrice
                            withAddAndSubtract:addAndSubtract];
    }
  };

  NSString *type = _isBuy ? @"1" : @"2";
  [WFStockByData computeStockByInfoWithStockCode:stockCode
                                 withEntrustType:type
                                   withCurAmount:@""
                                withEnableAmount:@""
                                withEntrustPrice:stockPrice
                                  withIsByOrSell:_isBuy
                                    withCallBack:callback];
}

//配资绑定数据
- (void)capitalBindWithStockInfoData:(WFStockByInfoData *)stockData
                      withStockPrice:(NSString *)stockPrice
                  withAddAndSubtract:(BOOL)addAndSubtract {

  _firmSaleBuyOrSellInputView.stockPriceTextField.text = stockPrice;
  _firmSaleBuyOrSellInputView.addAndSubtract = addAndSubtract;
  if (_upDateView) {
    [_upDateView capitalBindData:stockData];
  }

  if (_firmSaleBuyOrSellInputView) {
    [_firmSaleBuyOrSellInputView capitalDataRequestComplete:stockData];
  }
}

//实盘绑定数据
- (void)bindRealTradeStockPriceInfo:(RealTradeStockPriceInfo *)data
                     withStockPrice:(NSString *)stockPrice {
  _firmSaleBuyOrSellInputView.stockPriceTextField.text = stockPrice;
  //刷新行情
  if (_upDateView) {
    [_upDateView dataRequestComplete:data];
  }
  //刷新买入卖出
  if (_firmSaleBuyOrSellInputView) {
    [_firmSaleBuyOrSellInputView dataRequestComplete:data];
  }
}

/**买入股票*/
- (void)buyStockWithStockCoke:(NSString *)code
                        price:(NSString *)price
                       amount:(NSString *)amount
                withStockName:(NSString *)stockName {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak FirmSaleViewController *weakSelf = self;
  callback.onSuccess = ^(NSObject *object) {
    FirmSaleViewController *strongSelf = weakSelf;
    if (strongSelf) {
      //进行买入之后的相应操作：
      [NewShowLabel setMessageContent:@"委托成功！"];
      [self firmByOrSellSataisticsInterfaceWithStockName:stockName
                                           withStockCode:code
                                               withPrice:price
                                              withAmount:amount
                                            withByOrSell:@"买入"];
      //买入后刷新数据
      [strongSelf updataData];
    }
  };

  callback.onFailed = ^() {
    [NewShowLabel showNoNetworkTip];
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    if (obj.status) {
      [NewShowLabel setMessageContent:obj.message];
    }

  };

  [RealTradeBuySellEntrustResult buyStockWithStockCode:code
                                             withPrice:price
                                            withAmount:amount
                                          WithCallback:callback];
}

/**卖出股票*/
- (void)sellStockWithStockCoke:(NSString *)code
                     stockName:(NSString *)stockName
                         price:(NSString *)price
                        amount:(NSString *)amount {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak FirmSaleViewController *weakSelf = self;
  callback.onSuccess = ^(NSObject *object) {
    FirmSaleViewController *strongSelf = weakSelf;
    if (strongSelf) {
      //进行卖出之后的相应操作：
      [NewShowLabel setMessageContent:@"委托成功！"];
      [self firmByOrSellSataisticsInterfaceWithStockName:stockName
                                           withStockCode:code
                                               withPrice:price
                                              withAmount:amount
                                            withByOrSell:@"卖出"];
      //卖出后刷新数据
      [strongSelf updataData];
    }
  };

  callback.onFailed = ^() {
    [NewShowLabel showNoNetworkTip];
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    if (obj.status) {
      [NewShowLabel setMessageContent:obj.message];
    }
  };

  [RealTradeBuySellEntrustResult sellStockWithStockCode:code
                                              withPrice:price
                                             withAmount:amount
                                           WithCallback:callback];
}

#pragma mark - 实盘买入 卖出 统计接口
- (void)firmByOrSellSataisticsInterfaceWithStockName:(NSString *)stockName
                                       withStockCode:(NSString *)stockCode
                                           withPrice:(NSString *)stockPrice
                                          withAmount:(NSString *)stockAmount
                                        withByOrSell:(NSString *)isByOrSellOrChenchan {
  //传入参赛 ：股票名称 股票代码 股票价格 股票数量 买还是卖
  if (![SimuUtil isExistNetwork]) {
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak FirmSaleViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^() {
    FirmSaleViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    NSLog(@"成功");
  };

  [FirmBySellStatisticsInterface requestFirmByOrSellStatisticeWithSotckName:stockName
                                                              withStockCode:stockCode
                                                             withStockPrice:stockPrice
                                                            withStockAmount:stockAmount
                                                               withByOrSell:isByOrSellOrChenchan
                                                               withCallback:callback];
}

#pragma mark-- 优顾配资 买入卖出
- (void)excellentCareWithCapitalStockByOrSellOutWithIdentifier:(BOOL)isByOrSell
                                                 withStockCode:(NSString *)stockCode
                                                     withPrice:(NSString *)price
                                                    withAmount:(NSString *)amount {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }

  //配资买入卖出
  __weak FirmSaleViewController *weakSelf = self;

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^() {
    FirmSaleViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [_indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    FirmSaleViewController *strongSelf = weakSelf;
    if (strongSelf) {
      //进行卖出之后的相应操作：
      [NewShowLabel setMessageContent:@"委托成功！"];
      [self updataData];
    }
  };
  callback.onFailed = ^() {
    [_indicatorView stopAnimating];
  };
  [WFCapitalByOrSellOut requestCapitalByOrSellWithBoll:isByOrSell
                                         withStockCode:stockCode
                                             withPrice:price
                                            withAmount:amount
                                          withCallback:callback];
}

#pragma mark - 刷新所有
- (void)updataData {
  //如果还未选择股票，则不刷新选择股票控件
  [_indicatorView startAnimating];
  if (_firmSaleBuyOrSellInputView.stockNameLabel.text) {
    [_firmSaleBuyOrSellInputView updateData];
  }
  [_upDateView clearData];
  [_fsPositions refreshButtonPressDown];
}

//收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [_firmSaleBuyOrSellInputView.stockNumberTextField resignFirstResponder];
  [_firmSaleBuyOrSellInputView.stockPriceTextField resignFirstResponder];
}

- (void)leftButtonPress {
  //返回时收键盘
  [self touchesBegan:nil withEvent:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:_firmSaleBuyOrSellInputView];
  [super leftButtonPress];
}

//先清空买入卖出控件的所有数据 在赋值
- (void)updataDataAssignment:(NSDictionary *)dic {
  if (dic) {
    NSString *stockCode = dic[@"stockCode"];
    NSString *stockName = dic[@"stockName"];
    if (stockCode && stockName) {
      [_upDateView clearData];
      [_firmSaleBuyOrSellInputView emptyAllData];
      _firmSaleBuyOrSellInputView.stockCodeLabel.text = stockCode;
      _firmSaleBuyOrSellInputView.stockNameLabel.text = stockName;
    }
  }
}
@end
