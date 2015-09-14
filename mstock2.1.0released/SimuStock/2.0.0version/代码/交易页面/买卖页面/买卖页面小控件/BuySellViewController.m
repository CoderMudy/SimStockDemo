//
//  BuySellViewController.m
//  SimuStock
//
//  Created by 刘小龙 on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BuySellViewController.h"
#import "SelectStocksViewController.h"

//卖出股票界面

/************* 测试下 *************/

@interface BuySellViewController () {
  //买入卖出市价 下面的控件的位置
  CGRect marketSliedViewFrame;
  //买入卖出限价 控件的位置
  CGRect fixedSliedViewFrame;
  //买入卖出 按钮
  UIButton *BuySellStockButton;

  CGRect _subFrame;
}

@end

@implementation BuySellViewController
#pragma mark - 初始化方法 第一个BOOL YES为买 NO 为卖  第二个BOOL YES为市价 NO 为限价
- (id)initWithFrame:(CGRect)frame
           withStockCode:(NSString *)stockCode
           withStockName:(NSString *)stockName
             withMatchId:(NSString *)matchId
           withBuyOrSell:(BOOL)buyOrSell
         withMarketFixed:(BOOL)marketFixed
           withAccountID:(NSString *)accountId
           withTargetUid:(NSString *)targetUid
    withStockSellBuyType:(StockBuySellType)type {
  self = [super init];
  if (self) {
    //控件大小
    _subFrame = frame;
    _stockBuySellType = type;
    self.accountId = accountId;
    self.targetUid = targetUid;
    //股票代码统一显示为6位
    self.tempStockCode = [StockUtil sixStockCode:stockCode];
    self.tempStockName = stockName;
    self.matchId = matchId;
    if ([self.matchId isEqualToString:@"1"]) {
      //不是比赛
      _isFromMatch = NO;
    } else {
      //是比赛
      _isFromMatch = YES;
    }

    //记录资金值
    self.markeFoundsValue = 0;
    self.fixedFoundsValue = 0;
    //判断资金按钮是否被点击过
    self.moneyButton = NO;
    //判断是买入 还是 卖出 YES = 买 NO = 卖
    self.isBuyOrSell = buyOrSell;

    //是 市价 还是 限价
    self.marketFixedPrice = marketFixed;

    //判断 是市价成交 还是 限价成交 初始化为NO
    self.marketDealBool = NO;
    self.fixedDealBool = NO;
    if (self.tempStockCode.length != 0 && self.tempStockName.length != 0) {
      [self statrNetLoadingView];
    }
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (self.tempStockName.length != 0 && self.tempStockCode.length != 0) {
    [self statrNetLoadingView];
  }
}

- (void)viewDidLoad {

  //  SliederViewContrer *sliederVC = [[SliederViewContrer alloc]
  //  initWithNibName:@"SliederViewContrer" bundle:nil];
  //  CGRect sliederFrame = CGRectMake(0, 0, sliederVC.view.bounds.size.width,
  //  sliederVC.view.bounds.size.height);
  //  sliederVC.view.frame = sliederFrame;
  //  [self.view addSubview:sliederVC.view];
  //  [self addChildViewController:sliederVC];
  //
  //  return;
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(synchronousDataM:)
                                               name:@"SynchronousWinLoseVCData"
                                             object:nil];
  [super viewDidLoad];
  self.view.frame = _subFrame;
  self.view.bounds =
      CGRectMake(0, 0, _subFrame.size.width, _subFrame.size.height);
  simuBuyQueryData = [[SimuTradeBaseData alloc] init];
  scv_buystockNumber = 0;
  //创建承载页面
  [self creatBaseView];
  //创建滚动小控件
  [self creatSliderView];
  //加入资金小控件，比赛不需要Ø + 牛人购买  也不需要
  if (_stockBuySellType == StockBuySellOrdinaryType) {
    if (_isFromMatch == NO) {
      [self creatAddFoundBut];
    }
  }

  //创建选择资金小控件
  if (self.isBuyOrSell) {
    [self creatFundSelButs];
  }
  //创建买入按钮
  [self creatBuyStockButton];
  //开盘时间提醒
  [self creatopeningTimeView];
  //创建股票信息
  [self creatStockInfoView];
  //创建分享按钮
  if (_stockBuySellType == StockBuySellOrdinaryType) {
    [self createShareButton];
  }
  if (self.tempStockCode.length != 0) {
    self.buySellView.stockCodeTF.text = self.tempStockCode;
    self.buySellView.stockNameTF.text = self.tempStockName;
  }
  //开始请求，如果不是从比赛页面进入的，则请求
  if (!_isFromMatch) {
    //如果是买入页面
    if (self.tempStockCode.length == 0) {
      return;
    }
    if (self.isBuyOrSell) {
      [self getamountFromNet:self.tempStockCode
                         Pirce:@""
                          fund:@"0"
             withPriceOrAmount:YES
          withStockBuySellType:_stockBuySellType
                 withAccountID:_accountId];
    } else {
      //卖出股票信息查询
      [self querySellInfoWidthStockCode:self.tempStockCode
                      withPriceOrAmount:YES
                          withAccountId:_accountId];
    }
  } else {
    if (self.tempStockCode.length == 0 || self.tempStockName.length == 0) {
      [self stopLoading];
    } else {
      if (self.isBuyOrSell) {
        [self getamountFromNet:self.tempStockCode
                           Pirce:@""
                            fund:@"0"
               withPriceOrAmount:YES
            withStockBuySellType:_stockBuySellType
                   withAccountID:_accountId];
      } else {
        //卖出股票信息查询
        [self querySellInfoWidthStockCode:self.tempStockCode
                        withPriceOrAmount:YES
                            withAccountId:_accountId];
      }
    }
  }
  //给键盘添加一个监听  监听键盘输入框里内容的变化
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(textFiledEditChanged:)
             name:UITextFieldTextDidChangeNotification
           object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self stopLoading];
}

- (void)synchronousDataM:(NSNotification *)notification {
  NSString *stockCode = [notification.userInfo valueForKey:@"stockCode"];
  NSString *stockName = [notification.userInfo valueForKey:@"stockName"];
  NSString *buyAmount = [notification.userInfo valueForKey:@"buyAmount"];
  self.buySellView.stockCodeTF.text = stockCode;
  self.buySellView.stockNameTF.text = stockName;
  self.buySellView.buyAmountTF.text = buyAmount;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:UITextFieldTextDidChangeNotification
              object:nil];
  NSLog(@"<%@ 已释放>", self);
}

#pragma mark - 对外提供刷新方法
- (void)againRefreshData {
  //只刷新 价格 不刷新 数量
  if (self.buySellView.stockCodeTF.text.length == 0 ||
      self.buySellView.stockNameTF.text.length == 0) {
    return;
  }
  [self statrNetLoadingView];
  if (self.isBuyOrSell) {
    //出来 数量其他的都刷新
    [self getamountFromNet:self.buySellView.stockCodeTF.text
                       Pirce:@""
                        fund:@"0"
           withPriceOrAmount:NO
        withStockBuySellType:_stockBuySellType
               withAccountID:_accountId];
  } else {
    [self querySellInfoWidthStockCode:self.buySellView.stockCodeTF.text
                    withPriceOrAmount:NO
                        withAccountId:_accountId];
  }
}

#pragma mark - 卖出股票查询
- (void)querySellInfoWidthStockCode:(NSString *)stockCode
                  withPriceOrAmount:(BOOL)isEnd
                      withAccountId:(NSString *)accountId {
  if (stockCode == nil || stockCode.length == 0) {
    [self stopLoading];
    return;
  }
  if (![SimuUtil isLogined]) {
    [self stopLoading];
    return;
  }
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak BuySellViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    BuySellViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    BuySellViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSimuDoSellQueryData:(SimuTradeBaseData *)obj
                                 withBool:isEnd];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    if (error) {
      if ([error.status isEqualToString:@"0101"]) {
        [[NSNotificationCenter defaultCenter]
            postNotificationName:Illegal_Logon_SimuStock
                          object:nil];
      } else {
        if ([error.message isEqualToString:@"该" @"股"
                           @"票停牌，仅允许市价卖出"]) {
          return [NewShowLabel
              setMessageContent:
                  @"该股票已停牌，不能进行卖出操作"];
        }
        [NewShowLabel setMessageContent:error.message];
      }
      return;
    }
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
  };

  NSString *num = self.marketFixedPrice ? @"1" : @"0";
  if (_stockBuySellType == StockBuySellOrdinaryType) {
    [SimuTradeBaseData requestSimuDoSellQueryDataWithMatchId:self.matchId
                                               withStockCode:stockCode
                                                withCatagory:num
                                                withCallback:callback];
  } else if (_stockBuySellType == StockBuySellExpentType) {
    [SimuTradeBaseData requestExpertPlanSell:accountId
                                withCategory:num
                               withStockCode:stockCode
                                withCallback:callback];
  }
}

