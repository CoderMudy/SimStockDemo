//
//  SimuHavePrizeViewController.m
//  SimuStock
//
//  Created by jhss on 15/8/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SimuHavePrizeViewController.h"
#import "MakingShareAction.h"
#import "ZKControl.h"
#import "SimuTotalMatchViewController.h"
#import "SimuHomeMatchData.h"
#import "JhssImageCache.h"
#import "SchollWebViewController.h"
#import "SimuJoinMatchData.h"
#import "SimuOpenAccountData.h"
#import "GameWebViewController.h"
#import "SimuJoinViewController.h"
#import "CompetitionDetailsVC.h"
#import "InvitationGoodFriendButton.h"
#import "UIButton+Block.h"

@interface SimuHavePrizeViewController () <UIWebViewDelegate> {
  /** 下面导航栏 高度 */
  CGFloat _bottomTopToolHeight;

  /** 下面的 导航栏的承载View */
  UIView *_baseTopToolView;
}
@end

@implementation SimuHavePrizeViewController

- (id)initWithTitleName:(NSString *)titleName
            withMatchID:(NSString *)matchID
          withMatchType:(NSString *)matchType
            withMainUrl:(NSString *)mainUrl {
  self = [super init];
  if (self) {
    self.titleName = titleName;
    self.matchid = matchID;
    self.matchType = matchType;
    self.mainUrl = mainUrl;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _bottomTopToolHeight = 55.0f;
  [_topToolBar resetContentAndFlage:self.titleName Mode:TTBM_Mode_Leveltwo];
  [self createInviteFriendBtn];
  [self createJionMatchButtonAndRankListButton];
  [self loadWepPage];
  [self initVariables];
  [self requestMatchInfoData];
}

- (void)initVariables {
  _detailArr = [[NSMutableArray alloc] init];
  _evenPointBool = YES;
  invitationBool = NO;
  _popBool = NO;
  _logInBool = NO;
  _detailArr = [[NSMutableArray alloc] init];
  _cycleArr = [[NSMutableArray alloc] init];
  _entryButtonbool = YES;
}

//加载wep页
- (void)loadWepPage {
  _webView =
      [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, _clientView.frame.size.height - _bottomTopToolHeight)];
  _webView.backgroundColor = [UIColor whiteColor];
  [_clientView addSubview:_webView];
  _webView.delegate = self;
  // 1.创建资源路径 现在改为 直接跳 mainUrl
  //    stringUrl = [NSString stringWithFormat:@"%@mobile/" @"match/description/" @"?matchId=%@",
  //    scholl_web_url, _matchid];

  NSLog(@"SimuHavePrizeViewController mainUrl = %@", self.mainUrl);
  NSURL *url = [NSURL URLWithString:self.mainUrl];
  // 2.创建请求
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  // 3下载请求的数据
  [_webView loadRequest:request];
  ////添加UserAgent
  [SimuUtil WebViewUserAgent:_webView];
}

#pragma mark----UIWebDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
  NSString *abStr = webView.request.URL.absoluteString;
  NSLog(@" 1 = %@", abStr);
  if (![self.mainUrl isEqualToString:@""] && self.mainUrl.length > 0 && self.mainUrl != nil) {
    _indicatorView.hidden = NO;
    [_indicatorView startAnimating];
  }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  _littleCattleView.hidden = YES;
  [self stopIndicatorViewAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  NSString *abStr = webView.request.URL.absoluteString;
  NSLog(@" 3 = %@", abStr);
  [self stopIndicatorViewAnimating];
  [_clientView bringSubviewToFront:_baseTopToolView];
  if (!webView) {
    [_littleCattleView isCry:YES];
  }
}

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType {
  NSString *abStr = webView.request.URL.absoluteString;
  NSLog(@" 4 = %@", abStr);
  return YES;
}

/** 停掉菊花 */
- (void)stopIndicatorViewAnimating {
  __weak SimuHavePrizeViewController *weakSelf = self;
  [SimuUtil performBlockOnMainThread:^{
    weakSelf.indicatorView.hidden = YES;
    [weakSelf.indicatorView stopAnimating];
  } withDelaySeconds:1.0f];
}

