//
//  CompetitionDetailsVC.m
//  SimuStock
//
//  Created by Yuemeng on 15/7/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CompetitionDetailsVC.h"
#import "UserListItem.h"
#import "UserGradeView.h"
#import "MobClick.h"
#import "CompetitionRankDetailVC.h"
#import "CompetitionDetailsViewController.h"
#import "SimuHomeMatchData.h"
#import "JhssImageCache.h"
#import "SchollWebViewController.h"
#import "SimuJoinMatchData.h"
#import "SimuOpenAccountData.h"
#import "GameWebViewController.h"
#import "SimuJoinViewController.h"

//百万赛详情链接
#define MillionMatchDetails @"http://www.youguu.com/opms/html/article/31/2014/0509/2538.html"
//千万赛详情链接
#define TenMillionMatchDetails @"http://www.youguu.com/opms/html/article/31/2014/0509/2539.html"

@implementation CompetitionDetailsVC

- (id)initWithMatchID:(NSString *)matchID
        withTitleName:(NSString *)titleName
            withMtype:(NSString *)matchType
         withCalssObj:(CompetitionDetailsViewController *)superVC {
  self = [super init];
  if (self) {
    self.matchID = matchID;
    self.titleName = titleName;
    self.mType = matchType;
    self.superVC = superVC;
  }
  return self;
}
//统计页面停留时间
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [MobClick beginLogPageView:@"单个比赛内容详情"];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [MobClick endLogPageView:@"单个比赛内容详情"];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.hidden = YES;
  [self initVariables];
  [self createRankDetailVC];
  [self requestMatchInfoData];
}

- (void)initVariables {
  _detailArr = [[NSMutableArray alloc] init];
  _detailUrl = nil;
  _evenPointBool = YES;
  invitationBool = NO;
  _popBool = NO;
  _logInBool = [SimuUtil isLogined];
  _detailArr = [[NSMutableArray alloc] init];
  _cycleArr = [[NSMutableArray alloc] init];
  _entryButtonbool = YES;
}

- (void)showSubDetailView:(BOOL)needShow {
  _subInfoBackViewHeight.constant = (needShow ? 14 : 0);
  _subscriLabelTop.constant = (needShow ? 12 : 0);
  _matchBtnCenterY.constant = (needShow ? 13 : 0);
  _detailBtn.hidden = !needShow;
}

- (void)createRankDetailVC {
  CompetitionRankDetailVC *rankDetailVC =
      [[CompetitionRankDetailVC alloc] initWithNibName:@"CompetitionRankDetailVC"
                                                bundle:nil
                                           withMatchID:self.matchID
                                         withMatchType:self.mType
                                          withRankType:nil];

  rankDetailVC.titleName = self.titleName;
  rankDetailVC.view.frame = _clientView.bounds;
  rankDetailVC.userName.text = @"用户名";
  _rankDetailVC = rankDetailVC;
  [rankDetailVC resetHeight:_clientView.bounds];

  __weak CompetitionDetailsVC *weakSelf = self;
  _rankDetailVC.beginRefreshCompetitionBack = ^{
    CompetitionDetailsVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.superVC.indicatorView startAnimating];
      strongSelf.superVC.indicatorView.hidden = NO;
    }
  };
  _rankDetailVC.endRefreshCompetitionBack = ^{
    CompetitionDetailsVC *strongSelf = weakSelf;
    if (strongSelf) {
      strongSelf.superVC.indicatorView.hidden = YES;
      [strongSelf.superVC.indicatorView stopAnimating];
    }
  };
  [self.clientView addSubview:rankDetailVC.view];
  [self addChildViewController:rankDetailVC];
}

#pragma mark - 网络请求
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
}

- (void)startLoading {
  _matchBtnIndicator.hidden = NO;
  [_matchBtnIndicator startAnimating];
  _matchStatusBtn.titleLabel.layer.opacity = .0f;
  _matchStatusBtn.userInteractionEnabled = NO;
}

- (void)stopLoading {
  _matchBtnIndicator.hidden = YES;
  [_matchBtnIndicator stopAnimating];
  _matchStatusBtn.titleLabel.layer.opacity = 1.f;
  _matchStatusBtn.userInteractionEnabled = YES;
}

