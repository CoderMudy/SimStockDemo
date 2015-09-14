//
//  ActulTradingRenewcontractViewController.m
//  SimuStock
//
//  Created by jhss_wyz on 15/3/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ActulTradingRenewContractViewController.h"
#import "ApplyActulTradingDayView.h"
#import "ExtendContractInfoView.h"
#import "WFProductContract.h"
#import "ProcessInputData.h"
#import "RechargeAccountViewController.h"
#import "WeiboToolTip.h"
#import "ComposeInterfaceUtil.h"
#import "NetLoadingWaitView.h"
#import "ConfirmPayView.h"

///跳转web页面说明详情
#import "SchollWebViewController.h"

/** 不同屏幕尺寸之间的转换比例 */
#define View_Size_Factor 1

/** 实盘金额、费用信息视图之间的距离 */
#define Apply_ActulTrading_View_Margin (8 * View_Size_Factor)
/** “立即申请”按钮与费用信息视图的距离 */
#define Apply_ActulTrading_Btn_Margin_A (27 * View_Size_Factor)
#define Apply_ActulTrading_Btn_Margin_B (69 * View_Size_Factor)
/** 立即申请按钮的宽和高 */
#define Apply_ActulTrading_Btn_Width (155 * View_Size_Factor)
#define Apply_ActulTrading_Btn_Height (40 * View_Size_Factor)

@interface ActulTradingRenewContractViewController ()

/** 顶部右侧“说明”按钮 */
@property(strong, nonatomic) UIButton *instructionBtn;
/** 选择续约天数视图 */
@property(strong, nonatomic) ApplyActulTradingDayView *tradingDaysView;
/** 管理费信息视图 */
@property(strong, nonatomic) ExtendContractInfoView *tradingInfoView;

/** 合约展期的合约号 */
@property(copy, nonatomic) NSString *contractNo;

/** 合约展期信息 */
@property(strong, nonatomic) WFGetPostponeInfoResult *postponeInfo;
/** 选中天数的合约展期信息 */
@property(strong, nonatomic) WFGetPostponeDetailInfo *postponeDetailInfo;

/** 合约展期入参 */
@property(strong, nonatomic) WFExtendContractParameter *extendContractParameter;

/** 需要支付的总额（单位：元） */
@property(copy, nonatomic) NSString *totalAmount;
/** 优顾账户余额（单位：元） */
@property(copy, nonatomic) NSString *ygBalance;

/** 是否刷新成功（即是否有数据） */
@property(assign, nonatomic) BOOL isDataBinded;

/** 默认选中的实盘天数（单位：天） */
@property(copy, nonatomic) NSString *defaultDay;

/** 确认支付的视图 */
@property(strong, nonatomic) ConfirmPayView *payView;

@end

@implementation ActulTradingRenewContractViewController

- (instancetype)initWithContractNo:(NSString *)contractNo andProdId:(NSString *)prodId {
  if (self = [super init]) {
    self.contractNo = contractNo;
    self.extendContractParameter.prodId = prodId;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setupView];

  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  /// 设置默认选中的天数
  self.defaultDay = nil;

  [self refreshButtonPressDown];
}

#pragma mark ——— 设置子控件相关属性 ———
/** 设置所有子控件 */
- (void)setupView {
  [self.topToolBar resetContentAndFlage:@"配资续约" Mode:TTBM_Mode_Sideslip];

  /**
   * 将实盘金额、天数、费用信息视图以及“申请”按钮添加到实盘申请控制器的可用视图中
   */
  [self.clientView addSubview:self.tradingDaysView];
  [self.clientView addSubview:self.tradingInfoView];

  /** 设置顶部右侧“说明”按钮 */
  [self setupInstructionBtn];

  /** 设置“确认支付”视图 */
  [self createConfirmPayView];

  /** 设置所有子控件的Frame */
  [self setupSubviewFrame];

  [self.tradingDaysView.btnArrays
      enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        [btn addTarget:self
                      action:@selector(clickOnDayButton:)
            forControlEvents:UIControlEventTouchUpInside];
      }];

  [self.instructionBtn addTarget:self
                          action:@selector(clickOnInstructionBtn:)
                forControlEvents:UIControlEventTouchUpInside];
}

