//
//  StockPositionViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-2-11.
//  Copyright (c) 2014年 Mac. All rights reserved.
//
#import "StockPositionViewController.h"
#import "JhssImageCache.h"
#import "FoundMasterPurchViewConroller.h"
#import "SimuFollowingData.h"
#import "SimuShowUserHeadData.h"
#import "UserGradeView.h"
#import "UIButton+Hightlighted.h"
#import "AttentionEventObserver.h"
#import "SimuConfigConst.h"
#import "NetShoppingMallBaseViewController.h"

@interface StockPositionViewController () <refreshMyTrancingViewDelegate>

@end

@implementation StockPositionViewController

//协议 续约成功 或者 追踪成功后 自动刷新页面
- (void)refreshMyTrancingView {
  [self getFromNet];
}

- (id)initWithID:(NSString *)userid
    withNickName:(NSString *)nickName
     withHeadPic:(NSString *)imageName
     withMatchID:(NSString *)matchID
     withViptype:(NSInteger)vipType
    withUserItem:(UserListItem *)userItem {
  if (self = [super init]) {
    self.userID = userid;
    self.nickName = nickName;
    self.headPicName = imageName;
    self.matchID = matchID;
    self.stock_vipType = vipType;
    _userListItem = userItem;
    _userListItem.nickName = _nickName;
    spve_selectedRow.row = -1;
    spve_selectedRow.section = -1;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  //顶部工具栏
  [self topBanner];
  //个人信息
  [self createPersonInfo];
  //持仓和清仓表格和小牛
  [self createPositionAndClosedPositionTableViews];
  //菊花
  [self creatTradeIndecaterView];
  //创建持仓清仓切换按钮
  [self createSwitchButtons];

  [self getFromNet];
}

#pragma mark - 创建选择按钮控件
- (void)createSwitchButtons {
  _switchButtons = [[StockPositionSwitchButtonsView alloc]
      initWithFrame:CGRectMake(0, self.view.frame.size.height -
                                      BOTTOM_TOOL_BAR_HEIGHT,
                               self.view.frame.size.width,
                               BOTTOM_TOOL_BAR_HEIGHT)];
  [self.view addSubview:_switchButtons];
  //设定回调函数
  __weak StockPositionViewController *weakSelf = self;
  _switchButtons.switchButtonsClickBlock = ^(BOOL isPosition) {
    StockPositionViewController *strongSelf = weakSelf;
    if (strongSelf) {
      //刷新tableview
      [strongSelf switchButtonClicked:isPosition];
    }
  };
}

#pragma mark - 根据按下的按钮来刷新表格
- (void)switchButtonClicked:(BOOL)isPositionButtonClicked {
  _isPositionButtonClicked = isPositionButtonClicked;
  //切换表格
  if (_isPositionButtonClicked) {
    if (!currentPositionViewController.dataBinded) {
      [self refreshButtonPressDown];
    }
    currentPositionViewController.view.hidden = NO;
    closedPositionViewController.view.hidden = YES;
  } else {
    if (!closedPositionViewController.dataBinded) {
      [closedPositionViewController refreshButtonPressDown];
      [self getClearStocknumber];
    }
    currentPositionViewController.view.hidden = YES;
    closedPositionViewController.view.hidden = NO;
  }
}

//顶部工具栏
- (void)topBanner {
  NSString *user_id = [SimuUtil getUserID];
  if ([self.userID isEqualToString:user_id] == YES) {
    [_topToolBar resetContentAndFlage:@"我的持仓" Mode:TTBM_Mode_Leveltwo];
  } else {
    [_topToolBar resetContentAndFlage:@"TA的持仓" Mode:TTBM_Mode_Leveltwo];
  }
}

- (void)creatTradeIndecaterView {
  spvc_indicator = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  spvc_indicator.center = trackButton.center;
  [_userMideView addSubview:spvc_indicator];
}

- (void)createPersonInfo {
  UIView *middleView = _userMideView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 58)];
  middleView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  UIImageView *userImageView = _headImageView =
      [[UIImageView alloc] initWithFrame:CGRectMake(6, 11, 38, 38)];
  [userImageView setBackgroundColor:[Globle colorFromHexRGB:@"87c8f1"]];
  [JhssImageCache setImageView:userImageView
                       withUrl:self.headPicName
          withDefaultImageName:@"用户默认头像"];
  CALayer *userLayer = userImageView.layer;
  [userLayer setMasksToBounds:YES];
  [userLayer setCornerRadius:19.0];
  userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
  userImageView.layer.borderWidth = 2.0f;
  [middleView addSubview:userImageView];

  //用户评级控件
  UserGradeView *userGradeView =
      [[UserGradeView alloc] initWithFrame:CGRectMake(50, 16, 175, 28)];
  userGradeView.userInteractionEnabled = NO;
  [userGradeView bindUserListItem:_userListItem isOriginalPoster:NO];
  [middleView addSubview:userGradeView];

  trackButton = [UIButton buttonWithType:UIButtonTypeCustom];
  trackButton.hidden = YES;
  trackButton.frame = CGRectMake(self.view.bounds.size.width - 88, 15, 72, 27);
  [trackButton.layer setMasksToBounds:YES];
  trackButton.layer.cornerRadius = 27.0 / 2;
  [trackButton buttonWithNormal:Color_WFOrange_btn
           andHightlightedColor:Color_WFOrange_btnDown];
  //  trackButton.backgroundColor = [Globle colorFromHexRGB:@"#f5ad00"];
  [middleView addSubview:trackButton];
  [trackButton setTitle:@"追踪TA" forState:UIControlStateNormal];
  trackButton.titleLabel.textColor = [UIColor whiteColor];
  trackButton.titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_13_0];
  //  [trackButton addTarget:self
  //                  action:@selector(touchdown:)
  //        forControlEvents:UIControlEventTouchDown];
  //  [trackButton addTarget:self
  //                  action:@selector(outSide:)
  //        forControlEvents:UIControlEventTouchUpOutside];
  [trackButton addTarget:self
                  action:@selector(trackButtonPress:)
        forControlEvents:UIControlEventTouchUpInside];
  [self.clientView addSubview:middleView];
}

