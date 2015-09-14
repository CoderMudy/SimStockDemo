//
//  NetShoppingMallBaseViewController.m
//  SimuStock
//
//  Created by jhss on 13-9-18.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "NetShoppingMallBaseViewController.h"

#import "event_view_log.h"
#import "MobClick.h"

#import "PropListForReviewTableVC.h"
#import "SimuConfigConst.h"

//商品ID
#define SUB_PRODUCT_ID @"com.jhss.simustock.monthcard"

@implementation NetShoppingMallBaseViewController

- (id)init {
  if (self = [super init]) {
    [self setParentType:TMTM_Mode_BaseController withPageType:Mall_Buy_Diamond_Mode];
  }
  return self;
}

- (id)initFromSendCattleWithSuccessCallBack:(SuccessCallBack)successCallBack {
  if (self = [super init]) {
    [self setParentType:TMTM_Mode_BaseController withPageType:Mall_Buy_Props];
    self.successBlock = successCallBack;
    isSendCattle = YES;
  }
  return self;
}

/*
 *功能：初始化控制器，并且纪录父视图控制器类型
 *参数：type 父视图控制器类型
 */
- (id)initWithType:(ShopMallParentMode)type {
  if (self = [super init]) {
    [self setParentType:type withPageType:Mall_Buy_Diamond_Mode];
  }
  return self;
}

- (id)initWithPageType:(shopMallShowPageType)type {
  if (self = [super init]) {
    [self setParentType:TMTM_Mode_BaseController withPageType:type];
  }
  return self;
}

- (void)setParentType:(ShopMallParentMode)type withPageType:(shopMallShowPageType)pageType {

  storeUtil = [[StoreUtil alloc] initWithUIViewController:self];
  parentsType = type;
  ssvc_pageTyep = pageType;
  [MobClick beginLogPageView:@"商城"];

  ///切换商城子页面
  switch (ssvc_pageTyep) {
  case Mall_Buy_Diamond_Mode:
    tabIndex = 0;
    subTabIndex = 0;
    break;
  case smspt_foundCards_mode:
    tabIndex = 1;
    subTabIndex = 0;
    break;

  case Mall_Buy_Props:
    tabIndex = 1;
    subTabIndex = 1;
    break;
  }
}

- (void)viewDidLoad {
  self.frameInParent = UIScreen.mainScreen.bounds;
  [super viewDidLoad];

  //创建基本页面
  [_topToolBar resetContentAndFlage:@"商城" Mode:TTBM_Mode_Sideslip];

  //创建scrollView
  [self createScrollView];

  //创建钻石购买页面
  [self creatRechargeView];
  //创建商品页面
  [self creatCommodityView];
  //创建联网提示
  [self resetIndicatorView];

  //创建上工具栏
  [self creatTopToolBar];

  //重置topBar
  [self resetTopBar];
}

//重置topbar
- (void)resetTopBar {
  switch (ssvc_pageTyep) {
  case Mall_Buy_Diamond_Mode:
    [ssvc_topToolBar changTapToIndex:tabIndex];
    [ssvc_roundButtonView resetTabIndex:subTabIndex];
    [_diamondTableVC refreshButtonPressDown];
    break;

  case smspt_foundCards_mode:
    [ssvc_topToolBar changTapToIndex:tabIndex];
    [ssvc_roundButtonView resetTabIndex:subTabIndex];
    [_fundCardTableVC refreshButtonPressDown];
    break;

  case Mall_Buy_Props:
    [ssvc_topToolBar changTapToIndex:tabIndex];
    [ssvc_roundButtonView resetTabIndex:subTabIndex];
    [_propTableVC refreshButtonPressDown];
    break;
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  //记录日志
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV andCode:@"商城"];
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV andCode:@"商城-重置卡"];
}
#pragma mark
#pragma mark-----------------------------view------------------------

- (void)createScrollView {
  //创建承载滑动视图
  _scrollView =
      [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOP_TABBAR_HEIGHT, WIDTH_OF_VIEWCONTROLLER,
                                                     self.clientView.bounds.size.height - TOP_TABBAR_HEIGHT)];
  _scrollView.contentSize = CGSizeMake(WIDTH_OF_VIEWCONTROLLER * 2, _scrollView.bounds.size.height);
  _scrollView.pagingEnabled = YES;
  _scrollView.delegate = self;
  _scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.bounces = NO;
  _scrollView.backgroundColor = [UIColor clearColor];
  [self.clientView addSubview:_scrollView];
}

