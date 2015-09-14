//
//  MatchCreatViewController.m
//  SimuStock
//
//  Created by jhss_wyz on 15/8/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MatchCreateViewController.h"
#import "NewShowLabel.h"
#import "BaseRequester.h"
#import "MPNotificationView.h"
#import "MatchCreateSuccessViewController.h"
#import "UIButton+Block.h"
#import "SimuValidateMatchData.h"
#import "MatchCreateMatchInfoVC.h"
#import "UniversityInformationViewController.h"
#import "AwardsMatchViewController.h"
#import "MatchCreateConfirmTip.h"
#import "UIPlaceHolderTextView.h"

@interface MatchCreateViewController () {
  CGFloat _sixHeight;
}

@end

@implementation MatchCreateViewController

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillChange:)
                                               name:UIKeyboardWillChangeFrameNotification
                                             object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillChangeFrameNotification
                                                object:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    _sixHeight = 0.0f;
  } else {
    _sixHeight = 20.0f;
  }

  self.clientView.width = WIDTH_OF_SCREEN;
  self.clientView.height = HEIGHT_OF_SCREEN - self.topToolBar.bottom;
  [self resetTitle:@"创建比赛"];
  self.indicatorView.hidden = YES;
  [self createMatchCreateBtn];
  self.indicatorView.right = self.createBtn.left;

  [self createScrollView];
  [self createMainView];

  [self createMatchInfoView];
  [self createUniversityMatchInfoView];
  [self createAwardContainerInfoView];
  [self resetScrollViewContentSizeWithOffHeight:0.f];

  self.mainView.height = 33.f + self.matchInfoViewHeight.constant +
                         self.schoolInfoViewHeight.constant + self.awardInfoViewHeight.constant;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  self.scrollView.contentSize = CGSizeMake(WIDTH_OF_SCREEN, _mainView.height + _sixHeight);
}

/** 创建滚动视图 */
- (void)createScrollView {
  self.clientView.clipsToBounds = YES;
  self.scrollView = [[UIScrollView alloc] initWithFrame:self.clientView.bounds];
  self.scrollView.delegate = self;
  [self.clientView addSubview:self.scrollView];
}

/** 创建主视图 */
- (void)createMainView {
  self.mainView = [[[NSBundle mainBundle] loadNibNamed:@"MatchCreateClientView"
                                                 owner:self
                                               options:nil] firstObject];
  self.mainView.frame = self.scrollView.bounds;
  [self.scrollView addSubview:self.mainView];
}

/** 创建比赛信息视图 */
- (void)createMatchInfoView {
  self.matchCreateMatchInfoVC = [[MatchCreateMatchInfoVC alloc] init];
  __weak MatchCreateViewController *weakSelf = self;
  self.matchCreateMatchInfoVC.beginRefreshCallBack = ^{
    if (weakSelf) {
      [weakSelf startLoading];
    }
  };
  self.matchCreateMatchInfoVC.endRefreshCallBack = ^{
    if (weakSelf) {
      [weakSelf stopLoading];
    }
  };
  self.matchCreateMatchInfoVC.matchCreateMatchInfoHeightChanged = ^{
    MatchCreateViewController *strongSelf = weakSelf;
    if (strongSelf) {
      strongSelf.matchInfoViewHeight.constant =
          260.f + strongSelf.matchCreateMatchInfoVC.matchDescriptionViewHeight.constant;
      [strongSelf resetScrollViewContentSizeWithOffHeight:0.f];
    }
  };
  self.matchCreateMatchInfoVC.view.width = self.mainView.width;
  [self addChildViewController:self.matchCreateMatchInfoVC];
  [self.matchInfoContainerView addSubview:self.matchCreateMatchInfoVC.view];
  self.matchInfoViewHeight.constant = 260.f + self.matchCreateMatchInfoVC.matchDescriptionViewHeight.constant;
}