- (void)bindPositionInfo:(SimuRankPositionPageData *)positionData {
  self.currentPositionInfo = positionData;
  //设置追踪按钮
  [self setTrackButton:positionData.traceFlag];
  //设置持仓切换按钮标题
  [_switchButtons
      setPositonButtonTitle:positionData.positionAmount.stringValue];
}

#pragma mark - ⭐️创建持仓和清仓表格
- (void)createPositionAndClosedPositionTableViews {
  //父类的禁用
  _littleCattleView = nil;
  __weak StockPositionViewController *weakSelf = self;

  CGRect frame1 = CGRectMake(0, 58, self.view.bounds.size.width,
                             self.clientView.bounds.size.height - 58 -
                                 BOTTOM_TOOL_BAR_HEIGHT);
  currentPositionViewController =
      [[CurrentPositionViewController alloc] initWithFrame:frame1
                                                withUserId:self.userID
                                               withMatckId:self.matchID];

  currentPositionViewController.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };
  currentPositionViewController.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };
  currentPositionViewController.positionReadyCallBack =
      ^(SimuRankPositionPageData *positionData) {
        [weakSelf bindPositionInfo:positionData];
      };

  [self.clientView addSubview:currentPositionViewController.view];
  [self addChildViewController:currentPositionViewController];

  CGRect frame = CGRectMake(0, 58, self.view.bounds.size.width,
                            self.clientView.bounds.size.height - 58 -
                                BOTTOM_TOOL_BAR_HEIGHT);
  closedPositionViewController =
      [[ClosedPositionViewController alloc] initWithFrame:frame
                                               withUserId:self.userID
                                              withMatckId:self.matchID];
  closedPositionViewController.showTopSeperatorLine = YES;
  closedPositionViewController.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };
  closedPositionViewController.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };

  [self.clientView addSubview:closedPositionViewController.view];
  [self addChildViewController:closedPositionViewController];
  closedPositionViewController.view.hidden = YES;
}

#pragma mark
#pragma mark---------------------SimuIndicatorDelegate---------------------
- (void)refreshButtonPressDown {

  //当前显示那个列表刷新那个
  if (_isPositionButtonClicked) {
    [currentPositionViewController refreshButtonPressDown];
  } else {
    [closedPositionViewController refreshButtonPressDown];
    [self getClearStocknumber];
  }
}

#pragma mark
#pragma mark-------------------------按钮点击事件-------------------------------------

- (void)refreshButtonPress:(UIButton *)button {
  [self getFromNet];
}

//追踪按钮
- (void)touchdown:(UIButton *)btn {
  if (self.currentPositionInfo) {
    NSInteger flag = self.currentPositionInfo.traceFlag;
    if (flag == 0) //自己持仓
    {
    } else if (flag == 1) //已经追踪
    {
      btn.backgroundColor = [Globle colorFromHexRGB:@"#de9200"];

    } else if (flag == -1 || flag == -2 || flag == -3) //未开通
    {
      btn.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
    }
  }
}
- (void)outSide:(UIButton *)btn {
  if (self.currentPositionInfo) {
    NSInteger flag = self.currentPositionInfo.traceFlag;
    if (flag == 0) //自己持仓
    {
    } else if (flag == 1) //已经追踪
    {
      btn.backgroundColor = [Globle colorFromHexRGB:@"#f5ad00"];

    } else if (flag == -1 || flag == -2 || flag == -3) //未开通
    {
      btn.backgroundColor = [Globle colorFromHexRGB:@"#31bce9"];
    }
  }
}