#pragma mark 卖出查询回调 数据绑定
- (void)bindSimuDoSellQueryData:(SimuTradeBaseData *)sellQueryData
                       withBool:(BOOL)isEnd {
  NSDictionary *userInfo = @{
    @"token" : sellQueryData.token,
  };

  [[NSNotificationCenter defaultCenter]
      postNotificationName:@"SynchronousBuySellVCToken"
                    object:nil
                  userInfo:userInfo];

  //信息记录
  simuBuyQueryData = sellQueryData;
  self.marketDealBool = NO;
  self.fixedDealBool = NO;
  shareBut.hidden = YES;
  NSString *price = [NSString
      stringWithFormat:[StockUtil
                           getPriceFormatWithTradeType:sellQueryData.tradeType],
                       sellQueryData.salePrice];
  if (isEnd == NO) {
    self.buySellView.buyPriceTF.text = price;
    return;
  }
  scv_lastprice = sellQueryData.salePrice;
  NSString *amountSell = sellQueryData.sellable;
  NSArray *array =
      @[ sellQueryData.stockCode, sellQueryData.stockName, price, amountSell ];
  [self.buySellView bindData:array];
  scv_buystockNumber = [sellQueryData.sellable longLongValue];
  if (scv_littleSliderView) {
    if ([sellQueryData.sellable longLongValue] >= 1) {
      scv_littleSliderView.minimumValue = 1;
      scv_littleSliderView.maximumValue =
          [sellQueryData.sellable longLongValue];
      scv_littleSliderView.value = [sellQueryData.sellable longLongValue];
      //最大 最小卖出 数量
      _scv_minNumber.text = @"1";
      _scv_maxNumber.text = [NSString
          stringWithFormat:@"%lld", [sellQueryData.sellable longLongValue]];
    } else {
      //数据初始化
      [self sliderDataInitialization];
    }
  }
  if (scv_stockInfoView) {
    [scv_stockInfoView setUserPageData:sellQueryData isBuy:NO];
  }
}

#pragma mark
#pragma mark 创建各个控件
#pragma mark - 分享按钮部分
- (void)createShareButton {
  shareBut = [UIButton buttonWithType:UIButtonTypeCustom];
  if ([UIScreen mainScreen].bounds.size.height <= 480) {
    shareBut.frame = CGRectMake((self.view.bounds.size.width - 584.0 / 2) / 2,
                                CGRectGetMaxY(scv_stockInfoView.frame) + 25,
                                584.0 / 2, 74.0 / 2);
  } else {
    shareBut.frame = CGRectMake((self.view.bounds.size.width - 584.0 / 2) / 2,
                                CGRectGetMaxY(scv_stockInfoView.frame) + 25,
                                584.0 / 2, 74.0 / 2);
  }
  shareBut.backgroundColor = [Globle colorFromHexRGB:@"#f5ad00"];
  [shareBut.layer setMasksToBounds:YES];
  shareBut.layer.cornerRadius = 3.0;
  [shareBut setTitle:@"委托成功,分享" forState:UIControlStateNormal];
  [shareBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  shareBut.titleLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  [shareBut addTarget:self
                action:@selector(sharePressDown:)
      forControlEvents:UIControlEventTouchDown];
  [shareBut addTarget:self
                action:@selector(sharePressUp:)
      forControlEvents:UIControlEventTouchUpOutside];
  [shareBut addTarget:self
                action:@selector(sharebuttonTriggeringMethod:)
      forControlEvents:UIControlEventTouchUpInside];
  [_sliderView addSubview:shareBut];
  shareBut.hidden = YES;
}
//分享按钮方法
- (void)sharePressDown:(UIButton *)btn {
  btn.backgroundColor = [Globle colorFromHexRGB:@"#de9200"];
}
- (void)sharePressUp:(UIButton *)btn {
  btn.backgroundColor = [Globle colorFromHexRGB:@"#f5ad00"];
}
//分享按钮
- (void)sharebuttonTriggeringMethod:(UIButton *)btn {
  btn.backgroundColor = [Globle colorFromHexRGB:@"#f5ad00"];
  //交易分享http://www.youguu.com/opms/fragment/html/fragment.html
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
  NSString *buySell = self.isBuyOrSell ? @"买入" : @"卖出";
  [shareAction
          shareTitle:@"分享自"
             content:[NSString stringWithFormat:
                                   @"#优顾炒股#%@%@（%@）%"
                                   @"ld股，下载体验，和我一起玩 %@ "
                                   @"(分享自@优顾炒股官方)",
                                   buySell, self.tempStockName,
                                   self.tempStockCode,
                                   (long)[self.tempStockNumber integerValue],
                                   shareUrl]
               image:shareImage
      withOtherImage:nil
        withShareUrl:shareUrl
       withOtherInfo:
           [NSString stringWithFormat:
                         @"%@%@（%@）%" @"ld股，下载体验，和我一起玩 %@ ",
                         buySell, self.tempStockName, self.tempStockCode,
                         (long)[self.tempStockNumber integerValue], shareUrl]];
}
#pragma mark
#pragma mark-------创建控件------------------
//创上方闹钟和时间显示控件
- (void)creatopeningTimeView {
  if (_scvc_openingTimeView == nil) {
    CGRect openingTimeFrame;
    if (self.isBuyOrSell) {
      openingTimeFrame =
          CGRectMake(10.0, CGRectGetMaxY(scv_moneySelView.frame) + 10,
                     CGRectGetWidth(_sliderView.bounds), 29.5);
    } else {
      openingTimeFrame =
          CGRectMake(10.0, CGRectGetMaxY(BuySellStockButton.frame) + 10,
                     CGRectGetWidth(_sliderView.bounds), 29.5);
    }
    _scvc_openingTimeView =
        [[OpeningTimeView alloc] initWithFrame:openingTimeFrame];
    _scvc_openingTimeView.backgroundColor = [UIColor clearColor];
    [_sliderView addSubview:_scvc_openingTimeView];
    [_scvc_openingTimeView timeVisible:NO];
  }
}

//创建买入卖出承载页面
- (void)creatBaseView {
  ssvc_baseView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,
                               self.view.frame.size.height)];
  ssvc_baseView.backgroundColor = [Globle colorFromHexRGB:@"ffffff"];
  [self.view addSubview:ssvc_baseView];

  //创建买入卖出控件
  self.buySellView = [StockBuySellView staticInitalizationStockBuySellView];
  //  [self.buySellView
  //      accordingIncomingParametersShowBuyOrSell:self.isBuyOrSell
  //                               withMarketFixed:self.marketFixedPrice];
  self.buySellView.frame = CGRectMake(0, 0, CGRectGetWidth(ssvc_baseView.frame),
                                      self.buySellView.bounds.size.height);
  self.buySellView.stockCodeTF.delegate = self;
  self.buySellView.stockNameTF.delegate = self;
  [ssvc_baseView addSubview:self.buySellView];
  if (self.isBuyOrSell) {
    marketSliedViewFrame =
        CGRectMake(0, 10 + 35 + 10, CGRectGetWidth(ssvc_baseView.bounds),
                   CGRectGetHeight(ssvc_baseView.bounds) - 55);
  } else {
    marketSliedViewFrame =
        CGRectMake(0, 55 + 10 + 35, CGRectGetWidth(ssvc_baseView.bounds),
                   CGRectGetHeight(ssvc_baseView.bounds) - 90);
  }
}

//对外提供一个方法 来改变 价格和数量的位置
- (void)sendFramePriceAmountWithBuySell:(BOOL)buySell
                         wihtMarkeFixed:(BOOL)marketF {
  //  [self.buySellView accordingIncomingParametersShowBuyOrSell:buySell
  //                                             withMarketFixed:marketF];

  if (marketF) {
    _sliderView.frame = marketSliedViewFrame;
  } else {
    _sliderView.frame = fixedSliedViewFrame;
  }
  if (buySell) {
    if (_markeFoundsValue != 0) {
      _scv_foundsLB.hidden = NO;
      _scv_foundsLB.text =
          marketF
              ? [NSString stringWithFormat:@"¥ %ld", (long)_markeFoundsValue]
              : [NSString stringWithFormat:@"¥ %ld", (long)_fixedFoundsValue];
    } else {
      _scv_foundsLB.hidden = YES;
    }
  }
}