//创建钻石购买页面
- (void)creatRechargeView {

  _diamondTableVC =
      [[DiamondTableVC alloc] initWithFrame:CGRectMake(0, 0, self.clientView.bounds.size.width,
                                                       self.clientView.bounds.size.height - TOP_TABBAR_HEIGHT)];
  _diamondTableVC.propBuyDelegate = self;
  _diamondTableVC.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  [_scrollView addSubview:_diamondTableVC.view];
  [self addChildViewController:_diamondTableVC];
}

//创建商品页面
- (void)creatCommodityView {
  //商品页面承载页面
  ssvc_CommodityView =
      [[UIView alloc] initWithFrame:CGRectMake(WIDTH_OF_VIEWCONTROLLER, 0, self.clientView.bounds.size.width,
                                               self.clientView.bounds.size.height - TOP_TABBAR_HEIGHT)];
  ssvc_CommodityView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  ssvc_CommodityView.tag = 1;

  [_scrollView addSubview:ssvc_CommodityView];

  //商品页面上部工具栏
  ssvc_roundButtonView =
      [[RoundButtonView alloc] initWithFrame:CGRectMake(14, 11, ssvc_CommodityView.bounds.size.width - 28, 33)
                                   DataArray:@[ @"资金卡", @"道具" ]
                         withInitButtonIndex:0];
  ssvc_roundButtonView.delegate = self;

  [ssvc_CommodityView addSubview:ssvc_roundButtonView];
  //表格加入商品承载页面
  //表格
  CGRect tableFrame =
      CGRectMake(0, 44, ssvc_CommodityView.frame.size.width, ssvc_CommodityView.frame.size.height - 44);

  _fundCardTableVC =
      [[PropListTableVC alloc] initWithFrame:tableFrame withCommodityType:CommodityTypeFundCard];
  _fundCardTableVC.storeUtil = storeUtil;
  if ([SimuConfigConst isShowPropsForReview]) {
    _propTableVC = [[PropListForReviewTableVC alloc] initWithFrame:tableFrame
                                                 withCommodityType:CommodityTypeProp];
    _propTableVC.storeUtil = storeUtil;
    ((PropListForReviewTableVC *)_propTableVC).propBuyDelegate = self;
  } else {
    _propTableVC =
        [[PropListTableVC alloc] initWithFrame:tableFrame withCommodityType:CommodityTypeProp];
    _propTableVC.storeUtil = storeUtil;
  }
}

//创建上部工具栏
- (void)creatTopToolBar {
  //上部工具栏
  ssvc_topToolBar = [[TopToolBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TOP_TABBAR_HEIGHT)
                                                DataArray:@[ @"充值", @"商品" ]
                                      withInitButtonIndex:0];
  ssvc_topToolBar.delegate = self;
  [self.clientView addSubview:ssvc_topToolBar];
}
//创建联网指示器
- (void)resetIndicatorView {
  [_indicatorView setButonIsVisible:NO];
}

#pragma mark
#pragma mark------------------------tableview协议函数-----------------------------------

#pragma mark scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if (scrollView == _scrollView) {
    CGPoint offset = scrollView.contentOffset;

    if (offset.x == 0) {
      [ssvc_topToolBar changTapToIndex:0];
    } else if (offset.x == WIDTH_OF_VIEWCONTROLLER) {
      [ssvc_topToolBar changTapToIndex:1];
    }
  }
}

#pragma mark 移动滑块
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView == _scrollView) {
    if (scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x <= self.view.frame.size.width) {
      ssvc_topToolBar.maxlineView.frame =
          CGRectMake(scrollView.contentOffset.x / 2, ssvc_topToolBar.bounds.size.height - 3,
                     self.view.frame.size.width / 2, 2.5f);
    }
  }
}

#pragma mark
#pragma mark---------购买------------------------------

- (void)stopLoading {
  if ([NetLoadingWaitView isAnimating])
    [NetLoadingWaitView stopAnimating];
}

