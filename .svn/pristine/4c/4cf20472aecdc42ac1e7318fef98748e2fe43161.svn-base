//
//  MasterPurchesViewController.m
//  SimuStock
//
//  Created by Mac on 14-2-13.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MasterPurchesViewController.h"
#import "SimuUtil.h"

#import "MobClick.h"
#import "NewShowLabel.h"
#import "UIImage+ColorTransformToImage.h"

#import "BaseRequester.h"

@implementation MasterPurchesViewController

@synthesize delegate = _delegate;
@synthesize traceDelegate = _traceDelegate;

- (void)viewDidLoad {
  [super viewDidLoad];
  storeUtil = [[StoreUtil alloc] initWithUIViewController:self];
  storeUtil.afterPurchaseDelegate = self;
  [_indicatorView setButonIsVisible:NO];
  [self creatTopAndBottomViews];

  /**下载道具（追踪卡）*/
  [self loadTrackCardWithDiamonds];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)afterPurchaseRefreshControllerData
{
  NSLog(@"fsdfsfda");
  [self changePage];
}

//创建背景图和上下工具栏控件
- (void)creatTopAndBottomViews {
  mpvc_CardArray = [[NSMutableArray alloc] init];
  mpvc_DataArray = [[NSMutableArray alloc] init];
  cycleArr = [[NSMutableArray alloc] init];

  //创建上方工具栏
  [_topToolBar resetContentAndFlage:@"追踪牛人" Mode:TTBM_Mode_Leveltwo];

  //创建再如页面

  //创建上方的两个说明
  UIView *DiscraptView1 = [[UIView alloc]
      initWithFrame:CGRectMake(18, 17, self.view.bounds.size.width - 18 * 2,
                               35)];
  DiscraptView1.backgroundColor = [UIColor clearColor];
  [_clientView addSubview:DiscraptView1];
  //小图片
  UIImageView *sigeImageView1 =
      [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"小图标_02"]];
  sigeImageView1.center = CGPointMake(sigeImageView1.bounds.size.width / 2,
                                      sigeImageView1.bounds.size.height / 2);
  [DiscraptView1 addSubview:sigeImageView1];
  //说明
  UILabel *descraptLable1 = [[UILabel alloc]
      initWithFrame:CGRectMake(sigeImageView1.bounds.size.width + 8, 0,
                               DiscraptView1.bounds.size.width -
                                   (sigeImageView1.bounds.size.width + 8),
                               DiscraptView1.bounds.size.height)];
  descraptLable1.backgroundColor = [UIColor clearColor];
  descraptLable1.numberOfLines = 0;
  descraptLable1.font = [UIFont boldSystemFontOfSize:14];
  descraptLable1.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
  descraptLable1.textAlignment = NSTextAlignmentLeft;
  descraptLable1.text = @"追" @"踪"
      @"牛人，他的每笔交易会及时以消息通知的方式提醒"
      @"您。";
  [DiscraptView1 addSubview:descraptLable1];

  //说明2
  //  UIView *DiscraptView2 = [[UIView alloc]
  //      initWithFrame:CGRectMake(18, DiscraptView1.frame.origin.y +
  //                                       DiscraptView1.bounds.size.height +
  //                                       15,
  //                               DiscraptView1.bounds.size.width,
  //                               DiscraptView1.bounds.size.height)];
  DiscraptView2 = [[UIView alloc]
      initWithFrame:CGRectMake(18, DiscraptView1.frame.origin.y +
                                       DiscraptView1.bounds.size.height + 15,
                               DiscraptView1.bounds.size.width,
                               DiscraptView1.bounds.size.height)];
  DiscraptView2.backgroundColor = [UIColor clearColor];
  [_clientView addSubview:DiscraptView2];
  //小图片
  UIImageView *sigeImageView2 =
      [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"小图标01"]];
  sigeImageView2.center = CGPointMake(sigeImageView2.bounds.size.width / 2,
                                      sigeImageView2.bounds.size.height / 2);
  [DiscraptView2 addSubview:sigeImageView2];
  //说明
  UILabel *descraptLable2 = [[UILabel alloc]
      initWithFrame:CGRectMake(sigeImageView1.bounds.size.width + 8, 0,
                               DiscraptView2.bounds.size.width -
                                   (sigeImageView2.bounds.size.width + 8),
                               DiscraptView2.bounds.size.height)];
  descraptLable2.backgroundColor = [UIColor clearColor];
  descraptLable2.numberOfLines = 0;
  descraptLable2.font = [UIFont boldSystemFontOfSize:14];
  descraptLable2.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
  descraptLable2.textAlignment = NSTextAlignmentLeft;
  descraptLable2.text = @"购" @"买"
      @"成功后可在购买周期内追踪任何牛人的持仓和操盘"
      @"记录，" @"不限追踪人数。";
  [DiscraptView2 addSubview:descraptLable2];

  //卡片
  NSDictionary *dic1 = [[NSMutableDictionary alloc] init];
  [dic1 setValue:@"年卡" forKey:@"card_name"];
  [dic1 setValue:@"" forKey:@"card_price"];
  [dic1 setValue:@"1" forKey:@"card_isSel"];
  [dic1 setValue:@"0" forKey:@"card_index"];

  NSDictionary *dic2 = [[NSMutableDictionary alloc] init];
  [dic2 setValue:@"半年卡" forKey:@"card_name"];
  [dic2 setValue:@"" forKey:@"card_price"];
  [dic2 setValue:@"0" forKey:@"card_isSel"];
  [dic2 setValue:@"1" forKey:@"card_index"];

  NSDictionary *dic3 = [[NSMutableDictionary alloc] init];
  [dic3 setValue:@"月卡" forKey:@"card_name"];
  [dic3 setValue:@"" forKey:@"card_price"];
  [dic3 setValue:@"0" forKey:@"card_isSel"];
  [dic3 setValue:@"2" forKey:@"card_index"];

  NSDictionary *dic4 = [[NSMutableDictionary alloc] init];
  [dic3 setValue:@"月卡" forKey:@"card_name"];
  [dic3 setValue:@"" forKey:@"card_price"];
  [dic3 setValue:@"0" forKey:@"card_isSel"];
  [dic3 setValue:@"2" forKey:@"card_index"];

  NSDictionary *dic5 = [[NSMutableDictionary alloc] init];
  [dic3 setValue:@"月卡" forKey:@"card_name"];
  [dic3 setValue:@"" forKey:@"card_price"];
  [dic3 setValue:@"0" forKey:@"card_isSel"];
  [dic3 setValue:@"2" forKey:@"card_index"];

  NSDictionary *dic6 = [[NSMutableDictionary alloc] init];
  [dic3 setValue:@"月卡" forKey:@"card_name"];
  [dic3 setValue:@"" forKey:@"card_price"];
  [dic3 setValue:@"0" forKey:@"card_isSel"];
  [dic3 setValue:@"2" forKey:@"card_index"];

  NSArray *array =
      @[dic1, dic2, dic3, dic4, dic5, dic6];
  for (int i = 0; i < 6; i++) {
    TrackCardItemView *cardItem = [[TrackCardItemView alloc]
        initWithFrame:CGRectMake((WIDTH_OF_SCREEN - 284) / 2, DiscraptView2.frame.origin.y +
                DiscraptView2.bounds.size.height +
                40 + (42 + 11) * i,
            282, 42)
       WithContentDic:array[i]];
    cardItem.hidden = YES;
    cardItem.delegate = self;
    [_clientView addSubview:cardItem];
    [mpvc_CardArray addObject:cardItem];
  }

  NSString *flage =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"Notification_Set"];
  if (flage && [flage isEqualToString:@"Yes"]) {
    //通知中心处于关闭状态，提示打开通知
    UILabel *notifacationLable = [[UILabel alloc]
        initWithFrame:CGRectMake(18, DiscraptView2.frame.origin.y +
                                         DiscraptView2.bounds.size.height + 40 +
                                         (42 + 11) * 4 + 8,
                                 210, 14)];
    notifacationLable.backgroundColor = [UIColor clearColor];
    notifacationLable.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    notifacationLable.text = @"提"
                             @"示：您需要打开通知中心以接收通知";
    notifacationLable.font = [UIFont systemFontOfSize:Font_Height_12_0];
    [_clientView addSubview:notifacationLable];

    //如何打开按钮
    UIButton *openNotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    openNotButton.frame = CGRectMake(WIDTH_OF_SCREEN - 100,
                                     notifacationLable.frame.origin.y, 100, 14);
    openNotButton.backgroundColor = [UIColor clearColor];
    openNotButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
    [openNotButton setTitle:@"如何打开?" forState:UIControlStateNormal];
    [openNotButton setTitle:@"如何打开?" forState:UIControlStateHighlighted];
    [openNotButton setTitleColor:[Globle colorFromHexRGB:@"#df5850"]
                        forState:UIControlStateNormal];
    [openNotButton addTarget:self
                      action:@selector(OpenDiscriptonUrl)
            forControlEvents:UIControlEventTouchUpInside];
    [_clientView addSubview:openNotButton];
  }

  //购买背景
  UIView *shadowView = [[UIView alloc]
      initWithFrame:CGRectMake(0, _clientView.bounds.size.height - 69,
                               _clientView.bounds.size.width, 69)];
  shadowView.backgroundColor = [Globle colorFromHexRGB:@"#ececec"];
  [_clientView addSubview:shadowView];

  //背景的阴影
  UIView *shadowlineView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, _clientView.bounds.size.width, 1)];
  shadowlineView.backgroundColor = [Globle colorFromHexRGB:@"#cccccc"];
  [shadowView addSubview:shadowlineView];

  //确定按钮
  //加入取消按钮 单选_选中图标
  UIButton *ssv_cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  ssv_cancelButton.frame =
      CGRectMake(18, _clientView.bounds.size.height - 54,
                 _clientView.bounds.size.width - 18 * 2, 38);
  ssv_cancelButton.backgroundColor = [Globle colorFromHexRGB:@"#31bce9"];
  [ssv_cancelButton setTitle:@"立即兑换" forState:UIControlStateNormal];
  [ssv_cancelButton setTitle:@"立即兑换" forState:UIControlStateHighlighted];
  [ssv_cancelButton setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
  [ssv_cancelButton setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateHighlighted];
  UIImage *buttonHighlightImage =
      [UIImage imageFromView:ssv_cancelButton
          withBackgroundColor:[Globle colorFromHexRGB:@"086dae"]];
  [ssv_cancelButton setBackgroundImage:buttonHighlightImage
                              forState:UIControlStateHighlighted];
  ssv_cancelButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  [ssv_cancelButton addTarget:self
                       action:@selector(okbuttonpresswithDiamonds:)
             forControlEvents:UIControlEventTouchUpInside];
  [_clientView addSubview:ssv_cancelButton];
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
  //购买的追踪卡
  [[NSNotificationCenter defaultCenter] postNotificationName:@"cardSort"
                                                      object:@"trackCard"];
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
      i = obj.cardIndex;
      break;
    }
    // i++;
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
      openURL:[NSURL URLWithString:@"http://www.youguu.com/protocol/comments/"
                     @"comments.html"]];
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
  if (![NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView startAnimating];
  }
  [self changeProductWithDiamonds:_productID];
  [self performSelector:@selector(removeCompetitionCycleView)
             withObject:nil
             afterDelay:0];
}