//创建滑快小控件
- (void)creatSliderView {
  //创建滑块和资金标签的承载页面
  _sliderView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 143, CGRectGetWidth(self.view.bounds),
                               CGRectGetHeight(self.view.bounds) - 143)];
  _sliderView.backgroundColor = [UIColor clearColor];
  [ssvc_baseView addSubview:_sliderView];
  fixedSliedViewFrame = _sliderView.frame;
  //买入界面 显示资金显示按钮
  if (self.isBuyOrSell) {
    //创建显示资金标签
    self.scv_foundsLB =
        [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 12)];
    _scv_foundsLB.backgroundColor = [UIColor clearColor];
    _scv_foundsLB.textColor = [Globle colorFromHexRGB:@"#086dae"];
    _scv_foundsLB.font = [UIFont systemFontOfSize:Font_Height_12_0];
    _scv_foundsLB.text = @"¥0";
    _scv_foundsLB.textAlignment = NSTextAlignmentCenter;
    [_sliderView addSubview:_scv_foundsLB];
  } else {
    //创建可卖股票数量 最大最小显示框
    _scv_minNumber = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, 60, 12)];
    _scv_minNumber.backgroundColor = [UIColor clearColor];
    _scv_minNumber.textColor = [Globle colorFromHexRGB:Color_Blue_but];
    _scv_minNumber.font = [UIFont systemFontOfSize:Font_Height_12_0];
    _scv_minNumber.text = @"0";
    _scv_minNumber.textAlignment = NSTextAlignmentLeft;
    _scv_minNumber.adjustsLetterSpacingToFitWidth = YES;
    [_sliderView addSubview:_scv_minNumber];

    _scv_maxNumber = [[UILabel alloc]
        initWithFrame:CGRectMake(CGRectGetWidth(_sliderView.bounds) - 20 - 60,
                                 0, 60, 12)];
    _scv_maxNumber.backgroundColor = [UIColor clearColor];
    _scv_maxNumber.textColor = [Globle colorFromHexRGB:Color_Blue_but];
    _scv_maxNumber.font = [UIFont systemFontOfSize:Font_Height_12_0];
    _scv_maxNumber.text = @"0";
    _scv_maxNumber.textAlignment = NSTextAlignmentRight;
    _scv_maxNumber.adjustsLetterSpacingToFitWidth = YES;
    [_sliderView addSubview:_scv_maxNumber];
  }
  //创建划块
  CGRect sliderFrame = CGRectZero;
  if (self.isBuyOrSell) {
    sliderFrame =
        CGRectMake(16, CGRectGetMaxY(_scv_foundsLB.frame) + 5, 200, 14);
  } else {
    sliderFrame = CGRectMake(17, CGRectGetMaxY(_scv_minNumber.frame) + 5,
                             CGRectGetWidth(_sliderView.bounds) - 17 * 2, 14);
  }
  UISlider *slider = scv_littleSliderView =
      [[UISlider alloc] initWithFrame:sliderFrame];
  slider.backgroundColor = [UIColor clearColor];
  [slider addTarget:self
                action:@selector(sliderValueChanged:)
      forControlEvents:UIControlEventValueChanged];
  slider.minimumValue = 0.0; //下限
  slider.maximumValue = 0.0; //上限
  slider.value = 0.0;
  [slider setThumbImage:[UIImage imageNamed:@"滑动按钮.png"]
               forState:UIControlStateNormal];
  [slider setThumbImage:[UIImage imageNamed:@"滑动按钮.png"]
               forState:UIControlStateHighlighted];
  [slider
      setMaximumTrackImage:[[UIImage imageNamed:@"买入数量进度条.png"]
                               stretchableImageWithLeftCapWidth:4
                                                   topCapHeight:0]
                  forState:UIControlStateNormal];
  [slider
      setMinimumTrackImage:[[UIImage imageNamed:@"买入数量进度条左.png"]
                               stretchableImageWithLeftCapWidth:4
                                                   topCapHeight:0]
                  forState:UIControlStateNormal];
  //[slider setMinimumTrackTintColor:[Globle colorFromHexRGB:@"#6cb4de"]];
  [_sliderView addSubview:slider];
}
#pragma mark - 资金按钮 买入显示 卖出隐藏
- (void)creatAddFoundBut {
  CGRect buttonFrame =
      CGRectMake(CGRectGetMaxX(scv_littleSliderView.frame) + 8,
                 CGRectGetMinY(scv_littleSliderView.frame) - 8, 74, 30);
  SimuleftImagButtonView *addmoneyBut =
      [[SimuleftImagButtonView alloc] initWithFrame:buttonFrame
                                          ImageName:@"加资金图标.png"
                                          TitleName:@"资金"
                                          TextColor:@"#d23f30"
                                                Tag:100];

  addmoneyBut.titlelable.font = [UIFont systemFontOfSize:14];
  addmoneyBut.hidden = self.isBuyOrSell ? NO : YES;
  [_sliderView addSubview:addmoneyBut];
  addmoneyBut.delegate = self;
}
#pragma mark - 创建资金选择按钮
- (void)creatFundSelButs {
  simuselMonyeButView *button = scv_moneySelView = [[simuselMonyeButView alloc]
      initWithFrame:CGRectMake(16,
                               CGRectGetMaxY(scv_littleSliderView.frame) + 15,
                               200, 30)];
  button.delegate = self;
  button.hidden = self.isBuyOrSell ? NO : YES;
  [_sliderView addSubview:button];
}
//刷新资金选择按钮 对外提供
- (void)refreshFundSelectionButton {
  if (scv_moneySelView) {
    [scv_moneySelView removeFromSuperview];
    [self creatFundSelButs];
    [scv_moneySelView setTotolMoney:scv_buystockNumber];
  }
}
#pragma mark - 创建股票价格信息视图
- (void)creatStockInfoView {
  scv_stockInfoView = (SimuStockInfoView *)
      [[[NSBundle mainBundle] loadNibNamed:@"SimuStockInfoView"
                                     owner:nil
                                   options:nil] firstObject];
  scv_stockInfoView.frame =
      CGRectMake(0, CGRectGetMaxY(_scvc_openingTimeView.frame) + 4,
                 self.view.bounds.size.width, 90);
  if (!self.isBuyOrSell) {
    [scv_stockInfoView setTradeType:NO];
  }
  [_sliderView addSubview:scv_stockInfoView];
}
//创建买入按钮
- (void)creatBuyStockButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  BuySellStockButton = button;
  //买入 卖出 界面的frame
  NSString *buyOrSellTitle = nil;
  if (self.isBuyOrSell) {
    button.frame = CGRectMake(CGRectGetMaxX(scv_moneySelView.frame) + 10,
                              CGRectGetMinY(scv_moneySelView.frame), 74, 30.5);
    buyOrSellTitle = @"买入";
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 30.5 / 2.0;
  } else {
    button.frame =
        CGRectMake(17, CGRectGetMaxY(scv_littleSliderView.frame) + 10,
                   CGRectGetWidth(scv_littleSliderView.bounds), 30.5);
    buyOrSellTitle = @"卖出";
  }
  [button setTitle:buyOrSellTitle forState:UIControlStateNormal];
  [button setTitle:buyOrSellTitle forState:UIControlStateHighlighted];
  button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
  [button setBackgroundColor:[Globle colorFromHexRGB:@"#31bce9"]]; //@"#086dae"
  [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [button setTitleColor:[UIColor whiteColor]
               forState:UIControlStateHighlighted];
  [button addTarget:self
                action:@selector(buyPressDown:)
      forControlEvents:UIControlEventTouchDown];
  [button addTarget:self
                action:@selector(buyPressUp:)
      forControlEvents:UIControlEventTouchUpInside];
  [button addTarget:self
                action:@selector(buyPressUp:)
      forControlEvents:UIControlEventTouchUpOutside];
  [_sliderView addSubview:button];
}

#pragma mark-- 创建搜索页面 股票查询 买入股票
- (void)creatSearchVC {

  __weak BuySellViewController *weakSelf = self;

  OnStockSelected callback =
      ^(NSString *stockCode, NSString *stockName, NSString *firstType) {
        BuySellViewController *strongSelf = weakSelf;
        [strongSelf.scvc_openingTimeView timeVisible:YES];
        if (stockCode == nil || [stockCode length] <= 2)
          return;
        [strongSelf followingTransactionClearsData];
        [strongSelf.buySellView.buyPriceTF resignFirstResponder];
        [strongSelf.buySellView.buyAmountTF resignFirstResponder];
        strongSelf.tempStockCode = [StockUtil sixStockCode:stockCode];
        strongSelf.buySellView.stockCodeTF.text = self.tempStockCode;
        strongSelf.buySellView.stockNameTF.text = stockName;

        strongSelf.tempStockName = stockName;
        [strongSelf getamountFromNet:self.tempStockCode
                               Pirce:@""
                                fund:@"0"
                   withPriceOrAmount:YES
                withStockBuySellType:_stockBuySellType
                       withAccountID:_accountId];
      };
  [AppDelegate pushViewControllerFromRight:[[SelectStocksViewController alloc]
                                               initStartPageType:InBuyStockPage
                                                    withCallBack:callback]];
}

#pragma mark - 创建卖出股票页面 卖出股票
- (void)creatSellStockView {
  __weak BuySellViewController *weakSelf = self;
  SelectPositionStockViewController *searchView = [
      [SelectPositionStockViewController alloc]
        initWithMatchId:self.matchId
      withStartPageType:InSellStockPage
          withAccountId:self.accountId
          withTargetUid:self.targetUid
       withUserOrExpert:_stockBuySellType
           withCallBack:^(NSString *code, NSString *stockName,
                          NSString *firstType) {
             BuySellViewController *strongSelf = weakSelf;
             [strongSelf.scvc_openingTimeView timeVisible:YES];
             if (code == nil || [code length] < 2)
               return;
             strongSelf.tempStockCode = [StockUtil sixStockCode:code];

             strongSelf.buySellView.stockCodeTF.text = strongSelf.tempStockCode;
             strongSelf.buySellView.stockNameTF.text = stockName;

             strongSelf.tempStockName = stockName;
             [strongSelf querySellInfoWidthStockCode:strongSelf.tempStockCode
                                   withPriceOrAmount:YES
                                       withAccountId:_accountId];
             NSDictionary *userInfo = @{
               @"stockCode" : code,
               @"stockName" : stockName,
               @"firstType" : firstType
             };
             [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"SynchronousBuySellVCData"
                               object:nil
                             userInfo:userInfo];

           }];

  [AppDelegate pushViewControllerFromRight:searchView];
}