- (void)createJionMatchButtonAndRankListButton {
  _baseTopToolView =
      [[UIView alloc] initWithFrame:CGRectMake(0, _clientView.frame.size.height - _bottomTopToolHeight, WIDTH_OF_SCREEN, _bottomTopToolHeight)];

  _baseTopToolView.backgroundColor = [Globle colorFromHexRGB:@"ffffff"];
  [_clientView addSubview:_baseTopToolView];

  //按钮上面的灰线
  UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 1)];
  grayLine.backgroundColor = [Globle colorFromHexRGB:@"e5e5e5"];
  [_baseTopToolView addSubview:grayLine];

  //距离边界距离
  CGFloat x = 30;
  //按钮的宽度
  CGFloat buttonWidth = 115;
  //  CGFloat width = (WIDTH_OF_SCREEN - 3 * x) / 2;
  //按钮的高度
  CGFloat h = 30;
  jionBtn = [BGColorUIButton buttonWithType:UIButtonTypeCustom];
  jionBtn.frame = CGRectMake(x, 14.5, buttonWidth, h);
  jionBtn.centerX = self.view.width / 4;

  [jionBtn buttonWithTitle:@"参与比赛"
            andNormaltextcolor:Color_White
      andHightlightedTextColor:Color_White];
  [jionBtn setNormalBGColor:[Globle colorFromHexRGB:@"f79100"]];
  [jionBtn setHighlightBGColor:[Globle colorFromHexRGB:@"d77205"]];
  jionBtn.layer.masksToBounds = YES;
  jionBtn.layer.cornerRadius = 15;
  [_baseTopToolView addSubview:jionBtn];

  _matchBtnIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(buttonWidth / 2 - 15, 0, 30,
                                                                                 30)]; //指定进度轮的大小
  [jionBtn addSubview:_matchBtnIndicator];
  __weak SimuHavePrizeViewController *weakSelf = self;
  [jionBtn setOnButtonPressedHandler:^{
    NSLog(@"加入比赛");
    if (![SimuUtil isExistNetwork]) {
      [NewShowLabel showNoNetworkTip];
    } else {
      SimuHavePrizeViewController *strongSelf = weakSelf;
      [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
        if (isLogined) {
          NSLog(@"已登录过");
          [strongSelf stateBtnClickJuadge];
        } else {
          NSLog(@"重新后登录成功");
          [strongSelf requestMatchInfoData];
        }
      }];
    }
  }];

  BGColorUIButton *rankListBtn = [BGColorUIButton buttonWithType:UIButtonTypeCustom];
  rankListBtn.frame = CGRectMake(WIDTH_OF_SCREEN - buttonWidth - x, 14.5, buttonWidth, h);
  rankListBtn.centerX = (self.view.width / 4) * 3;
  [rankListBtn buttonWithTitle:@"排行榜"
            andNormaltextcolor:Color_White
      andHightlightedTextColor:Color_White];
  [rankListBtn setNormalBGColor:[Globle colorFromHexRGB:Color_Blue_but]];
  [rankListBtn setHighlightBGColor:[Globle colorFromHexRGB:@"055385"]];
  rankListBtn.layer.masksToBounds = YES;
  rankListBtn.layer.cornerRadius = 15;
  [_baseTopToolView addSubview:rankListBtn];

  [rankListBtn setOnButtonPressedHandler:^{
    NSLog(@"进入排行榜");
    SimuHavePrizeViewController *strongSelf = weakSelf;
    if (strongSelf) {
      SimuTotalMatchViewController *totalMatchVC =
          [[SimuTotalMatchViewController alloc] initWithTitleName:strongSelf.titleName
                                                      withMatchID:strongSelf.matchid
                                                    withMatchType:strongSelf.matchType];
      [AppDelegate pushViewControllerFromRight:totalMatchVC];
    }
  }];
}
#pragma mark - 网络请求
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
}