//兑换->充值按钮回调
- (void)conversionTipRechargeButtonMethod {
  [self diamondPopInterface];
  //[ssvc_topToolBar changTapToIndex:0];
  //[self performSelector:@selector(removeCompetitionCycleView) withObject:nil
  // afterDelay:0];
}
//立即购买
- (void)buyNowProductId:(NSString *)productId {
  if (productId == nil)
    return;
  NSLog(@"MasterPurchesVC:%@", productId);
  BOOL allComplete = [[CONTROLER productPurchase] completLastPurchaseInQueue];
  if (!allComplete)
    return;
  if (![NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView startAnimating];
  }
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
  __weak MasterPurchesViewController *weakSelf = self;

  callback.onSuccess = ^(NSObject *obj) {
      MasterPurchesViewController *strongSelf = weakSelf;
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

  [productOrderListItem requestProductOrderByProductId:productedid
                                          withCallback:callback];

  //不同卡型的购买消息
  if ([productedid rangeOfString:@"L130010"].length > 0) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cardSort"
                                                        object:@"trackCard"];
  } else {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cardSort"
                                                        object:@"otherCard"];
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

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  [self changePage];
}
#pragma mark
#pragma mark 网络下载相关函数
//下载追踪卡数据
- (void)loadTrackCard {

  [_indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self.indicatorView stopAnimating];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MasterPurchesViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
      MasterPurchesViewController *strongSelf = weakSelf;
      if (strongSelf) {
        [NewShowLabel showNoNetworkTip];
        [strongSelf.indicatorView stopAnimating];
        return NO;
      } else {
        return YES;
      }
  };

  callback.onSuccess = ^(NSObject *obj) {
      MasterPurchesViewController *strongSelf = weakSelf;
      if (strongSelf) {
        [strongSelf bindTrackCardList:(DiamondList *)obj];
      }
  };

  [DiamondList requestTrackCardListWithCallback:callback];
}

