//
//  MatchCreateInfoViewController.m
//  SimuStock
//
//  Created by jhss_wyz on 15/8/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MatchCreateMatchInfoVC.h"
#import "Globle.h"
#import "DateTipView.h"
#import "SelectMatchInitialFundSingle.h"
#import "NewShowLabel.h"
#import "SimuMatchGetInviteCodeData.h"
#import "MatchCreateViewController.h"
#import "SimuOpenMatchData.h"
#import "BottomDividingLineView.h"
#import "SimuMatchTemplateData.h"
#import "BaseRequester.h"
#import "SelectMatchPurposeSingle.h"
#import "UIPlaceHolderTextView.h"
#import "ConditionsWithKeyBoardUsing.h"
#import "FTCoreTextView.h"

@implementation MatchCreateMatchInfoVC

- (void)dealloc {
  [SelectMatchInitialFundSingle shared].selectMatchInitialFundBlock = nil;
  [SelectMatchInitialFundSingle shared].isDataBinded = NO;
  [SelectMatchInitialFundSingle shared].isTipShown = NO;
  [_dateTipView removeFromSuperview];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.matchInfo = [[MatchCreateMatchInfo alloc] init];

  self.matchNameTextView.delegate = self;
  self.matchDescriptionTextView.delegate = self;
  [self initMatchStartAndEndTime];
  [self createDateView];
  [self resetInitialFundBtn];
  [self initMatchNameAndDescription];

  __weak MatchCreateMatchInfoVC *weakSelf = self;
  [SelectMatchInitialFundSingle shared].beginRefreshCallBack = ^{
    if (weakSelf && weakSelf.beginRefreshCallBack) {
      weakSelf.beginRefreshCallBack();
    }
  };
  [SelectMatchInitialFundSingle shared].endRefreshCallBack = ^{
    if (weakSelf && weakSelf.endRefreshCallBack) {
      weakSelf.endRefreshCallBack();
    }
  };

  self.matchNameTextView.placeholder = @"请输入比赛名称";
  self.matchNameTextView.placeholderColor = [Globle colorFromHexRGB:@"#939393"];
  self.matchDescriptionTextView.placeholder = @"请输入比赛简介";
  self.matchDescriptionTextView.placeholderColor = [Globle colorFromHexRGB:@"#939393"];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  if ([self.matchDescriptionTextView.text length] > 0) {
    [self resetMatchDescriptionTextViewHeightWithString:self.matchDescriptionTextView.text];
  }
}

#pragma mark--------日期选择---------
/** 比赛开始时间和结束时间按钮点击响应函数 */
- (IBAction)timeBtnClick:(UIButton *)sender {
  [self endEdit];
  [self showDateView:(sender == self.matchStartDateBtn)];
}

/** 显示时间选择弹出框 */
- (void)showDateView:(BOOL)isStartTime {
  [_dateTipView resetTitle:(isStartTime ? @"开始时间" : @"结束时间")
                      date:(isStartTime ? self.matchInfo.openTime : self.matchInfo.closeTime)];
  _dateTipView.hidden = NO;
  isMatchStartTime = isStartTime;
}

- (void)dateTipBtnClick:(UIButton *)btn {
  /// 确定
  if (btn == _dateTipView.confirmButton) {
    if (isMatchStartTime) {
      self.matchInfo.openTime = [_dateTipView getSelectedDateTime];
      [self.matchStartDateBtn setTitle:self.matchInfo.openTime forState:UIControlStateNormal];
    } else {
      self.matchInfo.closeTime = [_dateTipView getSelectedDateTime];
      [self.matchEndDateBtn setTitle:self.matchInfo.closeTime forState:UIControlStateNormal];
    }
    [self checkMatchStartDateAndEndDate];
  }
  _dateTipView.hidden = YES;
}

/** 创建时间选择弹出框 */
- (void)createDateView {
  DateTipView *dateTipView = [[DateTipView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN)
                                                      withTitle:nil
                                                withCurrentTime:self.matchInfo.openTime];

  _dateTipView = dateTipView;
  __weak MatchCreateMatchInfoVC *weakSelf = self;

  /// 确定
  [_dateTipView.confirmButton setOnButtonPressedHandler:^{
    [weakSelf dateTipBtnClick:weakSelf.dateTipView.confirmButton];
  }];
  /// 取消
  [_dateTipView.backButton setOnButtonPressedHandler:^{
    [weakSelf dateTipBtnClick:weakSelf.dateTipView.backButton];
  }];

  _dateTipView.hidden = YES;
  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
  [mainWindow addSubview:_dateTipView];
}