- (void)destroyself {
  [self leftButtonPress];
}

#pragma mark
#pragma mark SimuleftButtonDelegate

- (void)ButtonPressUp:(NSInteger)index {
  [self showTrackMasgerPurchesVC];
}
#pragma mark
#pragma mark 按钮或划块回调函数
- (void)sliderValueChanged:(id)sender {
  UISlider *control = (UISlider *)sender;
  if (control == scv_littleSliderView) {
    if (self.isBuyOrSell) {
      //买入界面
      CGFloat value = control.value;
      CGFloat maxvalue = control.maximumValue;
      if (maxvalue == 0) {
        maxvalue = 1;
      }
      //滑块 在滑动时 分别计算 市价和限价 时要显示的价格
      self.markeFoundsValue = [self
          marketFoundsNewPriceTransactionCostrCalcuated:(NSInteger)value * 100];
      if (self.markeFoundsValue >= simuBuyQueryData.fundsable) {
        self.markeFoundsValue = simuBuyQueryData.fundsable;
      }
      self.fixedFoundsValue =
          [self transactionCostsCalculated:(NSInteger)value * 100];
      if (self.marketFixedPrice) {
        _scv_foundsLB.text =
            [NSString stringWithFormat:@"¥ %ld", (long)self.markeFoundsValue];
      } else {
        _scv_foundsLB.text =
            [NSString stringWithFormat:@"¥ %ld", (long)self.fixedFoundsValue];
      }

      CGPoint centerPos;
      if (value > 1) {
        centerPos =
            CGPointMake(16 + 200 * (value / maxvalue), _scv_foundsLB.center.y);
      } else {
        centerPos = CGPointMake(45, _scv_foundsLB.center.y);
      }
      if (centerPos.x < 16 + 30) {
        centerPos.x = 16 + 30;
        _scv_foundsLB.textAlignment = NSTextAlignmentLeft;
      } else if (centerPos.x > 16 + 200 - 30) {
        centerPos.x = 16 + 200 - 30;
        _scv_foundsLB.textAlignment = NSTextAlignmentRight;
      } else {
        _scv_foundsLB.textAlignment = NSTextAlignmentCenter;
      }

      _scv_foundsLB.center = centerPos;
      if ((NSInteger)value * 100) {
        //可买数量
        self.buySellView.buyAmountTF.text =
            [NSString stringWithFormat:@"%ld", (long)value * 100];
      }
      if (scv_moneySelView.corIndexSel != -1) {
        //刷新资金选择按钮
        [self refreshFundSelectionButton];
      }
    } else {
      //卖出界面
      if (self.buySellView.stockCodeTF.text.length == 0) {
        return;
      }
      float value = control.value;
      float maxValue = control.maximumValue;
      if (maxValue == 0) {
        return;
      }
      if ((int)maxValue) {
        //股票数量
        self.buySellView.buyAmountTF.text =
            [NSString stringWithFormat:@"%d", (int)value];
      }
    }
  }
}

#pragma mark - 滑块清空
- (void)clearSlideDataFromNewAaaignment {
  scv_littleSliderView.minimumValue = 0;
  scv_littleSliderView.maximumValue = 0;
  scv_littleSliderView.value = 0;
  _scv_maxNumber.text = @"0";
  _scv_minNumber.text = @"0";
  scv_lastprice = 0.0;
  scv_buystockNumber = 0;
}

#pragma mark 普通按钮点击
- (void)buyPressDown:(UIButton *)button {
  [button setBackgroundColor:[Globle colorFromHexRGB:@"#086dae"]];
}

#pragma mark - 买入卖出按钮点击动作
- (void)buyPressUp:(UIButton *)button {
  //买入
  [self.buySellView.buyAmountTF resignFirstResponder];
  [self.buySellView.buyPriceTF resignFirstResponder];

  [button setBackgroundColor:[Globle colorFromHexRGB:@"#31bce9"]];

  //判断 股票名称是否为空
  //不管是 市价还是限价 都要判断股票代码有没有
  NSString *stockname = @"";
  stockname = self.buySellView.stockNameTF.text;
  NSString *content = @"";
  if ([stockname length] == 0) {
    [NewShowLabel setMessageContent:@"请输入股票代码"];
    return;
  }
  NSString *stockprice = @"";
  if (self.buySellView.buyPriceTF.text &&
      self.buySellView.buyPriceTF.text.length != 0) {
    stockprice = [NSString stringWithString:self.buySellView.buyPriceTF.text];
  }
  NSString *stockAmount = @"";
  if (self.buySellView.buyAmountTF.text &&
      self.buySellView.buyAmountTF.text.length != 0) {
    stockAmount = [NSString stringWithString:self.buySellView.buyAmountTF.text];
  }
  //如果价格等于零
  if (simuBuyQueryData.newstockPrice == 0) {
    [NewShowLabel setMessageContent:@"获取股票信息失败,请刷新"];
    return;
  }
  //区分买入 和 卖出
  NSString *type = self.isBuyOrSell ? @"买入" : @"卖出";
  NSString *num = self.isBuyOrSell ? @"36" : @"37";
  //纪录日志
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button
                                                   andCode:num];

  if (simuBuyQueryData) {
    //如果是市价 价格和数量 都不用判断
    //这里还要判断是 买入 还是 卖出
    if (self.marketFixedPrice) {
      if (self.isBuyOrSell) {
        //判断 当前资金是否充足
        //委托金额过低，不能提交
        BOOL isEnd = [self
            lowestAmountMoneyWithAvailableMoney:simuBuyQueryData.fundsable
                                 withStockPrice:simuBuyQueryData.uplimitedPrice
                                withStockAmount:100
                                 withCommission:simuBuyQueryData.minFee];
        if (isEnd == NO) {
          return;
        }
        content = [NSString
            stringWithFormat:@"您确定要以市价买入%ld元的[%@]吗?",
                             (long)self.markeFoundsValue, stockname];
      } else {
        //卖出
        content = [NSString
            stringWithFormat:@"您确定要以市价卖出[%@]%@股吗?",
                             stockname, self.buySellView.buyAmountTF.text];
      }
    } else {
      //如果是限价
      if ([stockprice length] == 0) {
        content = [NSString stringWithFormat:@"请输入%@价格", type];
        [self alertShow:content];
        return;
      } else {
        //如果买入价格超出范围
        if (![self reasonablePrice:stockprice])
          return;
      }
      if ([stockAmount length] == 0) {
        content = [NSString stringWithFormat:@"请输入%@数量", type];
        [self alertShow:content];
        return;
      } else {
        NSInteger inputMount = [stockAmount integerValue];
        if (self.isBuyOrSell) {
          if (inputMount < 100) {
            content = @"买入数量必须为100的整数倍,请重新输入";
            [self alertShow:content];
            return;
          }
          if (inputMount % 100) {
            content = @"买入数量必须为100的整数倍，请重新输入";
            [self alertShow:content];
            return;
          } else {
            CGFloat highMonunt = 0.0f;
            highMonunt = simuBuyQueryData.stockamount;
            if (inputMount > highMonunt) {
            }
          }
        } else {
          //卖出
          if (inputMount == 0) {
            content = @"卖出数量必须大于0，小于可卖股数";
            [self alertShow:content];
            return;
          } else {
            CGFloat highMonunt = 0.0f;
            highMonunt = [simuBuyQueryData.sellable floatValue];
            if (inputMount > highMonunt) {
              content = [NSString
                  stringWithFormat:@"%@数量大于您的持有数量，请重新输入", type];
              [self alertShow:content];
              return;
            }
          }
        }
      }

      if (self.isBuyOrSell) {
        //买入
        BOOL isBuyFixed = [self
            lowestAmountMoneyWithAvailableMoney:simuBuyQueryData.fundsable
                                 withStockPrice:simuBuyQueryData.newstockPrice
                                withStockAmount:100
                                 withCommission:simuBuyQueryData.minFee];
        if (isBuyFixed == NO) {
          return;
        }
      }

      NSString *marketFixedIdentifier =
          self.marketFixedPrice ? @"市价" : @"限价";
      content = [NSString
          stringWithFormat:@"您确定要以%@元的价格%@%@ [%@] %@股？",
                           stockprice, marketFixedIdentifier, type, stockname,
                           stockAmount];
    }
    [self creatAlartView:content];
  } else {
    NSString *content = @"";
    stockname = self.buySellView.stockNameTF.text;
    if ([stockname length] == 0) {
      content = @"请选择要卖出的股票";
    } else
      content = @"股票不可交易";
    [self alertShow:content];
  }
}