/** 设置顶部右侧“说明”按钮 */
- (void)setupInstructionBtn {
  self.instructionBtn.frame =
      CGRectMake(CGRectGetMinX(_indicatorView.frame) - 45, CGRectGetMinY(_indicatorView.frame), 45,
                 CGRectGetHeight(_indicatorView.bounds));
  [self.instructionBtn setTitle:@"说明" forState:UIControlStateNormal];
  self.instructionBtn.titleLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  [self.instructionBtn setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                            forState:UIControlStateNormal];
  [self.instructionBtn setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                                 forState:UIControlStateHighlighted];
  [self.topToolBar addSubview:self.instructionBtn];
}

/** 设置所有子控件的Frame */
- (void)setupSubviewFrame {
  /// 设置续约天数的Frame
  self.tradingDaysView.left = 0;
  self.tradingDaysView.top = 0;
  self.tradingDaysView.width = WIDTH_OF_SCREEN;

  /// 设置费用信息的Frame
  self.tradingInfoView.top = self.tradingDaysView.bottom + Apply_ActulTrading_View_Margin;
  self.tradingInfoView.left = 0;
  self.tradingInfoView.width = WIDTH_OF_SCREEN;
}
/** 创建确认支付的视图 */
- (void)createConfirmPayView {
  self.payView = [ConfirmPayView createdConfirmPayInfoView];
  /** 设置frame  */
  self.payView.top = _clientView.height - 56;
  self.payView.left = 0;
  self.payView.width = WIDTH_OF_SCREEN;

  self.payView.payMoneyLabel.text = @"支付金额 ：";
  [self.payView.confirmPayButton addTarget:self
                                    action:@selector(clickOnApplyBtn:)
                          forControlEvents:UIControlEventTouchUpInside];
  [self.clientView addSubview:self.payView];
  [self.clientView bringSubviewToFront:self.payView];
}
#pragma mark ——— 联网指示器代理 ———
/** 点击刷新按钮响应函数 */
- (void)refreshButtonPressDown {
  /** 调用网络访问请求数据 */
  [self getPostponeInfo];
}

#pragma mark ——— 按钮点击响应函数 ———
/** 天数选择按钮点击响应函数 */
- (void)clickOnDayButton:(UIButton *)clickedBtn {
  if (clickedBtn == nil) {
    return;
  }

  self.tradingDaysView.selectedImage.hidden = NO;

  if (self.tradingDaysView.selectedBtn == clickedBtn) {
    return;
  }

  self.tradingDaysView.selectedBtn.selected = NO;
  clickedBtn.selected = YES;
  self.tradingDaysView.selectedBtn = clickedBtn;

  [self.tradingDaysView setupCheckmarkImage];

  [self refreshWFProductInfo];
}

/** 单击导航栏“说明”按钮响应函数 */
- (void)clickOnInstructionBtn:(UIButton *)clickedBtn {
  [SchollWebViewController
      startWithTitle:@"配资续约说明"
             withUrl:@"http://www.youguu.com/opms/html/" @"article/32/2015/0520/2706.html"];
}

/** 单击“立即申请”按钮响应函数 */
- (void)clickOnApplyBtn:(UIButton *)clickedBtn {
  if (self.isDataBinded == NO) {
    [NewShowLabel setMessageContent:@"无数据，请刷新"];
    return;
  }
  if (self.tradingDaysView.selectedBtn == nil) {
    [NewShowLabel setMessageContent:@"请选择操盘天数"];
    return;
  }
  [self inquireCurrentBalance];
}