- (void)startLoading {
  _matchBtnIndicator.hidden = NO;
  [_matchBtnIndicator startAnimating];
  //  jionBtn.titleLabel.layer.opacity = .0f;
  jionBtn.userInteractionEnabled = NO;
}

- (void)stopLoading {
  _matchBtnIndicator.hidden = YES;
  [_matchBtnIndicator stopAnimating];
  //  jionBtn.titleLabel.layer.opacity = 1.f;
  jionBtn.userInteractionEnabled = YES;
}
- (void)requestMatchInfoData {

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak SimuHavePrizeViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    SimuHavePrizeViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    SimuHavePrizeViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSimuHomeMatchData:(SimuHomeMatchData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [SimuHomeMatchData requestSimuHomeMatchDataWithMid:self.matchid withCallback:callback];
}
- (void)bindSimuHomeMatchData:(SimuHomeMatchData *)matchData {

  if (matchData.dataArray.count > 0) {
    [_detailArr removeAllObjects];
    [_detailArr addObject:matchData.dataArray[0]];
    SimuHomeMatchData *detailsData = _detailArr[0];
    if ([detailsData.state integerValue] == 2 && _wait == YES) {
      [NewShowLabel setMessageContent:@"还" @"没" @"到" @"比赛时间，请耐心等待！"];
    } else if ([detailsData.state integerValue] == 4) {
      [jionBtn setUserInteractionEnabled:NO];
    }
    if (_logInBool == YES) {
      _logInBool = NO;
      //登录成功切换到参与比赛
      [self stateBtnClickJuadge];
    }
    //详情界面
    [self bindMatchData:detailsData];
  }
}
#pragma mark - 绑定界面数据
- (void)bindMatchData:(SimuHomeMatchData *)data {
  NSString *state = @"";
  switch ([data.state integerValue]) {
  case btnFirstTitleType:
    state = @"参与比赛";
    break;
  case btnSecondTitleType:
    state = @"等待比赛开始";
    break;
  case btnThirdTitleType:
    state = @"进入比赛";
    break;
  case btnFourthTitleType:
    state = @"比赛结束";
    break;
  case btnFiveTitleType:
    state = @"续费";
    break;
  default:
    break;
  }
  [jionBtn setTitle:state forState:UIControlStateNormal];
  [jionBtn setTitle:state forState:UIControlStateHighlighted];
}

#pragma mark-----参与比赛
- (void)stateBtnClickJuadge {
  [_matchBtnIndicator startAnimating];
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
    [NewShowLabel showNoNetworkTip];
  }
  [_matchBtnIndicator stopAnimating];
}
#pragma mark 创建进入比赛模块页面
- (void)creatJoinMarchVC {
  [AppDelegate pushViewControllerFromRight:[[SimuJoinViewController alloc] init:self.matchid
                                                                           Name:self.titleName]];
}