#pragma mark - 最低金额
- (BOOL)lowestAmountMoneyWithAvailableMoney:(float)avilableMoney
                             withStockPrice:(float)price
                            withStockAmount:(int)amount
                             withCommission:(float)commission {
  //可用资金
  float totalPrice = price * amount + commission;
  if (avilableMoney < totalPrice) {
    [NewShowLabel setMessageContent:@"委托金额过低,不能提交"];
    return NO;
  } else {
    return YES;
  }
}

#pragma mark UITextFieldDelegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.buySellView.buyPriceTF resignFirstResponder];
  [self.buySellView.buyAmountTF resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

#pragma mark - 输入将要结束时
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  if (textField == self.buySellView.stockNameTF ||
      textField == self.buySellView.stockCodeTF) {
    shareBut.hidden = YES;
    [_scvc_openingTimeView timeVisible:NO];
    [self.buySellView.buyPriceTF resignFirstResponder];
    [self.buySellView.buyAmountTF resignFirstResponder];
    if (self.isBuyOrSell) {
      [self creatSearchVC];
    } else {
      self.sellMarketFiexdBool = NO;
      [self creatSellStockView];
    }
    return NO;
  }
  if (self.isBuyOrSell) {
    if (textField == self.buySellView.buyAmountTF) {
      //判断价格是否有问题
      if ([self reasonablePrice:self.buySellView.buyPriceTF.text] == NO) {
        //如果价格有问题，则继续停留在价格
        [self.buySellView.buyPriceTF becomeFirstResponder];
        return NO;
      }
      [self getLatestInformationInputPrices:self.buySellView.buyPriceTF.text];
    }
  }
  return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  if (textField == self.buySellView.buyPriceTF) {
    float price = [self.buySellView.buyPriceTF.text floatValue];
    if (price != scv_lastprice) {
      if ([self reasonablePrice:self.buySellView.buyPriceTF.text] == NO) {
        return;
      }
      scv_lastprice = price;
    }
  }
}

//收到通知后执行的方法
#pragma mark - 监听输入框的变化 如果内容有了变化执行这个方法
- (void)textFiledEditChanged:(NSNotification *)obj {

  UITextField *textField = (UITextField *)obj.object;
  NSString *toBeString = textField.text;
  if (self.buySellView.buyPriceTF == textField) {
    //过虑除数字和小数点以外的字符
    NSInteger decimalNum = simuBuyQueryData.tradeType == 1 ? 3 : 2;
    textField.text = [ProcessInputData numbersAndPunctuationData:toBeString
                                                      decimalNum:decimalNum];
    if (self.isBuyOrSell) {
      //记录下来改变后的值
      self.fixedFoundsValue = [self
          transactionCostsCalculated:(NSInteger)scv_littleSliderView.value *
                                     100];
      //同步计算价格
      _scv_foundsLB.text =
          [NSString stringWithFormat:@"¥ %ld", (long)self.fixedFoundsValue];
    }
  } else if (self.buySellView.buyAmountTF == textField) {
    //过虑除数字以外的字符
    NSString *filtered = [ProcessInputData processDigitalData:toBeString];
    if (self.isBuyOrSell) {
      if ([filtered integerValue] <= [simuBuyQueryData.maxBuy longLongValue]) {
        textField.text = filtered;
        scv_littleSliderView.value = (float)[filtered longLongValue] / 100;
        if (!self.moneyButton) {
          self.markeFoundsValue =
              [self transactionCostsCalculated:[filtered longLongValue]];
        }
        self.fixedFoundsValue =
            [self transactionCostsCalculated:[filtered longLongValue]];
        _scv_foundsLB.text =
            [NSString stringWithFormat:@"¥ %ld", (long)self.fixedFoundsValue];
        CGFloat value = scv_littleSliderView.value;
        CGFloat maxvalue = scv_littleSliderView.maximumValue;
        if (maxvalue == 0)
          maxvalue = 1;
        /*scv_stockAmoutTextField.text = [NSString
         * stringWithFormat:@"%d",(NSInteger)value*100];*/
        CGPoint centerPos =
            CGPointMake(16 + 200 * (value / maxvalue), _scv_foundsLB.center.y);
        if (centerPos.x < 16 + 30) {
          centerPos.x = 16 + 30;
          _scv_foundsLB.textAlignment = NSTextAlignmentLeft;
        } else if (centerPos.x > 16 + 200 - 30) {
          centerPos.x = 16 + 200 - 30;
          _scv_foundsLB.textAlignment = NSTextAlignmentRight;
        } else {
          _scv_foundsLB.textAlignment = NSTextAlignmentCenter;
        }

        _scv_foundsLB.center = centerPos;
      } else {
        textField.text = [NSString
            stringWithFormat:@"%lld", [simuBuyQueryData.maxBuy longLongValue]];
        scv_littleSliderView.value =
            (float)[simuBuyQueryData.maxBuy longLongValue] / 100;
        _scv_foundsLB.text = [NSString
            stringWithFormat:@"¥ %ld",
                             (long)[self
                                 transactionCostsCalculated:
                                     [simuBuyQueryData.maxBuy longLongValue]]];
        CGFloat value = scv_littleSliderView.value;
        CGFloat maxvalue = scv_littleSliderView.maximumValue;
        if (maxvalue == 0) {
          maxvalue = 1;
        }
        self.buySellView.buyAmountTF.text =
            [NSString stringWithFormat:@"%ld", (long)value * 100];
        CGPoint centerPos =
            CGPointMake(16 + 200 * (value / maxvalue), _scv_foundsLB.center.y);
        if (centerPos.x < 16 + 30) {
          centerPos.x = 16 + 30;
          _scv_foundsLB.textAlignment = NSTextAlignmentLeft;
        } else if (centerPos.x > 16 + 200 - 30) {
          centerPos.x = 16 + 200 - 30;
          _scv_foundsLB.textAlignment = NSTextAlignmentRight;
        } else {
          _scv_foundsLB.textAlignment = NSTextAlignmentCenter;
        }

        _scv_foundsLB.center = centerPos;
      }
      if (scv_moneySelView.corIndexSel != -1) {
        [self refreshFundSelectionButton];
      }
    } else {
      //卖
      if ([filtered integerValue] <= scv_buystockNumber) {
        textField.text = filtered;
        scv_littleSliderView.value = [filtered integerValue];

      } else {
        textField.text =
            [NSString stringWithFormat:@"%lld", scv_buystockNumber];
        scv_littleSliderView.value = (float)scv_buystockNumber;
      }
    }
  }
}
//获取最新输入价格信息
#pragma mark - 价格输入框
- (void)getLatestInformationInputPrices:(NSString *)priceText {

  //买入
  float price = [self.buySellView.buyPriceTF.text floatValue];
  NSString *scv_stockCode = self.buySellView.stockCodeTF.text;
  //从网络获取最大可买数量
  [self getamountFromNet:scv_stockCode
                     Pirce:priceText
                      fund:@"0"
         withPriceOrAmount:YES
      withStockBuySellType:_stockBuySellType
             withAccountID:_accountId];
  scv_lastprice = price;
  if (scv_moneySelView.corIndexSel != -1) {
    [self refreshFundSelectionButton];
  }
}
#pragma mark
#pragma mark 创建并展示各个页面 - 资金卡界面
- (void)showTrackMasgerPurchesVC {
  [self.buySellView.buyPriceTF resignFirstResponder];
  [self.buySellView.buyAmountTF resignFirstResponder];
  //资金卡页面
  FoundMasterPurchViewConroller *mfvc_masterPruchesViewController =
      [[FoundMasterPurchViewConroller alloc] init];
  [AppDelegate pushViewControllerFromRight:mfvc_masterPruchesViewController];
}

#pragma mark
#pragma mark 网络链接部分
- (void)setNoNetwork {
  [self.buySellView.buyPriceTF resignFirstResponder];
  [self.buySellView.buyAmountTF resignFirstResponder];
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
  if (self.indicctorStopAnmation) {
    self.indicctorStopAnmation();
  }
}

- (void)stopLoading {
  [self performSelector:@selector(stopNetLoadingView)
             withObject:nil
             afterDelay:0.3f];
  //[self stopNetLoadingView];
}

/**
 *停止动画
 */
- (void)stopNetLoadingView {
  //加入阻塞
  if ([NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView stopAnimating];
  }
  [self.indicatorView stopAnimating];
  if (self.indicatorStatrAnimation) {
    self.indicctorStopAnmation();
  }
}

/** 加载动画 */
- (void)statrNetLoadingView {
  if (self.indicctorStopAnmation) {
    self.indicatorStatrAnimation();
  }
  [self.indicatorView startAnimating];
  [NetLoadingWaitView startAnimating];
}

