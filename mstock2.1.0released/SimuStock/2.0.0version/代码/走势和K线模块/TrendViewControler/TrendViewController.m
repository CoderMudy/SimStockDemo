//
//  TrendViewController.m
//  SimuStock
//
//  Created by Mac on 13-9-27.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "TrendViewController.h"

#import "simuBottomTrendBarView.h"

// lq
#import "MakingScreenShot.h"
#import "MakingShareAction.h"
#import "StockDBManager.h"

#import "SpecilStockViewController.h"
#import "StockAlarmNotification.h"

@interface TrendViewController () {
  //工具栏下面的选择Tab
  simuTabSelView *topTabButtons;

  //底部的选择ToolBar
  simuBottomTrendBarView *bottomToolBarView;

  StockAlarmNotification *stockAlarmNotification;

  NSArray *titlesForIndex;
  NSDictionary *tabIndexToPageTypeMapForIndex;
  NSArray *titlesForStockFund;
  NSDictionary *tabIndexToPageTypeMapForStockFund;
}

@end

@implementation TrendViewController

- (id)initWithStockCode:(NSString *)stockCode
          withStockName:(NSString *)stockName
            withMarchId:(NSString *)stockMarchId
             withIsFirm:(BOOL)isfirm {
  if (self = [super init]) {
    self.stockCode = stockCode;
    self.stockName = stockName ? stockName : @"";
    self.marchId = stockMarchId;
    [self addObserver];

    tvc_isAnimationRun = NO;
    tvc_corpagetype = TPT_Trend_Mode;
    self.isFirm = isfirm;
  }
  return self;
}

- (void)addObserver {
  __weak TrendViewController *weakSelf = self;

  stockAlarmNotification = [[StockAlarmNotification alloc] init];
  stockAlarmNotification.onAddStockAlarm = ^(NSString *stockCode) {
    if ([stockCode isEqualToString:weakSelf.stockCode]) {
      [weakSelf resetAlarmWithAddOperation];
    }
  };
  stockAlarmNotification.onRemoveStockAlarm = ^(NSString *stockCode) {
    if ([stockCode isEqualToString:weakSelf.stockCode]) {
      [weakSelf resetAlarmWithRemoveOperation];
    }
  };
}

- (void)resetAlarmWithAddOperation {
  [bottomToolBarView resetSelfStockState:NO andSelfStockAlarmState:YES];
}
- (void)resetAlarmWithRemoveOperation {
  [bottomToolBarView resetSelfStockAlarmState:NO];
}

- (id)initWithStockCode:(NSString *)stockCode
          withStockName:(NSString *)stockName
          withFirstType:(NSString *)firstType
            withMarchId:(NSString *)stockMarchId
          withStartPage:(Trend_Page_Type)pageType {
  if (self = [super init]) {
    self.stockCode = stockCode;
    self.stockName = stockName ? stockName : @"";
    self.marchId = stockMarchId;
    [self addObserver];
    [self setFirstType:firstType];

    tvc_isAnimationRun = NO;
    tvc_corpagetype = pageType;
  }
  return self;
}

- (void)setFirstType:(NSString *)firstType {
  if (firstType == nil || [FIRST_TYPE_UNSPEC isEqualToString:firstType]) {
    NSArray *array;
    //通过8位股票代码查询
    if ([_stockCode length] == 8) {
      array = [StockDBManager searchFromDataBaseWith8CharCode:_stockCode
                                            withRealTradeFlag:YES];
    }
    //通过股票名称查询
    if (array == nil || [array count] == 0) {
      array = [StockDBManager searchFromDataBaseWithName:_stockName
                                       withRealTradeFlag:YES];
    }
    //通过股票代码片段查询，可能会出现混淆的情况
    if (array == nil || [array count] == 0) {
      array = [StockDBManager searchStockWithQueryText:_stockCode
                                     withRealTradeFlag:YES];
    }
    if (array && [array count] > 0) {
      StockFunds *stock = array[0];
      _firstType = [stock.firstType stringValue];
      _stockCode = stock.code;
    } else {
      //找不到,置为未指定
      _firstType = FIRST_TYPE_UNSPEC;
    }
  } else {
    _firstType = firstType;
  }
}