- (void)requestMatchInfoData {

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }
  [self startLoading];
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak CompetitionDetailsVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    CompetitionDetailsVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    CompetitionDetailsVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSimuHomeMatchData:(SimuHomeMatchData *)obj];
    }
  };

  [SimuHomeMatchData requestSimuHomeMatchDataWithMid:self.matchID withCallback:callback];
}

- (void)bindSimuHomeMatchData:(SimuHomeMatchData *)matchData {

  if (matchData.dataArray.count > 0) {
    [_detailArr removeAllObjects];
    [_detailArr addObject:matchData.dataArray[0]];
    SimuHomeMatchData *detailsData = _detailArr[0];
    if (detailsData.showMonthRank) {
      NSArray *array = @[ @"周盈利榜", @"月盈利榜", @"总盈利榜" ];
      [_rankDetailVC.simuCenterTabView resetButtons:array];
    } else {
      NSArray *array = @[ @"周盈利榜", @"总盈利榜" ];
      [_rankDetailVC.simuCenterTabView resetButtons:array];
    }

    if ([detailsData.state integerValue] == 2 && _wait == YES) {
      [NewShowLabel setMessageContent:@"还" @"没" @"到" @"比赛时间，请耐心等待！"];
    } else if ([detailsData.state integerValue] == 4) {
      [_matchStatusBtn setUserInteractionEnabled:NO];
    }
    if (!_logInBool && [SimuUtil isLogined]) {
      _logInBool = [SimuUtil isLogined];
      //登录成功切换到参与比赛
      [self stateBtnClickJuadge];
    }

    //详情界面
    [self bindMatchData:detailsData];

    //等待UI调整完毕后刷新列表
    if (!_firstRequestDone) {
      _firstRequestDone = YES;
      [SimuUtil performBlockOnMainThread:^{
        [_rankDetailVC switchCompetitionRankVC:0];
      } withDelaySeconds:.25f];
    }
  }
}

#pragma mark - 对点击后的比赛状态做判断
- (void)stateBtnClickJuadge {
  if (_detailArr.count != 0) {
    SimuHomeMatchData *detailsData = _detailArr[0];
    if ([detailsData.state integerValue] == 1 || [detailsData.state integerValue] == 5) {
      //参与比赛方法和续费
      [self joinMatch:detailsData];
    } else if ([detailsData.state integerValue] == 2) {
      _wait = YES;
      //等待比赛
      [self requestMatchInfoData];
    } else if ([detailsData.state integerValue] == 3) {
      //进入比赛
      [self creatJoinMarchVC];
    }
  } else {
    [NewShowLabel setMessageContent:@"暂" @"无比赛详情，请下载完成后再加入比赛"];
  }
}

#pragma mark 创建进入比赛模块页面
- (void)creatJoinMarchVC {
  [AppDelegate pushViewControllerFromRight:[[SimuJoinViewController alloc] init:self.matchID
                                                                           Name:self.titleName]];
}

