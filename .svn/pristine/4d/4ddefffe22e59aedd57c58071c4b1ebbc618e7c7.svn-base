//
//  ExpertPlanViewController.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExpertPlanViewController.h"
#import "UserHeadImageView.h"

#import "ExpertPlanTableViewController.h"
#import "UserAssetsData.h"

#import "PanicBuyingView.h"
#import "EPPlanTableHeaderPresentation.h"
#import "SimuRTBottomToolBar.h"
#import "EPCloseExpertPlanRequest.h"

@interface ExpertPlanViewController () <UIAlertViewDelegate> {

  /// title
  NSString *_titleName;
  //请求参数
  NSString *_accountId;
  NSString *_targetUid;

  EPPlanTableHeaderPresentation *tableHeaderPresentation;
  //底部
  SimuRTBottomToolBar *_bottomToolBar;

  // tableview
  ExpertPlanTableViewController *_expertPlanTableViewVC;
  //头的view
  EPPlanTableHeader *tableViewHeaeder;
  //更多button
  UIButton *_shareButton;

  //是否刷新
  BOOL _refreshBool;

  //是否终止协议
  BOOL _stopOperationgAgreement;

  //判断 界面有没有创建
  BOOL _viewCreate;
}

//购买提示View
@property(strong, nonatomic) PanicBuyingView *panicBuying;

/** 是否刷新 */
@property(assign, nonatomic) BOOL refreshBool;

/** 界面是否创建了 */
@property(assign, nonatomic) BOOL viewCreate;
@end

@implementation ExpertPlanViewController

- (void)dealloc {
  //  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:Notification_CP_SendCattle_LoginSuccess
              object:nil];
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:Notification_CP_BuyPlan_LoginSuccess
              object:nil];
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:Notification_CP_BuyPlanSuccess
              object:nil];
  NSLog(@"界面以释放");
}

- (id)initWithAccountId:(NSString *)accountId
          withTargetUid:(NSString *)targetUid
               withName:(NSString *)name {
  if (self = [super init]) {
    _accountId = accountId;
    _targetUid = targetUid;
    _titleName = name;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_indicatorView startAnimating];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(sendCattleRefresh)
             name:Notification_CP_SendCattle_LoginSuccess
           object:nil];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(buyPlanRefresh)
             name:Notification_CP_BuyPlan_LoginSuccess
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(buyPlanSuccess)
             name:Notification_CP_BuyPlanSuccess
           object:nil];

  _dic = [[NSDictionary alloc] init];
  _refreshBool = NO;
  _stopOperationgAgreement = NO;
  _viewCreate = NO;
  //导航栏
  [_topToolBar resetContentAndFlage:_titleName Mode:TTBM_Mode_Leveltwo];
  //数据请求
  [self getExpertPlanData];
  //创建分享栏
  [self createButtonShare];

  //创建 更多按钮
  if (_moreShareExplainRefreshView == nil) {
    [self createMoreSelectedView];
  }
}

- (void)buyPlanSuccess {
  [self refreshButton:NO];
}

- (void)sendCattleRefresh {
  self.refreshType = Notification_CP_SendCattle_LoginSuccess;
  [self refreshButtonPressDown];
}

- (void)buyPlanRefresh {
  self.refreshType = Notification_CP_BuyPlan_LoginSuccess;
  //通知刷新
  _viewCreate = NO;
  [self refreshButtonPressDown];
}

- (void)createMoreSelectedView {
  _moreShareExplainRefreshView =
      [[[NSBundle mainBundle] loadNibNamed:@"MoreShareExplainRefreshView"
                                     owner:self
                                   options:nil] firstObject];
  _moreShareExplainRefreshView.hidden = YES;
  _moreShareExplainRefreshView.layer.masksToBounds = YES;
  [_moreShareExplainRefreshView expertOrUser:_dic];
  __weak ExpertPlanViewController *weakSelf = self;
  _moreShareExplainRefreshView.sharePressCallBack = ^() {
    ExpertPlanViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf shareCallBack];
    }
  };
  _moreShareExplainRefreshView.explanationCallBack = ^() {
    ExpertPlanViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf explanationCallBack];
    }
  };

  _moreShareExplainRefreshView.earlyTerminationCallBack = ^() {
    ExpertPlanViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf earlyTerminationCallBack];
    }
  };

  _moreShareExplainRefreshView.operatingAgreementCallBack = ^() {
    ExpertPlanViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf operationgAgreementCallBack];
    }
  };

  [WINDOW addSubview:_moreShareExplainRefreshView];
}