- (void)viewDidLoad {
  titlesForIndex = @[ @"行情", @"资讯" ];
  titlesForStockFund = @[
    @"行情",
    @"资讯",
    @"牛人",
    @"F10资料", //
    @"聊股"
  ];
  tabIndexToPageTypeMapForIndex = @{
    @0 : @(TPT_Trend_Mode),
    @1 : @(TPT_Info_Mode)
  };
  tabIndexToPageTypeMapForStockFund = @{
    @0 : @(TPT_Trend_Mode),
    @1 : @(TPT_Info_Mode),
    @2 : @(TPT_Superman_Mode),
    @3 : @(TPT_F10_Mode),
    @4 : @(TPT_WB_Mode)
  };

  [super viewDidLoad];

  //分享控件lq
  [self createShareControl];
  [self creatTabSelView];
  [self creatBotomToolBarView];
  [self creatBaseView];
  [self creatScrolView];

  NSInteger tabIndex = [self tabIndexForPageType:tvc_corpagetype];
  [topTabButtons buttonSelectedAtIndex:tabIndex animation:NO];

  [tvc_scrollView
      setContentOffset:CGPointMake(tabIndex * tvc_baseView.bounds.size.width, 0)
              animated:NO];

  [self performSelector:@selector(resetBottomButonState)
             withObject:nil
             afterDelay:0.2];
}

#pragma mark
#pragma mark------分享控件-------
// lq分享控件
- (void)createShareControl {
  CGRect frame = self.view.frame;
  shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
  shareButton.frame = CGRectMake(frame.size.width - 80, startY, 40, 45);
  UIImage *shareImage = [UIImage imageNamed:@"分享.png"];
  [shareButton setImage:shareImage forState:UIControlStateNormal];
  [shareButton setImage:shareImage forState:UIControlStateHighlighted];
  [shareButton setBackgroundImage:nil forState:UIControlStateNormal];
  //按钮选中中视图
  UIImage *selectedCenterImage = [[UIImage imageNamed:@"return_touch_down.png"]
      resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 14, 14)];
  [shareButton setBackgroundImage:selectedCenterImage
                         forState:UIControlStateHighlighted];
  [shareButton addTarget:self
                  action:@selector(shareTrendInfo:)
        forControlEvents:UIControlEventTouchUpInside];
  [_topToolBar addSubview:shareButton];
}

- (void)shareTrendInfo:(id)sender {

  //截屏
  UIView *tempScr = [securitiesCurStatusVC curStatusViewForShare];
  if (tempScr == nil) {
    return;
  }
  MakingScreenShot *makingScreenShot = [[MakingScreenShot alloc] init];
  //分享
  UIImage *shareImage = [makingScreenShot
      makingScreenShotWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,
                                           350)
                       withView:tempScr
                       withType:MakingScreenShotType_TrendPage_Half];
  //分享到微信的截屏，小屏
  //截屏
  MakingScreenShot *makingSmallScreenShot = [[MakingScreenShot alloc] init];
  //分享
  UIImage *otherImage = [makingSmallScreenShot
      makingScreenShotWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,
                                           350)
                       withView:tempScr
                       withType:
                           MakingScreenShotType_TrendPage_Half]; // 45+56=101+32=133
  if (shareImage) {
    //图片截取成功，做分享
    MakingShareAction *shareAction = [[MakingShareAction alloc] init];
    shareAction.shareModuleType = ShareModuleTypeMarket;
    shareAction.shareStockCode = self.stockCode;
    [shareAction
            shareTitle:[NSString stringWithFormat:@"%@(%@)", self.stockName,
                                                  [self.stockCode
                                                      substringFromIndex:2]]
               content:[NSString stringWithFormat:
                                     @"#优顾炒股# %@(%@)行情 "
                                     @"%@/wap/quote.shtml?stockcode=%@ "
                                     @"(分享自@优顾炒股官方)",
                                     self.stockName,
                                     [self.stockCode substringFromIndex:2],
                                     wap_address, self.stockCode]
                 image:shareImage
        withOtherImage:otherImage
          withShareUrl:[NSString
                           stringWithFormat:@"%@/wap/quote.shtml?stockcode=%@",
                                            wap_address, self.stockCode]
         withOtherInfo:[NSString
                           stringWithFormat:@"涨跌幅：%@\n最新价：%@",
                                            [securitiesCurStatusVC riseRate],
                                            [securitiesCurStatusVC curPrice]]];
  }
}
#pragma mark
#pragma mark 对外接口
- (NSString *)getMartchId {
  return self.marchId;
}

