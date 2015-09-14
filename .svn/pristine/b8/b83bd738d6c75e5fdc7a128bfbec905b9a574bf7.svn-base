//
//  BaseBuySellVC.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseBuySellVC.h"
#import "SimuStockInfoView.h"
#import "SliederBuySellView.h"
#import "StockUtil.h"
#import "BaseBuySellWorkRequset.h"
#import "SimuDoDealSubmitData.h"
#import "ShareButtonForBuySellView.h"
#import "MakingScreenShot.h"
#import "MakingShareAction.h"
#import "SelectStocksViewController.h"
#import "SelectPositionStockViewController.h"
#import "NetLoadingWaitView.h"

@interface BaseBuySellVC () {
  /** frame */
  CGRect _subFrame;
  /** 是不是比赛 */
  BOOL _isMatch;

  //买入卖出市价 下面的控件的位置
  CGRect marketSliedViewFrame;
  //买入卖出限价 控件的位置
  CGRect fixedSliedViewFrame;

  /** 记录分享时 股票代码 股票名称 股票买卖数量 */
  NSString *_tempCode;
  NSString *_tempName;
  NSString *_tempAmount;
  NSString *_tempPrice;

  NSString *_markFundsString;
  NSString *_fixedFundsString;
  
 
}
/** 买卖Type */
@property(assign, nonatomic) BuySellType buySellType;
/** 牛人用户 和 普通 用户 type */
@property(assign, nonatomic) StockBuySellType expertUserType;
/** 市价限价type */
@property(assign, nonatomic) MarketFixedPriceType marketFixedType;

/** 记录token */
@property(copy, nonatomic) NSString *token;

/** 股票代码 */
@property(copy, nonatomic) NSString *stockCode;
/** 股票名称 */
@property(copy, nonatomic) NSString *stockName;
/** 计划id */
@property(copy, nonatomic) NSString *accountId;
/** 牛人id */
@property(copy, nonatomic) NSString *targetUid;
/** 比赛id */
@property(copy, nonatomic) NSString *matchId;

/** 更多资金选择按钮bool */
@property(assign, nonatomic) BOOL moerButtonDownBool;
/** 请求类 */
@property(strong, nonatomic) BaseBuySellWorkRequset *requsetBuySell;
/** 记录资金总量 */
@property(assign, nonatomic) NSInteger currentTatalCapitalFunds;

/** 是否启动大菊花 */
@property(assign, nonatomic) BOOL whetherStartLoadingView;

///** 判断是否在清算期间 */
//@property(assign, nonatomic) NSString *liquidationPeriod;

@end

@implementation BaseBuySellVC

- (void)dealloc {
  //释放
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:@"SynchronousWinLoseVCData"
              object:nil];
}

//初始化
- (instancetype)initWithFrame:(CGRect)frame
                withStockCode:(NSString *)stockCode
                withStockName:(NSString *)stockName
                  withMatchId:(NSString *)matchId
                withAccountId:(NSString *)accountId
                withTargetUid:(NSString *)targetUid
              withBuySellType:(BuySellType)buySellType
          withMarketFixedType:(MarketFixedPriceType)marketFixedType
      withStockBuySellForUser:(StockBuySellType)userType {
  self = [super init];
  if (self) {
    _subFrame = frame;
    _stockCode = [StockUtil sixStockCode:stockCode];
    _stockName = stockName;
    _accountId = accountId;
    _targetUid = targetUid;
    _matchId = matchId;
    if ([matchId isEqualToString:@"1"]) {
      //不是比赛
      _isMatch = NO;
    } else {
      _isMatch = YES;
    }
    _buySellType = buySellType;
    _marketFixedType = marketFixedType;
    _expertUserType = userType;
    _moerButtonDownBool = NO;

    //判断 是市价成交 还是 限价成交 初始化为NO
    self.marketDealBool = NO;
    self.fixedDealBool = NO;

    self.profitStopViewBool = NO;
  }
  return self;
}