//操作协议回调
- (void)operationgAgreementCallBack {
  NSString *url =
      @"http://www.youguu.com/opms/html/article/32/2015/0717/2727.html";
  [AppDelegate pushViewControllerFromRight:
                   [[SchollWebViewController alloc]
                       initWithNameTitle:@"牛人计划操作协议"
                                 andPath:url]];
}

//说明回调
- (void)explanationCallBack {
  NSString *url =
      @"http://www.youguu.com/opms/html/article/32/2015/0717/2726.html";
  [AppDelegate
      pushViewControllerFromRight:[[SchollWebViewController alloc]
                                      initWithNameTitle:@"牛人计划说明"
                                                andPath:url]];
}

//分享回调
- (void)shareCallBack {
  NSString *url = @"http://test.youguu.com/mobile/wap_advertise/150716/";
  [AppDelegate
      pushViewControllerFromRight:[[SchollWebViewController alloc]
                                      initWithNameTitle:@"牛人计划分享"
                                                andPath:url]];
}

#pragma mark-- 加载 小菊花
- (void)startLoadWaitView {
  [_indicatorView startAnimating];
}

#pragma mark-- 停止 小菊花
- (void)stopLoadWaitView {
  [_indicatorView stopAnimating];
}

//提前终止协议回调
- (void)earlyTerminationCallBack {
  NSString *message = @"若当前收益大于目标收益,"
                      @"并且没有股票持仓。可以申请提前结束,"
                      @"视为计划成功。是否提前终止牛人计划?";
  [self creatAlartView:message];
}
//创建警告框
- (void)creatAlartView:(NSString *)showcontent {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                  message:showcontent
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确定", nil];
  alert.tag = 202;
  [alert show];
}

///点击 确定按钮
- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  _stopOperationgAgreement = NO;
  if (buttonIndex == 1) {
    [self startLoadWaitView];
    [self closeExpertPlanWithAccountId:_accountId];
  } else {
    //取消
  }
}

- (void)getUserAssetsData {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak ExpertPlanViewController *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
    ExpertPlanViewController *strongSelf = weakSelf;
    if (strongSelf) {
      //绑定数据
      [strongSelf.panicBuying
          bindAccountBalance:((UserAssetsData *)obj).amount];
      [strongSelf postBuyPlanNotification];
    }
  };
  callback.onFailed = ^() {
    NSLog(@"fsfdsfsd");
  };
  [UserAssetsData requestUserAssetsWithCallback:callback];
}

- (void)bingUserAssetsData:(NSString *)amount
            withDictionary:(NSDictionary *)dic {
  NSDictionary *userAssetsDic = @{
    @"amount" : amount,
    @"trackPrice" : dic[@"trackPrice"],
    @"itemState" : dic[@"itemState"],
    @"accountID" : dic[@"accountID"],
    @"targetUid" : dic[@"targetUid"],
    @"userState" : dic[@"userState"]
  };
  [self.panicBuying bingDataForPanicBuying:userAssetsDic];
  [self postBuyPlanNotification];
}