#pragma mark
#pragma mark----SimuIndicatorDelegate----
- (void)refreshButtonPressDown {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }

  [_indicatorView startAnimating];
  _littleCattleView.hidden = YES;
  if (tvc_stockInformationVC && tvc_corpagetype == TPT_Info_Mode) {
    //资讯刷新
    [tvc_stockInformationVC refresh];
  } else if (tvc_FTenDataVC && tvc_corpagetype == TPT_F10_Mode) {
    // f10刷新
    [tvc_FTenDataVC FTenRefresh];
  } else if (sameStockSupermanVC && tvc_corpagetype == TPT_Superman_Mode) {
    [sameStockSupermanVC refresh];
  } else if (securitiesCurStatusVC && tvc_corpagetype == TPT_Trend_Mode) {
    //走势刷新
    [securitiesCurStatusVC refreshSecuritesData];
  } else {
    //聊股刷新
    [_weiboViewController refreshButtonPressDown];
  }
}

//切换页面动画
- (void)viewChangeWithLayerAnimate:(UIView *)baseView
                        RemoveView:(UIView *)removeView
                           AddView:(UIView *)addView {
  if (baseView == nil)
    return;

  if (addView == nil)
    return;

  CATransition *animation = [CATransition animation];
  animation.delegate = self;
  animation.duration = 0.5;
  animation.timingFunction = [CAMediaTimingFunction
      functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  // animation.type =@"rippleEffect";
  if (removeView.tag < addView.tag) {
    animation.subtype = kCATransitionFromRight;
  } else {
    animation.subtype = kCATransitionFromLeft;
  }

  [baseView addSubview:addView];

  [[baseView layer] addAnimation:animation forKey:@"animation"];

  tvc_corActiveView = tvc_newButNotActiveView;
  tvc_isAnimationRun = NO;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  //当前正在展示的视图更新
  tvc_corActiveView = tvc_newButNotActiveView;
  tvc_isAnimationRun = NO;
}

#pragma mark
#pragma mark 2.1.0函数
//创建滑动页面
- (void)creatScrolView {
  if (nil == tvc_scrollView) {
    tvc_scrollView = [[UIScrollView alloc] initWithFrame:tvc_baseView.bounds];
    tvc_scrollView.pagingEnabled = YES;
    tvc_scrollView.bounces = NO;
    tvc_scrollView.showsHorizontalScrollIndicator = NO;
    tvc_scrollView.contentSize =
        CGSizeMake(tvc_baseView.bounds.size.width * [self.titlesArray count],
                   tvc_baseView.bounds.size.height);
    tvc_scrollView.backgroundColor = [UIColor clearColor];
    tvc_scrollView.delegate = self;
    [tvc_baseView addSubview:tvc_scrollView];
  }
}

- (void)resetContentWithStockName:(NSString *)stockName
                    withStockCode:(NSString *)stockCode {

  [_topToolBar resetContentAndFlage:@"" Mode:TTBM_Mode_Leveltwo];
  if (sbv_nameLable == nil) {
    //创建股票名称标签
    sbv_nameLable = [[UILabel alloc]
        initWithFrame:CGRectMake((WIDTH_OF_SCREEN - 180) / 2,
                                 _topToolBar.bounds.size.height - 45, 180,
                                 45 / 2)];
    sbv_nameLable.font = [UIFont systemFontOfSize:15];
    sbv_nameLable.textAlignment = NSTextAlignmentCenter;
    sbv_nameLable.textColor = [UIColor whiteColor];
    sbv_nameLable.backgroundColor = [UIColor clearColor];
    [_topToolBar addSubview:sbv_nameLable];
  }
  if (sbv_codeLable == nil) {
    //创建股票代码标签
    sbv_codeLable = [[UILabel alloc]
        initWithFrame:CGRectMake((WIDTH_OF_SCREEN - 180) / 2,
                                 _topToolBar.bounds.size.height - 45 + 45 / 2,
                                 180, 45 / 2)];
    sbv_codeLable.textColor = [UIColor whiteColor];
    sbv_codeLable.backgroundColor = [UIColor clearColor];
    sbv_codeLable.textAlignment = NSTextAlignmentCenter;
    sbv_codeLable.font = [UIFont systemFontOfSize:15];
    [_topToolBar addSubview:sbv_codeLable];
  }
  sbv_nameLable.text = stockName;
  sbv_codeLable.text = stockCode;
}
// tab选择页面创建
- (void)creatTabSelView {
  topTabButtons = [[simuTabSelView alloc]
      initWithFrame:CGRectMake(0, _topToolBar.bounds.size.height,
                               self.view.bounds.size.width, 34)
         titleArray:[self titlesArray]];
  __weak TrendViewController *weakSelf = self;
  topTabButtons.tabSelectedAtIndex = ^(NSInteger index) {
    [weakSelf setSelectedTab:index];
  };
  [self.view addSubview:topTabButtons];
}

- (void)setSelectedTab:(NSInteger)index {
  Trend_Page_Type pageType = [self pageTypeAtTabIndex:index];
  tvc_corpagetype = pageType;

  if (pageType == TPT_Trend_Mode) {
    //创建股票行情走势K线页面，必须先创建
    [self creatOrActiveKLineVC];
    shareButton.hidden = NO;
  } else if (pageType == TPT_Info_Mode) {
    shareButton.hidden = YES;
    [self creatStockInformationVC];
  } else if (pageType == TPT_Superman_Mode) {
    shareButton.hidden = YES;
    [self createSameStockHeroVC];
  } else if (pageType == TPT_F10_Mode) {
    shareButton.hidden = YES;
    [self creatFTenDataVC];
  } else if (pageType == TPT_WB_Mode) {
    shareButton.hidden = YES;
    [self creatWeiboVC];
  }

  [self resetTopToolBarConten];
}

//创建底部控件
- (void)creatBotomToolBarView {
  bottomToolBarView = [[simuBottomTrendBarView alloc]
      initWithFrame:CGRectMake(0, self.view.bounds.size.height - 45,
                               self.view.bounds.size.width, 45)
        withMatchId:self.marchId
      withFirstType:self.firstType
          andisFirm:self.isFirm];
  bottomToolBarView.delegate = self;
  [self.view addSubview:bottomToolBarView];

  [bottomToolBarView setAllButtonArray];
}

#pragma mark - (YL)点击发布聊股
- (void)distributeVC {
  [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL
                                                                    isLogined) {
    ///发布聊股
    SpecilStockViewController *specilStockVC =
        [[SpecilStockViewController alloc]
                initWithStockCode:_stockCode
                    withStockName:_stockName
            withFadeWeiboCallBack:^(TweetListItem *obj) {
              if (_weiboViewController) {
                [_weiboViewController disVC_data:obj];
              }
            }];

    [self.navigationController pushViewController:specilStockVC animated:YES];
  }];
}