///从服务器（本地）购买产品，生成订单
- (void)buyingProducteFromSevers:(NSString *)productedid {

  [NetLoadingWaitView startAnimating];
  [MobClick beginLogPageView:@"商城-买入"];

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak NetShoppingMallBaseViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^() {
    NetShoppingMallBaseViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    NetShoppingMallBaseViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindProductOrder:(productOrderListItem *)obj];
    }
  };

  [productOrderListItem requestProductOrderByProductId:productedid withCallback:callback];

  //不同卡型的购买消息
  if ([productedid rangeOfString:@"L130010"].length > 0) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cardSort" object:@"trackCard"];
  } else {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cardSort" object:@"otherCard"];
  }
}

- (void)bindProductOrder:(productOrderListItem *)productOrder {
  [CONTROLER productPurchase].orderListNumber = productOrder.mInOrderID;
  [[CONTROLER productPurchase] requestProduct:@[ productOrder.mPayCode ]];
}

#pragma mark
#pragma mark CompetitionCycleViewDelegate 协议
//移除视图
- (void)removeCompetitionCycleView {
  [storeUtil removeCompetitionCycleView];
}
//兑换->兑换按钮回调
- (void)diamondExchangeFundsToBuyCards:(NSString *)_productID {
  if (_productID == nil)
    return;

  [NetLoadingWaitView startAnimating];

  [self changeProductWithDiamonds:_productID];
  [self performSelector:@selector(removeCompetitionCycleView) withObject:nil afterDelay:0];
}
//兑换->充值按钮回调
- (void)conversionTipRechargeButtonMethod {
  [ssvc_topToolBar changTapToIndex:0];
  [self performSelector:@selector(removeCompetitionCycleView) withObject:nil afterDelay:0];
}

#pragma mark
#pragma mark TopToolBarViewDelegate 协议
- (void)changeToIndex:(NSInteger)index {
  if (index == 0) {
    if (!_diamondTableVC.dataBinded) {
      [_diamondTableVC refreshButtonPressDown];
    }
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
  } else {
    [_scrollView setContentOffset:CGPointMake(WIDTH_OF_VIEWCONTROLLER, 0) animated:YES];
    [self roundSelectedChange:subTabIndex];
  }
}

#pragma mark
#pragma mark RechargeCellDelegate 协议

- (void)buyButtonPressDown:(NSString *)productid {
  if (productid == nil || [productid length] == 0)
    return;

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }

  __weak NetShoppingMallBaseViewController *weakSelf = self;

  [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
    BOOL allComplete = [[CONTROLER productPurchase] completLastPurchaseInQueue];
    if (!allComplete)
      return;
    //记录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"144"];
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV andCode:@"商城-买入"];

    [weakSelf buyingProducteFromSevers:productid];
  }];
}

#pragma mark
#pragma mark RoundButtonViewDelegate 协议
- (void)roundSelectedChange:(NSInteger)index {
  subTabIndex = index;
  if (index == 0) {
    ssvc_pageTyep = smspt_foundCards_mode;
    [ssvc_CommodityView addSubview:_fundCardTableVC.view];
    [self addChildViewController:_fundCardTableVC];
    [_propTableVC.view removeFromSuperview];
    [_propTableVC removeFromParentViewController];
    if (![_fundCardTableVC dataBinded]) {
      [_fundCardTableVC refreshButtonPressDown];
    }
  } else if (index == 1) {
    ssvc_pageTyep = Mall_Buy_Props;
    [ssvc_CommodityView addSubview:_propTableVC.view];
    [self addChildViewController:_propTableVC];
    [_fundCardTableVC.view removeFromSuperview];
    [_fundCardTableVC removeFromParentViewController];
    if (![_propTableVC dataBinded]) {
      [_propTableVC refreshButtonPressDown];
    }
  }
}

- (void)stopIndicator {
  [_indicatorView stopAnimating];
}

//用钻石兑换道具接口
- (void)changeProductWithDiamonds:(NSString *)productID {
  [storeUtil changeProductWithDiamonds:productID andSuccessCallBack:self.successBlock];
}

+ (void)startMallWithShowPageType:(shopMallShowPageType)type {
  [AppDelegate pushViewControllerFromRight:[[NetShoppingMallBaseViewController alloc] initWithPageType:type]];
}

@end