#pragma mark - 参与比赛方法
- (void)joinMatch:(SimuHomeMatchData *)detailsData {
  //是否web 页报名
  if (self.webBool) {
    // web 报名
    [SchollWebViewController startWithTitle:self.titleName
                                    withUrl:self.webStringURL
                              withMatchType:self.matchType];
    return;
  } else if (detailsData.inviteFlag) {
    //邀请码参赛
    _invitationView =
        [[InvitationCodeView alloc] initWithFrame:CGRectMake(0, -45, self.view.width, self.view.height + 90)];
    _invitationView.delegate = self;
    [self.view addSubview:_invitationView];
    //百万、千万赛
  } else if ([_matchid integerValue] == 2 || [_matchid integerValue] == 3) {
    [self millionsAndPaymentCycleInterface];

  } else {
    [self entryRequest]; //非邀请码参赛
  }
}
#pragma mark--------非邀请码参与比赛---------
- (void)entryRequest {

  [self startLoading];

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak SimuHavePrizeViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    SimuHavePrizeViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    SimuHavePrizeViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSimuJoinMatchData:(SimuJoinMatchData *)obj];
    }
  };

  callback.onFailed = ^{
    //    [weakSelf callbackOnFailed];
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
                                              withMatchId:self.matchid
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
  __weak SimuHavePrizeViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    SimuHavePrizeViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    SimuHavePrizeViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSimuCompetitionMillionCycleData:(SimuCompetitionMillionCycleData *)obj];
    }
  };
  callback.onFailed = ^{
    //    [self callbackOnFailed];
    [weakSelf setNoNetwork];
  };

  [SimuCompetitionMillionCycleData requestSimuCompetitionMillionCycleDataWithMid:_matchid
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

- (void)createInviteFriendBtn {
  //邀请好友按钮
  InvitationGoodFriendButton *invtationButton =
      [[InvitationGoodFriendButton alloc] initInvitationButtonWithTopBar:_topToolBar
                                                       withIndicatorView:_indicatorView];
  __weak SimuHavePrizeViewController *weakSelf = self;
  invtationButton.invitationButtonBlock = ^() {
    SimuHavePrizeViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf shareMatchAction];
    }
  };
}

- (void)shareMatchAction {
  MakingShareAction *matchDetailShareAction = [[MakingShareAction alloc] init];
  matchDetailShareAction.shareModuleType = ShareModuleTypeStockMatchRank;
  NSString *matchDetailShareUrl =
      [NSString stringWithFormat:@"http://www.youguu.com/opms/fragment/html/fragment.html"];
  //分享内容加在otherInfo中
  [matchDetailShareAction shareTitle:[NSString stringWithFormat:@"%@很不错，你也来试试 ", self.titleName]
                             content:[NSString stringWithFormat:@"#优顾炒股#%@很不错，你也来试试 " @"%@ (分享自@优顾炒股官方)", self.titleName, matchDetailShareUrl]
                               image:[UIImage imageNamed:@"shareIcon"]
                      withOtherImage:nil
                        withShareUrl:matchDetailShareUrl
                       withOtherInfo:[NSString stringWithFormat:@"#优顾炒股#%@很不错，你也来试试 " @"%@ (分享自@优顾炒股官方)", self.titleName, matchDetailShareUrl]];
}

//邀请码
#pragma mark InvitationCodeViewDelegate 代理
- (void)invitationCode:(NSString *)code {
  if ([SimuUtil isExistNetwork] == NO) {
    [self showMessage:REQUEST_FAILED_MESSAGE];
    return;
  }
  [self useInvitationCode:code];
}

#pragma mark 无网络
- (void)showMessage:(NSString *)message {
  [_invitationView.ssv_searchTextField resignFirstResponder];
  [NewShowLabel setMessageContent:message];
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
  __weak SimuHavePrizeViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    SimuHavePrizeViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    SimuHavePrizeViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSimuJoinMatchData:(SimuJoinMatchData *)obj];
    }
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    SimuHavePrizeViewController *strongSelf = weakSelf;
    if (strongSelf) {
      if ([obj.status isEqualToString:@"0214"] || [obj.status isEqualToString:@"0220"]) {
        [NewShowLabel setMessageContent:@"验证码错误"];
      } else {
        [BaseRequester defaultErrorHandler](obj, exc);
      }
    }
  };
  callback.onFailed = ^{
    SimuHavePrizeViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf callbackOnFailed];
      [strongSelf setNoNetwork];
    }
  };

  [SimuJoinMatchData requestSimuJoinMatchDataWithNickName:[CommonFunc base64StringFromText:[SimuUtil getUserNickName]]
                                           withInviteCode:[CommonFunc base64StringFromText:code]
                                              withMatchID:self.matchid
                                             withCallback:callback];
}

- (void)callbackOnFailed {
  _logInBool = NO;
}

- (void)leftButtonPress {
  if (_webView && [_webView canGoBack] == YES) {
    [_webView goBack];
  }else{
    [super leftButtonPress];
  }
}
@end