//创建承载页面
- (void)creatBaseView {
  //承载控件
  tvc_baseRect = CGRectMake(
      0, _topToolBar.bounds.size.height + topTabButtons.bounds.size.height,
      self.view.bounds.size.width,
      self.view.bounds.size.height - _topToolBar.bounds.size.height -
          topTabButtons.bounds.size.height -
          bottomToolBarView.bounds.size.height);
  tvc_baseView = [[UIView alloc] initWithFrame:tvc_baseRect];
  [self.view addSubview:tvc_baseView];
}

//创建走势和K线页面,并激活
- (void)creatOrActiveKLineVC {
  __weak TrendViewController *weakSelf = self;
  SecuritiesInfo *info = [[SecuritiesInfo alloc] init];
  info.securitiesCode = ^{
    return weakSelf.stockCode;
  };
  info.securitiesFirstType = ^{
    return weakSelf.firstType;
  };
  info.securitiesName = ^{
    return weakSelf.stockName;
  };
  if (securitiesCurStatusVC == Nil) {
    securitiesCurStatusVC =
        [[SecuritiesCurStatusVC alloc] initWithFrame:tvc_baseView.bounds
                                  withSecuritiesInfo:info];
    smvc_fromViewController = securitiesCurStatusVC;
  }
  //从其他分页进入时刷新股票价格和涨幅
  securitiesCurStatusVC.onDataReadyCallBack = ^() {
    [weakSelf resetTopToolBarConten];
  };
  securitiesCurStatusVC.beginRefreshCallBack = ^() {
    [weakSelf.indicatorView startAnimating];
  };
  securitiesCurStatusVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };

  securitiesCurStatusVC.view.frame = tvc_baseView.bounds;
  securitiesCurStatusVC.view.tag = 0;

  [tvc_scrollView addSubview:securitiesCurStatusVC.view];
  [self addChildViewController:securitiesCurStatusVC];
  [tvc_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

//创建资讯页面,并激活
- (void)creatStockInformationVC {
  if (tvc_stockInformationVC == nil) {
    tvc_stockInformationVC =
        [[StockInformationViewController alloc] initWithCode:self.stockCode
                                                        name:self.stockName
                                                  controller:self
                                                   firstType:self.firstType];
    tvc_stockInformationVC.view.frame = CGRectMake(
        tvc_baseView.bounds.origin.x + tvc_baseView.bounds.size.width,
        tvc_baseView.bounds.origin.y, tvc_baseView.bounds.size.width,
        tvc_baseView.bounds.size.height);
    [tvc_stockInformationVC interfaceSwitchingTriggerLoadIndicator];
    [tvc_scrollView addSubview:tvc_stockInformationVC.view];
  } else {
    //资讯
    if (tvc_stockInformationVC) {
      [tvc_stockInformationVC stockInformationCode:self.stockCode
                                              name:self.stockName
                                         firstType:self.firstType];
    }
  }
  [tvc_scrollView
      setContentOffset:CGPointMake(tvc_baseView.bounds.size.width, 0)
              animated:YES];
}

- (void)createSameStockHeroVC {
  if (sameStockSupermanVC == nil) {
    CGRect frame = CGRectMake(
        tvc_baseView.bounds.origin.x + 2 * tvc_baseView.bounds.size.width,
        tvc_baseView.bounds.origin.y, tvc_baseView.bounds.size.width,
        tvc_baseView.bounds.size.height);
    sameStockSupermanVC =
        [[SameStockHeroMainViewController alloc] initWithFrame:frame
                                                 withStockCode:self.stockCode
                                                     firstType:_firstType];
    __weak TrendViewController *weakSelf = self;
    sameStockSupermanVC.beginRefreshCallBack = ^{
      [weakSelf.indicatorView startAnimating];
    };
    sameStockSupermanVC.endRefreshCallBack = ^{
      [weakSelf.indicatorView stopAnimating];
    };
    [tvc_scrollView addSubview:sameStockSupermanVC.view];
  } else {
    if (sameStockSupermanVC) {
      [sameStockSupermanVC resetStockCode:self.stockCode firstType:_firstType];
    }
  }
  [tvc_scrollView
      setContentOffset:CGPointMake(2.f * tvc_baseView.bounds.size.width, 0)
              animated:YES];
}
//创建F10页面,并激活
- (void)creatFTenDataVC {
  if (tvc_FTenDataVC == nil) {
    tvc_FTenDataVC = [[FTenDataViewController alloc] initCode:self.stockCode
                                                         name:self.stockName
                                                   controller:self
                                                    firstType:self.firstType];

    tvc_FTenDataVC.view.frame = CGRectMake(
        tvc_baseView.bounds.origin.x + 3 * tvc_baseView.bounds.size.width,
        tvc_baseView.bounds.origin.y, tvc_baseView.bounds.size.width,
        tvc_baseView.bounds.size.height);
    [tvc_FTenDataVC interfaceSwitchingTriggerLoadIndicator];
    [tvc_scrollView addSubview:tvc_FTenDataVC.view];
  } else {
    // F10
    if (tvc_FTenDataVC) {
      NSLog(@"tvc_baseView.bounds.size.height:%f",
            tvc_baseView.bounds.size.height);
      [tvc_FTenDataVC resetStockCode:self.stockCode
                                name:self.stockName
                           firstType:self.firstType];
    }
  }
  [tvc_scrollView
      setContentOffset:CGPointMake(3.f * tvc_baseView.bounds.size.width, 0)
              animated:YES];
}

//创建聊股分页，并激活
- (void)creatWeiboVC {
  if (!_weiboViewController) {
    _weiboViewController =
        [[TrendWeiboViewController alloc] initCode:self.stockCode
                                              name:self.stockName
                                        controller:self];
    _weiboViewController.view.frame = CGRectMake(
        tvc_baseView.bounds.origin.x + 4 * tvc_baseView.bounds.size.width,
        tvc_baseView.bounds.origin.y, tvc_baseView.bounds.size.width,
        tvc_baseView.bounds.size.height);
    [_weiboViewController interfaceSwitchingTriggerLoadIndicator];
    [tvc_scrollView addSubview:_weiboViewController.view];
  } else {
    //聊股
    if (_weiboViewController) {
      [_weiboViewController refreshDataWithStockCode:self.stockCode];
    }
  }
  [tvc_scrollView
      setContentOffset:CGPointMake(4.f * tvc_baseView.bounds.size.width, 0)
              animated:YES];
}

#pragma mark
#pragma mark 功能函数
#pragma mark 重新设定走势和其他页面切换时候的上标题栏内容
- (void)resetTopToolBarConten {
  if (tvc_corpagetype == TPT_Trend_Mode) {
    //走势页面
    if (_topToolBar) {
      [self resetContentWithStockName:self.stockName
                        withStockCode:
                            [NSString
                                stringWithFormat:
                                    @"(%@)",
                                    [StockUtil sixStockCode:self.stockCode]]];
    }
  } else {
    if (_topToolBar && self.stockCode && [self.stockCode length] > 0) {
      //上标题栏，如果从聊股进入，则没有数据，所以显示股票

      if (![securitiesCurStatusVC curPrice] ||
          ![securitiesCurStatusVC riseRate]) {
        NSString *stockCode = self.stockCode;
        if (stockCode.length == 8) {
          stockCode = [stockCode substringFromIndex:2];
        }
        NSString *codeStr = [NSString stringWithFormat:@"(%@)", stockCode];
        [self resetContentWithStockName:self.stockName withStockCode:codeStr];
      } else {
        NSString *flag = [NSString
            stringWithFormat:@"(%@  %@)", [securitiesCurStatusVC curPrice],
                             [securitiesCurStatusVC riseRate]];
        [self resetContentWithStockName:self.stockName withStockCode:flag];
      }
    }
  }
}
//重新设定底部按钮是否隐藏状态
- (void)resetBottomButonState {

  if (self.stockCodeArray == nil || [self.stockCodeArray count] == 0 ||
      [self.stockCodeArray count] == 1) {
    [bottomToolBarView resetLOrRButton:NO RightButton:NO];
    return;
  }
  if (_index == 0) {
    [bottomToolBarView resetLOrRButton:NO RightButton:YES];
    return;
  } else if (_index == [self.stockCodeArray count] - 1) {
    [bottomToolBarView resetLOrRButton:YES RightButton:NO];
    return;
  } else {
    [bottomToolBarView resetLOrRButton:YES RightButton:YES];
    return;
  }
}

- (NSArray *)titlesArray {
  BOOL isDapa = [StockUtil isMarketIndex:self.firstType];
  return isDapa ? titlesForIndex : titlesForStockFund;
}

- (Trend_Page_Type)pageTypeAtTabIndex:(NSInteger)index {
  BOOL isDapa = [StockUtil isMarketIndex:self.firstType];
  NSDictionary *dic = isDapa ? tabIndexToPageTypeMapForIndex
                             : tabIndexToPageTypeMapForStockFund;
  return (Trend_Page_Type)[dic[@(index)] integerValue];
}

- (NSInteger)tabIndexForPageType:(Trend_Page_Type)pageType {
  BOOL isDapa = [StockUtil isMarketIndex:self.firstType];
  NSDictionary *dic = isDapa ? tabIndexToPageTypeMapForIndex
                             : tabIndexToPageTypeMapForStockFund;
  __block NSInteger tabIndex = 0;
  [dic enumerateKeysAndObjectsUsingBlock:^(NSNumber *indexNumber,
                                           NSNumber *pageTypeNumber,
                                           BOOL *stop) {
    if (pageType == [pageTypeNumber integerValue]) {
      tabIndex = [indexNumber integerValue];
      *stop = YES;
    }

  }];
  return tabIndex;
}

#pragma mark
#pragma mark 行情、资讯、F10、聊股切换回调协议

// UIScrollViewDelegate 协议
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  NSInteger index =
      (NSInteger)(scrollView.contentOffset.x / tvc_baseView.bounds.size.width);
  [topTabButtons buttonSelectedAtIndex:index animation:NO];
}