#pragma mark ——— 刷新配资信息 ———
/** 刷新配资产品申请信息及页面费用信息 */
- (void)refreshWFProductInfo {
  if (self.tradingDaysView.selectedBtn == nil) {
    return;
  }

  /// 获得展期时长
  NSString *prodTerm = (NSString *)(self.postponeInfo.dayArray[
      [self.tradingDaysView.btnArrays indexOfObject:self.tradingDaysView.selectedBtn]]);

  /// 获得所选天数对应的展期信息
  self.postponeDetailInfo = [self.postponeInfo getPostponeDetailInfoWithProdterm:prodTerm];

  NSString *endDay = @"";
  if (self.postponeDetailInfo.endDay && ![self.postponeDetailInfo.endDay isEqualToString:@""]) {
    endDay = [NSString stringWithFormat:@"到期日：%@", self.postponeDetailInfo.endDay];
  }

  /// 设置配资起始时间及结束时间
  self.tradingDaysView.topRightTitleLable.text = endDay;
  self.tradingDaysView.topRightTitleLable.font = [UIFont systemFontOfSize:Font_Height_12_0];

  /// 设置管理费信息
  NSString *managementFree =
      [ProcessInputData convertMoneyString:self.postponeDetailInfo.mgrAmount];
  [self.tradingInfoView setupManagementInfoWithManagementFee:managementFree];
  //设置支付金额<支付金额与管理费相同>
  self.payView.payMoneyNumberLabel.text = [managementFree stringByAppendingString:@"元"];

  /// 设置合约展期申请参数
  self.extendContractParameter.contractNo = self.postponeInfo.contractNo;
  self.extendContractParameter.prodTerm = self.postponeDetailInfo.prodTerm;
  self.extendContractParameter.orderAbstract = @"";
  self.extendContractParameter.totalAmount = self.postponeDetailInfo.mgrAmount;
  self.extendContractParameter.prodId = self.postponeDetailInfo.prodId;

  /// 设置默认选中的天数
  self.defaultDay = prodTerm;
}

#pragma mark ——— 网络访问相关 ———
/** 合约展期网络接口 */
- (void)extendContract {

  [NetLoadingWaitView startAnimating];
  [self.indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self stopLoading];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak ActulTradingRenewContractViewController *weakSelf = self;
  /// 解析
  callback.onSuccess = ^(NSObject *obj) {
    ActulTradingRenewContractViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self extendContractOnSuccessWithResult:obj];
    }
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    ActulTradingRenewContractViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf extendContractOnErrorWithRequest:obj andExc:exc];
    }
  };
  callback.onFailed = ^{
    ActulTradingRenewContractViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      [BaseRequester defaultFailedHandler];
    }
  };

  [WFProductContract
      extendWFProductContractWithContractNo:self.extendContractParameter.contractNo
                                  andProdId:self.extendContractParameter.prodId
                                andProdTerm:self.extendContractParameter.prodTerm
                           andOrderAbstract:self.extendContractParameter.orderAbstract
                             andTotalAmount:self.extendContractParameter.totalAmount
                                andCallback:callback];
}

/** 获得合约展期信息的网络接口 */
- (void)getPostponeInfo {

  [self.indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    self.isDataBinded = NO;
    [NewShowLabel showNoNetworkTip];
    [self.indicatorView stopAnimating];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak ActulTradingRenewContractViewController *weakSelf = self;
  /// 解析

  callback.onCheckQuitOrStopProgressBar = ^{
    ActulTradingRenewContractViewController *strongSelf = weakSelf;
    if (strongSelf) {
      strongSelf.isDataBinded = NO;
      [strongSelf.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    ActulTradingRenewContractViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self getPostponeInfoOnSuccessWithResult:obj];
    }
  };

  [WFProductContract getPostponeInfoWithContractNo:self.contractNo andCallback:callback];
}

- (void)stopLoading {
  [self.indicatorView stopAnimating];
  [NetLoadingWaitView stopAnimating];
}

#pragma mark ——— 网络访问结果处理 ———
/** 合约展期网络请求成功处理函数 */
- (void)extendContractOnSuccessWithResult:(NSObject *)obj {
  WFGetPostponeInfoResult *result = (WFGetPostponeInfoResult *)obj;

  [NewShowLabel setMessageContent:result.message];
  if ([result.status isEqualToString:@"0000"]) {
    [self stopLoading];
    [self.navigationController popViewControllerAnimated:YES];
  } else {
    [self stopLoading];
  }
}

/** 合约展期网络请求错误处理函数 */
- (void)extendContractOnErrorWithRequest:(BaseRequestObject *)obj andExc:(NSException *)exc {
  [self stopLoading];
  /// 优顾账户余额不足，需要查询余额
  if (obj && [obj.status isEqualToString:@"0015"]) {
    [AppDelegate pushViewControllerFromRight:[[RechargeAccountViewController alloc]
                                                 initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN,
                                                                          HEIGHT_OF_SCREEN)]];
    return;
  } else {
    [BaseRequester defaultErrorHandler](obj, exc);
  }
}