#pragma makr-- 加载动画
/** 加载动画 */
- (void)statrNetLoadingView {
  [self.indicatorView startAnimating];
  if (_whetherStartLoadingView) {
    [NetLoadingWaitView startAnimating];
  }
}
#pragma makr-- 停止动画
/** 停止动画 */
- (void)stopNetLoadingView {
  //加入阻塞
  [self.indicatorView stopAnimating];
  if (_whetherStartLoadingView) {
    _whetherStartLoadingView = NO;
    [NetLoadingWaitView stopAnimating];
  }
}

#pragma mark 网络链接部分
- (void)setNoNetwork {
  [self.stockBuySellView.buyPriceTF resignFirstResponder];
  [self.stockBuySellView.buyAmountTF resignFirstResponder];
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
  [self.indicatorView stopAnimating];
  if (_whetherStartLoadingView) {
    _whetherStartLoadingView = NO;
    [NetLoadingWaitView stopAnimating];
  }
}
- (void)stopLoading {
  [self stopNetLoadingView];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [self.stockSliederView.moneyButtonBuyView widthLabel];
}

#pragma mark-- viewDidLoad
- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(synchronousDataM:)
                                               name:@"SynchronousWinLoseVCData"
                                             object:nil];
  //是否启动大菊花 初始化 NO
  _whetherStartLoadingView = NO;
  
  //创建界面
  [self createBaseView];
  //创建分享按钮 牛人界面不需要
  if (_expertUserType == StockBuySellOrdinaryType) {
    [self createShareButton];
  }

  if (_stockCode.length != 0 && _stockCode != nil) {
    self.stockBuySellView.stockCodeTF.text = _stockCode;
    self.stockBuySellView.stockNameTF.text = _stockName;
    //请求数据
    [self requsetDataWithBuySellForHandleWithFund:@"0"
                                        withPrice:@""
                                  withBuySellBool:NO
                                        withToken:nil];
  }
}

#pragma mark-- 通知中心的方法
- (void)synchronousDataM:(NSNotification *)notification {
  NSString *stockCode = [notification.userInfo valueForKey:@"stockCode"];
  NSString *stockName = [notification.userInfo valueForKey:@"stockName"];
  NSString *buyAmount = [notification.userInfo valueForKey:@"buyAmount"];
  _stockBuySellView.stockCodeTF.text = stockCode;
  _stockBuySellView.stockNameTF.text = stockName;
  _stockBuySellView.buyAmountTF.text = buyAmount;
  self.profitStopViewBool = YES;
}

#pragma mark-- 对外提供的刷新方法 YES 为切换刷新 NO 为手动刷新
/** 对外提供的刷新方法 YES 为切换刷新 NO 为手动刷新 */
- (void)externalSupplyRefreshMethod:(BOOL)isEnd {
  
  if (_stockBuySellView.stockCodeTF.text.length == 0) {
    [NewShowLabel setMessageContent:@"请输入股票代码"];
    if (!isEnd) {
      _shareButtonView.hidden = YES;
    }
    [self.indicatorView stopAnimating];
    return;
  }else{
    _stockCode = _stockBuySellView.stockCodeTF.text;
    _stockName = _stockBuySellView.stockNameTF.text;
  }
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  self.profitStopViewBool = NO;
  if (isEnd) {
    self.moerButtonDownBool = isEnd;
    NSString *funds = nil;
    if (_marketFixedType == MarketPriceType) {
      funds = [NSString stringWithFormat:@"%ld", (long)self.stockSliederView
                                                     .marketFoundsValue];
    } else if (_marketFixedType == FixedPriceType) {
      funds = [NSString stringWithFormat:@"%ld", (long)self.stockSliederView
                                                     .fixedFoundsValue];
    }
    [self requsetDataWithBuySellForHandleWithFund:funds
                                        withPrice:_stockBuySellView.buyPriceTF
                                                      .text
                                  withBuySellBool:NO
                                        withToken:nil];
  } else {
    self.moerButtonDownBool = isEnd;
    //请求数据
    [self requsetDataWithBuySellForHandleWithFund:@"0"
                                        withPrice:@""
                                  withBuySellBool:NO
                                        withToken:nil];
  }
}