#pragma mark

//点击左边按钮，切换股票
- (void)leftPressDown {
  [self leftRightPressDown:YES];
}

//点击右边按钮，切换股票
- (void)rightPressDown {
  [self leftRightPressDown:NO];
}

#pragma mark - 切换股票触发
- (void)leftRightPressDown:(BOOL)isLeft {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }

  if (isLeft) {
    _index--;
  } else {
    _index++;
  }
  if (_index <= 0) {
    _index = 0;
  }
  if (_index > [self.stockCodeArray count] - 1) {
    _index = [self.stockCodeArray count] - 1;
  }
  [self resetBottomButonState];

  NSDictionary *stockDictionary = self.stockCodeArray[_index];
  NSString *stockcode = self.stockCode = [stockDictionary objectForKey:@"code"];
  NSString *stockName = self.stockName = [stockDictionary objectForKey:@"name"];
  //上标题栏
  NSString *tempCode = @"";
  if (stockcode && [stockcode length] == 8) {
    tempCode = [stockcode substringFromIndex:2];
  } else {
    if (stockcode) {
      tempCode = [NSString stringWithString:stockcode];
    }
  }
  NSString *firstType = [NSString
      stringWithFormat:@"%@", [stockDictionary objectForKey:@"firstType"]];
  [self setFirstType:firstType];
  if (_topToolBar) {
    NSString *flag = [NSString stringWithFormat:@"(%@)", tempCode];
    [self resetContentWithStockName:stockName withStockCode:flag];
  }

  BOOL isDapa = [StockUtil isMarketIndex:self.firstType];
  if (topTabButtons) {
    NSArray *titles = [self titlesArray];
    [topTabButtons resetTabTitleArray:titles
                     andSelectedIndex:tvc_corpagetype - 1];
    tvc_scrollView.contentSize =
        CGSizeMake(tvc_baseView.bounds.size.width * titles.count,
                   tvc_baseView.bounds.size.height);
    [self addRemoveViewControllers:!isDapa];
    [tvc_stockInformationVC clearTableViewData];

    __weak TrendViewController *weakSelf = self;
    SecuritiesInfo *info = [[SecuritiesInfo alloc] init];
    info.securitiesCode = ^{
      return weakSelf.stockCode;
    };
    info.securitiesFirstType = ^{
      return weakSelf.firstType;
    };
    info.securitiesName = ^{
      return weakSelf.stockName;
    };
    [securitiesCurStatusVC resetWithFrame:tvc_baseView.bounds
                       withSecuritiesInfo:info];
    //切换至行情页面
    [topTabButtons buttonSelectedAtIndex:0 animation:NO];
  }
  // 从新选择bottomview，按钮
  [bottomToolBarView setAllButtonArray];
  [self resetBottomButonState];
}