#pragma mark - 绑定界面数据
- (void)bindMatchData:(SimuHomeMatchData *)data {
  NSString *state = @"";
  switch ([data.state integerValue]) {
  case 1:
    state = @"参与比赛";
    break;
  case 2:
    state = @"等待比赛开始";
    break;
  case 3:
    state = @"进入比赛";
    break;
  case 4:
    state = @"比赛结束";
    break;
  case 5:
    state = @"续费";
    break;
  default:
    break;
  }

  [JhssImageCache setImageView:_bannerImageView
                       withUrl:data.backgroundUrl
          withDefaultImageName:@"banner.png"];

  //需要邀请码、显示奖池数、有详情链接
  BOOL needsShowView = data.invitecode.length > 0 || data.rewardFlag || data.detailUrl.length > 0;
  [self showSubDetailView:needsShowView];

  //比赛详情显示与否
  if (data.isShowDesFlag) {
    _matchDescLabel.text = [NSString stringWithFormat:@"比赛说明：\n%@", data.matchDescp];
    _matchDescLabel.hidden = NO;
    _matchTimeLabel.text = [NSString stringWithFormat:@"比赛时间：\n%@", data.matchTime];
    _matchTimeLabel.hidden = NO;
  }

  _userGradeView.width = WIDTH_OF_SCREEN - 77;
  [_userGradeView bindUserListItem:data.userListItem isOriginalPoster:NO];
  _userGradeView.lblNickName.normalTitleColor =
      [UserListItem colorWithVIPType:data.vipType defaultColor:[Globle colorFromHexRGB:@"#ff9c00"]];

  [_matchStatusBtn setTitle:state forState:UIControlStateNormal];
  _matchStatusBtn.enabled = !([data.state integerValue] == 4);

  //验证码
  if (data.invitecode.length > 0) {
    NSString *verifyCode = [NSString stringWithFormat:@"验证码：%@", data.invitecode];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:verifyCode];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[Globle colorFromHexRGB:@"#0cbbd5"]
                       range:NSMakeRange([attrString length] - 4, 4)];
    _verifyCodeLabel.attributedText = attrString;
    _verifyCodeLabel.hidden = NO;
  }

  //奖池数
  if (data.rewardFlag) {
    _rewardPoolLabel.text = data.rewardPool;
    _rewardPoolLabel.hidden = NO;
  }

  //详情
  if (data.isShowDetailFlag && data.detailUrl.length > 0) {
    _detailUrl = data.detailUrl;
    _detailBtn.hidden = NO;
  } else {
    _detailBtn.hidden = YES;
  }

  //不显示奖池数、没有邀请码、且有详情
  if (!data.rewardFlag && (data.invitecode.length == 0) && (data.detailUrl.length > 0)) {
    _subInfoBackViewWidth.constant = 0;
    _detailLabelLeft.constant = 0;
  }

  self.view.hidden = NO;
}

#pragma mark - 参与比赛方法
- (void)joinMatch:(SimuHomeMatchData *)detailsData {
  //邀请码参赛
  if (self.webBool) {
    // web 报名
    [SchollWebViewController startWithTitle:self.titleName withUrl:self.webStringUrl];
    return;
  }
  if (detailsData.inviteFlag) {
    _invitationView =
        [[InvitationCodeView alloc] initWithFrame:CGRectMake(0, -45, self.view.width, self.view.height + 90)];
    _invitationView.delegate = self;
    [self.view addSubview:_invitationView];
    //百万、千万赛
  } else if ([_matchID integerValue] == 2 || [_matchID integerValue] == 3) {
    [self millionsAndPaymentCycleInterface];

  } else {
    [self entryRequest]; //非邀请码参赛
  }

  //  else if (detailsData.signupFlag) {//钻石参赛 后端已经去掉了
  //    _diamondbool = YES;
  //    NSString *message =
  //    [NSString stringWithFormat:@"参加比赛需要%ld颗钻石,您是否参赛？",
  //    (long)detailsData.signupFee];
  //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒"
  //                                                        message:message
  //                                                       delegate:self
  //                                              cancelButtonTitle:@"取消"
  //                                              otherButtonTitles:@"确定", nil];
  //    [alertView show];
  //  }
}

//#pragma mark - UIAlertView代理
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//  switch (buttonIndex) {
//  case 0:
//    return; //取消
//  case 1:
//    [self entryRequest];
//    break;
//  default:
//    break;
//  }
//}

#pragma mark--------非邀请码参与比赛---------
- (void)entryRequest {

  [self startLoading];

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak CompetitionDetailsVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    CompetitionDetailsVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    CompetitionDetailsVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSimuJoinMatchData:(SimuJoinMatchData *)obj];
    }
  };

  callback.onFailed = ^{
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    if (obj) {
      if ([@"0232" isEqualToString:obj.status]) { //团体赛报名TODO
        GameWebViewController *gameWebWebVC =
            [[GameWebViewController alloc] initWithNameTitle:@"比赛报名" andPath:obj.message];
        gameWebWebVC.urlType = AdvUrlModuleTypeMatchApply;
        //切换
        [AppDelegate pushViewControllerFromRight:gameWebWebVC];
      } else {
        [BaseRequester defaultErrorHandler](obj, exc);
      }
    } else {
      [NewShowLabel setMessageContent:@"请求失败"];
    }
  };

  [SimuJoinMatchData requestSimuJoinMatchDataWithNickName:[CommonFunc base64StringFromText:[SimuUtil getUserNickName]]
                                              withMatchId:self.matchID
                                             withCallback:callback];
}