//请求牛人主页数据
- (void)getExpertPlanData {

  //判断网络
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self stopLoadWaitView];
    if (!_viewCreate) {
      [_littleCattleView isCry:YES];
    }
    return;
  }
  _littleCattleView.hidden = YES;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak ExpertPlanViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^() {
    ExpertPlanViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoadWaitView];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    ExpertPlanViewController *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.refreshBool) {
        [strongSelf refreshDataForView:(ExpertPlanData *)obj];
      } else {
        strongSelf.viewCreate = YES;
        [strongSelf bindExpertPlanData:(ExpertPlanData *)obj];
      }
    }
  };

  callback.onFailed = ^() {
    ExpertPlanViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoadWaitView];
    }
  };
  NSDictionary *dic = @{ @"accountId" : _accountId, @"targetUid" : _targetUid };

  [ExpertPlanData requestHomeDataForExpertPlanWithDictionary:dic withCallback:callback];
}
#pragma mark-- 创建tableview
- (void)bindExpertPlanData:(ExpertPlanData *)expertPlan {
  self.expertPlan = expertPlan;
  //计划状态
  if (self.planExpertData) {
    self.planExpertData(expertPlan);
  }

  if ([_titleName isEqualToString:@""]) {
    _topToolBar.sbv_nameLable.text = expertPlan.planName;
  }

  _dic = @{
    @"state" : @(expertPlan.state),
    @"planState" : @(expertPlan.planState),
  };
  self.simuBottomToolBar.hidden = YES;

  if (tableHeaderPresentation) {
    [tableHeaderPresentation removeAllViews];
  }

  tableViewHeaeder = [[[NSBundle mainBundle] loadNibNamed:@"EPPlanTableHeader"
                                                    owner:self
                                                  options:nil] lastObject];

  if (self.panicBuying) {
    self.panicBuying.hidden = YES;
  }
  //第一种 用户视角: 用户未购买 + 计划在募集期 未运行
  if ([expertPlan isUserWithPlanPrepare]) {
    [self cratePanicBuying];
    tableHeaderPresentation = [[UserWithPlanPrepareEPTHPresentation alloc]
        initWithEPPlanTableHeader:tableViewHeaeder
               withExpertPlanData:expertPlan];

  } else if ([expertPlan isUserWithPlanRunning]) {
    //情况二 用户视角 不管买没卖 计划运行中
    tableHeaderPresentation = [[UserWithPlanRunningEPTHPresentation alloc]
        initWithEPPlanTableHeader:tableViewHeaeder
               withExpertPlanData:expertPlan];

  } else if ([expertPlan isExpertPlanRecruitmengPeriod]) {
    self.simuBottomToolBar.hidden = NO;
    //情况 三 牛人视角 计划未运行
    tableHeaderPresentation = [[ExpertWithPlanNotRunningEPTHPresentation alloc]
        initWithEPPlanTableHeader:tableViewHeaeder
               withExpertPlanData:expertPlan];

  } else if ([expertPlan isExpertPlanWithRunning]) {
    self.simuBottomToolBar.hidden = NO;
    //牛人视角  计划运行中
    tableHeaderPresentation = [[ExpertWithPlanRunningEPTHPresentation alloc]
        initWithEPPlanTableHeader:tableViewHeaeder
               withExpertPlanData:expertPlan];
  }
  CGFloat buyHeight = 0.0f;
  if (expertPlan.state == ExpertPerspectiveState) {
    buyHeight = BOTTOM_TOOL_BAR_HEIGHT;
  } else if (expertPlan.state == UserNotPurchasedState) {
    buyHeight = CGRectGetHeight(self.panicBuying.bounds);
  }
  CGRect frame = CGRectMake(0, 0, _clientView.bounds.size.width,
                            _clientView.height - buyHeight);
  _expertPlanTableViewVC =
      [[ExpertPlanTableViewController alloc] initWithFrame:frame
                                             withAccountID:_accountId
                                             withTargetUid:_targetUid
                                        withExpertPlanData:expertPlan];
  _expertPlanTableViewVC.buyAction = self.buyAction;
  _expertPlanTableViewVC.sellAction = self.sellAction;
  __weak ExpertPlanViewController *weakSelf = self;
  _expertPlanTableViewVC.pullDownRefreshAction = ^{
    [weakSelf refreshButtonPressDown];

  };
  [self.clientView addSubview:_expertPlanTableViewVC.view];
  [self addChildViewController:_expertPlanTableViewVC];
  [_expertPlanTableViewVC refreshButtonPressDown];
  _expertPlanTableViewVC.tableView.tableHeaderView = tableViewHeaeder;
}

- (void)cratePanicBuying {
  //创建购买提示view
  if (self.panicBuying == nil) {
    self.panicBuying = [PanicBuyingView createPanicBuyingView];
    self.panicBuying.frame =
        CGRectMake(0, CGRectGetHeight(self.clientView.bounds) -
                          CGRectGetHeight(self.panicBuying.bounds),
                   CGRectGetWidth(self.clientView.bounds),
                   CGRectGetHeight(self.panicBuying.bounds));
    [self.clientView addSubview:self.panicBuying];
  }
  self.panicBuying.hidden = NO;
  [self.clientView bringSubviewToFront:self.panicBuying];
  NSDictionary *dic = @{
    @"trackPrice" : @(self.expertPlan.buyingTips.trackPrice),
    @"itemState" : @(self.expertPlan.buyingTips.itemState),
    @"accountID" : self.expertPlan.accoundId,
    @"targetUid" : @(self.expertPlan.targetUid),
    @"userState" : @(self.expertPlan.state)
  };
  //绑定抢购控件数据
  [self.panicBuying bingDataForPanicBuying:dic];
  //请求账号余额
  [self getUserAccountPrice];
}