/** 初始化比赛开始结束时间 */
- (void)initMatchStartAndEndTime {
  /// 获得当前时间
  NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
  [dateformatter setDateFormat:@"YYYY-MM-dd"];
  NSDate *tomorrowDate = [NSDate dateWithTimeIntervalSinceNow:86400];
  NSDate *nextMonthDate = [NSDate dateWithTimeIntervalSinceNow:2678400];
  NSString *tomorrowString = [dateformatter stringFromDate:tomorrowDate];
  NSString *nextMonthString = [dateformatter stringFromDate:nextMonthDate];
  self.matchInfo.openTime = tomorrowString;
  self.matchInfo.closeTime = nextMonthString;
  [self.matchStartDateBtn setTitle:self.matchInfo.openTime forState:UIControlStateNormal];
  [self.matchEndDateBtn setTitle:self.matchInfo.closeTime forState:UIControlStateNormal];
}

/** 校验比赛开始结束时间间隔 */
- (BOOL)checkMatchStartDate:(NSString *)startTime andEndDate:(NSString *)endTime {
  int startYear = [[startTime substringWithRange:NSMakeRange(0, 4)] intValue];
  int startMonth = [[startTime substringWithRange:NSMakeRange(5, 2)] intValue];
  int startDay = [[startTime substringWithRange:NSMakeRange(startTime.length - 2, 2)] intValue];

  int endYear = [[endTime substringWithRange:NSMakeRange(0, 4)] intValue];
  int endMonth = [[endTime substringWithRange:NSMakeRange(5, 2)] intValue];
  int endDay = [[endTime substringWithRange:NSMakeRange(endTime.length - 2, 2)] intValue];
  /// 1.当 年 月 都相同的时  2.当 年相同 月不相同时  3.当 年不相同时
  if (startYear == endYear) {
    if (startMonth == endMonth) {
      if (endDay - startDay < 5) {
        [NewShowLabel setMessageContent:@"比赛周期不能少于5天"];
        return NO;
      }
    } else if (endMonth - startMonth > 3) {
      [NewShowLabel setMessageContent:@"比赛时间不能超过3个月"];
      return NO;
    } else if (endMonth - startMonth == 3) {
      if (endDay > startDay) {
        [NewShowLabel setMessageContent:@"比赛时间不能超过3个月"];
        return NO;
      }
    }
  } else if (endYear - startYear == 1) {
    if ((12 - startMonth) + endMonth > 3) {
      [NewShowLabel setMessageContent:@"比赛时间不能超过3个月"];
      return NO;
    } else if ((12 - startMonth) + endMonth == 3) {
      if (endDay > startDay) {
        [NewShowLabel setMessageContent:@"比赛时间不能超过3个月"];
        return NO;
      }
    }
  } else if (endYear - startYear > 1) {
    [NewShowLabel setMessageContent:@"比赛时间不能超过3个月"];
    return NO;
  }
  return YES;
}

#pragma mark---------初始资金处理----------
- (void)clickOnInitialFundBtn {
  [SelectMatchPurposeSingle shared].selectMatchPurposeBlock = nil;
  /// 结束编辑状态
  [self endEdit];
  __weak MatchCreateMatchInfoVC *weakSelf = self;
  [SelectMatchInitialFundSingle shared].selectMatchInitialFundBlock = ^(NSString *templateID) {
    MatchCreateMatchInfoVC *strongSelf = weakSelf;
    if (strongSelf) {
      if ([templateID length] < 1) {
        SimuMatchTemplateData *item = [SelectMatchInitialFundSingle shared].matchData.dataArray[0];
        [strongSelf.initialFundBtn setTitle:item.mTemplateName forState:UIControlStateNormal];
        [strongSelf.initialFundBtn setTitleColor:[Globle colorFromHexRGB:@"#5A5A5A"]
                                        forState:UIControlStateNormal];
        strongSelf.matchInfo.templateId = item.mTemplateID;
        strongSelf.createFee = item.mCreateFee;
      } else {
        [[SelectMatchInitialFundSingle shared]
                .matchData.dataArray enumerateObjectsUsingBlock:^(SimuMatchTemplateData *item, NSUInteger idx, BOOL *stop) {
          if ([templateID isEqualToString:item.mTemplateID]) {
            [strongSelf.initialFundBtn setTitle:item.mTemplateName forState:UIControlStateNormal];
            [strongSelf.initialFundBtn setTitleColor:[Globle colorFromHexRGB:@"#5A5A5A"]
                                            forState:UIControlStateNormal];
            strongSelf.matchInfo.templateId = item.mTemplateID;
            strongSelf.createFee = item.mCreateFee;
          }
        }];
      }
    }
  };
  [[SelectMatchInitialFundSingle shared] showSelectTip];
}