//追踪按钮
- (void)trackButtonAction:(UIButton *)btn {
  //登录页
  [FullScreenLogonViewController
      checkLoginStatusWithCallBack:^(BOOL isLogined) {
        if (![SimuUtil isExistNetwork]) {
          [self showMessage:REQUEST_FAILED_MESSAGE];
          return;
        }
        if (self.currentPositionInfo) {
          NSInteger flag = self.currentPositionInfo.traceFlag;
          MasterPurchesViewController *masterPur =
              [[MasterPurchesViewController alloc] init];
          masterPur.traceDelegate = self;
          if (flag == 0) //自己持仓
          {

          } else if (flag == 1) { //已经追踪
            UIAlertView *alert = [[UIAlertView alloc]
                    initWithTitle:@"温馨提示"
                          message:@"确定要取消追踪该牛人吗？"
                         delegate:self
                cancelButtonTitle:@"继续追踪"
                otherButtonTitles:@"取消追踪", nil];
            alert.tag = 12000;
            [alert show];

          } else if (flag == -1) { //未开通
            if ([SimuConfigConst isShowPropsForReview]) {
              [AppDelegate pushViewControllerFromRight:
                               [[NetShoppingMallBaseViewController alloc]
                                   initWithPageType:Mall_Buy_Props]];
            } else {
              [AppDelegate pushViewControllerFromRight:masterPur];
            }

          } else if (flag == -2) { //未追踪
            spvc_indicator.center = trackButton.center;
            [spvc_indicator startAnimating];
            trackButton.hidden = YES;
            [self addTrace];
          } else if (flag == -3) { //追踪过期
            if ([SimuConfigConst isShowPropsForReview]) {
              [AppDelegate pushViewControllerFromRight:
                               [[NetShoppingMallBaseViewController alloc]
                                   initWithPageType:Mall_Buy_Props]];
            } else {
              [AppDelegate pushViewControllerFromRight:masterPur];
            }
          }
        }
      }];
}

- (void)trackButtonPress:(UIButton *)btn {
  [self trackButtonAction:btn];
}

#pragma mark
#pragma mark alertViewdelegate
- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 12000) {
    if (buttonIndex == 1) {
      spvc_indicator.center = trackButton.center;
      [spvc_indicator startAnimating];
      trackButton.hidden = YES;
      [self delTrace];
    }
  }
}

#pragma mark
#pragma mark--------------------------buttonPressDownDelegate------------------
- (void)addMoneyPressDown {
  [self creatTrackMasgerPurchesController];
}
#pragma mark
#pragma mark--------------------------资金卡商店相关函数--------------------------
- (void)creatTrackMasgerPurchesController {
  [AppDelegate
      pushViewControllerFromRight:[[FoundMasterPurchViewConroller alloc] init]];
}

#pragma mark
#pragma mark 对外接口
- (void)showMessage:(NSString *)message {
  [NewShowLabel setMessageContent:message];
}

#pragma mark
#pragma mark-------网络返回------------