- (void)bindTrackCardList:(DiamondList *)data {
  int i = 0;
  for (TrackCardInfo *obj in data.dataArray) {
    if (i >= [mpvc_CardArray count])
      continue;
    TrackCardItemView *cardItem = mpvc_CardArray[i];
    cardItem.hidden = NO;
    //追踪卡名称
    NSString *cardNmae = obj.CardName;
    //追踪卡价格
    NSString *cardPrice = [obj.CardPrice stringByAppendingString:@"元"];
    //追踪卡折扣
    NSString *cardcount = obj.discount;
    if (cardcount == nil || [cardcount length] == 0) {
      cardcount = @"";
    } else {
      NSRange m_range = [cardcount rangeOfString:@"."];
      if (m_range.location > 0) {
        NSString *tempCount = [cardcount substringToIndex:m_range.location];
        cardcount = [tempCount stringByAppendingString:@"折"];
      }
    }

    //追踪卡id
    NSString *productid = obj.CardID;
    cardItem.productID = productid;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:cardNmae forKey:@"card_name"];
    [dic setValue:cardPrice forKey:@"card_price"];
    [dic setValue:cardcount forKey:@"card_count"];
    [dic setValue:cardcount forKey:@"card_nocountprice"];
    [cardItem resetCardContent:dic];
    i++;
  }
}