- (void)resetInitialFundBtn {
  __weak MatchCreateMatchInfoVC *weakSelf = self;
  [self.initialFundBtn setOnButtonPressedHandler:^{
    if (weakSelf) {
      [weakSelf clickOnInitialFundBtn];
    }
  }];
}

#pragma mark---------邀请码处理----------
- (IBAction)invitationCodeStateChanged:(id)sender {
  if (self.invitationCodeSwitch.on) {
    double timeInternal = [[NSDate date] timeIntervalSince1970];
    if (timeInternal - [[NSUserDefaults standardUserDefaults] integerForKey:@"inviteTimeInternal"] < 300) { /// 读取缓存
      [self showInviteCodeView];
    } else {
      //获得邀请码
      [self requestStockMatchInvitationCode];
    }
  } else {
    self.matchInfo.hasInviteCode = NO;
    self.invitationCodeLabel.hidden = YES;
    self.invitationCodeInstructionLabel.hidden = NO;
  }
}

- (void)requestStockMatchInvitationCode {
  if (![SimuUtil isExistNetwork]) {
    [self getInvitationCodeFailed];
    [NewShowLabel showNoNetworkTip];
    return;
  }

  if (self.beginRefreshCallBack) {
    self.beginRefreshCallBack();
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MatchCreateMatchInfoVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MatchCreateMatchInfoVC *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.endRefreshCallBack) {
        strongSelf.endRefreshCallBack();
      }
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    if (weakSelf) {
      [weakSelf bindSimuMatchGetInviteCodeData:(SimuMatchGetInviteCodeData *)obj];
    }
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *ex) {
    if (weakSelf) {
      [weakSelf getInvitationCodeFailed];
    }
  };

  callback.onFailed = ^{
    if (weakSelf) {
      [weakSelf getInvitationCodeFailed];
    }
  };

  [SimuMatchGetInviteCodeData requestSimuMatchGetInviteCodeDataWithCallback:callback];
}

- (void)bindSimuMatchGetInviteCodeData:(SimuMatchGetInviteCodeData *)codeData {

  self.matchInfo.inviteCode = codeData.dataArray[1];
  /// 保存之前获得邀请码时间
  double timeInternal = [[NSDate date] timeIntervalSince1970];
  [[NSUserDefaults standardUserDefaults] setInteger:timeInternal forKey:@"inviteTimeInternal"];
  [[NSUserDefaults standardUserDefaults] setObject:self.matchInfo.inviteCode
                                            forKey:@"invitationCode"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  /// 调用邀请码开关点击响应函数，更新邀请码显示状态
  [self invitationCodeStateChanged:self.invitationCodeSwitch];
}

- (void)showInviteCodeView {
  self.matchInfo.inviteCode =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"invitationCode"];

  if (!self.matchInfo.inviteCode || self.matchInfo.inviteCode.length == 0) {
    self.matchInfo.hasInviteCode = NO;
    [self.invitationCodeSwitch setOn:NO animated:YES];
    return;
  }
  self.invitationCodeLabel.text = self.matchInfo.inviteCode;
  self.matchInfo.hasInviteCode = YES;
  self.invitationCodeInstructionLabel.hidden = YES;
  self.invitationCodeLabel.hidden = NO;
}

- (void)getInvitationCodeFailed {
  self.matchInfo.hasInviteCode = NO;
  [self.invitationCodeSwitch setOn:NO animated:YES];
}