#pragma makr-- 创建分享按钮
- (void)createShareButton {
  CGRect frameShare =
      CGRectMake((self.view.bounds.size.width - 584.0 / 2) / 2,
                 CGRectGetMaxY(self.stockInfoView.frame) + 25, 292, 37);
  self.shareButtonView = [ShareButtonForBuySellView showShareButtonView];
  self.shareButtonView.frame = frameShare;
  self.shareButtonView.hidden = YES;
  __weak BaseBuySellVC *weakSelf = self;
  self.shareButtonView.shareButtonBlock = ^() {
    BaseBuySellVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf sharebuttonTriggeringMethod];
    }
  };
  [self.sliederStockInfoView addSubview:self.shareButtonView];
}

#pragma mark-- 分享
- (void)sharebuttonTriggeringMethod {
  NSString *shareUrl =
      @"http://www.youguu.com/opms/fragment/html/fragment.html";
  NSString *selfUserID = [SimuUtil getUserID];

  //截屏
  MakingScreenShot *makingScreenShot = [[MakingScreenShot alloc] init];
  //分享
  UIImage *shareImage = [makingScreenShot
      makingScreenShotWithFrame:self.view.frame
                       withView:self.view
                       withType:MakingScreenShotType_HomePage];

  MakingShareAction *shareAction = [[MakingShareAction alloc] init];
  shareAction.shareModuleType = ShareModuleTypeStaticWap;
  shareAction.shareUserID = selfUserID;
  NSString *buySell = nil;
  NSString *content = nil;
  NSString *otherContent = nil;
  if (_buySellType == StockBuyType) {
    buySell = @"买入";
    if (_marketFixedType == MarketPriceType) {
      content = [NSString
          stringWithFormat:@"#优顾炒股#%@%@元的%@，下载体验，和我一起玩 %@ "
                           @"(分享自@优顾炒股官方)",
                           buySell, _markFundsString, _tempName, shareUrl];
      otherContent = [NSString
          stringWithFormat:@"%@%@（%@）%@元，下载体验，和我一起玩 %@ ", buySell,
                           _tempName, _tempCode, _markFundsString, shareUrl];
    } else if (_marketFixedType == FixedPriceType) {
      content = [NSString
          stringWithFormat:@"#优顾炒股#%@%@（%@）%ld股，下载体验，和我一起玩 "
                           @"%@ (分享自@优顾炒股官方)",
                           buySell, _tempName, _tempCode,
                           (long)[_tempAmount integerValue], shareUrl];
      otherContent = [NSString
          stringWithFormat:@"%@%@（%@）%ld股，下载体验，和我一起玩 %@ ",
                           buySell, _tempName, _tempCode,
                           (long)[_tempAmount integerValue], shareUrl];
    }
  } else if (_buySellType == StockSellType) {
    buySell = @"卖出";
    if (_marketFixedType == MarketPriceType) {
      content = [NSString
          stringWithFormat:@"#优顾炒股#%@%@股的%@，下载体验，和我一起玩 %@ "
                           @"(分享自@优顾炒股官方)",
                           buySell, _tempAmount, _tempName, shareUrl];
      otherContent = [NSString
          stringWithFormat:@"%@%@（%@）%@元，下载体验，和我一起玩 %@ ", buySell,
                           _tempName, _tempCode, _markFundsString, shareUrl];

    } else if (_marketFixedType == FixedPriceType) {
      content = [NSString
          stringWithFormat:@"#优顾炒股#%@%@（%@）%ld股，下载体验，和我一起玩 "
                           @"%@ (分享自@优顾炒股官方)",
                           buySell, _tempName, _tempCode,
                           (long)[_tempAmount integerValue], shareUrl];
      otherContent = [NSString
          stringWithFormat:@"%@%@（%@）%ld股，下载体验，和我一起玩 %@ ",
                           buySell, _tempName, _tempCode,
                           (long)[_tempAmount integerValue], shareUrl];
    }
  }
  [shareAction shareTitle:@"分享自"
                  content:content
                    image:shareImage
           withOtherImage:nil
             withShareUrl:shareUrl
            withOtherInfo:otherContent];
}