#pragma mark InvitationCodeViewDelegate 代理
- (void)invitationCode:(NSString *)code {
  if ([SimuUtil isExistNetwork] == NO) {
    [self showMessage:REQUEST_FAILED_MESSAGE];
    return;
  }
  [self useInvitationCode:code];
}

#pragma mark 邀请码参加比赛
- (void)useInvitationCode:(NSString *)code {

  if (![SimuUtil isLogined]) {
    return;
  }

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak CompetitionDetailsVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    CompetitionDetailsVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    CompetitionDetailsVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSimuJoinMatchData:(SimuJoinMatchData *)obj];
    }
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    CompetitionDetailsVC *strongSelf = weakSelf;
    if (strongSelf) {
      if ([obj.status isEqualToString:@"0214"] || [obj.status isEqualToString:@"0220"]) {
        [NewShowLabel setMessageContent:@"验证码错误"];
      } else {
        [BaseRequester defaultErrorHandler](obj, exc);
      }
    }
  };

  [SimuJoinMatchData requestSimuJoinMatchDataWithNickName:[CommonFunc base64StringFromText:[SimuUtil getUserNickName]]
                                           withInviteCode:[CommonFunc base64StringFromText:code]
                                              withMatchID:self.matchID
                                             withCallback:callback];
}

#pragma mark 参加比赛回调
- (void)bindSimuJoinMatchData:(SimuJoinMatchData *)joinData {

  if ([joinData.status isEqualToString:@"0214"] == YES) {
    _invitationView.showLabel.text = @"验证码错误";
    [_invitationView.confirmButton setTitle:@"重新输入" forState:UIControlStateNormal];
    return;
  } else if ([joinData.status isEqualToString:@"0215"] == YES) {
    _invitationView.showLabel.text = joinData.message;
    [_invitationView.confirmButton setTitle:@"重新输入" forState:UIControlStateNormal];
    return;
    //比赛已结束
  } else if ([joinData.status isEqualToString:@"0217"] == YES) {
    _invitationView.showLabel.text = joinData.message;
    return;
  } else if ([joinData.status isEqualToString:@"0213"] == YES) {
    _invitationView.showLabel.text = joinData.message;
    return;
    //邀请码与比赛不匹配
  } else if ([joinData.status isEqualToString:@"0220"] == YES) {
    _invitationView.showLabel.text = @"验证码错误";
    [_invitationView.confirmButton setTitle:@"重新输入" forState:UIControlStateNormal];
    return;
    //钻石余额不足
  } else if ([joinData.status isEqualToString:@"0212"] == YES) {
    if (_diamondbool) {
      _diamondbool = NO;
      _comCycleView =
          [[CompetitionCycleView alloc] initWithFrame:CGRectMake(0, -45, self.view.width, self.view.height + 45)];
      _comCycleView.delegate = self;
      [self.view addSubview:_comCycleView];
      [_comCycleView diamondInadequateWarningsView];
    } else {
      _invitationView.showLabel.text = joinData.message;
    }
    return;
  }

  [_invitationView removeFromSuperview];
  [NewShowLabel setMessageContent:@"参与比赛成功"];
  [self requestMatchInfoData];
}

#pragma mark - 百万(千万)赛支付周期列表接口
- (void)millionsAndPaymentCycleInterface {
  if (![SimuUtil isLogined]) {
    return;
  }

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak CompetitionDetailsVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    CompetitionDetailsVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    CompetitionDetailsVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSimuCompetitionMillionCycleData:(SimuCompetitionMillionCycleData *)obj];
    }
  };

  [SimuCompetitionMillionCycleData requestSimuCompetitionMillionCycleDataWithMid:_matchID
                                                                    withCallback:callback];
}