- (void)addRemoveViewControllers:(BOOL)isAdd {
  NSArray *viewControllers = @[
    tvc_FTenDataVC ? tvc_FTenDataVC : [NSNull null],
    sameStockSupermanVC ? sameStockSupermanVC : [NSNull null],
    _weiboViewController ? _weiboViewController : [NSNull null]
  ];
  __weak UIScrollView *weakObj = tvc_scrollView;
  [viewControllers
      enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL *stop) {
        if (obj != [NSNull null]) {
          if (isAdd) {
            UIViewController *vc = (UIViewController *)obj;
            if (!vc.view.superview) {
              [weakObj addSubview:vc.view];
            }
          } else {
            UIViewController *vc = (UIViewController *)obj;
            if (vc.view.superview) {
              [vc.view removeFromSuperview];
            }
          }
        }
      }];
}
#pragma mark
#pragma mark 子页面刷新或加载
- (void)refreshData:(BOOL)refresh {
  if (refresh) {
    [_indicatorView startAnimating];
  } else {
    [_indicatorView stopAnimating];
  }
}

+ (void)showDetailWithStockCode:(NSString *)stockCode
                  withStockName:(NSString *)stockName
                  withFirstType:(NSString *)firstType
                    withMatchId:(NSString *)matchId {
  //改 第三处
  NSArray *array = [StockDBManager searchFromdataWithStockName:stockName
                                                 withStockCode:stockCode];
  StockFunds *stock = array[0];
  stockCode = stock.code;
  stockName = stock.name;
  TrendViewController *viewController =
      [[TrendViewController alloc] initWithStockCode:stockCode
                                       withStockName:stockName
                                       withFirstType:firstType
                                         withMarchId:matchId
                                       withStartPage:TPT_Trend_Mode];
  [AppDelegate pushViewControllerFromRight:viewController];
}