#pragma makr-- 数据请求
/** 参数说明： funds  总资金 price 价格 buySellBool 传YES 为买卖委托
 *  传NO 为查询数据
 */
- (void)requsetDataWithBuySellForHandleWithFund:(NSString *)funds
                                      withPrice:(NSString *)price
                                withBuySellBool:(BOOL)buySellBool
                                      withToken:(NSString *)token {
  //创建请求类
  if (![SimuUtil isLogined]) {
    if (_whetherStartLoadingView) {
      [NetLoadingWaitView stopAnimating];
    }
    return;
  }

  if (![SimuUtil isExistNetwork]) {
    self.stockBuySellView.isOriginalView = NO;
    [self setNoNetwork];
    [self stopLoading];
    return;
  }
  //菊花转动
  [self statrNetLoadingView];
  self.requsetBuySell = [[BaseBuySellWorkRequset alloc] init];
  __weak BaseBuySellVC *weakSelf = self;
  self.requsetBuySell.succountData = ^(NSObject *obj, BOOL isEnd) {
    BaseBuySellVC *strongSelf = weakSelf;
    if (strongSelf) {
      //只要有网络请求
      strongSelf.marketDealBool = NO;
      strongSelf.fixedDealBool = NO;
      if (isEnd) {
        [strongSelf
            bindBuySellEntrustWithSimuDoDealSubmitData:(SimuDoDealSubmitData *)
                                                           obj];
      } else {
        [strongSelf bindDataWithSimuTradeBaseData:(SimuTradeBaseData *)obj];
      }
    }
  };
  self.requsetBuySell.fialdData = ^() {
    BaseBuySellVC *strongSelf = weakSelf;
    if (strongSelf) {
      strongSelf.stockBuySellView.isOriginalView = NO;
      [strongSelf setNoNetwork];
      [strongSelf stopNetLoadingView];
    }
  };
  self.requsetBuySell.viewNotWork = ^() {
    BaseBuySellVC *strongSelf = weakSelf;
    if (strongSelf) {
      strongSelf.stockBuySellView.isOriginalView = NO;
      [strongSelf stopLoading];
    }
  };
  self.requsetBuySell.erroeData = ^(BaseRequestObject *obj, NSException *exc) {
    BaseBuySellVC *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.whetherStartLoadingView) {
        strongSelf.whetherStartLoadingView = NO;
        [NetLoadingWaitView stopAnimating];
      }
      if (obj) {
        if ([obj.status isEqualToString:@"0101"]) {
          [[NSNotificationCenter defaultCenter]
              postNotificationName:Illegal_Logon_SimuStock
                            object:nil];

        } else {
          if ([obj.message isEqualToString:@"该" @"股"
                           @"票停牌，仅允许市价卖出"]) {
            return [NewShowLabel
                setMessageContent:
                    @"该股票已停牌，不能进行卖出操作"];
          }
          //股票停牌 或者 在清算期间
          strongSelf.stockBuySellView.isOriginalView = NO;
          [NewShowLabel setMessageContent:obj.message];
        }
        return;
      }
      [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
    }
  };

  //买入卖出委托
  if (buySellBool) {
    [self.requsetBuySell tradeEntrustWithCode:_stockCode
                              withFrozendFund:funds
                                   withAmount:_stockBuySellView.buyAmountTF.text
                                    withPrice:price
                                  withMatchId:_matchId
                                    withToken:token
                              withBuySellType:_buySellType
                          withMarketFixedType:_marketFixedType
                                 withUserType:_expertUserType];
  } else {
    //请求数据 查询
    if (_buySellType == StockBuyType) {
      //买
      [self.requsetBuySell getAmountFromNet:_stockCode
                                  withPrice:price
                                  withFunds:funds
                              withAccountId:_accountId
                                withMatchId:_matchId
                        withMarketFixedType:_marketFixedType
                               withUserType:_expertUserType];
    } else if (_buySellType == StockSellType) {
      //卖
      [self.requsetBuySell querySellInfoWidthStockCode:_stockCode
                                         withAccountId:_accountId
                                           withMatchId:_matchId
                                   withMarketFixedType:_marketFixedType
                                          withUserType:_expertUserType];
    }
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.stockBuySellView.buyPriceTF resignFirstResponder];
  [self.stockBuySellView.buyAmountTF resignFirstResponder];
}

