//
//  MatchCreatingVC.m
//  SimuStock
//
//  Created by Yuemeng on 15/7/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MatchCreatingSubView.h"
#import "Globle.h"
#import "SimuMatchTemplateData.h"
#import "SimuUtil.h"
#import "NewShowLabel.h"
#import "BaseRequester.h"
#import "SimuMatchGetInviteCodeData.h"
#import "SimuValidateMatchData.h"
#import "SimuOpenMatchData.h"
#import "MPNotificationView.h"
#import "MatchCreatingViewController.h"
#import "MatchCreateSuccessViewController.h"
#import "MobClick.h"

@interface MatchCreatingSubView ()

@end

@implementation MatchCreatingSubView

- (instancetype)initWithSuperVC:(MatchCreatingViewController *)superVC {
  if (self = [super init]) {
    _superVC = superVC;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  __weak MatchCreatingSubView *weakSelf = self;
  _superVC.refreshButtonPressDownBlock = ^() {
    [weakSelf refreshButtonPressDown];
  };

  _code4Labels = @[ _code1Label, _code2Label, _code3Label, _code4Label ];

  _matchInfoTextView.layer.borderColor =
      [Globle colorFromHexRGB:Color_Border].CGColor;
  _startTimeBtn.layer.borderColor =
      [Globle colorFromHexRGB:Color_Blue_but].CGColor;
  _endTimeBtn.layer.borderColor =
      [Globle colorFromHexRGB:Color_Blue_but].CGColor;
  _codeBtn.layer.borderColor = [Globle colorFromHexRGB:Color_Border].CGColor;
  _codeView.layer.borderColor = [Globle colorFromHexRGB:@"#909090"].CGColor;
  _line1Width.constant = 0.5f;
  _line2Width.constant = 0.5f;
  _line3Width.constant = 0.5f;

  if ([[[NSUserDefaults standardUserDefaults]
          objectForKey:@"StockMatch_MatchName"] length] > 0) {
    _matchNameTextField.text = [[NSUserDefaults standardUserDefaults]
        objectForKey:@"StockMatch_MatchName"];
  }
  if ([[[NSUserDefaults standardUserDefaults]
          objectForKey:@"StockMatch_MatchDescr"] length] > 0) {
    _matchInfoTextView.text = [[NSUserDefaults standardUserDefaults]
        objectForKey:@"StockMatch_MatchDescr"];
    _placeHolderLabel.hidden = YES;
  }
  if ([[self getUserFundInfo] length] > 0) {
    _blueCursorXCons.constant = [[NSUserDefaults standardUserDefaults]
                                    floatForKey:@"StockMatch_VerinerPosition"] -
                                9;
  }

  //创建时间选择器
  [self createInitTime];
  [self createDateView];
  [self requestMatchTemplateList];
}

- (void)createInitTime {
  //获得当前时间
  NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
  [dateformatter setDateFormat:@"YYYY-MM-dd"];
  NSDate *tomorrowDate = [NSDate dateWithTimeIntervalSinceNow:86400];
  NSDate *nextMonthDate = [NSDate dateWithTimeIntervalSinceNow:2678400];
  NSString *tomorrowString = [dateformatter stringFromDate:tomorrowDate];
  NSString *nextMonthString = [dateformatter stringFromDate:nextMonthDate];
  _startTimeStr = tomorrowString;
  _endTimeStr = nextMonthString;
  [_startTimeBtn setTitle:_startTimeStr forState:UIControlStateNormal];
  [_endTimeBtn setTitle:_endTimeStr forState:UIControlStateNormal];
}

- (void)createDateView {
  _dateTipView = [[DateTipView alloc]
        initWithFrame:CGRectMake(0, -65, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN)
            withTitle:nil
      withCurrentTime:_startTimeStr];
  //确定
  [_dateTipView.confirmButton addTarget:self
                                 action:@selector(dateTipBtnClick:)
                       forControlEvents:UIControlEventTouchUpInside];
  //取消
  [_dateTipView.backButton addTarget:self
                              action:@selector(dateTipBtnClick:)
                    forControlEvents:UIControlEventTouchUpInside];

  _dateTipView.hidden = YES;
  [self.view addSubview:_dateTipView];
}

- (void)dateTipBtnClick:(UIButton *)btn {
  //确定
  if (btn == _dateTipView.confirmButton) {
    if (_isStartTime) {
      _startTimeStr = [_dateTipView getSelectedDateTime];
      [_startTimeBtn setTitle:_startTimeStr forState:UIControlStateNormal];
    } else {
      _endTimeStr = [_dateTipView getSelectedDateTime];
      [_endTimeBtn setTitle:_endTimeStr forState:UIControlStateNormal];
    }
  }
  _dateTipView.hidden = YES;
}

/**用户起始资金信息, 获取之前用户存储的模板*/
- (NSString *)getUserFundInfo {
  _matchFundInfo = [[NSUserDefaults standardUserDefaults]
      objectForKey:@"StockMatch_TemplateID"];
  if ([_matchFundInfo length] > 0) {
    NSArray *array = [_matchFundInfo componentsSeparatedByString:@"#"];
    if ([array count] == 3) {
      _templateID = array[0];
      _isDiamondMatch = [array[1] boolValue];
      _numberOfUsingDiamond = [array[2] intValue];
      return _templateID;
    } else {
      return @"";
    }
  } else {
    return @"";
  }
}

#pragma mark--------日期选择---------
- (IBAction)timeBtnClick:(UIButton *)sender {
  [self.view endEditing:YES];
  [self showDateView:(sender == _startTimeBtn)];
}

#pragma mark--------资金切换---------
- (IBAction)tapFund:(UITapGestureRecognizer *)sender {

  CGFloat centerX = 0;

  //当前选中模板ID
  if ([_matchTemplateArray count] > 0) {
    SimuMatchTemplateData *item;

    if (sender == _tap10) {
      centerX = _fund10Label.centerX;
      item = _matchTemplateArray[0];
    } else if (sender == _tap100) {
      centerX = _fund100Label.centerX;
      item = _matchTemplateArray[1];
    } else if (sender == _tap1000) {
      centerX = _fund1000Label.centerX;
      item = _matchTemplateArray[2];
    }
    _templateID = item.mTemplateID;
    _isDiamondMatch = [item.mCreateFlag boolValue];
    _numberOfUsingDiamond = [item.mCreateFee integerValue];

    _blueCursorXCons.constant = centerX - 9;
    [UIView animateWithDuration:.3f
                     animations:^{
                       [_blueCursor layoutIfNeeded];
                     }];
  }
}

#pragma mark--------点击邀请码---------
- (IBAction)codeSelectBtnCLK:(UIButton *)sender {
  // 1.如果已选中，则直接未选中
  // 2.如果没有选中的话，判断是否有缓存后变为选中

  if (_codeBtn.selected) {
    _codeBtn.selected = NO;
    _inviteCodeView.hidden = YES;
  } else {
    if (![SimuUtil isExistNetwork]) {
      return;
    }
    _codeBtn.selected = YES;
    NSInteger timeInternal = [[NSDate date] timeIntervalSince1970];
    if (timeInternal - [[NSUserDefaults standardUserDefaults]
                           integerForKey:@"inviteTimeInternal"] <
        300) { //读取缓存
      [self showInviteCodeView];
    } else {
      //获得邀请码
      [self requestStockMatchInvitationCode];
    }
  }
}

- (void)showInviteCodeView {
  _tempInvitationCode =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"invitationCode"];

  if (!_tempInvitationCode || _tempInvitationCode.length == 0) {
    _codeBtn.selected = NO;
    return;
  }
  [_code4Labels enumerateObjectsUsingBlock:^(UILabel *codeLabel, NSUInteger idx,
                                             BOOL *stop) {
    codeLabel.text =
        [_tempInvitationCode substringWithRange:NSMakeRange(idx, 1)];
  }];
  _inviteCodeView.hidden = NO;
}