#pragma mark----------zxc----------
//下载资金卡数据（钻石商城新接口）（钻石资金卡）
- (void)loadTrackCardWithDiamonds {

  if (![SimuUtil isLogined]) {
    return;
  }
  [_indicatorView startAnimating];
  if (![SimuUtil isExistNetwork]) {
    [self stopLoading];
    [NewShowLabel showNoNetworkTip];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MasterPurchesViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
      MasterPurchesViewController *strongSelf = weakSelf;
      if (strongSelf) {
        [self stopLoading];
        return NO;
      } else {
        return YES;
      }
  };

  callback.onSuccess = ^(NSObject *obj) {
      MasterPurchesViewController *strongSelf = weakSelf;
      if (strongSelf) {
        [strongSelf bindProductList:(ProductList *)obj];
      }
  };

  [ProductList requestProductListWithCatagories:@"D030000"
                                   withCallback:callback];
}

- (void)bindProductList:(ProductList *)pagedata {
  int i = 0;
  [mpvc_DataArray removeAllObjects];

  for (ProductListItem *obj in pagedata.dataArray) {
    //  if ([obj.mCategoryId isEqualToString:@"D030000"] == YES &&
    //      [obj.mName isEqualToString:@"重置卡"] == NO) {
    if ([obj.mName isEqualToString:@"重置卡"] == NO) {
      if (i >= [mpvc_CardArray count])
        continue;
      TrackCardItemView *cardItem = mpvc_CardArray[i];
      cardItem.hidden = NO;

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
      if (i == 0) {
        [cardItem resetSelState:YES];
      }
      cardItem.delegate = self;
      cardItem.productID = productid;
      cardItem.cardIndex = i;
      [cardItem resetCardContentForDiamonds:dic];
      [mpvc_CardArray addObject:cardItem];
      i++;
    }
  }
}

- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip];
  if ([mpvc_DataArray count] == 0) {
    _littleCattleView.hidden = YES;
  } else {
    [_littleCattleView isCry:YES];
  }
}

- (void)stopLoading {
  [_indicatorView stopAnimating];
}

//用钻石兑换道具接口
- (void)changeProductWithDiamonds:(NSString *)productID {
  [storeUtil changeProductWithDiamonds:productID];
}

//购买钻石弹窗接口
- (void)diamondPopInterface {
  [storeUtil showBuyingDiamondView];
}
#pragma mark
#pragma mark-------购买成功，自动返回----
- (void)changePage {
  //返回上一层
  if (self.traceDelegate && [self.traceDelegate respondsToSelector:@selector(refreshMyTrancingView)]) {
    [self.traceDelegate refreshMyTrancingView];
  }
  [self leftButtonPress];
}
#pragma mark
#pragma mark SimTopBannerViewDelegate
- (void)leftButtonPress {
  [super leftButtonPress];
}

@end