#pragma mark---------校验创建比赛的数据----------
- (BOOL)checkMatchInfo {
  [self endEdit];
  _dateTipView.hidden = YES;

  NSString *matchName = self.matchNameTextView.text;
  NSString *matchDescription = self.matchDescriptionTextView.text;

  self.matchInfo.matchName = matchName;
  self.matchInfo.matchDescp = matchDescription;

  if ([matchName length] == 0) {
    [NewShowLabel setMessageContent:@"请输入比赛名称"];
    return NO;
  } else if (![[ConditionsWithKeyBoardUsing shareInstance] isnumberOrChar:matchName]) {
    [NewShowLabel setMessageContent:@"比"
                                    @"赛名称由中文、英文或数字组成，请重新输入"];
    return NO;
  } else if ([matchDescription length] == 0) {
    [NewShowLabel setMessageContent:@"请输入比赛简介"];
    return NO;
  } else if (self.matchInfo.templateId.length == 0) {
    [NewShowLabel setMessageContent:@"请选择初始资金"];
    return NO;
  }

  //检验比赛名称长度
  if ([matchName length] > 8) {
    [NewShowLabel setMessageContent:@"比赛名称长度超过限制"];
    return NO;
  }

  if (![self checkMatchStartDateAndEndDate]) {
    return NO;
  }

  /// 校验比赛校验码
  if (self.matchInfo.hasInviteCode && !self.matchInfo.inviteCode && self.matchInfo.inviteCode.length == 0) {
    [self getInvitationCodeFailed];
  }

  return YES;
}

/** 比赛开始时间及结束时间校验 */
- (BOOL)checkMatchStartDateAndEndDate {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"YYYY-MM-dd"];
  NSDate *tomorrowDate = [NSDate dateWithTimeInterval:86400 sinceDate:[NSDate date]];

  NSString *tomorrowStr = [dateFormatter stringFromDate:tomorrowDate];
  NSDate *nextMonthDate = [NSDate dateWithTimeIntervalSinceNow:2678400];
  //转化时间,去掉时、分、秒
  NSString *nextMonthStr = [dateFormatter stringFromDate:nextMonthDate];
  nextMonthDate = [dateFormatter dateFromString:nextMonthStr];
  NSDate *startDate = [dateFormatter dateFromString:self.matchInfo.openTime];
  tomorrowDate = [dateFormatter dateFromString:tomorrowStr];
  if ([startDate timeIntervalSinceDate:tomorrowDate] < 0) {
    [NewShowLabel setMessageContent:@"比" @"赛" @"开" @"始时间必须晚于创建当天"];
    return NO;
  }
  // 11-23st  tomorrow10-24 nextdate11-23 13:49:43
  switch ([[dateFormatter dateFromString:self.matchInfo.openTime] compare:[dateFormatter dateFromString:self.matchInfo.closeTime]]) {
  //比下个月的同一天还要大
  case NSOrderedDescending: {
    [NewShowLabel setMessageContent:@"比" @"赛" @"结" @"束时间不能早于开始时间"];
    return NO;
  }
  case NSOrderedSame: {
    [NewShowLabel setMessageContent:@"比" @"赛" @"结束时间必须大于比赛开始时间"];
    return NO;
  };

  default:
    break;
  }

  /*
   比较两时间的差
   */
  BOOL isEnd =
      [self checkMatchStartDate:self.matchInfo.openTime andEndDate:self.matchInfo.closeTime];
  if (!isEnd) {
    return NO;
  }

  return YES;
}

/**区分返回的status*/
/**创建比赛*/
/*
 “0000”：请求成功，其他均为请求数据失败。
 “0212”：钻石余额不足，请充值
 “0215”：邀请码过期
 “0218”：扣钻石失败
 “0222”：金币余额不足
 “0223”：扣金币失败
 “1003”：创建人参加比赛失败
 “1001”：系统处理错误
 */
- (void)verificationStatusForCreateMatch:(NSString *)localStatus
                             withMessage:(NSString *)localMessage {
  NSInteger statusInt = [localStatus integerValue];
  switch (statusInt) {
  case 215: {
    [NewShowLabel setMessageContent:@"验证码过期"];
    //过期立即重置下
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"inviteTimeInternal"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //先将邀请码一栏清除
    if (self.invitationCodeSwitch.on) {
      self.invitationCodeLabel.text = @"";
      self.invitationCodeLabel.hidden = YES;
    }
    //获得邀请码
    [self requestStockMatchInvitationCode];
  } break;
  default:
    [NewShowLabel setMessageContent:localMessage];
    break;
  }
}