#pragma mark 买入操作 卖出委托下单
- (void)tradeStockActive {
  //得到委托资金
  NSString *frozenFund =
      [NSString stringWithFormat:@"%ld", (long)self.markeFoundsValue];
  NSString *stockCode =
      [NSString stringWithString:self.buySellView.stockCodeTF.text];
  NSString *stockprice =
      [NSString stringWithString:self.buySellView.buyPriceTF.text];
  NSString *stockAmount =
      [NSString stringWithString:self.buySellView.buyAmountTF.text];
  //买入 0 卖出 1
  NSString *tradtype = self.isBuyOrSell ? @"0" : @"0";
  //委托网络访问
  [self tradeEntrust:stockCode
         frozendFund:frozenFund
           TradeType:tradtype
         StockAmount:stockAmount
               Price:stockprice];
}

//买卖委托
- (void)tradeEntrust:(NSString *)stockCode
         frozendFund:(NSString *)frozendFund
           TradeType:(NSString *)tradeType
         StockAmount:(NSString *)stockAmounts
               Price:(NSString *)stockPrice {

  if (stockCode.length == 0 || tradeType.length == 0 ||
      stockAmounts.length == 0 || stockPrice.length == 0)
    return;

  if (![SimuUtil isLogined]) {
    return;
  }

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak BuySellViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    BuySellViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    BuySellViewController *strongSelf = weakSelf;
    if (strongSelf) {
      NSLog(@"买入 卖出 成功");
      [strongSelf bindSimuDoDealSubmitData:(SimuDoDealSubmitData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    NSLog(@"fsfsdfdfs");
    if (obj.status) {
      [NewShowLabel setMessageContent:obj.message];
    }
  };

  if (_stockBuySellType == StockBuySellOrdinaryType) {
    if (self.marketFixedPrice) {
      if (self.isBuyOrSell) {
        //市价 买入
        [SimuDoDealSubmitData
            requestMarketBuyStockMatchID:self.matchId
                           withStockCode:stockCode
                          withFrozenFund:frozendFund
                               withToken:simuBuyQueryData.token
                           withTradeType:tradeType
                            withCallback:callback];
      } else {
        //市价 卖出
        [SimuDoDealSubmitData requestMarketSellMatchID:self.matchId
                                         withStockCode:stockCode
                                            withAmount:stockAmounts
                                             withToken:simuBuyQueryData.token
                                         withTradeType:tradeType
                                          withCallback:callback];
      }
    } else {
      //限价
      if (self.isBuyOrSell) {
        //限价 买入
        [SimuDoDealSubmitData requestBuyStockWithMatchId:self.matchId
                                           withStockCode:stockCode
                                          withStockPrice:stockPrice
                                        withStockAmounts:stockAmounts
                                               withToken:simuBuyQueryData.token
                                            withCallback:callback];
      } else {
        //限价 卖出
        [SimuDoDealSubmitData requestSellWithMatchId:self.matchId
                                       withStockCode:stockCode
                                      withStockPrice:stockPrice
                                    withStockAmounts:stockAmounts
                                           withToken:simuBuyQueryData.token
                                        withCallback:callback];
      }
    }
  } else if (_stockBuySellType == StockBuySellExpentType) {
    //限价 0  市价 1
    NSString *tempCategory = nil;
    NSString *tempFunds = nil;
    NSString *tempStockPrice = nil;
    NSString *tempStockAmount = nil;
    if (self.marketFixedPrice) {
      //市价
      tempCategory = @"1";
      if (self.isBuyOrSell) {
        tempStockAmount = @"0";
        tempFunds = frozendFund;
        tempStockPrice = @"0";
        tempStockAmount = @"0";
      } else {
        tempStockAmount = stockAmounts;
        tempStockPrice = @"0";
      }
    } else {
      tempCategory = @"0";
      if (self.isBuyOrSell) {
        tempFunds = @"0";
        tempStockPrice = stockPrice;
        tempStockAmount = stockAmounts;
      } else {
        tempStockPrice = stockPrice;
        tempStockAmount = stockAmounts;
      }
    }

    if (self.isBuyOrSell) {
      //牛人 买入
      [SimuDoDealSubmitData requestBuyAccountId:self.accountId
                                  withSctokCode:stockCode
                                   withCategory:tempCategory
                                      withPrice:tempStockPrice
                                       withFund:tempFunds
                                     withAmount:tempStockAmount
                                      withToken:simuBuyQueryData.token
                                   withCallback:callback];

    } else {
      //牛人 卖出
      [SimuDoDealSubmitData requestSellAccountId:self.accountId
                                   withSctokCode:stockCode
                                    withCategory:tempCategory
                                       withPrice:tempStockPrice
                                      withAmount:tempStockAmount
                                       withToken:simuBuyQueryData.token
                                    withCallback:callback];
    }
  }
}

//买入或卖出数据绑定
- (void)bindSimuDoDealSubmitData:(SimuDoDealSubmitData *)obj {
  //交易股票信息
  if (_scvc_openingTimeView.sttbv_alarmIV.hidden == NO) {
    NSString *titleBuySell = self.isBuyOrSell ? @"买入" : @"卖出";
    NSString *message = [NSString
        stringWithFormat:@"您的委托\"%@%@"
                         @"\"已提交\n现在休市，要等到开盘后才可能成交哦",
                         titleBuySell, self.buySellView.stockNameTF.text];
    [NewShowLabel setMessageContent:message];
  }
  [self followingTransactionClearsData];
  [[NSNotificationCenter defaultCenter]
      postNotificationName:@"ClearProfitAndStopVCData"
                    object:nil];
  // 3.5寸屏 按钮上移20,按钮缩小
  /*
   CGRect frame = shareBut.frame;
   if (self.view.frame.size.height <= 480) {
   shareBut.frame = CGRectMake(frame.origin.x + 40 , frame.origin.y - 10,
   frame.size.width - 80, frame.size.height -20);
   shareBut.titleLabel.font = [UIFont systemFontOfSize:12];
   }
   */
  //显示分享按钮
  shareBut.hidden = NO;
  if (self.marketFixedPrice) {
    self.marketDealBool = YES;
  } else {
    self.fixedDealBool = YES;
  }
}

/** 看情况 显示分享按钮  */
- (void)showMarketFixedShareButtonWithBool:(BOOL)marketFixed {
  //如果 市价交易成功 点击 限价界面 隐藏分享按钮
  if (marketFixed) {
    //市价界面 有没有成交过
    if (self.marketDealBool) {
      shareBut.hidden = NO;
    } else {
      shareBut.hidden = YES;
    }
  } else {
    if (self.fixedDealBool) {
      shareBut.hidden = NO;
    } else {
      shareBut.hidden = YES;
    }
  }
}

//用当前价格，取得最大可买数量
#pragma mark - 用当前价格，取得最大可买数量
- (void)getamountFromNet:(NSString *)stock_code
                   Pirce:(NSString *)stock_price
                    fund:(NSString *)stock_fund
       withPriceOrAmount:(BOOL)isEnd
    withStockBuySellType:(StockBuySellType)type
           withAccountID:(NSString *)accountId {
  if (![SimuUtil isLogined]) {
    [self stopLoading];
    return;
  }
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak BuySellViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    BuySellViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    BuySellViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSimuBuyQueryData:(SimuTradeBaseData *)obj
                         withBoolIsEnd:isEnd];
    }
  };

  callback.onFailed = ^() {
    [weakSelf setNoNetwork];
  };

  NSString *category = self.marketFixedPrice ? @"1" : @"0";

  if (_stockBuySellType == StockBuySellOrdinaryType) {
    [SimuTradeBaseData requestSimuBuyQueryDataWithMatchId:self.matchId
                                            withStockCode:stock_code
                                           withStockPrice:stock_price
                                            withStockFund:stock_fund
                                             withCallback:callback];
  } else if (_stockBuySellType == StockBuySellExpentType) {
    //牛人
    [SimuTradeBaseData requestExpertPlanBuy:_accountId
                               withCategory:category
                              withStockCode:stock_code
                                  withPrice:stock_price
                                  withFunds:stock_fund
                               withCallback:callback];
  }
}