- (void)requestStockMatchInvitationCode {

  [_superVC.indicatorView startAnimating];

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MatchCreatingSubView *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MatchCreatingSubView *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    MatchCreatingSubView *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf
          bindSimuMatchGetInviteCodeData:(SimuMatchGetInviteCodeData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [SimuMatchGetInviteCodeData
      requestSimuMatchGetInviteCodeDataWithCallback:callback];
}

#pragma mark 获取比赛邀请码回调
- (void)bindSimuMatchGetInviteCodeData:(SimuMatchGetInviteCodeData *)codeData {

  _tempInvitationCode = codeData.dataArray[1];
  //保存之前获得邀请码时间
  NSInteger timeInternal = [[NSDate date] timeIntervalSince1970];
  [[NSUserDefaults standardUserDefaults] setInteger:timeInternal
                                             forKey:@"inviteTimeInternal"];
  [[NSUserDefaults standardUserDefaults] setObject:_tempInvitationCode
                                            forKey:@"invitationCode"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  //显示邀请码
  [self showInviteCodeView];
}

- (void)refreshButtonPressDown {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self stopLoading];
    return;
  }
  [self requestMatchTemplateList];
  //游标移到首位置
  [self tapFund:_tap10];

  //缓存下填写信息模板id、是否钻石比赛、钻石数
  _matchFundInfo =
      [NSString stringWithFormat:@"%@#%d#%ld", _templateID, _isDiamondMatch,
                                 (long)_numberOfUsingDiamond];
  [[NSUserDefaults standardUserDefaults]
      setFloat:_blueCursor.center.x
        forKey:@"StockMatch_VerinerPosition"];
  [[NSUserDefaults standardUserDefaults] setObject:_matchFundInfo
                                            forKey:@"StockMatch_TemplateID"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark--------日期选择框---------
- (void)showDateView:(BOOL)isStartTime {
  [_dateTipView resetTitle:(isStartTime ? @"开始时间" : @"结束时间")
                      date:(isStartTime ? _startTimeStr : _endTimeStr)];
  _dateTipView.hidden = NO;
  _isStartTime = isStartTime;
}

#pragma mark---------uitextFieldDelegate-----
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self.view endEditing:YES];
  return YES;
}