/** 创建高校比赛信息视图 */
- (void)createUniversityMatchInfoView {
  UniversityInformationViewController *universityInfoVC = [[UniversityInformationViewController alloc] init];
  self.universityInformationVC = universityInfoVC;
  __weak MatchCreateViewController *weakSelf = self;
  self.matchCreateMatchInfoVC.beginRefreshCallBack = ^{
    if (weakSelf) {
      [weakSelf startLoading];
    }
  };
  self.matchCreateMatchInfoVC.endRefreshCallBack = ^{
    if (weakSelf) {
      [weakSelf stopLoading];
    }
  };
  universityInfoVC.univerInfoHeightBlock = ^(NSNumber *currentHeight, NSNumber *lastHeight) {
    MatchCreateViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.view endEditing:YES];
      strongSelf.schoolInfoViewHeight.constant = [currentHeight doubleValue];
      [strongSelf resetScrollViewContentSizeWithOffHeight:0.f];
      CGFloat contentOffSet = strongSelf.scrollView.contentOffset.y + [currentHeight doubleValue] -
                              [lastHeight doubleValue];
      if ([currentHeight doubleValue] < [lastHeight doubleValue]) {
        contentOffSet = strongSelf.scrollView.contentOffset.y;
      }
      [strongSelf.scrollView setContentOffset:CGPointMake(0, contentOffSet) animated:NO];
    }
  };
  self.universityInformationVC.view.width = self.mainView.width;
  [self addChildViewController:universityInfoVC];
  [self.schoolInfoContainerView addSubview:universityInfoVC.view];
  self.schoolInfoViewHeight.constant = 85.f;
}

/** 创建有奖比赛信息视图 */
- (void)createAwardContainerInfoView {
  AwardsMatchViewController *awardsMatchVC =
      [[AwardsMatchViewController alloc] initWithNibName:@"AwardsMatchViewController"
                                                  bundle:nil
                                               withFrame:CGRectMake(0, 0, self.clientView.bounds.size.width, 87)];
  self.awardsVC = awardsMatchVC;
  __weak MatchCreateViewController *weakSelf = self;
  awardsMatchVC.foreignProvideFrameBlock = ^(CGRect frame) {
    MatchCreateViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.view endEditing:YES];
      strongSelf.awardInfoViewHeight.constant = frame.size.height;
      [strongSelf resetScrollViewContentSizeWithOffHeight:0.f];
      CGFloat contentOffSet = strongSelf.mainView.height - strongSelf.clientView.height;
      [strongSelf.scrollView setContentOffset:CGPointMake(0, (contentOffSet < 0 ? -contentOffSet : contentOffSet))
                                     animated:NO];
    }
  };

  awardsMatchVC.matchStartIndicatorBlock = ^() {
    MatchCreateViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView startAnimating];
      strongSelf.indicatorView.hidden = NO;
    }
  };

  awardsMatchVC.matchStopIndicatorBlock = ^() {
    MatchCreateViewController *strongSelf = weakSelf;
    if (strongSelf) {
      strongSelf.indicatorView.hidden = YES;
      [strongSelf.indicatorView stopAnimating];
    }
  };
  [self addChildViewController:awardsMatchVC];
  [self.awardContainerInfoView addSubview:awardsMatchVC.view];
  self.awardInfoViewHeight.constant = awardsMatchVC.view.height;
}