+ (void)showDetailWithStockCode:(NSString *)stockCode
                  withStockName:(NSString *)stockName
                  withFirstType:(NSString *)firstType
                    withMatchId:(NSString *)matchId
                  withStartPage:(Trend_Page_Type)startPage {

  TrendViewController *viewController =
      [[TrendViewController alloc] initWithStockCode:stockCode
                                       withStockName:stockName
                                       withFirstType:firstType
                                         withMarchId:matchId
                                       withStartPage:startPage];
  [AppDelegate pushViewControllerFromRight:viewController];
}
///实盘看行情(bottom没有买入/卖出按钮)
+ (void)showDetailWithStockCode:(NSString *)stockCode
                  withStockName:(NSString *)stockName
                    withMatchId:(NSString *)matchId
                     withISFirm:(BOOL)isfirm {
  //改 第二处
  NSArray *array = [StockDBManager searchFromdataWithStockName:stockName
                                                 withStockCode:stockCode];
  StockFunds *stock = array[0];
  stockCode = stock.code;
  stockName = stock.name;
  TrendViewController *viewController = nil;
  if ([stock.firstType integerValue] == 4) {

    viewController = [[TrendViewController alloc]
        initWithStockCode:stockCode
            withStockName:stockName
            withFirstType:[stock.firstType stringValue]
              withMarchId:matchId
            withStartPage:TPT_Trend_Mode];

  } else {

    viewController = [[TrendViewController alloc] initWithStockCode:stockCode
                                                      withStockName:stockName
                                                        withMarchId:matchId
                                                         withIsFirm:isfirm];
  }
  ///是否实盘看行情
  viewController.isFirm = isfirm;
  [AppDelegate pushViewControllerFromRight:viewController];
}