#pragma mark---------uitextViewDelegate------
- (void)textViewDidChange:(UITextView *)textView {
  if ([textView.text length] > 0) {
    _placeHolderLabel.hidden = YES;
  } else {
    _placeHolderLabel.hidden = NO;
  }
}

- (BOOL)textView:(UITextView *)textView
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text {
  if ([text isEqualToString:@"\n"])
    return NO;
  if (range.location >= 30) {
    NSString *toBeString = [textView.text substringToIndex:30];
    textView.text = toBeString;
    return NO;
  } else {
    return YES;
  }
}

#pragma mark - 网络请求
#pragma mark--------刷新按钮delegate----
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
}

- (void)stopLoading {
  [_superVC.indicatorView stopAnimating]; //停止菊花
}

#pragma mark 发送获取比赛模板请求
- (void)requestMatchTemplateList {

  if (![SimuUtil isLogined]) {
    return;
  }

  [_superVC.indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MatchCreatingSubView *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MatchCreatingSubView *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    MatchCreatingSubView *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSimuMatchTemplateData:(SimuMatchTemplateData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [SimuMatchTemplateData requestSimuMatchTemplateDataWithCallback:callback];
}

#pragma mark 比赛模板数据
- (void)bindSimuMatchTemplateData:(SimuMatchTemplateData *)matchData {
  _matchTemplateArray = [[NSArray alloc] initWithArray:matchData.dataArray];

  NSArray *diamondLabels =
      @[ _diamondLeftLabel, _diamondMidLabel, _diamondRightLabel ];
  NSArray *fundLabels = @[ _fund10Label, _fund100Label, _fund1000Label ];

  [diamondLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx,
                                              BOOL *stop) {
    SimuMatchTemplateData *data = _matchTemplateArray[idx];
    BOOL isDiamondCreated = [data.mCreateFlag boolValue];
    label.hidden = !isDiamondCreated;
    if (isDiamondCreated) {
      label.text =
          [NSString stringWithFormat:@"（需%@颗钻石）", data.mCreateFee];
    }
    ((UILabel *)fundLabels[idx]).text = data.mTemplateName;

    //如果用户之前没有选过比赛模板，则直接把第一个当做默认
    if (idx == 0 && [[self getUserFundInfo] length] < 1) {
      _templateID = data.mTemplateID;
      _isDiamondMatch = [data.mCreateFlag boolValue];
      _numberOfUsingDiamond = [data.mCreateFee integerValue];
    }
  }];
}

#pragma mark - 比赛校验
- (void)validateMatch {
  [self.view endEditing:YES];
  _dateTipView.hidden = YES;

  NSString *matchName =
      [_matchNameTextField.text stringByReplacingOccurrencesOfString:@" "
                                                          withString:@""];
  NSString *matchDescr =
      [_matchInfoTextView.text stringByReplacingOccurrencesOfString:@" "
                                                         withString:@""];
  //缓存下填写信息模板id、是否钻石比赛、钻石数
  _matchFundInfo =
      [NSString stringWithFormat:@"%@#%d#%ld", _templateID, _isDiamondMatch,
                                 (long)_numberOfUsingDiamond];

  [self savePreviousMatchInfoWithMatchName:matchName
                            withMatchDescr:matchDescr
                            withTemplateID:_matchFundInfo
                       withVerinerPosition:_blueCursor.center.x];

  if ([matchName length] == 0) {
    [NewShowLabel setMessageContent:@"您还没有输入比赛名称"];
    return;
  } else if ([matchDescr length] == 0) {
    [NewShowLabel setMessageContent:@"您还没有输入比赛说明"];
    return;
  }

  //检验比赛名称长度
  if ([matchName length] > 8) {
    [NewShowLabel setMessageContent:@"比赛名称长度超过限制"];
    return;
  }

  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"YYYY-MM-dd"];
  NSDate *tomorrowDate =
      [NSDate dateWithTimeInterval:86400 sinceDate:[NSDate date]];

  NSString *tomorrowStr = [dateFormatter stringFromDate:tomorrowDate];
  NSDate *nextMonthDate = [NSDate dateWithTimeIntervalSinceNow:2678400];
  //转化时间,去掉时、分、秒
  NSString *nextMonthStr = [dateFormatter stringFromDate:nextMonthDate];
  nextMonthDate = [dateFormatter dateFromString:nextMonthStr];
  NSDate *startDate = [dateFormatter dateFromString:_startTimeStr];
  tomorrowDate = [dateFormatter dateFromString:tomorrowStr];
  if ([startDate timeIntervalSinceDate:tomorrowDate] < 0) {
    [NewShowLabel setMessageContent:@"比" @"赛" @"开"
                  @"始时间必须晚于创建当天"];
    return;
  }
  // 11-23st  tomorrow10-24 nextdate11-23 13:49:43
  switch ([[dateFormatter dateFromString:_startTimeStr]
      compare:[dateFormatter dateFromString:_endTimeStr]]) {
  //比下个月的同一天还要大
  case NSOrderedDescending: {
    [NewShowLabel setMessageContent:@"比" @"赛" @"结"
                  @"束时间不能早于开始时间"];
    return;
  }
  case NSOrderedSame: {
    [NewShowLabel setMessageContent:@"比" @"赛"
                  @"结束时间必须大于比赛开始时间"];
    return;
  };

  default:
    break;
  }

  /*
   比较两时间的差
   */
  BOOL isEnd = [self theLegitimacyOfTheGameTimeRange:_startTimeStr
                                          andEndTime:_endTimeStr];
  if (!isEnd) {
    return;
  }
  //校验比赛接口
  /*
   	比赛开始时间必须晚于创建当天
   	比赛开始时间不能晚于创建次日后的30天开赛
   	比赛开始时间必须大于比赛结束时间
   	最长比赛时间不能超过90天
   */
  //创建钻石提示页面
  //比赛校验请求
  if (![SimuUtil isLogined]) {
    return;
  }

  [_superVC.indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MatchCreatingSubView *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MatchCreatingSubView *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    MatchCreatingSubView *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSimuPositionPageData:(SimuValidateMatchData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *ex) {
    if ([obj.status isEqualToString:@"0219"]) {
      JsonErrorObject *err = (JsonErrorObject *)obj;
      NSString *errMsg =
          err.errorDetailInfo[@"result"][@"matchName"][@"valiMsg"];
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

  [SimuValidateMatchData
      requestSimuValidateMatchDataWtihMatchName:
          [CommonFunc base64StringFromText:matchName]
                                  withStartTime:_startTimeStr
                                    withEndTime:_endTimeStr
                         withTempInvitationCode:_tempInvitationCode
                                 withTemplateID:_templateID
                                   withCallback:callback];
}

#pragma mark 比赛验证码回调
- (void)bindSimuPositionPageData:(SimuValidateMatchData *)validataMatchData {
  [self verificationStatusForValidateMatch:validataMatchData.status
                               withMessage:validataMatchData.message
                             withException:validataMatchData.errorDictionary];
}

/**校验比赛*/
/*
 “0000”：您创建的比赛需要消耗N颗钻石
 “0219”：创建比赛参数错误
 */
- (void)verificationStatusForValidateMatch:(NSString *)localStatus
                               withMessage:(NSString *)localMessage
                             withException:(NSDictionary *)exception {
  NSInteger statusInt = [localStatus integerValue];
  switch (statusInt) {
  case 0: {
    _requestTag = 500;
    [_superVC.storeUtil
        diamondInadequateWarningsView:
            [NSString stringWithFormat:@"您创建的比赛需要%ld颗钻石",
                                       (long)_numberOfUsingDiamond]
                      withButtonTitle:@"确定"];
  } break;
  case 219: {
    //邀请码
    NSDictionary *inviteCodeDict = exception[@"inviteCode"];
    if (inviteCodeDict) {
      NSString *inviteCodeStatus =
          [SimuUtil changeIDtoStr:inviteCodeDict[@"valiFlag"]];
      //邀请码已过期
      if (![inviteCodeStatus integerValue]) {
        //获得邀请码
        [self requestStockMatchInvitationCode];
        [NewShowLabel setMessageContent:inviteCodeDict[@"valiMsg"]];
      }
    }
    //比赛名称不能重复
    NSDictionary *matchNameDict = exception[@"matchName"];
    if (matchNameDict) {
      NSString *matchNameStatus =
          [SimuUtil changeIDtoStr:matchNameDict[@"valiFlag"]];
      if (![matchNameStatus integerValue]) {
        [NewShowLabel setMessageContent:matchNameDict[@"valiMsg"]];
      }
    }
    //比赛开始时间exc
    NSDictionary *matchTimeDict = exception[@"matchTime"];
    if (matchTimeDict) {
      NSString *matchTimeStatus =
          [SimuUtil changeIDtoStr:matchTimeDict[@"valiFlag"]];
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

#pragma mark--------数据处理（asi代理）-------
//缓存下数据(比赛名称，比赛描述，所选钻石类型)
- (void)savePreviousMatchInfoWithMatchName:(NSString *)matchName
                            withMatchDescr:(NSString *)matchDescr
                            withTemplateID:(NSString *)match_templateID
                       withVerinerPosition:(float)match_VerinerPosition {
  [[NSUserDefaults standardUserDefaults] setObject:matchName
                                            forKey:@"StockMatch_MatchName"];
  [[NSUserDefaults standardUserDefaults] setObject:matchDescr
                                            forKey:@"StockMatch_MatchDescr"];
  [[NSUserDefaults standardUserDefaults]
      setFloat:match_VerinerPosition
        forKey:@"StockMatch_VerinerPosition"];
  [[NSUserDefaults standardUserDefaults] setObject:match_templateID
                                            forKey:@"StockMatch_TemplateID"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
 * 比较时间日期的方法
 */
- (BOOL)theLegitimacyOfTheGameTimeRange:(NSString *)startTime
                             andEndTime:(NSString *)endTime {
  /* year 年
   * month 月
   * day 日
   */
  int year = [[startTime substringWithRange:NSMakeRange(0, 4)] intValue];
  int months = [[startTime substringWithRange:NSMakeRange(5, 2)] intValue];
  int days = [[startTime
      substringWithRange:NSMakeRange(startTime.length - 2, 2)] intValue];

  int year1 = [[endTime substringWithRange:NSMakeRange(0, 4)] intValue];
  int months1 = [[endTime substringWithRange:NSMakeRange(5, 2)] intValue];
  int days1 = [
      [endTime substringWithRange:NSMakeRange(endTime.length - 2, 2)] intValue];
  /*
   1.当 年 月 都相同的时  2.当 年相同 月不相同时  3.当 年不相同时
   */
  if (year == year1) {
    if (months == months1) {
      if (days1 - days < 5) {
        [NewShowLabel setMessageContent:@"比赛周期不能少于5天"];
        return NO; //小于5天  返回 5555
      }
    } else if (months1 - months > 3) {
      [NewShowLabel setMessageContent:@"比赛时间不能超过3个月"];
      return NO; //大于3个月 返回 3333
    } else if (months1 - months == 3) {
      if (days1 > days) {
        [NewShowLabel setMessageContent:@"比赛时间不能超过3个月"];
        return NO;
      }
    }
  } else if (year1 - year == 1) {
    if ((12 - months) + months1 > 3) {
      [NewShowLabel setMessageContent:@"比赛时间不能超过3个月"];
      return NO;
    } else if ((12 - months) + months1 == 3) {
      if (days1 > days) {
        [NewShowLabel setMessageContent:@"比赛时间不能超过3个月"];
        return NO;
      }
    }
  } else if (year1 - year > 1) {
    [NewShowLabel setMessageContent:@"比赛时间不能超过3个月"];
    return NO;
  }
  return YES;
}

#pragma mark--------钻石提示框-------
- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 501) {
    switch (buttonIndex) {
    case 0:
      NSLog(@"取消");
      break;
    case 1:
      //充值界面及请求
      [self buyDiamond];
      break;
    default:
      break;
    }
  } else {
    // 500
    switch (buttonIndex) {
    case 0:
      NSLog(@"取消");
      break;
    case 1:
      NSLog(@"点击确定按钮 500 执行此处");
      //校验通过，提交比赛数据
      [self sendSubmitMatchRequest];
      break;
    default:
      break;
    }
  }
}

#pragma mark - 协议方法 -- 5004
- (void)rechargeDataRequest {
  if (_requestTag == 500) {
    [self submitMatchCreated];
  } else {
    //充值界面及请求
    [self buyDiamond];
  }
}

#pragma mark
#pragma-- --立即购买接口-- --
- (void)buyNowProductId:(NSString *)productId {
  [self buyingProducteFromSevers:productId];
  [_superVC.storeUtil removeCompetitionCycleView];
}

//从服务器（本地）购买产品，生成订单
- (void)buyingProducteFromSevers:(NSString *)productedid {
  [MobClick beginLogPageView:@"商城-买入"];

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MatchCreatingSubView *weakSelf = self;

  callback.onSuccess = ^(NSObject *obj) {
    MatchCreatingSubView *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindProductOrder:(productOrderListItem *)obj];
    }
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *ex) {
    [weakSelf stopLoading];
    [BaseRequester defaultErrorHandler](obj, ex);
  };
  callback.onFailed = ^{
    [weakSelf stopLoading];
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

//获取钻石列表
- (void)buyDiamond {
  [_superVC.storeUtil showBuyingDiamondView];
}

//提交比赛
- (void)submitMatchCreated {
  [self sendSubmitMatchRequest];
}

//发送提交比赛请求
- (void)sendSubmitMatchRequest {
  NSString *matchName =
      [_matchNameTextField.text stringByReplacingOccurrencesOfString:@" "
                                                          withString:@""];
  NSString *matchDescr =
      [_matchInfoTextView.text stringByReplacingOccurrencesOfString:@" "
                                                         withString:@""];

  if (![SimuUtil isLogined]) {
    return;
  }

  [_superVC.indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MatchCreatingSubView *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MatchCreatingSubView *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    MatchCreatingSubView *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSimuOpenMatchData:(SimuOpenMatchData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };
  //如果钻石不够 弹出提示购买充值页面
  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {

    MatchCreatingSubView *strongSelf = weakSelf;
    if (strongSelf) {
      [self verificationStatusForCreateMatch:obj.status
                                 withMessage:obj.message];
    }

  };

  [SimuOpenMatchData
      requestSimuOpenMatchDataWithUsername:
          [CommonFunc base64StringFromText:[SimuUtil getUserName]]
                             withMatchName:[CommonFunc
                                               base64StringFromText:matchName]
                      withMatchDescription:[CommonFunc
                                               base64StringFromText:matchDescr]
                             withStartTime:_startTimeStr
                               withEndTime:_endTimeStr
                    withTempInvitationCode:_tempInvitationCode
                            withTemplateId:_templateID
                              withCallback:callback];
}

#pragma mark 提交比赛回调
- (void)bindSimuOpenMatchData:(SimuOpenMatchData *)openMatchData {
  NSLog(@"创建比赛成功");
  //购买成功取消缓存
  [self savePreviousMatchInfoWithMatchName:@""
                            withMatchDescr:@""
                            withTemplateID:@""
                       withVerinerPosition:-1];
  [MPNotificationView notifyWithText:openMatchData.message andDuration:1.5];
  //刷新前一页列表
  [self.delegate refreshCurrentPage];
  //清除邀请码信息
  _tempInvitationCode = @"";
  _codeBtn.selected = NO;
  _inviteCodeView.hidden = YES;
  //清空输入框
  _matchNameTextField.text = @"";
  _matchInfoTextView.text = @"";
  _placeHolderLabel.hidden = NO;
  [self tapFund:_tap10];
  //先释放当前页
  [self matchCreatingSuccess:openMatchData.dataArray[0]];
}

- (void)matchCreatingSuccess:(NSDictionary *)dict {
  //先清掉提示框(防止重复点击)
  [_superVC.storeUtil removeCompetitionCycleView];
  MatchCreateSuccessViewController *matchCreateSuccessVC =
      [[MatchCreateSuccessViewController alloc] init];
  matchCreateSuccessVC.matchName = dict[@"matchName"];
  matchCreateSuccessVC.matchDescr = dict[@"matchDescp"];
  matchCreateSuccessVC.matchInviteCode = dict[@"inviteCode"];
  matchCreateSuccessVC.matchCreator = dict[@"creator"];
  matchCreateSuccessVC.matchImageUrl = dict[@"background"];
  matchCreateSuccessVC.matchTime = [NSString
      stringWithFormat:@"%@至%@", dict[@"openTime"], dict[@"closeTime"]];
  matchCreateSuccessVC.parentVC = self;

  [AppDelegate pushViewControllerFromRight:matchCreateSuccessVC];
}

/**区分返回的status*/
/**创建比赛*/
/*
 “0000”：请求成功，其他均为请求数据失败。
 “0212”：钻石余额不足，请充值
 “0215”：邀请码过期
 “0218”  扣钻石失败
 “0222”：金币余额不足
 “0223”：扣金币失败
 “1003”：创建人参加比赛失败
 “1001”：系统处理错误
 */
- (void)verificationStatusForCreateMatch:(NSString *)localStatus
                             withMessage:(NSString *)localMessage {
  NSInteger statusInt = [localStatus integerValue];
  switch (statusInt) {
  case 212: {
    _requestTag = 501;
    [_superVC.storeUtil
        diamondInadequateWarningsView:@"您的钻石数量不足"
                      withButtonTitle:@"充值"];
  } break;
  case 215: {
    [NewShowLabel setMessageContent:@"验证码过期"];
    //过期立即重置下
    [[NSUserDefaults standardUserDefaults] setInteger:0
                                               forKey:@"inviteTimeInternal"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //先将邀请码一栏清除
    if (_codeBtn.selected) {
      _tempInvitationCode = @"";
      _inviteCodeView.hidden = YES;
    }
    //获得邀请码
    [self requestStockMatchInvitationCode];
  } break;
  default:
    [NewShowLabel setMessageContent:localMessage];
    break;
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
}

@end