/** 右侧“创建”按钮 */
- (void)createMatchCreateBtn {
  UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  self.createBtn = createBtn;
  createBtn.frame = CGRectMake(_topToolBar.width - 60, _topToolBar.height - 45, 60, 45);
  createBtn.backgroundColor = [UIColor clearColor];
  [createBtn setTitleColor:[Globle colorFromHexRGB:@"4dfdff"] forState:UIControlStateNormal];
  createBtn.clipsToBounds = NO;
  [createBtn.titleLabel setFont:[UIFont systemFontOfSize:Font_Height_16_0]];
  [createBtn setTitle:@"创建" forState:UIControlStateNormal];
  UIImage *rightImage =
      [[UIImage imageNamed:@"return_touch_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 14, 14)];
  [createBtn setBackgroundImage:rightImage forState:UIControlStateHighlighted];
  __weak MatchCreateViewController *weakSelf = self;
  [createBtn setOnButtonPressedHandler:^{
    MatchCreateViewController *strongSelf = weakSelf;
    if (strongSelf) {
      /// 注意：此处必须收回键盘，页面需要在结束编辑时设置数据
      [strongSelf.view endEditing:YES];
      /// 校验比赛基本数据
      if (![strongSelf.matchCreateMatchInfoVC checkMatchInfo]) {
        return;
      }
      /// 校验比赛高校信息
      if (![strongSelf.universityInformationVC checkUnivserInfo]) {
        return;
      }
      /// 校验比赛有奖信息
      if (![strongSelf.awardsVC checkDataSource]) {
        return;
      }
      [strongSelf requestCheckMatchInfo];
    }
  }];
  [_topToolBar addSubview:createBtn];
}

#pragma mark---------比赛信息校验----------
/** 校验比赛信息接口 */
- (void)requestCheckMatchInfo {
  /*
   	比赛开始时间必须晚于创建当天
   	比赛开始时间不能晚于创建次日后的30天开赛
   	比赛开始时间必须大于比赛结束时间
   	最长比赛时间不能超过90天
   */
  [self startLoading];

  if (![SimuUtil isExistNetwork]) {
    [self stopLoading];
    [NewShowLabel showNoNetworkTip];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MatchCreateViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MatchCreateViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    [weakSelf bindSimuPositionPageData:(SimuValidateMatchData *)obj];
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *ex) {
    if ([obj.status isEqualToString:@"0219"]) {
      JsonErrorObject *err = (JsonErrorObject *)obj;
      NSString *errMsg = err.errorDetailInfo[@"result"][@"matchName"][@"valiMsg"];
      if (!errMsg) {
        errMsg = err.errorDetailInfo[@"result"][@"matchTime"][@"valiMsg"];
      }
      if (!errMsg) {
        errMsg = err.errorDetailInfo[@"result"][@"inviteCode"][@"valiMsg"];
      }
      if (errMsg) {
        [NewShowLabel setMessageContent:errMsg];
      } else {
        [BaseRequester defaultErrorHandler](obj, ex);
      }
    } else {
      [BaseRequester defaultErrorHandler](obj, ex);
    }
  };

  [SimuValidateMatchData requestSimuValidateMatchDataWtihMatchInfo:self.matchCreateMatchInfoVC.matchInfo
                                                      withCallback:callback];
}

/** 比赛验证回调 */
- (void)bindSimuPositionPageData:(SimuValidateMatchData *)validataMatchData {
  if ([validataMatchData.status isEqualToString:@"0000"]) {
    /// 校验成功弹出确认框
    __weak MatchCreateViewController *weakSelf = self;
    [MatchCreateConfirmTip
        showTipWithMessage:[NSString stringWithFormat:@"您创建的比赛需要%@金币", self.matchCreateMatchInfoVC.createFee]
        withSureBlock:^{
          /// 调用创建比赛接口
          [weakSelf sendSubmitMatchRequest];
        }
        withCancelBlock:^{
            /// 暂不处理
        }];
  } else {
    [self verificationStatusForValidateMatch:validataMatchData.status
                                 withMessage:validataMatchData.message
                               withException:validataMatchData.errorDictionary];
  }
}

/** 校验比赛 */
- (void)verificationStatusForValidateMatch:(NSString *)localStatus
                               withMessage:(NSString *)localMessage
                             withException:(NSDictionary *)exception {
  NSInteger statusInt = [localStatus integerValue];
  switch (statusInt) {
  case 219: {
    /// 邀请码
    NSDictionary *inviteCodeDict = exception[@"inviteCode"];
    if (inviteCodeDict) {
      NSString *inviteCodeStatus = [SimuUtil changeIDtoStr:inviteCodeDict[@"valiFlag"]];
      /// 邀请码已过期
      if (![inviteCodeStatus integerValue]) {
        /// 获得邀请码
        [self.matchCreateMatchInfoVC requestStockMatchInvitationCode];
        [NewShowLabel setMessageContent:inviteCodeDict[@"valiMsg"]];
      }
    }
    /// 比赛名称不能重复
    NSDictionary *matchNameDict = exception[@"matchName"];
    if (matchNameDict) {
      NSString *matchNameStatus = [SimuUtil changeIDtoStr:matchNameDict[@"valiFlag"]];
      if (![matchNameStatus integerValue]) {
        [NewShowLabel setMessageContent:matchNameDict[@"valiMsg"]];
      }
    }
    /// 比赛开始时间exc
    NSDictionary *matchTimeDict = exception[@"matchTime"];
    if (matchTimeDict) {
      NSString *matchTimeStatus = [SimuUtil changeIDtoStr:matchTimeDict[@"valiFlag"]];
      if (![matchTimeStatus integerValue]) {
        [NewShowLabel setMessageContent:matchTimeDict[@"valiMsg"]];
      }
    }
  } break;
  default:
    [NewShowLabel setMessageContent:localMessage];
    break;
  }
}

#pragma mark---------创建比赛----------
/** 发送提交比赛请求 */
- (void)sendSubmitMatchRequest {
  if (![SimuUtil isLogined]) {
    return;
  }

  [self startLoading];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MatchCreateViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MatchCreateViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    [weakSelf bindSimuOpenMatchData:(SimuOpenMatchData *)obj];
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    [weakSelf.matchCreateMatchInfoVC verificationStatusForCreateMatch:obj.status
                                                          withMessage:obj.message];
  };

  self.matchCreateMatchInfoVC.matchInfo.userName = [SimuUtil getUserName];
  [SimuOpenMatchData requestMatchCreateWithMatchInfo:self.matchCreateMatchInfoVC.matchInfo
                                      universityInfo:self.universityInformationVC.matchUniversityInfo
                                           awardInfo:self.awardsVC.matchAwardInfo
                                        withCallback:callback];
}
/** 提交比赛回调 */
- (void)bindSimuOpenMatchData:(SimuOpenMatchData *)openMatchData {
  /// 购买成功取消缓存
  [self.matchCreateMatchInfoVC savePreviousMatchInfoWithMatchName:@"" withMatchDescription:@""];
  [MPNotificationView notifyWithText:openMatchData.message andDuration:1.5];
  /// 清除邀请码信息
  self.matchCreateMatchInfoVC.invitationCodeLabel.text = @"";
  [self.matchCreateMatchInfoVC.invitationCodeSwitch setOn:NO];
  self.matchCreateMatchInfoVC.invitationCodeLabel.hidden = YES;
  /// 清空输入框
  self.matchCreateMatchInfoVC.matchDescriptionTextView.text = @"";
  self.matchCreateMatchInfoVC.matchNameTextView.text = @"";
  /// 先释放当前页
  [self matchCreatingSuccess:openMatchData.dataArray[0]];
}

- (void)matchCreatingSuccess:(NSDictionary *)dict {
  MatchCreateSuccessViewController *matchCreateSuccessVC = [[MatchCreateSuccessViewController alloc] init];
  __weak MatchCreateViewController *weakSelf = self;
  matchCreateSuccessVC.leftBackBlock = ^{
    [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    [weakSelf.navigationController popViewControllerAnimated:NO];
  };
  matchCreateSuccessVC.matchName = dict[@"matchName"];
  matchCreateSuccessVC.matchDescr = dict[@"matchDescp"];
  matchCreateSuccessVC.matchInviteCode = dict[@"inviteCode"];
  matchCreateSuccessVC.matchCreator = dict[@"creator"];
  matchCreateSuccessVC.matchCreatorNickName = [SimuUtil getUserNickName];
  matchCreateSuccessVC.matchImageUrl = dict[@"background"];
  matchCreateSuccessVC.matchTime =
      [NSString stringWithFormat:@"%@至%@", dict[@"openTime"], dict[@"closeTime"]];
  matchCreateSuccessVC.parentVC = self;

  [AppDelegate pushViewControllerFromRight:matchCreateSuccessVC];
}

- (void)resetScrollViewContentSizeWithOffHeight:(CGFloat)offHeight {
  CGFloat contentHeight = 33.0f + _matchInfoViewHeight.constant + _schoolInfoViewHeight.constant +
                          _awardInfoViewHeight.constant + offHeight + _sixHeight;
  _scrollView.contentSize =
      CGSizeMake(WIDTH_OF_SCREEN, (contentHeight > _clientView.height ? contentHeight : _clientView.height));
  _mainView.height = _scrollView.contentSize.height;
}

#pragma mark--- 键盘监听相关响应函数 ---
/** 键盘出现时的响应函数 */
- (void)keyboardWillChange:(NSNotification *)notification {
  //停止表格滚动
  [self.scrollView setContentOffset:self.scrollView.contentOffset animated:NO];

  CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  NSLog(@"%f", keyboardRect.origin.y);
  if (keyboardRect.origin.y == HEIGHT_OF_SCREEN) {
    /// 键盘将要消失时且键盘出现时恢复滚动视图位置
    self.scrollView.top = 0;
    return;
  }

  UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
  UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
  CGPoint point = [[firstResponder superview] convertPoint:firstResponder.origin toView:nil];

  CGFloat height = keyboardRect.origin.y - (point.y + firstResponder.height - self.scrollView.top);

  //如果触发键盘的UIView只显示了一半，则向下滚动该UIView的高度
  if (point.y + firstResponder.height > keyboardRect.origin.y + keyboardRect.size.height) {
    self.scrollView.scrollEnabled = NO;
    CGPoint point = CGPointMake(self.scrollView.contentOffset.x,
                                self.scrollView.contentOffset.y + firstResponder.height);
    [self.scrollView setContentOffset:point animated:NO];
    self.scrollView.scrollEnabled = YES;
  }
  if (height > 0) {
    /// 键盘将要出现但是不会遮盖输入框时不做处理
    return;
  }
  /// 键盘将要出现且会遮盖输入框时的处理
  if (self.scrollView.top == 0) {
    self.scrollView.top = height;
  }
  NSLog(@"%f", self.scrollView.top);
}

/** 页面滚动收键盘 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (self.scrollView.scrollEnabled) {
    [self.view endEditing:YES];
  }
}

- (void)startLoading {
  [self.indicatorView startAnimating];
  self.indicatorView.hidden = NO;
}

- (void)stopLoading {
  [self.indicatorView stopAnimating];
  self.indicatorView.hidden = YES;
}

@end