#pragma makr - 创建导航栏上面的分享栏
- (void)createButtonShare {
  CGRect frame = self.view.frame;
  _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _shareButton.frame = CGRectMake(frame.size.width - 44,
                                  _topToolBar.bounds.size.height - 45, 44, 45);
  UIImage *shareImage = [UIImage imageNamed:@"MoreLogo"];
  [_shareButton setImage:shareImage forState:UIControlStateNormal];
  [_shareButton setImage:shareImage forState:UIControlStateHighlighted];
  [_shareButton setBackgroundImage:nil forState:UIControlStateNormal];
  //按钮选中中视图
  UIImage *mtvc_centerImage = [[UIImage imageNamed:@"return_touch_down.png"]
      resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 14, 14)];
  [_shareButton setBackgroundImage:mtvc_centerImage
                          forState:UIControlStateHighlighted];
  [_shareButton addTarget:self
                   action:@selector(showMoreSelectedView)
         forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_shareButton];
  _indicatorView.frame =
      CGRectMake(_shareButton.left - _indicatorView.frame.size.width,
                 _indicatorView.frame.origin.y, _indicatorView.frame.size.width,
                 _indicatorView.frame.size.height);
}

#pragma mark-- 刷新按钮
- (void)refreshButtonPressDown {
  [self refreshButton:_viewCreate];
}

//刷新控件
- (void)refreshButton:(BOOL)isEnd {
  //启动 大菊花
  [self startLoadWaitView];
  _refreshBool = isEnd;
  //刷新数据
  [self getExpertPlanData];
}

- (void)showMoreSelectedView {
  _moreShareExplainRefreshView.hidden = NO;
  [_moreShareExplainRefreshView expertOrUser:_dic];
  [self.view bringSubviewToFront:self.moreShareExplainRefreshView];
}

- (void)postBuyPlanNotification {
  if (self.expertPlan.state != ExpertPerspectiveState) {
    if ([self.refreshType
            isEqualToString:Notification_CP_BuyPlan_LoginSuccess]) {
      [[NSNotificationCenter defaultCenter]
          postNotificationName:Notification_CP_BuyPlan_RefreshSuccess
                        object:self
                      userInfo:nil];
      self.refreshType = @"";
    }
  }
}

- (void)postSendCattleNotification {
  if (self.expertPlan.state != ExpertPerspectiveState) {
    if ([self.refreshType
            isEqualToString:Notification_CP_SendCattle_LoginSuccess]) {
      [[NSNotificationCenter defaultCenter]
          postNotificationName:Notification_CP_SendCattle_RefreshSuccess
                        object:self
                      userInfo:nil];
      self.refreshType = @"";
    }
  }
}

#pragma makr-- 刷新工具
- (void)refreshDataForView:(ExpertPlanData *)data {
  [tableHeaderPresentation refreshExpertPlanHeadeData:data];
  //刷新 抢购框
  if (self.panicBuying) {
    [self getUserAccountPrice];
  }
  [_expertPlanTableViewVC refreshButtonPressDown];
  [self stopLoadWaitView];
  [self postSendCattleNotification];
}

///刷新 或 请求 账号资产
- (void)getUserAccountPrice {
  [self getUserAssetsData];
}

#pragma mark-- 关闭牛人计划
- (void)closeExpertPlanWithAccountId:(NSString *)accountId {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self stopLoadWaitView];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak ExpertPlanViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^() {
    ExpertPlanViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoadWaitView];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    [NewShowLabel setMessageContent:@"牛人计划成功终止"];
  };
  callback.onFailed = ^() {
    ExpertPlanViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoadWaitView];
    }
    [NewShowLabel setMessageContent:@"计划终止失败"];
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    if (obj.message) {
      [NewShowLabel setMessageContent:obj.message];
    }
  };

  [EPCloseExpertPlanRequest requestClosePlanWithAccountId:_accountId
                                             withCallback:callback];
}

@end