#pragma makr-- 创建界面
/** 创建界面 */
- (void)createBaseView {
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_White];
  //创建 买入卖出输入框
  self.stockBuySellView =
      [StockBuySellView staticInitalizationStockBuySellView];
  //重新设定
  [_stockBuySellView reSituationWithBuySellType:_buySellType
                            withMarketFixedType:_marketFixedType];
  _stockBuySellView.frame =
      CGRectMake(0, 0, CGRectGetWidth(self.view.bounds),
                 CGRectGetHeight(_stockBuySellView.bounds));
  [self.view addSubview:_stockBuySellView];
  //创建搜索页面 和 查询页面
  __weak BaseBuySellVC *weakSelf = self;
  self.stockBuySellView.createStockViewBlock = ^(BuySellType type) {
    BaseBuySellVC *strongSelf = weakSelf;
    if (strongSelf) {
      if (type == StockBuyType) {
        [strongSelf createSearchVC];
      } else if (type == StockSellType) {
        [strongSelf creatSellStockView];
      }
    }
  };
  //请求数据
  self.stockBuySellView.requsetBuyAmountBlock = ^(NSString *price) {
    BaseBuySellVC *strongSelf = weakSelf;
    if (strongSelf) {
      strongSelf.moerButtonDownBool = NO;
      [strongSelf requsetDataWithBuySellForHandleWithFund:@"0"
                                                withPrice:price
                                          withBuySellBool:NO
                                                withToken:nil];
    }
  };

  self.stockBuySellView.showPriceLabelBlock =
      ^(NSString *price, BOOL isEnd, BuySellType type) {
        BaseBuySellVC *strongSelf = weakSelf;
        if (strongSelf) {
          [strongSelf.stockSliederView
              priceOrAmountChangeReSetUpSliderWithPice:price
                                       withBuySellType:type
                                              withBool:isEnd];
        }

      };

  //计算 在买入卖出情况下 买卖输入框下面的控件要显示的位置frame
  if (_buySellType == StockBuyType) {
    marketSliedViewFrame =
        CGRectMake(0, 55.0f, CGRectGetWidth(self.view.bounds),
                   CGRectGetHeight(self.view.bounds) - 55.0f);
  } else if (_buySellType == StockSellType) {
    marketSliedViewFrame =
        CGRectMake(0, 95.0f, CGRectGetWidth(self.view.bounds),
                   CGRectGetHeight(self.view.bounds) - 90.0f);
  }

  //创建滑块
  self.sliederStockInfoView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 143.0f, CGRectGetWidth(self.view.bounds),
                               CGRectGetHeight(self.view.bounds) - 143.0f)];
  _sliederStockInfoView.backgroundColor = [UIColor clearColor];
  fixedSliedViewFrame = _sliederStockInfoView.frame;
  [self.view addSubview:self.sliederStockInfoView];
  //创建 SliederBuySellView
  self.stockSliederView =
      [SliederBuySellView showSliederBuySellViewWithBuySellType:_buySellType];
  self.stockSliederView.frame =
      CGRectMake(0, 0, CGRectGetWidth(self.view.bounds),
                 CGRectGetHeight(self.stockSliederView.bounds));
  _stockSliederView.buySellTextField = self.stockBuySellView;
  [_stockSliederView marketFixedAssignment:_marketFixedType];
  [_stockSliederView sliderMapImage:_buySellType];
  [_stockSliederView eliminateData];
  if (_expertUserType == StockBuySellExpentType || _isMatch) {
    [_stockSliederView showOrHiddenForMoneyButton:YES];
  }
  _stockSliederView.moreFoundButton = ^(NSInteger funds, NSString *price) {
    BaseBuySellVC *strongSelf = weakSelf;
    if (strongSelf) {
      //请求数据
      strongSelf.currentTatalCapitalFunds = funds;
      strongSelf.moerButtonDownBool = YES;
      [strongSelf requsetDataWithBuySellForHandleWithFund:
                      [NSString stringWithFormat:@"%ld", (long)funds]
                                                withPrice:price
                                          withBuySellBool:NO
                                                withToken:nil];
    }
  };

  _stockSliederView.downButtonBuySell =
      ^(NSInteger funds, NSString *price, NSString *token) {
        //点击 买入卖出 按钮回调
        BaseBuySellVC *strongSelf = weakSelf;
        if (strongSelf) {
          strongSelf.whetherStartLoadingView = YES;
          [strongSelf statrNetLoadingView];
          [strongSelf requsetDataWithBuySellForHandleWithFund:
                          [NSString stringWithFormat:@"%ld", (long)funds]
                                                    withPrice:price
                                              withBuySellBool:YES
                                                    withToken:strongSelf.token];
        }
      };
  [self.sliederStockInfoView addSubview:self.stockSliederView];
  //创建信息view
  self.stockInfoView = (SimuStockInfoView *)
      [[[NSBundle mainBundle] loadNibNamed:@"SimuStockInfoView"
                                     owner:nil
                                   options:nil] lastObject];
  _stockInfoView.frame =
      CGRectMake(0, CGRectGetMaxY(self.stockSliederView.frame) + 5,
                 CGRectGetWidth(self.view.bounds), 90);
  if (_buySellType == StockSellType) {
    [_stockInfoView setTradeType:NO];
  }
  [self.sliederStockInfoView addSubview:self.stockInfoView];
}

