//
//  FoundMasterPurchViewConroller.m
//  SimuStock
//
//  Created by Mac on 14-3-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "FoundMasterPurchViewConroller.h"
#import "SimuUtil.h"

#import "MobClick.h"
#import "NewShowLabel.h"
#import "BaseRequester.h"

@implementation FoundMasterPurchViewConroller

- (void)viewDidLoad {
  [super viewDidLoad];
  storeUtil = [[StoreUtil alloc] initWithUIViewController:self];

  [self creatTopAndBottomViews];
  [self resetIndicatorView];

  [self loadfoundsCardWithDiamonds];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

//创建背景图和上下工具栏控件
- (void)creatTopAndBottomViews {
  mpvc_CardArray = [[NSMutableArray alloc] init];
  mpvc_DataArray = [[NSMutableArray alloc] init];
  cycleArr = [[NSMutableArray alloc] init];

  //创建上方工具栏
  [_topToolBar resetContentAndFlage:@"购买资金" Mode:TTBM_Mode_Leveltwo];

  //创建载入页面
  UIView *baseView = self.clientView;

  //说明
  UILabel *descraptLable1 =
      [[UILabel alloc] initWithFrame:CGRectMake(18, 34, self.view.bounds.size.width - 18 * 2, 35)];
  descraptLable1.backgroundColor = [UIColor clearColor];
  descraptLable1.numberOfLines = 0;
  descraptLable1.font = [UIFont boldSystemFontOfSize:14];
  descraptLable1.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
  descraptLable1.textAlignment = NSTextAlignmentCenter;
  descraptLable1.text = @"拥有更多模拟交易资金," @"立" @"即" @"变身炒股土" @"豪!";
  [baseView addSubview:descraptLable1];

  //商品列表
  scrollView = [[UIScrollView alloc]
      initWithFrame:CGRectMake((WIDTH_OF_SCREEN - 284) / 2, descraptLable1.frame.origin.y + descraptLable1.bounds.size.height + 14,
                               282, baseView.bounds.size.height - 69 -
                                        (descraptLable1.frame.origin.y + descraptLable1.bounds.size.height + 14))];
  [scrollView setContentSize:CGSizeMake(scrollView.bounds.size.width, self.view.bounds.size.height - 200)];
  scrollView.showsVerticalScrollIndicator = YES;
  scrollView.showsHorizontalScrollIndicator = NO;
  scrollView.backgroundColor = [UIColor clearColor];
  [baseView addSubview:scrollView];

  //购买背景
  UIView *shadowView =
      [[UIView alloc] initWithFrame:CGRectMake(0, baseView.bounds.size.height - 69, baseView.bounds.size.width, 69)];
  shadowView.backgroundColor = [Globle colorFromHexRGB:@"#ececec"];
  [baseView addSubview:shadowView];
  //背景的阴影
  UIView *shadowlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, baseView.bounds.size.width, 1)];
  shadowlineView.backgroundColor = [Globle colorFromHexRGB:@"#cccccc"];
  [shadowView addSubview:shadowlineView];
  //立即购买按钮
  
  BGColorUIButton *ssv_cancelButton = [BGColorUIButton buttonWithType:UIButtonTypeCustom];
  [ssv_cancelButton buttonWithTitle:@"立即兑换"
                 andNormaltextcolor:Color_White
           andHightlightedTextColor:Color_White];
  [ssv_cancelButton setNormalBGColor:[Globle colorFromHexRGB:@"31bce9"]];
  [ssv_cancelButton setHighlightBGColor:[Globle colorFromHexRGB:Color_Blue_but]];

  ssv_cancelButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  [ssv_cancelButton addTarget:self
                       action:@selector(okbuttonpresswithDiamonds:)
             forControlEvents:UIControlEventTouchUpInside];
  ssv_cancelButton.frame =
      CGRectMake(18, baseView.bounds.size.height - 54, baseView.bounds.size.width - 18 * 2, 38);
  [baseView addSubview:ssv_cancelButton];
}

//创建联网指示器
- (void)resetIndicatorView {

  [_indicatorView setButonIsVisible:NO];
}

#pragma mark
#pragma mark 按钮回调函数
- (void)okbuttonpress:(UIButton *)button {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }

  NSString *productID = nil;
  for (TrackCardItemView *obj in mpvc_CardArray) {
    if (obj.isSelected == YES) {
      productID = [NSString stringWithFormat:@"%@", obj.productID];
      break;
    }
  }
  if (productID == nil)
    return;
  BOOL allComplete = [[CONTROLER productPurchase] completLastPurchaseInQueue];
  if (!allComplete)
    return;

  if ([NetLoadingWaitView isAnimating] == NO) {
    [NetLoadingWaitView startAnimating];
  }
  [self buyingProducteFromSevers:productID];
}
- (void)okbuttonpresswithDiamonds:(UIButton *)button {

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  TrackCardItemView *item = nil;
  int i = 0;
  for (TrackCardItemView *obj in mpvc_CardArray) {
    if (obj.isSelected == YES) {
      item = obj;
      break;
    }
    i++;
  }
  if (item == nil)
    return;
  if (!mpvc_DataArray) {
    return;
  } else {
    if (mpvc_DataArray.count == 0) {
      return;
    }
  }
  ProductListItem *item_obj = mpvc_DataArray[i];
  [storeUtil buyProductWithDiamonds:item_obj];
}