+ (void)showDetailWithStockCode:(NSString *)stockCode
                  withStockName:(NSString *)stockName
                  withFirstType:(NSString *)firstType
                    withMatchId:(NSString *)matchId
                 withStockArray:(NSMutableArray *)dataArray
                      withIndex:(NSInteger)index {

  TrendViewController *viewController =
      [[TrendViewController alloc] initWithStockCode:stockCode
                                       withStockName:stockName
                                       withFirstType:firstType
                                         withMarchId:matchId
                                       withStartPage:TPT_Trend_Mode];
  viewController.stockCodeArray = dataArray;
  viewController.index = index;
  [AppDelegate pushViewControllerFromRight:viewController];
}

/** 从牛人界面跳个股行情 */
+ (void)showDetailWithStockCode:(NSString *)stockCode
                  withStockName:(NSString *)stockName
                  withFirstType:(NSString *)firstType
                    withMatchId:(NSString *)matchId
                 withIsExperter:(BOOL)isExpert {
  //改 第三处
  NSArray *array = [StockDBManager searchFromdataWithStockName:stockName
                                                 withStockCode:stockCode];
  StockFunds *stock = array[0];
  stockCode = stock.code;
  stockName = stock.name;
  TrendViewController *viewController =
      [[TrendViewController alloc] initWithStockCode:stockCode
                                       withStockName:stockName
                                       withFirstType:firstType
                                         withMarchId:matchId
                                       withStartPage:TPT_Trend_Mode];
  viewController.isFirm = isExpert;
  [AppDelegate pushViewControllerFromRight:viewController];
}

@end