//绑定可买数据
#pragma mark - 数据绑定 买入初始数据绑定
- (void)bindSimuBuyQueryData:(SimuTradeBaseData *)buyQueryData
               withBoolIsEnd:(BOOL)isEnd {

  simuBuyQueryData = buyQueryData;
  if (isEnd == NO) {
    //股票类型 1 基金 0 股票
    NSString *format = buyQueryData.tradeType == 1 ? @"%.3f" : @"%.2f";
    //股票价格
    NSString *price = [NSString stringWithFormat:format, buyQueryData.buyPrice];
    self.buySellView.buyPriceTF.text = price;
    return;
  }

  //股票类型 1 基金 0 股票
  NSString *format = buyQueryData.tradeType == 1 ? @"%.3f" : @"%.2f";
  //股票价格
  NSString *price = [NSString stringWithFormat:format, buyQueryData.buyPrice];
  NSArray *array = @[
    buyQueryData.stockCode,
    buyQueryData.stockName,
    price,
    buyQueryData.maxBuy
  ];
  [self.buySellView bindData:array];

  //最新价格
  scv_lastprice = buyQueryData.newstockPrice;
  //最大可买数
  //_scv_stockAmoutTextField.text = buyQueryData.maxBuy;
  //可用资金
  scv_buystockNumber = buyQueryData.fundsable;

  if (scv_littleSliderView) {
    if ([buyQueryData.maxBuy longLongValue] >= 100) {
      //资金足够买100股
      scv_littleSliderView.minimumValue = 1;
      scv_littleSliderView.maximumValue =
          [buyQueryData.maxBuy longLongValue] / 100;
      //初始化赋值
      scv_littleSliderView.value = [buyQueryData.maxBuy longLongValue] / 100;

      CGPoint centerPos;
      if (scv_littleSliderView.value > 1) {
        centerPos = CGPointMake(16 +
                                    200 * (scv_littleSliderView.value /
                                           scv_littleSliderView.maximumValue),
                                _scv_foundsLB.center.y);
      } else {
        centerPos = CGPointMake(45, _scv_foundsLB.center.y);
      }

      if (centerPos.x < 46) {
        centerPos.x = 46;
        _scv_foundsLB.textAlignment = NSTextAlignmentLeft;
      } else if (centerPos.x > 186) {
        centerPos.x = 186;
        _scv_foundsLB.textAlignment = NSTextAlignmentRight;
      } else {
        _scv_foundsLB.textAlignment = NSTextAlignmentCenter;
      }
      _scv_foundsLB.center = centerPos;
      //记录数据
      //限价数据
      self.fixedFoundsValue = (long)
          [self transactionCostsCalculated:[buyQueryData.maxBuy longLongValue]];
      if (buyQueryData.fundsable == 0) {
        _scv_foundsLB.hidden = YES;
      }
      self.markeFoundsValue =
          [self marketFoundsNewPriceTransactionCostrCalcuated:
                    [buyQueryData.maxBuy longLongValue]];
      if (self.markeFoundsValue >= buyQueryData.fundsable) {
        self.markeFoundsValue = buyQueryData.fundsable;
      }
      _scv_foundsLB.hidden = NO;
      if (self.marketFixedPrice) {
        _scv_foundsLB.text =
            [NSString stringWithFormat:@"¥ %ld", (long)self.markeFoundsValue];
      } else {
        _scv_foundsLB.text =
            [NSString stringWithFormat:@"¥ %ld", (long)self.fixedFoundsValue];
      }

    } else {
      //当可买数量 不足100股时
      [self whenNumberBuyIsInsufficient];
      if ([buyQueryData.maxBuy isEqualToString:@"0"]) {
        self.fixedFoundsValue = [self
            transactionCostsCalculated:[buyQueryData.maxBuy longLongValue]];
        self.markeFoundsValue = (int)buyQueryData.fundsable;
      }
      //赋值
      _scv_foundsLB.hidden = NO;
      if (self.marketFixedPrice) {
        _scv_foundsLB.text =
            [NSString stringWithFormat:@"¥ %d", (int)buyQueryData.fundsable];
      } else {
        _scv_foundsLB.text =
            [NSString stringWithFormat:@"¥ %ld", (long)self.fixedFoundsValue];
      }
    }
  }

  self.marketDealBool = NO;
  self.fixedDealBool = NO;
  shareBut.hidden = YES;

  if (scv_moneySelView) {
    //刷新 资金点击控件
    [scv_moneySelView setTotolMoney:scv_buystockNumber];
  }
  if (scv_stockInfoView) {
    //给下面的stock信息赋值
    [scv_stockInfoView setUserPageData:simuBuyQueryData isBuy:YES];
  }
}

#pragma mark
#pragma mark SimTopBannerViewDelegate
//左边按钮按下
- (void)leftButtonPress {
  self.buySellView.stockCodeTF.delegate = nil;
  self.buySellView.stockNameTF.delegate = nil;
  [self.buySellView.buyPriceTF resignFirstResponder];
  [self.buySellView.buyAmountTF resignFirstResponder];
  shareBut.hidden = YES;
  [_scvc_openingTimeView timeVisible:NO];
  self.buySellView.buyAmountTF.delegate = self;
  self.buySellView.buyPriceTF.delegate = self;
}

#pragma mark - 资金选择按钮按下
#pragma mark simuselMonyButDelegate
- (void)moneyButtonPressDown:(NSInteger)index {
  self.moneyButton = YES;
  NSInteger funds = 0;
  if (index == 0) {
    if (scv_littleSliderView) {

      funds = 20000;
    }
  } else if (index == 1) {
    if (scv_littleSliderView) {
      funds = 50000;
    }
  } else if (index == 2) {
    if (scv_littleSliderView) {
      funds = 100000;
    }
  } else if (index == 3) {
    if (scv_littleSliderView) {
      funds = 200000;
    }
  }
  //记录原始数值
  self.markeFoundsValue = funds;
  NSString *stringFunds = [NSString stringWithFormat:@"%ld", (long)funds];
  NSString *price =
      self.marketFixedPrice ? @"" : self.buySellView.buyPriceTF.text;
  //调接口 查询最大可买数
  if (!self.marketFixedPrice) {
    [self statrNetLoadingView];
    [self getMaxAmountWithStockCode:self.buySellView.stockCodeTF.text
                        withMatchID:self.matchId
                          withPrice:price
                          withFunds:stringFunds];
  }
  // value 即可买股票的最大数量除以100
  scv_littleSliderView.value =
      (NSInteger)[self amountCalculatedByNumberSharesToBuy:funds] / 100;
  CGFloat value = scv_littleSliderView.value;
  CGFloat maxvalue = scv_littleSliderView.maximumValue;
  if (maxvalue == 0) {
    maxvalue = 1;
  }
  //设置滑块和资金标签
  //记录原始数值
  self.markeFoundsValue = funds;
  //记录计算后的数值
  self.fixedFoundsValue =
      [self transactionCostsCalculated:(NSInteger)value * 100];
  //如果是市价
  if (self.marketFixedPrice) {
    _scv_foundsLB.text =
        [NSString stringWithFormat:@"¥ %ld", (long)self.markeFoundsValue];
  }
  self.buySellView.buyAmountTF.text =
      [NSString stringWithFormat:@"%ld", (long)value * 100];
  CGPoint centerPos =
      CGPointMake(16 + 200 * (value / maxvalue), _scv_foundsLB.center.y);
  if (centerPos.x < 16 + 30) {
    centerPos.x = 16 + 30;
    _scv_foundsLB.textAlignment = NSTextAlignmentLeft;
  } else if (centerPos.x > 16 + 200 - 30) {
    centerPos.x = 16 + 200 - 30;
    _scv_foundsLB.textAlignment = NSTextAlignmentRight;
  } else {
    _scv_foundsLB.textAlignment = NSTextAlignmentCenter;
  }
  _scv_foundsLB.center = centerPos;
}