//如何打开通知设置
- (void)OpenDiscriptonUrl {
  [[UIApplication sharedApplication]
      openURL:[NSURL URLWithString:@"http://www.youguu.com/protocol/comments/" @"comments.html"]];
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
  if ([NetLoadingWaitView isAnimating] == NO) {
    [NetLoadingWaitView startAnimating];
  }
  [self changeProductWithDiamonds:_productID];
  [self performSelector:@selector(removeCompetitionCycleView) withObject:nil afterDelay:0];
}
//兑换->充值按钮回调
- (void)conversionTipRechargeButtonMethod {

  [self diamondPopInterface];
}
//立即购买
- (void)buyNowProductId:(NSString *)productId {
  if (productId == nil)
    return;
  NSLog(@"FoundMasterPurchVC:%@", productId);
  BOOL allComplete = [[CONTROLER productPurchase] completLastPurchaseInQueue];
  if (!allComplete)
    return;

  [self buyingProducteFromSevers:productId];
  [storeUtil removeCompetitionCycleView];
}

- (void)stopLoadingView {
  if ([NetLoadingWaitView isAnimating])
    [NetLoadingWaitView stopAnimating];
}

//从服务器（本地）购买产品，生成订单
- (void)buyingProducteFromSevers:(NSString *)productedid {

  [NetLoadingWaitView startAnimating];
  [MobClick beginLogPageView:@"商城-买入"];

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak FoundMasterPurchViewConroller *weakSelf = self;

  callback.onSuccess = ^(NSObject *obj) {
    FoundMasterPurchViewConroller *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindProductOrder:(productOrderListItem *)obj];
    }
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *ex) {
    [weakSelf stopLoadingView];
    [BaseRequester defaultErrorHandler](obj, ex);
  };
  callback.onFailed = ^{
    [weakSelf stopLoadingView];
    [NewShowLabel showNoNetworkTip];
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
#pragma mark TrackCardDelegate

- (void)TrackCardSelStateChange:(BOOL)selstate CardIndex:(NSInteger)index {
  if (index >= [mpvc_CardArray count])
    return;
  for (TrackCardItemView *obj in mpvc_CardArray) {
    if (index == obj.cardIndex) {
      [obj resetSelState:YES];
    } else {
      [obj resetSelState:NO];
    }
  }
}

#pragma mark
#pragma mark 网络下载相关函数

//下载资金卡数据（钻石商城新接口）
- (void)loadfoundsCardWithDiamonds {
  [_indicatorView startAnimating];

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak FoundMasterPurchViewConroller *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    FoundMasterPurchViewConroller *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    FoundMasterPurchViewConroller *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindProductList:(ProductList *)obj];
    }
  };

  [ProductList requestProductListWithCatagories:@"D020000" withCallback:callback];
}

- (void)bindProductList:(ProductList *)pagedata {

  //资金卡列表数据，支持钻石兑换资金卡的钻石商城新接口
  int i = 0;
  [mpvc_CardArray removeAllObjects];
  [mpvc_DataArray removeAllObjects];
  [scrollView removeAllSubviews];
  [scrollView setContentSize:CGSizeMake(282, (42 + 11) * [pagedata.dataArray count] + 10)];
  for (ProductListItem *obj in pagedata.dataArray) {
    // if ([obj.mCategoryId isEqualToString:@"D020000"] == YES) {
    if (1) {
      [mpvc_DataArray addObject:obj];
      //追踪卡名称
      NSString *cardNmae = obj.mName;
      //追踪卡价格
      NSString *cardPrice = [@"x" stringByAppendingString:obj.mPrice];
      //追踪卡折扣
      NSString *cardcount = obj.mDiscount;
      if ([obj.mSale integerValue] == 0) {
        cardPrice = [@"x" stringByAppendingString:obj.mNoCountPrice];
      }
      //追踪卡id
      NSString *productid = obj.mProductId;
      NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
      [dic setValue:cardNmae forKey:@"card_name"];
      [dic setValue:cardPrice forKey:@"card_price"];
      [dic setValue:cardcount forKey:@"card_count"];
      [dic setValue:cardPrice forKey:@"card_nocountprice"];

      TrackCardItemView *cardItem =
          [[TrackCardItemView alloc] initWithFrame:CGRectMake(0, (42 + 11) * i, 282, 42)
                                    WithContentDic:dic];

      [cardItem resetSelState:(i == 0)];

      cardItem.delegate = self;
      cardItem.productID = productid;
      cardItem.cardIndex = i;
      [cardItem resetCardContentForDiamonds:dic];
      [scrollView addSubview:cardItem];
      [mpvc_CardArray addObject:cardItem];
      i++;
    }
  }
  [scrollView setContentSize:CGSizeMake(282, (42 + 11) * i + 10)];
}
//用钻石兑换道具接口
- (void)changeProductWithDiamonds:(NSString *)productID {
  [storeUtil changeProductWithDiamonds:productID];
}
//购买钻石弹窗接口
- (void)diamondPopInterface {
  [storeUtil showBuyingDiamondView];
}

@end