#pragma mark--------数据缓存-------
/** 缓存下数据(比赛名称，比赛描述，所选钻石类型) */
- (void)savePreviousMatchInfoWithMatchName:(NSString *)matchName
                      withMatchDescription:(NSString *)matchDescription {
  [[NSUserDefaults standardUserDefaults] setObject:matchName forKey:@"StockMatch_MatchName"];
  [[NSUserDefaults standardUserDefaults] setObject:matchDescription
                                            forKey:@"StockMatch_MatchDescr"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark---------UITextViewDelegate----------
- (void)textViewDidEndEditing:(UITextView *)textView {
  NSString *matchName =
      [self.matchNameTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  NSString *matchDescription =
      [self.matchDescriptionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  if (textView == self.matchNameTextView &&
      ![[ConditionsWithKeyBoardUsing shareInstance] isnumberOrChar:matchName]) {
    [NewShowLabel setMessageContent:@"比"
                                    @"赛名称由中文、英文或数字组成，请重新输入"];
    return;
  }
  self.matchNameTextView.text = matchName;
  self.matchDescriptionTextView.text = matchDescription;
  [self savePreviousMatchInfoWithMatchName:matchName withMatchDescription:matchDescription];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(textViewEditChanged:)
                                               name:UITextViewTextDidChangeNotification
                                             object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UITextViewTextDidChangeNotification
                                                object:nil];
}

- (void)textViewEditChanged:(NSNotification *)obj {
  UITextView *textView = (UITextView *)obj.object;
  NSInteger kMaxLength = 8;

  if (textView == self.matchDescriptionTextView) {
    kMaxLength = 30;
  } else if (textView == self.matchNameTextView) {
    kMaxLength = 8;
  } else {
    return;
  }

  NSString *toBeString = textView.text;
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UITextViewTextDidChangeNotification
                                                object:nil];
  /// 键盘输入模式
  NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
  if ([lang isEqualToString:@"zh-Hans"]) {
    /// 简体中文输入，包括简体拼音，健体五笔，简体手写
    UITextRange *selectedRange = [textView markedTextRange];
    /// 获取高亮部分
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (!position) {
      toBeString = [toBeString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
      textView.text = toBeString;
      /// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
      if (toBeString.length > kMaxLength) {
        textView.text = [toBeString substringToIndex:kMaxLength];
      }
    } else {
      /// 有高亮选择的字符串，则暂不对文字进行统计和限制
    }
  }
  /// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
  else {
    toBeString = [toBeString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    textView.text = toBeString;
    if (toBeString.length > kMaxLength) {
      textView.text = [toBeString substringToIndex:kMaxLength];
    }
  }
  /// 动态改变比赛简介视图的高度
  if (textView == self.matchDescriptionTextView) {
    [self resetMatchDescriptionTextViewHeightWithString:textView.text];
  }

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(textViewEditChanged:)
                                               name:UITextViewTextDidChangeNotification
                                             object:nil];
}

#pragma mark---------比赛名称和比赛简介处理----------
/** 初始化比赛名称和比赛简介 */
- (void)initMatchNameAndDescription {
  NSString *matchName =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"StockMatch_MatchName"];
  NSString *matchDescp =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"StockMatch_MatchDescr"];
  if ([matchName length] > 0) {
    self.matchInfo.matchName = matchName;
    self.matchNameTextView.text = matchName;
  }
  if ([matchDescp length] > 0) {
    self.matchInfo.matchDescp = matchDescp;
    self.matchDescriptionTextView.text = matchDescp;
    [self resetMatchDescriptionTextViewHeightWithString:matchDescp];
  }
}

/** 重设比赛简介视图的高度 */
- (void)resetMatchDescriptionTextViewHeightWithString:(NSString *)str {
  CGFloat matchDescriptionTextViewHeight =
      [FTCoreTextView heightWithText:str
                               width:(self.matchDescriptionTextView.width - 15.f)
                                font:15.f];
  self.matchDescriptionViewHeight.constant =
      matchDescriptionTextViewHeight < 20.f ? 42.f : (matchDescriptionTextViewHeight + 22.f);
  if (self.matchCreateMatchInfoHeightChanged) {
    self.matchCreateMatchInfoHeightChanged();
  }
}

- (void)endEdit {
  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
  [mainWindow endEditing:YES];
}

@end
