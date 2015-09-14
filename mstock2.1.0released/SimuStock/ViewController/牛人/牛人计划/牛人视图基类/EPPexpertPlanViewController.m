//
//  EPPexpertPlanViewController.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "EPPexpertPlanViewController.h"
#import "SimuRTBottomToolBar.h"
#import "ExpertPlanViewController.h"
#import "simuBuyViewController.h"
#import "simuCancellationViewController.h"
#import "FollowBuyClientVC.h"

@interface EPPexpertPlanViewController () <simuBottomTrendBarViewDelegate> {
  // accoundId
  NSString *_accoundId;
  // targetUid
  NSString *_targetUid;
  // titleName
  NSString *_titleName;

  //子页面的高度
  CGRect subViewFrame;
}

@end

@implementation EPPexpertPlanViewController

- (id)initAccountId:(NSString *)accounId
      withTargetUid:(NSString *)targetUid
      withTitleName:(NSString *)titleName {
  self = [super init];
  if (self) {
    _accoundId = accounId;
    _targetUid = targetUid;
    _titleName = titleName;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _planStateBool = NO;

  subViewFrame = CGRectMake(0, 0, self.view.bounds.size.width,
                            self.view.bounds.size.height - BOTTOM_TOOL_BAR_HEIGHT);
  //创建底部导航栏
  [self createBottomToolBar];

  [self crateAccountViewController];
}

#pragma mark - 创建牛人视角的 买入卖出栏
- (void)createBottomToolBar {
  NSArray *nameArray = @[ @"账户", @"买入", @"卖出", @"查委托" ];
  //普通图片名称
  NSArray *upnameArray = @[ @"交易_UP", @"买入_up", @"卖出_up", @"查委托_up" ];
  //按下图片名称数组
  NSArray *downnameArray = @[ @"交易_down", @"买入_down", @"卖出_down", @"查委托_down" ];
  NSMutableArray *arra = [[NSMutableArray alloc] init];
  for (int i = 0; i < [nameArray count]; i++) {
    MarketBottomButtonInfo *info = [[MarketBottomButtonInfo alloc] init];
    info.notSellectedImageName = upnameArray[i];
    info.sellectedImageName = downnameArray[i];
    info.titleName = nameArray[i];
    [arra addObject:info];
  }
  _expertBottomToolBar = [[SimuRTBottomToolBar alloc]
      initWithFrame:CGRectMake(0, self.view.bounds.size.height - BOTTOM_TOOL_BAR_HEIGHT,
                               self.view.bounds.size.width, BOTTOM_TOOL_BAR_HEIGHT)
        ContenArray:arra];
  _expertBottomToolBar.hidden = YES;
  _expertBottomToolBar.delegate = self;
  [self.view addSubview:_expertBottomToolBar];
}

//点击左边按钮
- (void)leftPressDown {
}
//点击右边按钮
- (void)rightPressDown {
}

//底部按钮 点击事件
- (void)pressDownIndex:(NSInteger)index {
  if (index == 0) {
    //创建账户界面
    [self crateAccountViewController];
  } else if (index == 1) {
    //买入界面
    [self createBuyStockVC];

  } else if (index == 2) {
    //卖出界面
    [self createSellStockVC];

  } else if (index == 3) {
    //查委托界面
    [self createStockCancellationVC];
  }
}

#pragma mark - 创建首页账户
- (void)crateAccountViewController {

  if (_mainExpertPlanVC == nil) {
    _mainExpertPlanVC = [[ExpertPlanViewController alloc] initWithAccountId:_accoundId
                                                              withTargetUid:_targetUid
                                                                   withName:_titleName];
    [_mainExpertPlanVC setBackButtonPressedHandler:self.commonBackHandler];

    __weak EPPexpertPlanViewController *weakSelf = self;
    PositonCellButtonCallback buyAction = ^(PositionInfo *positionInfo) {
      EPPexpertPlanViewController *strongSelf = weakSelf;
      if (strongSelf) {
        if ([strongSelf.mainExpertPlanVC.expertPlan judgeExpert]) {
          [strongSelf pressDownIndex:1];
          [strongSelf.expertBottomToolBar resetinterface:1];
          [strongSelf.stockBuyVC resetWithStockCode:positionInfo.stockCode
                                      withStockName:positionInfo.stockName];
        } else {
          FollowBuyClientVC *vc =
              [[FollowBuyClientVC alloc] initWithStockCode:positionInfo.stockCode
                                             withStockName:positionInfo.stockName
                                                 withIsBuy:YES];
          [AppDelegate pushViewControllerFromRight:vc];
        }
      }
    };

    PositonCellButtonCallback sellAction = ^(PositionInfo *positionInfo) {
      EPPexpertPlanViewController *strongSelf = weakSelf;
      if (strongSelf) {
        if ([strongSelf.mainExpertPlanVC.expertPlan judgeExpert]) {

          [strongSelf pressDownIndex:2];
          [strongSelf.expertBottomToolBar resetinterface:2];
          [strongSelf.stockSellVC resetWithStockCode:positionInfo.stockCode
                                       withStockName:positionInfo.stockName];

        } else {
          FollowBuyClientVC *vc =
              [[FollowBuyClientVC alloc] initWithStockCode:positionInfo.stockCode
                                             withStockName:positionInfo.stockName
                                                 withIsBuy:NO];
          [AppDelegate pushViewControllerFromRight:vc];
        }
      }
    };

    _mainExpertPlanVC.planExpertData = ^(ExpertPlanData *expertPlanData) {
      EPPexpertPlanViewController *strongSelf = weakSelf;
      if (strongSelf) {
        strongSelf.planStateBool = YES;
        strongSelf.planData = expertPlanData;
        [strongSelf returnPlanStateForExpert];
      }
    };
    _mainExpertPlanVC.buyAction = buyAction;
    _mainExpertPlanVC.sellAction = sellAction;

    [self addChildViewController:_mainExpertPlanVC];
    [self.view addSubview:_mainExpertPlanVC.view];
    _mainExpertPlanVC.simuBottomToolBar = _expertBottomToolBar;
    [self.view bringSubviewToFront:_expertBottomToolBar];
  } else {
    [self.view bringSubviewToFront:_mainExpertPlanVC.view];
    [self.view bringSubviewToFront:_expertBottomToolBar];
  }
  if (_planStateBool) {
    [self returnPlanStateForExpert];
  }
}

//判断 各种状态
- (BOOL)returnPlanStateForExpert {
  BOOL isEnd = YES;
  PlanState _planSate = self.planData.planState;
  switch (_planSate) {
  case PlanStateFrozen:
    //该计划已冻结
    [NewShowLabel setMessageContent:@"该计划已被冻结"];
    isEnd = NO;
    break;
  case PlanStateSuccessfullyClosed:
    //成功关闭
    [NewShowLabel setMessageContent:@"该计划已成功结束"];
    isEnd = NO;
    break;
  case PlanStateFailedClosed:
    //失败关闭
    [NewShowLabel setMessageContent:@"该计划失败结束"];
    isEnd = NO;
    break;
  case PlanStateAdvanceStopClosed:
    //提前终止
    [NewShowLabel setMessageContent:@"该计划已终止结束"];
    isEnd = NO;
    break;
  case PlanStateOnShelf:
    //未上架
    [NewShowLabel setMessageContent:@"该计划未上架"];
    isEnd = NO;
    break;
  case PlanStateRecruitmengPeriod: {
    if (_planData.state == ExpertPerspectiveState || self.planData.state == UserPurchasedState) {
      [NewShowLabel setMessageContent:@"牛人计划未开始运行"];
      isEnd = NO;
    }
  } break;
  case PlanStateOffShelf:
    //下架
    [NewShowLabel setMessageContent:@"该计划已下架"];
    isEnd = NO;
    break;
  case PlanStateRunning:
    break;
  }
  return isEnd;
}

//买入 界面
- (void)createBuyStockVC {

  if (_planStateBool) {
    if (![self returnPlanStateForExpert]) {
      return;
    }
  }

  if (_stockBuyVC == nil) {
    _stockBuyVC = [[simuBuyViewController alloc] initWithStockCode:@""
                                                     withStockName:@""
                                                       withMatchId:@"1"
                                                     withAccountId:_accoundId
                                              withStockSellBuyType:StockBuySellExpentType
                                                     withTitleName:_titleName
                                                     withTargetUid:_targetUid];
    [_stockBuyVC setBackButtonPressedHandler:self.commonBackHandler];
    _stockBuyVC.view.backgroundColor = [UIColor redColor];
    _stockBuyVC.view.frame = subViewFrame;
    CGRect clineFrame = _stockBuyVC.clientView.frame;
    clineFrame.size.height = _stockBuyVC.clientView.size.height - BOTTOM_TOOL_BAR_HEIGHT;
    _stockBuyVC.clientView.frame = clineFrame;

    [self addChildViewController:_stockBuyVC];
    [self.view addSubview:_stockBuyVC.view];
  } else {
    [self.view bringSubviewToFront:_stockBuyVC.view];
  }
}

//卖出 界面
- (void)createSellStockVC {

  if (_planStateBool) {
    if (![self returnPlanStateForExpert]) {
      return;
    }
  }

  if (_stockSellVC == nil) {
    _stockSellVC = [[simuSellViewController alloc] initWithStockCode:@""
                                                       withStockName:@""
                                                         withMatchId:@"1"
                                                       withAccountId:_accoundId
                                                withStockSellBuyType:StockBuySellExpentType
                                                       withTitleName:_titleName
                                                       withTargetUid:_targetUid];
    [_stockSellVC setBackButtonPressedHandler:self.commonBackHandler];
    _stockSellVC.view.frame = subViewFrame;
    [self addChildViewController:_stockSellVC];
    [self.view addSubview:_stockSellVC.view];
  } else {
    [self.view bringSubviewToFront:_stockSellVC.view];
  }
}

//查委托 撤单界面
- (void)createStockCancellationVC {

  if (_planStateBool) {
    if (![self returnPlanStateForExpert]) {
      return;
    }
  }

  if (_stockCancellationVC == nil) {
    _stockCancellationVC =
        [[simuCancellationViewController alloc] initWithMatchId:@"1"
                                                  withAccountId:_accoundId
                                                  withTitleName:_titleName
                                               withUserOrExpert:StockBuySellExpentType];
    _stockCancellationVC.view.frame = subViewFrame;
    [self addChildViewController:_stockCancellationVC];
    [self.view addSubview:_stockCancellationVC.view];
  } else {
    [_stockCancellationVC doqueryWithRequestFromUser:NO];
    [self.view bringSubviewToFront:_stockCancellationVC.view];
  }
}

@end