#pragma mark - 追踪按钮
- (void)setTrackButton:(NSInteger)flag {
  if (flag == 0) //自己持仓
  {
    trackButton.hidden = YES;
  } else {
    trackButton.hidden = NO;
    [spvc_indicator stopAnimating];
    if (flag == 1) //已经追踪
    {
      [trackButton setTitle:@"已追踪" forState:UIControlStateNormal];
      [trackButton setTitle:@"已追踪" forState:UIControlStateHighlighted];
      //            [trackButton setTitleEdgeInsets:UIEdgeInsetsMake(4, 21, 4,
      //            0)];
      [trackButton setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateNormal];
      [trackButton setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateHighlighted];
      trackButton.frame =
          CGRectMake(self.view.bounds.size.width - 88, 15, 80, 27);
      [trackButton.layer setMasksToBounds:YES];
      trackButton.layer.cornerRadius = 27.0 / 2;
      trackButton.backgroundColor = [Globle colorFromHexRGB:@"#f5ad00"];

    } else if (flag == -3) {
      [trackButton setTitle:@"续费追踪" forState:UIControlStateNormal];
      [trackButton setTitle:@"续费追踪" forState:UIControlStateHighlighted];
      [trackButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
      trackButton.backgroundColor = [Globle colorFromHexRGB:@"#31bce9"];
      [trackButton setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateNormal];
      [trackButton setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateHighlighted];
      trackButton.frame =
          CGRectMake(self.view.bounds.size.width - 88, 15, 72, 27);
      [trackButton.layer setMasksToBounds:YES];
      trackButton.layer.cornerRadius = 27.0 / 2;
    } else {
      [trackButton setTitle:@"追踪TA" forState:UIControlStateNormal];
      [trackButton setTitle:@"追踪TA" forState:UIControlStateHighlighted];
      [trackButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
      trackButton.backgroundColor = [Globle colorFromHexRGB:@"#31bce9"];
      [trackButton setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateNormal];
      [trackButton setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateHighlighted];
      trackButton.frame =
          CGRectMake(self.view.bounds.size.width - 88, 15, 72, 27);
      [trackButton.layer setMasksToBounds:YES];
      trackButton.layer.cornerRadius = 27.0 / 2;
    }
  }
}

#pragma mark
#pragma mark SimTopBannerViewDelegate
//左边按钮按下leftButtonPress
- (void)leftButtonPress {
  //追踪数量变化，刷新主页
  if ([SimuUtil isLogined]) {
    [AttentionEventObserver postAttentionEvent];
  }
  [super leftButtonPress];
}

#pragma mark
#pragma mark-------网络访问------------

- (void)getFromNet {
  [_indicatorView startAnimating];
  [currentPositionViewController refreshButtonPressDown];
  [self getClearStocknumber];
  if (self.nickName == nil || [self.nickName length] == 0) {
    [self getNickNameAndHeadPic];
  }
}

//绑定清仓数量
- (void)bindClosePositionStockNumber:
        (SimuRankClosedPositionNumber *)closedPagedata {
  if (!closedPagedata) {
    return;
  }
  _closeStockNumber = closedPagedata.closeStockNumber;
  //设置清仓按钮标题
  [_switchButtons setClearPositonButtonTitle:_closeStockNumber];
}

- (void)setNoNetwork {
  [spvc_indicator stopAnimating];
  [NewShowLabel showNoNetworkTip];
}

//获得清仓股票数量
- (void)getClearStocknumber {

  [_indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [_indicatorView stopAnimating];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak StockPositionViewController *weakSelf = self;

  callback.onSuccess = ^(NSObject *obj) {
    StockPositionViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf
          bindClosePositionStockNumber:(SimuRankClosedPositionNumber *)obj];
    }
  };

  [SimuRankClosedPositionNumber requestClosedPositionNumberWithUid:self.userID
                                                       withMatchId:self.matchID
                                                      wichCallback:callback];
}

- (void)stopLoading {
  [spvc_indicator stopAnimating];
  [_indicatorView stopAnimating]; //停止菊花
  //    [self endRefreshLoading]; //停止并隐藏上拉加载更多控件
}

#pragma mark 追踪
- (void)addTrace {

  //  //记录追踪状态
  _isTracing = YES;

  if (![SimuUtil isLogined]) {
    return;
  }

  [_indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak StockPositionViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    StockPositionViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [NetLoadingWaitView stopAnimating];
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    StockPositionViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSimuFollowingData:(SimuFollowingData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
    trackButton.hidden = NO;
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    trackButton.hidden = NO;
  };
  [SimuFollowingData requestFollowingWithUserId:self.userID
                                    withMatchId:self.matchID
                                      withIsAdd:YES
                                   withCallback:callback];
}

#pragma mark 追踪回调
- (void)bindSimuFollowingData:(SimuFollowingData *)followData {

  if ([followData.status isEqualToString:@"0000"]) {
    spve_selectedRow.row = -1;
    spve_selectedRow.section = -1;
    [self refreshButtonPress:nil];
  } else if ([followData.status isEqualToString:@"0101"] == YES) {
    [BaseViewController onIllegalLogin];
  } else {
    [spvc_indicator stopAnimating];
    trackButton.hidden = NO;
    [NewShowLabel setMessageContent:followData.message];
  }
}

#pragma mark 取消追踪
- (void)delTrace {
  //记录追踪状态
  _isTracing = NO;

  if (![SimuUtil isLogined]) {
    return;
  }

  [_indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak StockPositionViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    StockPositionViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [NetLoadingWaitView stopAnimating];
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    StockPositionViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSimuFollowingData:(SimuFollowingData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [SimuFollowingData requestFollowingWithUserId:self.userID
                                    withMatchId:self.matchID
                                      withIsAdd:NO
                                   withCallback:callback];
}

#pragma m 取得用户昵称和用户头像
- (void)getNickNameAndHeadPic {

  if (![SimuUtil isLogined]) {
    return;
  }

  [_indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak StockPositionViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    StockPositionViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [NetLoadingWaitView stopAnimating];
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    StockPositionViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSimuShowUserHeadData:(SimuShowUserHeadData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [SimuShowUserHeadData requestSimuShowUserHeadDataWithCallback:callback];
}

#pragma mark 用户头像等信息回调
- (void)bindSimuShowUserHeadData:(SimuShowUserHeadData *)userHeadData {
  _nicklabel.text = userHeadData.nickname;
  [JhssImageCache setImageView:_headImageView
                       withUrl:userHeadData.headpicUrl
          withDefaultImageName:@"用户默认头像"];
}

@end
