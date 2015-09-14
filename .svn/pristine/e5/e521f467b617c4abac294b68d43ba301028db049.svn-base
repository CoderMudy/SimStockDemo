//
//  ExpertScreenViewController.m
//  SimuStock
//
//  Created by jhss_wyz on 15/8/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExpertScreenViewController.h"
#import "ExpertFilterViewController.h"
#import "ExpertOneScreenView.h"
#import "SchollWebViewController.h"
#import "ExpertScreenConditionData.h"
#import "ExpertFilterListWrapper.h"
#import "JsonFormatRequester.h"
#import "UIButton+Block.h"
#import "SimuUtil.h"
#import "NewShowLabel.h"

@implementation ExpertScreenViewController

/** 主视图的高度 */
static const CGFloat MAIN_VIEW_HEIGHT = 892.f;
/** 确认按钮视图的高度 */
static const CGFloat CONFIRM_VIEW_HEIGHT = 66.f;
/** 确认按钮视图的透明度 */
static const CGFloat CONFIRM_VIEW_ALPHA = 0.9f;

- (void)viewDidLoad {
  self.frameInParent = CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN);
  [super viewDidLoad];
  [self resetTitle:@"牛人筛选"];
  [self createInstructionBtn];

  [self createScrollView];
  [self createMainView];
  [self createConfirmView];

  [self refreshButtonPressDown];
}

/** 创建并设置右上角说明按钮 */
- (void)createInstructionBtn {
  self.instructionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.topToolBar addSubview:self.instructionBtn];
  self.instructionBtn.frame = _indicatorView.frame;
  self.indicatorView.right = self.instructionBtn.left;
  [self.instructionBtn setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                                 forState:UIControlStateHighlighted];
  [self.instructionBtn setImage:[UIImage imageNamed:@"helpIcon.png"] forState:UIControlStateNormal];
  [self.instructionBtn setImage:[UIImage imageNamed:@"helpIcon.png"]
                       forState:UIControlStateHighlighted];
  self.instructionBtn.imageEdgeInsets = UIEdgeInsetsMake(12.25f, 10.f, 12.25f, 10.f);
  [self.instructionBtn setTintColor:[UIColor whiteColor]];
  [self.instructionBtn setOnButtonPressedHandler:^{
    /// 跳转web说明页
    NSString *textUrl = @"http://www.baidu.com";
    [SchollWebViewController startWithTitle:@"功能说明" withUrl:textUrl];
  }];
}

/** 创建并设置页面滚动视图 */
- (void)createScrollView {
  self.scrollView = [[UIScrollView alloc] initWithFrame:self.clientView.bounds];
  [self.clientView addSubview:self.scrollView];
  self.scrollView.contentSize = CGSizeMake(self.scrollView.width, MAIN_VIEW_HEIGHT);
  self.scrollView.showsHorizontalScrollIndicator = NO;
  self.scrollView.showsVerticalScrollIndicator = NO;
}

#pragma mark--------- 主视图相关 ---------
/** 创建并设置主视图 */
- (void)createMainView {
  self.mainView = [[[NSBundle mainBundle] loadNibNamed:@"ExpertScreenMainView"
                                                 owner:self
                                               options:nil] lastObject];
  [self.scrollView addSubview:self.mainView];
  self.mainView.frame = CGRectMake(0, 0, self.scrollView.width, MAIN_VIEW_HEIGHT);
  NSArray *tittleArray = @[
    @"超越同期上证指数",
    @"年化收益大于等于",
    @"月均收益大于等于",
    @"最大回撤比例小于等于",
    @"回撤时间占比小于等于",
    @"盈利天数占比大于等于",
    @"成功率大于等于",
    @"平均持股天数小于等于",
    @"交易笔数大于等于"
  ];
  [self.conditionViewarray enumerateObjectsUsingBlock:^(ExpertOneScreenView *oneScreenView, NSUInteger idx, BOOL *stop) {
    oneScreenView.tittleLabel.text = tittleArray[idx];
  }];
}

#pragma mark--------- 确认按钮视图相关 ---------
/** 创建并设置确认按钮视图 */
- (void)createConfirmView {
  self.confirmView = [[[NSBundle mainBundle] loadNibNamed:@"ExpertScreenConfirmView"
                                                    owner:self
                                                  options:nil] lastObject];
  [self.clientView addSubview:self.confirmView];
  self.confirmView.frame = CGRectMake(0, (self.clientView.height - CONFIRM_VIEW_HEIGHT),
                                      self.clientView.width, CONFIRM_VIEW_HEIGHT);
  self.lineViewHeight.constant = 0.5f;
  [self.view bringSubviewToFront:self.confirmView];
  self.confirmView.backgroundColor = [Globle colorFromHexRGB:@"#FFFFFF" alpha:CONFIRM_VIEW_ALPHA];
  self.confirmBtn.normalBGColor = [Globle colorFromHexRGB:Color_WFOrange_btn];
  self.confirmBtn.highlightBGColor = [Globle colorFromHexRGB:Color_WFOrange_btnDown];
  __weak ExpertScreenViewController *weakSelf = self;
  [self.confirmBtn setOnButtonPressedHandler:^{
    if (weakSelf) {
      [weakSelf clickOnConfirmBtn];
    }
  }];
}