#pragma makr-- 点击市价 和限价 后 调整界面布局
/** 点击市价 和限价 后 调整界面布局 */
- (void)sendFramePriceAmountWithBuySell:(BuySellType)buySell
                         wihtMarkeFixed:(MarketFixedPriceType)marketF {
  [_stockBuySellView reSituationWithBuySellType:buySell
                            withMarketFixedType:marketF];
  [_stockSliederView marketFixedAssignment:marketF];
  _marketFixedType = marketF;
  if (marketF == MarketPriceType) {
    //市价
    self.sliederStockInfoView.frame = marketSliedViewFrame;
  } else if (marketF == FixedPriceType) {
    self.sliederStockInfoView.frame = fixedSliedViewFrame;
  }
  if (buySell == StockBuyType) {
    //买入
    [_stockSliederView marketFixedAssignment:marketF];
    [_stockSliederView showLabelForMarketFiexd:marketF];
  }
}

#pragma mark-- 绑定查询数据
/** 绑定查询数据 */
- (void)bindDataWithSimuTradeBaseData:(SimuTradeBaseData *)data {
  //查询数据绑定 区分 哪里请求的数据
  if (data) {
    self.token = data.token;
    _shareButtonView.hidden = YES;
    if (_buySellType == StockSellType) {
      NSDictionary *userInfo = @{
        @"token" : self.token,
      };

      [[NSNotificationCenter defaultCenter]
          postNotificationName:@"SynchronousBuySellVCToken"
                        object:nil
                      userInfo:userInfo];
    }

    if (self.stockBuySellView) {
      [self.stockBuySellView bindWithSimuTradeBaseData:data
                                       withBuySellType:_buySellType];
    }
    if (self.stockSliederView) {
      [self.stockSliederView bindBuySellData:data
                 withSwitchRefreshSliderBool:_moerButtonDownBool];
    }
    if (!_moerButtonDownBool) {
      if (self.stockInfoView) {
        if (_buySellType == StockBuyType) {
          [self.stockInfoView setUserPageData:data isBuy:YES];
        } else if (_buySellType == StockSellType) {
          [self.stockInfoView setUserPageData:data isBuy:NO];
        }
      }
    }
  }
}