#pragma mark 百万（千万)赛支付周期列表回调
- (void)bindSimuCompetitionMillionCycleData:(SimuCompetitionMillionCycleData *)cycleData {

  if ([cycleData.dataArray count] == 0) {
  } else {
    [_cycleArr removeAllObjects];
    [_cycleArr addObject:cycleData.dataArray[0]];
    SimuCompetitionMillionCycleData *cycleData = _cycleArr[0];
    if ([cycleData.list count] == 0) {
      return;
    } else {
      //参赛周期弹出框
      [self millionFundingCycleRaceParticipantsView:cycleData];
    }
  }
}

#pragma mark-------百万(千万)资金赛参赛周期视图-----
- (void)millionFundingCycleRaceParticipantsView:(SimuCompetitionMillionCycleData *)cycleData {
  _comCycleView = [[CompetitionCycleView alloc]
      initWithFrame:CGRectMake(0, -45, self.view.frame.size.width, self.view.frame.size.height + 45)];
  _comCycleView.delegate = self;
  [self.view addSubview:_comCycleView];
  [_comCycleView competitionCycleView:cycleData title:self.titleName];
}

#pragma mark-------CompetitionCycleViewDelegate-----
//请求参赛扣费
- (void)requestParticipatingDeductionDiamond:(NSInteger)type {
  [self millionsJoinMatch:type];
}
//充值
- (void)rechargeDataRequest {
  [_superVC.storeUtil showBuyingDiamondView];
}
#pragma mark
#pragma-- --立即购买接口-- --
- (void)buyNowProductId:(NSString *)productId {
  [self buyingProducteFromSevers:productId];
  [_superVC.storeUtil removeCompetitionCycleView];
}

#pragma mark - 百万（千万）赛参赛接口
- (void)millionsJoinMatch:(NSInteger)type {

  if (![SimuUtil isLogined]) {
    return;
  }

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak CompetitionDetailsVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    CompetitionDetailsVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    CompetitionDetailsVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSimuOpenAccountData:(SimuOpenAccountData *)obj];
    }
  };

  [SimuOpenAccountData requestSimuOpenAccountDataWithMatchId:self.matchID
                                                    withType:type
                                                withCallback:callback];
}
#pragma mark 百万（千万）赛参赛接口
- (void)bindSimuOpenAccountData:(SimuOpenAccountData *)data {

  if ([data.status isEqualToString:@"0212"] == YES) {
    if (_comCycleView.cycleView) {
      [_comCycleView.cycleView removeFromSuperview];
    }
    [_comCycleView diamondInadequateWarningsView];
  }

  [_comCycleView removeFromSuperview];
  [self requestMatchInfoData];
  [NewShowLabel setMessageContent:@"参与比赛成功"];
}

#pragma mark - 从服务器（本地）购买产品，生成订单
- (void)buyingProducteFromSevers:(NSString *)productedid {

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  [MobClick beginLogPageView:@"商城-买入"];

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak CompetitionDetailsVC *weakSelf = self;

  callback.onSuccess = ^(NSObject *obj) {
    CompetitionDetailsVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindProductOrder:(productOrderListItem *)obj];
    }
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *ex) {
    [BaseRequester defaultErrorHandler](obj, ex);
  };
  callback.onFailed = ^{
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

#pragma mark-------

#pragma mark 无网络
- (void)showMessage:(NSString *)message {
  [_invitationView.ssv_searchTextField resignFirstResponder];
  [NewShowLabel setMessageContent:message];
}

#pragma mark--------邀请码参与比赛---------

- (IBAction)matchStatusBtnClick:(UIButton *)btn {
  [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
    if (!_logInBool) {
      [self requestMatchInfoData];
    } else {
      [self stateBtnClickJuadge];
    }
  }];
}

- (IBAction)detailBtnClick:(UIButton *)btn {
  if ([self.matchID integerValue] == 2) {
    [SchollWebViewController startWithTitle:@"百万奖金赛" withUrl:MillionMatchDetails];
  } else if ([self.matchID integerValue] == 3) {
    [SchollWebViewController startWithTitle:@"千万奖金赛" withUrl:TenMillionMatchDetails];
  } else {
    if (_detailUrl) {
      [SchollWebViewController startWithTitle:_titleName withUrl:_detailUrl];
    }
  }
}

@end