/** 确认按钮点击响应函数 */
- (void)clickOnConfirmBtn {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  self.filterCondition = [[ExpertFilterCondition alloc] init];
  /// 同期证指数
  self.filterCondition.condiWinRate = [self.largeThanStockIndexView.selectedConditon floatValue];
  /// 年华收益
  self.filterCondition.condiAnnualProfit = [self.annualizedReturnView.selectedConditon floatValue];
  /// 月均收益
  self.filterCondition.monthAvgProfitRate = [self.monthAvgProfitRateView.selectedConditon floatValue];
  /// 最大回撤比例
  self.filterCondition.condiMaxBackRate = [self.retracementRadioView.selectedConditon floatValue];
  /// 回撤时间占比
  self.filterCondition.condiBackRate = [self.retracementTimeView.selectedConditon floatValue];
  /// 盈利天数占比
  self.filterCondition.condiProfitDaysRate = [self.profitableDaysLabel.selectedConditon floatValue];
  /// 成功率
  self.filterCondition.condiSucRate = [self.successRateView.selectedConditon floatValue];
  /// 平均持股天数
  self.filterCondition.condiAvgDays = [self.holdDaysView.selectedConditon intValue];
  /// 交易笔数
  self.filterCondition.condiCloseNum = [self.transactionNumberView.selectedConditon intValue];
  /// 跳转筛选结果控制器
  ExpertFilterViewController *filterVC =
      [[ExpertFilterViewController alloc] initWithExpertFilterConditions:self.filterCondition];
  [AppDelegate pushViewControllerFromRight:filterVC];
}

#pragma mark--------- 网络请求相关 ---------
/** 刷新按钮点击响应函数 */
- (void)refreshButtonPressDown {
  [self.indicatorView startAnimating];
  if (self.dataBinded) {
    [self.indicatorView stopAnimating];
    return;
  }
  [self requetExpertScreenConditionData];
}

/** 筛选牛人条件区间网络请求 */
- (void)requetExpertScreenConditionData {
  if (![SimuUtil isExistNetwork]) {
    [self.indicatorView stopAnimating];
    [NewShowLabel showNoNetworkTip];
    [self requestExpertScreenConditionDataFailedOrError];
    return;
  }
  __weak ExpertScreenViewController *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    ExpertScreenViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    if (weakSelf) {
      [weakSelf bindExpertScreenConditionData:obj];
    }
  };

  callback.onError = ^(BaseRequestObject *err, NSException *ex) {
    ExpertScreenViewController *strongSelf = weakSelf;
    if (strongSelf) {
      if ([err.status isEqualToString:@"0101"]) {
        [BaseRequester defaultErrorHandler](err, ex);
      } else {
        [NewShowLabel setMessageContent:err.message];
        [strongSelf requestExpertScreenConditionDataFailedOrError];
      }
    }
  };

  callback.onFailed = ^() {
    ExpertScreenViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [NewShowLabel showNoNetworkTip];
      [strongSelf requestExpertScreenConditionDataFailedOrError];
    }
  };

  [ExpertScreenConditionData requetExpertScreenConditionDataWithCallback:callback];
}

/** 绑定数据 */
- (void)bindExpertScreenConditionData:(NSObject *)obj {
  self.conditionData = (ExpertScreenConditionData *)obj;
  self.dataBinded = YES;
  [self.conditionViewarray enumerateObjectsUsingBlock:^(ExpertOneScreenView *oneScreenView, NSUInteger idx, BOOL *stop) {
    if (idx < self.conditionViewarray.count - 2) {
      [oneScreenView resetWithAConditionInterval:self.conditionData.dataArray[idx]
                                conditionIsFloat:YES];
    } else {
      [oneScreenView resetWithAConditionInterval:self.conditionData.dataArray[idx]
                                conditionIsFloat:NO];
    }
  }];
}

/** 网络请求失败或出错时 */
- (void)requestExpertScreenConditionDataFailedOrError {
  if (self.dataBinded) {
    return;
  }
  [self.conditionViewarray enumerateObjectsUsingBlock:^(ExpertOneScreenView *oneScreenView, NSUInteger idx, BOOL *stop) {
    if (idx < self.conditionViewarray.count - 2) {
      [oneScreenView resetWithAConditionInterval:nil conditionIsFloat:YES];
    } else {
      [oneScreenView resetWithAConditionInterval:nil conditionIsFloat:NO];
    }
  }];
}

@end