#pragma mark-- 点击资金button 时请求接口 查询最大可买数量
- (void)getMaxAmountWithStockCode:(NSString *)stockCode
                      withMatchID:(NSString *)mathcID
                        withPrice:(NSString *)price
                        withFunds:(NSString *)fund {
  if (![SimuUtil isLogined]) {
    [self stopLoading];
    return;
  }
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak BuySellViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    BuySellViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    BuySellViewController *strongSelf = weakSelf;
    if (strongSelf) {
      //请求成功
      [strongSelf maximunValueFromTheNewAaaignment:(SimuTradeBaseData *)obj];
    }
  };

  callback.onFailed = ^() {
    [weakSelf setNoNetwork];
  };
  [SimuTradeBaseData requestSimuBuyQueryDataWithMatchId:mathcID
                                          withStockCode:stockCode
                                         withStockPrice:price
                                          withStockFund:fund
                                           withCallback:callback];
}
//得到服务端数据 从新赋值
- (void)maximunValueFromTheNewAaaignment:(SimuTradeBaseData *)obj {
  simuBuyQueryData = obj;
  //给滑块赋值
  simuBuyQueryData = obj;
  CGFloat maxvalue = scv_littleSliderView.maximumValue;
  scv_littleSliderView.value = obj.stockamount / 100;
  CGPoint centerPoint =
      CGPointMake(16 + 200 * (scv_littleSliderView.value / maxvalue),
                  _scv_foundsLB.center.y);
  if (centerPoint.x < 46) {
    centerPoint.x = 46;
    _scv_foundsLB.textAlignment = NSTextAlignmentLeft;
  } else if (centerPoint.x > 186) {
    centerPoint.x = 186;
    _scv_foundsLB.textAlignment = NSTextAlignmentRight;
  } else {
    _scv_foundsLB.textAlignment = NSTextAlignmentCenter;
  }
  //股票数量
  self.buySellView.buyAmountTF.text =
      [NSString stringWithFormat:@"%ld", (long)obj.stockamount];
  self.fixedFoundsValue = [self
      transactionCostsCalculated:(NSInteger)scv_littleSliderView.value * 100];
  _scv_foundsLB.text =
      [NSString stringWithFormat:@"¥ %ld", (long)self.fixedFoundsValue];
  _scv_foundsLB.center = centerPoint;
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {

  if (buttonIndex == 1) {
    //加入阻塞
    if (![NetLoadingWaitView isAnimating]) {
      [NetLoadingWaitView startAnimating];
    }
    //确定
    [self.buySellView.buyPriceTF resignFirstResponder];
    [self.buySellView.buyAmountTF resignFirstResponder];
    [self tradeStockActive];
  } else {
    //取消
  }
}

#pragma mark
#pragma mark 普通函数
//判断输入的价格是否在正确的价格区间
- (BOOL)reasonablePrice:(NSString *)priceStr {
  NSString *content;
  CGFloat lowPrice = 0.0f;
  CGFloat highPrice = 0.0f;
  CGFloat inputPrice = [priceStr doubleValue];
  if (simuBuyQueryData) {
    lowPrice = simuBuyQueryData.downlimitedPrice;
    highPrice = simuBuyQueryData.uplimitedPrice;
  }
  if (inputPrice < lowPrice || inputPrice > highPrice) {
    NSString *format =
        [StockUtil getPriceFormatWithTradeType:simuBuyQueryData.tradeType];
    content = [NSString
        stringWithFormat:
            @"买入价格只能在%@元和%@元之间，请重新输入",
            [NSString stringWithFormat:format, lowPrice],
            [NSString stringWithFormat:format, highPrice]];
    if (![self.buySellView.stockCodeTF.text isEqualToString:@""] &&
        self.buySellView.stockCodeTF.text.length > 0) {
      [self alertShow:content];
    } else {
      [self alertShow:@"请先输入股票代码！"];
    }
    return NO;
  }
  return YES;
}

- (void)alertShow:(NSString *)message {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                  message:message
                                                 delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
  [alert show];
}
//创建警告框
- (void)creatAlartView:(NSString *)showcontent {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                  message:showcontent
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确定", nil];
  [alert show];
}

#pragma mark 刷新
#pragma mark-------SimuIndicatorDelegate-----------
- (void)refreshButtonPressDown {
  shareBut.hidden = YES;
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  if (self.buySellView.stockCodeTF.text == nil ||
      self.buySellView.stockCodeTF.text.length == 0) {
    //    //弹出提示没有选择股票
    //    [NewShowLabel setMessageContent:@"请输入股票代码"];
    if (self.indicatorStatrAnimation) {
      self.indicctorStopAnmation();
    }
    return;
  }
  if (self.indicctorStopAnmation) {
    self.indicatorStatrAnimation();
  }

  if (self.isBuyOrSell) {
    [self refreshFundSelectionButton];
    [self getamountFromNet:self.buySellView.stockCodeTF.text
                       Pirce:@""
                        fund:@"0"
           withPriceOrAmount:YES
        withStockBuySellType:_stockBuySellType
               withAccountID:_accountId];
  } else {
    self.sellMarketFiexdBool = NO;
    [self querySellInfoWidthStockCode:self.buySellView.stockCodeTF.text
                    withPriceOrAmount:YES
                        withAccountId:_accountId];
  }
}

#pragma mark--  卖出界面 切换市价限价 进行价格刷新
- (void)refreshPriceForFixedSell {
  self.sellMarketFiexdBool = YES;
  if (self.indicctorStopAnmation) {
    self.indicatorStatrAnimation();
  }
  if (self.isBuyOrSell) {
    //[self getamountFromNet:self.buySellView.stockCodeTF.text Pirce:@""
    // fund:@"0"];
  } else {
    [self querySellInfoWidthStockCode:self.buySellView.stockCodeTF.text
                    withPriceOrAmount:YES
                        withAccountId:_accountId];
  }
}
#pragma mark 对外接口
- (void)reset {
  //记录交易的股票信息
  self.tempStockCode = self.buySellView.stockCodeTF.text;
  self.tempStockName = self.buySellView.stockNameTF.text;
  self.tempStockNumber = self.buySellView.buyAmountTF.text;

  //清空股票名称和股票价格 数量等
  [self.buySellView clearData];

  if (scv_stockInfoView) {
    [scv_stockInfoView clearControlData];
  }
  if (scv_moneySelView) {
    [scv_moneySelView clearAllData];
  }
}
//滑块数据初始化
- (void)sliderDataInitialization {
  scv_littleSliderView.minimumValue = 0;
  scv_littleSliderView.maximumValue = 0;
  scv_littleSliderView.value = 0;
  scv_lastprice = 0.0;
  scv_buystockNumber = 0;
  _scv_foundsLB.text = @"¥ 0";
  CGPoint centerPos = CGPointMake(16 + 30, _scv_foundsLB.center.y);
  _scv_foundsLB.center = centerPos;
  _scv_foundsLB.hidden = YES;
  [scv_moneySelView clearAllData];
}

- (void)whenNumberBuyIsInsufficient {
  scv_littleSliderView.minimumValue = 0;
  scv_littleSliderView.maximumValue = 0;
  scv_littleSliderView.value = 0;
  scv_lastprice = 0.0;
  scv_buystockNumber = 0;
  CGPoint centerPos = CGPointMake(16 + 30, _scv_foundsLB.center.y);
  _scv_foundsLB.center = centerPos;
  if (centerPos.x == 46) {
    _scv_foundsLB.textAlignment = NSTextAlignmentLeft;
  }
  [scv_moneySelView clearAllData];
}

#pragma mark-- 限价 交易费用 最新价+手续费
/** 交易费用计算 按照 限价时计算  最新价格+手续费  */
- (NSInteger)transactionCostsCalculated:(NSInteger)number {
  NSString *stockPrice = self.buySellView.buyPriceTF.text;
  CGFloat amountInt =
      ([stockPrice floatValue] * number * simuBuyQueryData.feeRateInt) / 10000;
  if (amountInt < simuBuyQueryData.minFee) {
    amountInt = simuBuyQueryData.minFee;
  }

  if (number) {
    return amountInt + [stockPrice floatValue] * number + 0.5;
  } else {
    return 0;
  }
}

#pragma mark - 市价 交易费用 涨停价+手续费
/** 在市价时计算 价格 按照涨停价 计算 */
- (NSInteger)marketFoundsNewPriceTransactionCostrCalcuated:(NSInteger)num {
  //拿到涨停价
  //股票类型 1 基金 0 股票
  NSString *format = simuBuyQueryData.tradeType == 1 ? @"%.3f" : @"%.2f";
  NSString *stockPrice =
      [NSString stringWithFormat:format, simuBuyQueryData.uplimitedPrice];
  CGFloat amountInt =
      ([stockPrice floatValue] * num * simuBuyQueryData.feeRateInt) / 10000;
  if (amountInt < simuBuyQueryData.minFee) {
    amountInt = simuBuyQueryData.minFee;
  }
  if (num) {
    return amountInt + [stockPrice floatValue] * num + 0.5;
  } else {
    return 0;
  }
}

//通过金额计算可买股数
- (NSInteger)amountCalculatedByNumberSharesToBuy:(NSInteger)funds {
  //价格
  NSString *stockPrice = self.buySellView.buyPriceTF.text;
  NSInteger number = 0;
  number =
      (10000 * funds) / ([stockPrice floatValue] * simuBuyQueryData.feeRateInt +
                         10000 * [stockPrice floatValue]);
  return number;
}
//交易成功后清空数据
- (void)followingTransactionClearsData {
  [self reset];
  simuBuyQueryData.stockCode = @"";
  simuBuyQueryData.stockName = @"";
  simuBuyQueryData.openPrice = 0.f;
  simuBuyQueryData.closePrice = 0.f;
  simuBuyQueryData.newstockPrice = 0.f;
  simuBuyQueryData.highestPrice = 0.f;
  simuBuyQueryData.lowestPrice = 0.f;
  simuBuyQueryData.uplimitedPrice = 0.f;
  simuBuyQueryData.downlimitedPrice = 0.f;
  simuBuyQueryData.fundsable = 0.f;
  simuBuyQueryData.commission = @"";
  simuBuyQueryData.holdstock = @"";
  simuBuyQueryData.feeRateInt = 0;
  simuBuyQueryData.maxBuy = @"";
  simuBuyQueryData.minFee = 0.f;
  simuBuyQueryData.buyPrice = 0.f;
  simuBuyQueryData.token = @"";

  scv_lastprice = 0.0;
  scv_buystockNumber = 0;

  scv_littleSliderView.minimumValue = 0;
  scv_littleSliderView.maximumValue = 0;
  scv_littleSliderView.value = 0;
  CGPoint centerPos = CGPointMake(16 + 30, _scv_foundsLB.center.y);
  _scv_foundsLB.center = centerPos;
  _scv_foundsLB.hidden = YES;

  _scv_minNumber.text = @"0";
  _scv_maxNumber.text = @"0";

  //  self.tempStockName = nil;
  //  self.tempStockCode = nil;

  //情况数据
  self.markeFoundsValue = 0;
  self.fixedFoundsValue = 0;
}
@end