/** 获得合约展期信息网络请求成功处理函数 */
- (void)getPostponeInfoOnSuccessWithResult:(NSObject *)result {
  /// 数据模型赋值
  self.postponeInfo = (WFGetPostponeInfoResult *)result;
  self.tradingDaysView.infoArray = self.postponeInfo.dayArray;

  //设置账户余额
  self.ygBalance = [[ProcessInputData convertMoneyString:self.postponeInfo.ygBalance]
      stringByAppendingFormat:@"元"];
  self.payView.accountBalanceLabel.text = self.ygBalance;

  /// 刷新选择按钮
  [self.tradingDaysView refreshSelectButtons];

  if (self.defaultDay == nil && [self.defaultDay isEqualToString:@""]) {
    self.tradingDaysView.selectedBtn = nil;
  } else {
    [self.postponeInfo.dayArray
        enumerateObjectsUsingBlock:^(NSString *day, NSUInteger idx, BOOL *stop) {
          if ([day isEqualToString:self.defaultDay]) {
            [self clickOnDayButton:self.tradingDaysView.btnArrays[idx]];
            *stop = YES;
          }
        }];
    if (self.tradingDaysView.selectedBtn == nil) {
      self.tradingDaysView.selectedBtn = nil;
    }
  }

  self.isDataBinded = YES;
  [self.indicatorView stopAnimating];
}

/** 查询账户余额网络接口 */
- (void)inquireCurrentBalance {

  [NetLoadingWaitView startAnimating];
  [self.indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self stopLoading];
    return;
  }

  __weak ActulTradingRenewContractViewController *weakSelf = self;
  [WFPayUtil checkWFAccountBalanceWithOwner:self
      andCleanCallBack:^{
        [weakSelf stopLoading];
      }
      andSurePayCallBack:^{
        [weakSelf extendContract];
      }
      andTotalAmountCent:self.extendContractParameter.totalAmount];
}

#pragma mark ——— 子控件懒加载 ———
/** 懒加载顶部右侧“说明”按钮 */
- (UIButton *)instructionBtn {
  if (_instructionBtn == nil) {
    _instructionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  }
  return _instructionBtn;
}

/** 懒加载续约天数视图 */
- (ApplyActulTradingDayView *)tradingDaysView {
  if (_tradingDaysView == nil) {
    _tradingDaysView = [ApplyActulTradingDayView applyActulTradingDayView];
  }
  return _tradingDaysView;
}

/** 懒加载续约信息视图 */
- (ExtendContractInfoView *)tradingInfoView {
  if (_tradingInfoView == nil) {
    _tradingInfoView = [ExtendContractInfoView extendContractInfoView];
  }
  return _tradingInfoView;
}

/** 懒加载合约展期入参 */
- (WFExtendContractParameter *)extendContractParameter {
  if (_extendContractParameter == nil) {
    _extendContractParameter = [[WFExtendContractParameter alloc] init];
  }
  return _extendContractParameter;
}

@end