#pragma mark-- 绑定买入卖出委托数据
/** 绑定买入卖出委托数据 */
- (void)bindBuySellEntrustWithSimuDoDealSubmitData:
    (SimuDoDealSubmitData *)data {
  NSLog(@"数据请求成功");
  //交易股票信息
  OpeningTimeView *openingTime = nil;
  NSString *titleBuySell = nil;
  if (_buySellType == StockBuyType) {
    openingTime = _stockSliederView.alarmTimeView;
    titleBuySell = @"买入";
  } else if (_buySellType == StockSellType) {
    openingTime = _stockSliederView.openingTimeView;
    titleBuySell = @"卖出";
  }
  if (openingTime.sttbv_alarmIV.hidden == NO) {
    NSString *message = [NSString
        stringWithFormat:@"您的委托\"%@%@"
                         @"\"已提交\n现在已收盘，要等到开盘后才可能成交哦",
                         titleBuySell, _stockBuySellView.stockNameTF.text];
    [NewShowLabel setMessageContent:message];
  }
  //清楚数据
  [self tempStockCodeWithName:YES];
  [self clearAllDataForSubView];
  [[NSNotificationCenter defaultCenter]
      postNotificationName:@"ClearProfitAndStopVCData"
                    object:nil];

  _shareButtonView.hidden = NO;
  if (_marketFixedType == MarketPriceType) {
    self.marketDealBool = YES;
  } else if (_marketFixedType == FixedPriceType) {
    self.fixedDealBool = YES;
  }
}
/** 分享时用的 记录股票信息 */
- (void)tempStockCodeWithName:(BOOL)isEnd {
  if (isEnd) {
    _tempCode = _stockBuySellView.stockCodeTF.text;
    _tempName = _stockBuySellView.stockNameTF.text;
    _tempAmount = _stockBuySellView.buyAmountTF.text;
    _tempPrice = _stockBuySellView.buyPriceTF.text;
    //记录市价和限价资金
    _markFundsString = [NSString
        stringWithFormat:@"%ld", (long)self.stockSliederView.marketFoundsValue];
    _fixedFundsString = [NSString
        stringWithFormat:@"%ld", (long)self.stockSliederView.fixedFoundsValue];
  } else {
    _tempCode = nil;
    _tempName = nil;
    _tempAmount = nil;
    _tempPrice = nil;
  }
}
#pragma mark-- 看情况 显示分享按钮
/** 看情况 显示分享按钮  */
- (void)showMarketFixedShareButtonWithBool:(BOOL)marketFixed {
  //如果 市价交易成功 点击 限价界面 隐藏分享按钮
  if (marketFixed) {
    //市价界面 有没有成交过
    if (self.marketDealBool) {
      _shareButtonView.hidden = NO;
    } else {
      _shareButtonView.hidden = YES;
    }
  } else {
    if (self.fixedDealBool) {
      _shareButtonView.hidden = NO;
    } else {
      _shareButtonView.hidden = YES;
    }
  }
}

#pragma mark-- 清除数据
/**清除数据 */
- (void)clearAllDataForSubView {
  self.stockCode = nil;
  self.stockName = nil;
  self.moerButtonDownBool = NO;
  [_stockBuySellView clearData];
  [_stockSliederView eliminateData];
  if (_stockInfoView) {
    [_stockInfoView clearControlData];
  }
}

- (void)followingTransactionClearsData {
  self.moerButtonDownBool = NO;
  [_stockBuySellView clearData];
  [_stockSliederView eliminateData];
  if (_stockInfoView) {
    [_stockInfoView clearControlData];
  }
}

#pragma mark-- 搜索股票页面
/** 搜索股票页面  */
- (void)createSearchVC {
  __weak BaseBuySellVC *weakSelf = self;
  OnStockSelected callback =
      ^(NSString *stockCode, NSString *stockName, NSString *firstType) {
        BaseBuySellVC *strongSelf = weakSelf;
        if (strongSelf.buySellType == StockBuyType) {
          [strongSelf.stockSliederView.alarmTimeView timeVisible:YES];
        } else if (strongSelf.buySellType == StockSellType) {
          [strongSelf.stockSliederView.openingTimeView timeVisible:YES];
        }
        if (stockCode == nil || stockCode.length == 0) {
          return;
        }
        [strongSelf followingTransactionClearsData];
        strongSelf.stockCode = [StockUtil sixStockCode:stockCode];
        strongSelf.stockName = stockName;
        strongSelf.stockBuySellView.stockCodeTF.text = strongSelf.stockCode;
        strongSelf.stockBuySellView.stockNameTF.text = stockName;
        strongSelf.stockBuySellView.isOriginalView = YES;
        [strongSelf requsetDataWithBuySellForHandleWithFund:@"0"
                                                  withPrice:@""
                                            withBuySellBool:NO
                                                  withToken:nil];
      };
  [AppDelegate pushViewControllerFromRight:[[SelectStocksViewController alloc]
                                               initStartPageType:InBuyStockPage
                                                    withCallBack:callback]];
}

#pragma mark-- 卖出股票查询页面
/** 卖出股票查询页面 */
- (void)creatSellStockView {
  __weak BaseBuySellVC *weakSelf = self;
  SelectPositionStockViewController *searchVC = [
      [SelectPositionStockViewController alloc]
        initWithMatchId:self.matchId
      withStartPageType:InSellStockPage
          withAccountId:self.accountId
          withTargetUid:self.targetUid
       withUserOrExpert:self.expertUserType
           withCallBack:^(NSString *stockCode, NSString *stockName,
                          NSString *firstType) {

             BaseBuySellVC *strongSelf = weakSelf;
             if (strongSelf) {
               if (strongSelf.buySellType == StockBuyType) {
                 [strongSelf.stockSliederView.alarmTimeView timeVisible:YES];
               } else if (strongSelf.buySellType == StockSellType) {
                 [strongSelf.stockSliederView.openingTimeView timeVisible:YES];
               }

               if (stockCode == nil || stockCode.length == 0) {
                 return;
               }
               [strongSelf followingTransactionClearsData];
               strongSelf.stockCode = [StockUtil sixStockCode:stockCode];
               strongSelf.stockName = stockName;
               strongSelf.stockBuySellView.stockCodeTF.text =
                   strongSelf.stockCode;
               strongSelf.stockBuySellView.stockNameTF.text = stockName;
               strongSelf.stockBuySellView.isOriginalView = YES;

               [strongSelf requsetDataWithBuySellForHandleWithFund:@"0"
                                                         withPrice:@""
                                                   withBuySellBool:NO
                                                         withToken:nil];
               NSDictionary *userInfo = @{
                 @"stockCode" : stockCode,
                 @"stockName" : stockName,
                 @"firstType" : firstType
               };
               [[NSNotificationCenter defaultCenter]
                   postNotificationName:@"SynchronousBuySellVCData"
                                 object:nil
                               userInfo:userInfo];
             }
           }];
  [AppDelegate pushViewControllerFromRight:searchVC];
}
@end
