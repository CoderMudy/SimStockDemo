//
//  StockLogonViewController.m
//  SimuStock
//
//  Created by Mac on 15-3-3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockLogonViewController.h"
#import "UserRealTradingInfo.h"
#import "SchollWebViewController.h"
#import "NetLoadingWaitView.h"
#import "UIImage+ColorTransformToImage.h"

#import "WFDataSharingCenter.h"
#import "simuRealTradeVC.h"

#define ClientGuideAgreeMent @"同意《优顾交易用户使用须知》" //@"优顾交易用户使用须知"
/** 侧栏宽度 */
#define SwitchSlideWidth 60.0f
/** 控制器宽度 */
#define CurrentViewWidth self.view.frame.size.width - SwitchSlideWidth
/** 控制器高度 */
#define CurrentViewHeight self.view.frame.size.height - SwitchSlideWidth
/** 客户号 */
#define CustomerNumber 0
/** 资金账号 */
#define FundEntrusted 1

@implementation StockLogonViewController

-(void)viewWillDisappear:(BOOL)animated
{
  [self.clientNumberTextField resignFirstResponder];
  [self.tradePasswordTextField resignFirstResponder];
  [self.verifyNumberTextField resignFirstResponder];
//  [self.view endEditing:YES];
  [super viewWillDisappear:animated];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN - SwitchSlideWidth, CurrentViewHeight);

  self.clientGuideView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  //客户号
  selectdFundType = CustomerNumber;
  isAcceptAgreement = YES;
  [self createCustomizeKeyBoard];
  [self refreshMainView];
}

#pragma mark
#pragma mark - 界面刷新(初始)
- (void)refreshMainView {
  _FTLineView.transform = CGAffineTransformMakeScale(1.0f, 0.50f);
  _SeLineView.transform = CGAffineTransformMakeScale(1.0f, 0.50f);
  _ThLineView.transform = CGAffineTransformMakeScale(1.0f, 0.50f);
  _VeLineView.transform = CGAffineTransformMakeScale(0.50f, 1.0f);
  //客户号
  _clientNumberTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  _clientNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
  _clientNumberTextField.delegate = self;
  [_overFundTFButton addTarget:self
                        action:@selector(fundTFBecomeFirstResponding)
              forControlEvents:UIControlEventTouchUpInside];
  //客户号与资金账号切换按钮
  [_clientNumTypeBtn.layer setBorderWidth:1.0f];
  [_clientNumTypeBtn.layer setBorderColor:[Globle colorFromHexRGB:@"31bce9"].CGColor];
  [_clientNumTypeBtn.layer setMasksToBounds:YES];
  [_clientNumTypeBtn.layer setCornerRadius:12.0f];
  //交易密码
  _tradePasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  _tradePasswordTextField.inputView = customKeyBoard;
  _tradePasswordTextField.delegate = self;
  [_tradePasswordTextField setSecureTextEntry:YES];
  _tradePasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
  _tradePasswordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  _tradePasswordTextField.textColor = [Globle colorFromHexRGB:@"454545"];
  _tradePasswordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  //验证码
  _verifyNumberTextField.delegate = self;
  _verifyNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
  // 验证码上部按钮
  [_verifyNumButton setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                              forState:UIControlStateHighlighted];
  [_verifyNumButton setBackgroundColor:[Globle colorFromHexRGB:@"31bce9"]];
  [_verifyNumButton.layer setMasksToBounds:YES];
  [_verifyNumButton.layer setCornerRadius:2.5f];
  [_verifyNumButton addTarget:self
                       action:@selector(receivVerifyNumber)
             forControlEvents:UIControlEventTouchUpInside];
  //验证码菊花
  _verifyIndicator.center = _verifyNumImageView.center;
  // 保存账号选择器
  [_saveInfoSwitch addTarget:self
                      action:@selector(selectButton:)
            forControlEvents:UIControlEventTouchUpInside];
  //实盘登录
  UIImage *firmLogonBtnImage = [UIImage imageFromView:_firmLogonButton
                                  withBackgroundColor:[Globle colorFromHexRGB:@"d18501"]];
  [_firmLogonButton setBackgroundImage:firmLogonBtnImage forState:UIControlStateHighlighted];
  [_firmLogonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
  [_firmLogonButton addTarget:self
                       action:@selector(logonSuccess)
             forControlEvents:UIControlEventTouchUpInside];
  //客服电话
  sevicesBtn = [[Image_TextButton alloc] initWithImage:@"电话小图标"
                                              withText:@"德邦客服"
                                          withTextFont:10.0f
                                         withTextColor:@"31bce9"
                                     withHighLighColor:Color_Blue_but
                                     withTextAlignment:NSTextAlignmentLeft
                                             withFrame:_serviceView.frame];
  sevicesBtn.origin = CGPointMake(0, 0);
  [sevicesBtn.imageTextBtn addTarget:self
                              action:@selector(clickSeviceBtn)
                    forControlEvents:UIControlEventTouchUpInside];
  [_serviceView addSubview:sevicesBtn];
  //交易指引
  tradeGuideBtn = [[Image_TextButton alloc] initWithImage:@"开户帮助小图标"
                                                 withText:@"德邦证券开户指引"
                                             withTextFont:10.0f
                                            withTextColor:@"31bce9"
                                        withHighLighColor:Color_Blue_but
                                        withTextAlignment:NSTextAlignmentRight
                                                withFrame:_tradeGuideView.frame];
  tradeGuideBtn.origin = CGPointMake(0, 0);
  [tradeGuideBtn.imageTextBtn addTarget:self
                                 action:@selector(clickAccoutGuideBtn)
                       forControlEvents:UIControlEventTouchUpInside];
  [_tradeGuideView addSubview:tradeGuideBtn];
  //选中对号
  [_clientGuideSelectedBtn.layer setMasksToBounds:YES];
  [_clientGuideSelectedBtn.layer setCornerRadius:7.0f];
  //  [_noticeOfUseBtn
  //      setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
  //                forState:UIControlStateHighlighted];
  //交易协议
  [self addUserAgreementLink];
}
/**
 *重载缓存信息
 */
- (void)reloadCacheInfo {
  //证券名称(匹配)
  NSString *companyName = [[UserRealTradingInfo sharedInstance] getUserInfo:SaveTypeUserTradingCompany];
  if ([currentCompany.name isEqualToString:companyName]) {
    //是否保存
    _saveInfoSwitch.on =
        [[[UserRealTradingInfo sharedInstance] getUserInfo:SaveTypeAccountSaveStatus] integerValue];
    if (_saveInfoSwitch.on) {
      //加载缓存数据
      [self showUserSavedInfo];
    }
  }
}
- (void)clickFundButtonShowCache:(NSString *)currentAccountType
                withSelectedType:(NSInteger)selected {
  //证券名称(匹配)
  NSString *companyName = [[UserRealTradingInfo sharedInstance] getUserInfo:SaveTypeUserTradingCompany];
  if ([currentCompany.name isEqualToString:companyName]) {
    SaveType selectedType = selected == 0 ? SaveTypeUserTradingIDCustomerNumber : SaveTypeUserTradingIDFundNumber;
    NSString *fundAccountNum = [[UserRealTradingInfo sharedInstance] getUserInfo:selectedType];
    if (![fundAccountNum isEqualToString:@""]) {
      _fundAccountStr = fundAccountNum;
      [self fundAccountEncryption:fundAccountNum];
    }
  }
}

#pragma mark - 刷新当前券商数据
/*
 *  需要刷新的参数
 *  name 德邦证券
 *  logo 证券
 *  num 证券号
 *  accountTypes客户号和资金号
 *  ak 动态ak
 *  funcs (未知)
 *  help 交易指引
 *  method 实盘操作方式
 *  phone 客服
 *  randurl 验证码
 *  title  (未知)
 *  type (未知)
 *  url (未知)
 */
- (void)refreshOpenAccountInfo:(RealTradeSecuritiesCompany *)obj {
  //先重置，再加载数据 判断显示 客户号 还是 资金账户
  [self clearTextFieldContent:obj.accountTypes];
  currentCompany = obj;
  [self refreshCaptchaImage:obj.randUrl];
  //保存需要显示的更多选项序号
  [[NSUserDefaults standardUserDefaults] setObject:obj.funcs forKey:@"showListOfMore"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  //重载缓存数据
  [self reloadCacheInfo];
  [sevicesBtn refreshImageTextButtonWithText:currentCompany.phone.title
                                WithTextFont:10.0f
                                   withImage:@"电话小图标"
                           withTextAlignment:NSTextAlignmentLeft
                                   withFrame:sevicesBtn.frame];
  sevicesBtn.origin = CGPointMake(0, 0);
  [tradeGuideBtn refreshImageTextButtonWithText:currentCompany.help.title
                                   WithTextFont:10.0f
                                      withImage:@"开户帮助小图标"
                              withTextAlignment:NSTextAlignmentRight
                                      withFrame:tradeGuideBtn.frame];
  tradeGuideBtn.origin = CGPointMake(0, tradeGuideBtn.frame.origin.y);
}
/** 添加用户使用协议 */
- (void)addUserAgreementLink {
  TTTAttributedLabel *userAgreementLink = [[TTTAttributedLabel alloc] initWithFrame:_clientGuideView.bounds];
  userAgreementLink.font = [UIFont systemFontOfSize:Font_Height_12_0];
  userAgreementLink.textAlignment = NSTextAlignmentLeft;
  userAgreementLink.delegate = self;
  userAgreementLink.userInteractionEnabled = NO;
  userAgreementLink.numberOfLines = 0;
  userAgreementLink.backgroundColor = [UIColor clearColor];
  userAgreementLink.text = ClientGuideAgreeMent;
  NSRange r = [ClientGuideAgreeMent rangeOfString:@"优顾交易用户使用须知"];
  [userAgreementLink addLinkToURL:[NSURL URLWithString:@"action://show-user-agreement"]
                        withRange:r];
  [_clientGuideView addSubview:userAgreementLink];
  [_clientGuideView sendSubviewToBack:userAgreementLink];
}
/** 读取账号缓存信息 */
- (void)showUserSavedInfo {
  //先得到 最后一次选中的是 客户号 还是 资金账号
  NSString *selectedType = [[UserRealTradingInfo sharedInstance] getUserInfo:SaveTypeSelectedType];
  SaveType custormerOrFund = [selectedType integerValue] == 0 ? SaveTypeAccountTypeCustomerNumber
                                                              : SaveTypeAccountTypeFundNumber;

  NSString *accountType = [[UserRealTradingInfo sharedInstance] getUserInfo:custormerOrFund];
  //客户号
  if ([accountType isEqualToString:@"客户号"]) {
    selectdFundType = CustomerNumber;
    _clientNumberTextField.placeholder = @"客户号";
    [_clientNumTypeBtn setTitle:@"客" forState:UIControlStateNormal];
  } else { //资金账号
    selectdFundType = FundEntrusted;
    _clientNumberTextField.placeholder = @"资金账号";
    [_clientNumTypeBtn setTitle:@"资" forState:UIControlStateNormal];
  }
  //加载 券商号  看是 客户号 还是 资金号
  SaveType custormerFundID = [selectedType integerValue] == 0 ? SaveTypeUserTradingIDCustomerNumber
                                                              : SaveTypeUserTradingIDFundNumber;
  NSString *fundAccountNum = [[UserRealTradingInfo sharedInstance] getUserInfo:custormerFundID];
  _fundAccountStr = fundAccountNum;
  [self fundAccountEncryption:fundAccountNum];
}
#pragma mark - 刷新验证码
/** 验证码重置 */
- (void)receivVerifyNumber {
  [self refreshCaptchaImage:currentCompany.randUrl];
}
/** 刷新验证码 */
- (void)refreshCaptchaImage:(NSString *)url {
  if (url == nil || [url length] < 1) {
    [self verifyNumButtonState];
    _verifyNumImageView.hidden = YES;
    return;
  }
  if (![_verifyIndicator isAnimating]) {
    [_verifyIndicator startAnimating];
    _verifyIndicator.hidden = NO;
  }
  _verifyNumButton.hidden = YES;
  _verifyNumImageView.hidden = YES;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    if ([_verifyIndicator isAnimating]) {
      [_verifyIndicator stopAnimating];
      _verifyIndicator.hidden = YES;
    }
    return NO;
  };
  callback.onSuccess = ^(NSObject *obj) {
    [_verifyNumImageView setImage:(UIImage *)obj];
    _verifyNumButton.hidden = YES;
    _verifyNumImageView.hidden = NO;
  };
  callback.onFailed = ^{
    [self verifyNumButtonState];
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    [self verifyNumButtonState];
  };
  RealTradeCaptchaImageRequester *requester = [[RealTradeCaptchaImageRequester alloc] init];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[UIImage class]
               withHttpRequestCallBack:callback];
}

#pragma makr-- 验证码上的重试按钮
- (void)verifyNumButtonState {
  _verifyNumButton.hidden = NO;
  [_verifyNumButton setTitle:@"重试" forState:UIControlStateNormal];
}

#pragma mark - 界面按钮事件
/** 保存选择器 */
- (void)selectButton:(UIButton *)button {
}
- (void)fundTFBecomeFirstResponding {
  [_clientNumberTextField becomeFirstResponder];
}
/** 点击客服电话 */
- (void)clickSeviceBtn {
  [self allObjResignFirstResponder];
  [[UIApplication sharedApplication]
      openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", [currentCompany.phone.des stringByReplacingOccurrencesOfString:@"-"
                                                                                                                                     withString:@""]]]];
}
- (IBAction)changeAccountType:(UIButton *)sender {
  //客户号
  if ([sender.titleLabel.text isEqualToString:@"客"]) {
    selectdFundType = FundEntrusted;
    _clientNumberTextField.placeholder = @"资金账号";
    [sender setTitle:@"资" forState:UIControlStateNormal];
  } else { //资金账号
    selectdFundType = CustomerNumber;
    _clientNumberTextField.placeholder = @"客户号";
    [sender setTitle:@"客" forState:UIControlStateNormal];
  }
  sender.layer.borderColor = [Globle colorFromHexRGB:@"31bce9"].CGColor;
  _clientNumberTextField.text = @"";
  _tradePasswordTextField.text = @"";
  _verifyNumberTextField.text = @"";
  _fundAccountStr = @"";
  //加载缓存
  [self clickFundButtonShowCache:_clientNumberTextField.placeholder
                withSelectedType:selectdFundType];
  //无缓存时，光标自动跳到账号一栏
  if ([_clientNumberTextField.text length] < 1) {
    [_clientNumberTextField becomeFirstResponder];
  }
}
//客 资 按钮 相互切换时 按下来的 状态颜色
- (IBAction)buttonDownColor:(UIButton *)sender {
  sender.layer.borderColor = [Globle colorFromHexRGB:Color_Blue_but].CGColor;
}
/** 重置textfield */
- (void)clearTextFieldContent:(NSArray *)accountArrayType {
  _fundAccountStr = @"";
  _clientNumberTextField.text = @"";
  _tradePasswordTextField.text = @"";
  _verifyNumberTextField.text = @"";

  //显示 客户号 还是 资金号
  if (accountArrayType.count < 2) {
    _clientNumTypeBtn.hidden = YES;
    RealTradeSecuritiesAccountType *accountType1 = accountArrayType[0];
    _clientNumberTextField.placeholder = accountType1.name;
    if (accountType1.type == 0) {
      selectdFundType = CustomerNumber;
    } else if (accountType1.type == 1) {
      selectdFundType = FundEntrusted;
    }
  } else {
    _clientNumTypeBtn.hidden = NO;
    RealTradeSecuritiesAccountType *accountType2 = accountArrayType[0];
    RealTradeSecuritiesAccountType *accountType3 = accountArrayType[1];
    if (accountType2.type == 0 && accountType3.type == 1) {
      selectdFundType = CustomerNumber;
      _clientNumberTextField.placeholder = accountType2.name;
      [_clientNumTypeBtn setTitle:@"客" forState:UIControlStateNormal];
    }
  }
}
/** 点击用户指引 */
- (void)clickAccoutGuideBtn {
  [self allObjResignFirstResponder];
  [SchollWebViewController startWithTitle:currentCompany.help.title
                                  withUrl:currentCompany.help.des];
}
/** 设置光标位置 */
- (void)fundAccountEncryption:(NSString *)fundAcc {
  //资金账号4位加密
  NSInteger strLength = [fundAcc length];
  if (strLength > 4 && strLength < 9) {
    NSString *tempStr = nil;
    switch (strLength) {
    case 5:
      tempStr = @"●"; //原始‘●’
      break;
    case 6:
      tempStr = @"●●";
      break;
    case 7:
      tempStr = @"●●●";
      break;
    case 8:
      tempStr = @"●●●●";
      break;
    default:
      break;
    }
    _clientNumberTextField.text =
        [fundAcc stringByReplacingCharactersInRange:NSMakeRange(4, [fundAcc length] - 4)
                                         withString:tempStr];
  } else if (strLength > 8) {
    _clientNumberTextField.text =
        [fundAcc stringByReplacingCharactersInRange:NSMakeRange(4, 4) withString:@"●●●●"];
  } else {
    _clientNumberTextField.text = fundAcc;
  }
}
/**
 *自定义键盘
 */
- (void)createCustomizeKeyBoard {
  customKeyBoard =
      [[CustomizeNumberKeyBoard alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 222, WINDOW.size.width, 222)];
  customKeyBoard.delegate = self;
}
#pragma mark - customizeNumkeyBoardDelegate
- (void)selectRandomMethod:(NSString *)theValue {
  //删除、确定键
  if ([theValue isEqualToString:@"clear"]) {
    NSString *text = _tradePasswordTextField.text;
    NSInteger lenth = [text length] - 1;
    if (lenth > -1) {
      text = [text substringToIndex:[text length] - 1];
    }
    _tradePasswordTextField.text = text;
    if ([_tradePasswordTextField.text length] == 0) {
    }
    return;
  } else if ([theValue isEqualToString:@"enter"]) {
    [_tradePasswordTextField resignFirstResponder];
    return;
  }
  NSString *oldValue = [NSString stringWithFormat:@"%@", _tradePasswordTextField.text];
  //限制密码长度
  if ([oldValue length] > 15) {
    return;
  }
  NSString *newValue = [oldValue stringByAppendingString:theValue];
  [_tradePasswordTextField setText:newValue];
}
#pragma mark - 保存用户账户信息
/**
 *保存账户信息
 */
- (void)saveUserLoginedInfo {
  if (_saveInfoSwitch.on) {
    //过滤无效保存
    if ([_fundAccountStr length] < 1) {
      return;
    }
    //保存下滑动条状态
    NSString *switchStatus = [NSString stringWithFormat:@"%d", _saveInfoSwitch.on];
    if (switchStatus && [switchStatus integerValue] > 0) {
      [[UserRealTradingInfo sharedInstance] saveUserInfo:SaveTypeAccountSaveStatus
                                         withSaveContent:switchStatus];
    }
    //保存平台名称
    NSString *companyName = currentCompany.name;
    if (companyName && [companyName length] > 0) {
      [[UserRealTradingInfo sharedInstance] saveUserInfo:SaveTypeUserTradingCompany
                                         withSaveContent:companyName];
    }
    //保存选中类型
    NSString *selectedType = [NSString stringWithFormat:@"%ld", (long)selectdFundType];
    [[UserRealTradingInfo sharedInstance] saveUserInfo:SaveTypeSelectedType
                                       withSaveContent:selectedType];
    //保存账号类型
    RealTradeSecuritiesAccountType *type = currentCompany.accountTypes[selectdFundType];
    NSString *accountType = type.name;
    if (selectdFundType == 0) {
      //客户号
      [[UserRealTradingInfo sharedInstance] saveUserInfo:SaveTypeAccountTypeCustomerNumber
                                         withSaveContent:accountType];
      //保存账号 客户号
      [[UserRealTradingInfo sharedInstance] saveUserInfo:SaveTypeUserTradingIDCustomerNumber
                                         withSaveContent:_fundAccountStr];
    } else if (selectdFundType == 1) {
      //资金号
      [[UserRealTradingInfo sharedInstance] saveUserInfo:SaveTypeAccountTypeFundNumber
                                         withSaveContent:accountType];
      //保存账号 资金号
      [[UserRealTradingInfo sharedInstance] saveUserInfo:SaveTypeUserTradingIDFundNumber
                                         withSaveContent:_fundAccountStr];
    }

  } else {
    //删除switch状态，账号类型，公司，账号id
    [[UserRealTradingInfo sharedInstance] deleteUserInfo:SaveTypeAccountSaveStatus];
    [[UserRealTradingInfo sharedInstance] deleteUserInfo:SaveTypeAccountTypeCustomerNumber];
    [[UserRealTradingInfo sharedInstance] deleteUserInfo:SaveTypeAccountTypeFundNumber];
    [[UserRealTradingInfo sharedInstance] deleteUserInfo:SaveTypeSelectedType];

    [[UserRealTradingInfo sharedInstance] deleteUserInfo:SaveTypeUserTradingCompany];
    [[UserRealTradingInfo sharedInstance] deleteUserInfo:SaveTypeUserTradingIDCustomerNumber];
    [[UserRealTradingInfo sharedInstance] deleteUserInfo:SaveTypeUserTradingIDFundNumber];
  }
}
#pragma mark
#pragma mark - uitextfielddelegate
- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  if ([string isEqualToString:@"\n"]) {
    return YES;
  }
  if (![string isNumber]) {
    return NO;
  }
  NSString *toBeString =
      [textField.text stringByReplacingCharactersInRange:range withString:string];
  //资金账号
  if (textField == _clientNumberTextField) {
    //明文-1
    if (_fundAccountStr) {
      _fundAccountStr =
          [_fundAccountStr stringByReplacingCharactersInRange:range withString:string];
    } else {
      _fundAccountStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    //得到输入框里的内容
    NSString *toBeString;
    if (range.location >= 4 && range.location < 8 && range.length == 0 && [string length] == 1) {
      toBeString = [textField.text stringByReplacingCharactersInRange:range withString:@"●"];
    } else {
      toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    //输入框内容超过了固定长度
    if ([toBeString length] > 12) {
      textField.text = [toBeString substringToIndex:12];
      //明文-2
      _fundAccountStr = [_fundAccountStr substringToIndex:12];
      return NO;
    }
    textField.text = toBeString;
    return NO;
  } //交易密码
  else if (textField == _tradePasswordTextField) {
    if ([toBeString length] > 15) {
      textField.text = [toBeString substringToIndex:15];
      return NO;
    } else {
      return YES;
    }
    //验证码
  } else {
    if ([toBeString length] > 4) {
      textField.text = [toBeString substringToIndex:4];
      return NO;
    } else {
      return YES;
    }
  }
}
/**
 *检查输入信息
 */
- (BOOL)checkInputContent {
#if 0 // ak检查
  NSString *ak = [SimuUtil getAK];
  int isRightAK = ak.compare(currentMinAK);
  if (isRightAK == -1) {
    // 当前模拟炒股应用版本过低，请先升级后在体验该功能。
    ToastUtil.show("当前优顾炒股应用版本过低，请先升级后在体验该功能");
    return;
  }
#endif
  NSDate *previousDate =
      [[UserRealTradingInfo sharedInstance] getUserFailLogonTimeWithAccountId:_fundAccountStr];

  NSTimeInterval timeInterval = [previousDate timeIntervalSinceNow];
  NSInteger failTime = [[UserRealTradingInfo sharedInstance] getUserRealTradeLogonWithAccountId:_fundAccountStr];
  if (previousDate && failTime == login_entry_limit) {
    //<300
    if (-timeInterval < five_minuteToSecond) {
      [NewShowLabel setMessageContent:@"密"
                    @"码输入错误超过5次，您的账号已被锁定，"
                    @"请在5分钟后重试"];
      return NO;
    }
  }
  if (-timeInterval > five_minuteToSecond) {
    failTime = 0;
    return YES;
  }
  return YES;
}
- (void)logonSuccess {
  //先停止小菊花
  if ([_verifyIndicator isAnimating]) {
    [_verifyIndicator stopAnimating];
  }
  [self allObjResignFirstResponder];
  //用户协议
  if (!isAcceptAgreement) {
    [NewShowLabel
        setMessageContent:[NSString stringWithFormat:@"请" @"阅读并同意《优顾交易用" @"户使用须知》"]];
    return;
  }
  //判空
  if ([_overFundTFButton.titleLabel.text isEqualToString:@"请" @"选择账号类型"]) {
    [NewShowLabel setMessageContent:@"您还没有选择账号类型"];
    return;
  } else if ([_fundAccountStr length] < 1) {
    [NewShowLabel setMessageContent:@"您还没有输入资金账户"];
    return;
  } else if ([_tradePasswordTextField.text length] < 1) {
    [NewShowLabel setMessageContent:@"您还没有输入交易密码"];
    return;
  } else if ([_verifyNumberTextField.text length] < 1) {
    [NewShowLabel setMessageContent:@"您还没有输入验证码"];
    return;
  }
  //密码输入错误超过5次，您的账号已被锁定，请在5分钟后重试
  if (![self checkInputContent]) {
    return;
  }
  urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  // 东莞的type 德邦 恒生
  NSString *accountType = [NSString stringWithFormat:@"%ld", (long)selectdFundType];
  NSString *account = _fundAccountStr;
  NSString *password = _tradePasswordTextField.text;
  NSString *captcheCode = _verifyNumberTextField.text;

  [urlFactory setUrlPrefix:currentCompany.url];
  // POST / GET
  [urlFactory sendValueForLongon:currentCompany.method];
  //券商号
  [urlFactory sendvalueforBrokerID:currentCompany.num];
  if (urlFactory == nil || [[urlFactory getLoginPath] length] < 1) {
    [NewShowLabel setMessageContent:@"登" @"录" @"数" @"据不正确，请重新刷新页面"];
    return;
  }

  //保存券商信息
  [[RealTradeUrls singleInstance] saveRealTradeUrlFactory:currentCompany.type];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
    return;
  }

  [NetLoadingWaitView startAnimating];

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  __weak StockLogonViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{

    StockLogonViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  //返回成功
  callback.onSuccess = ^(NSObject *obj) {
    StockLogonViewController *strongSelf = weakSelf;
    if (strongSelf) {

      //[strongSelf firmBindingSuccess];

      RealTradeLoginResponse *realLogin = (RealTradeLoginResponse *)obj;
      //同一账号
      [strongSelf firmBindingYouguuAccountAndCustomerId:realLogin.customerId];
    };
  };
  callback.onFailed = ^() {
    StockLogonViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopAnimatingLogon];
      [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
      //验证码重置
      [strongSelf refreshCaptchaImage:currentCompany.randUrl];
    }
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    StockLogonViewController *strongSelf = weakSelf;
    if (strongSelf) {
      //验证码重置
      [strongSelf stopAnimatingLogon];
      [strongSelf refreshCaptchaImage:currentCompany.randUrl];
      [strongSelf logonWithError:error withException:ex];
    }
  };

  [RealTradeLoginResponse loginWithUrl:[urlFactory getLoginPath]
                           withCaptcha:captcheCode
                       withAccountType:accountType
                           withAccount:account
                          withPassword:password
                          withCallback:callback];
}

#pragma mark - 大菊花停止
- (void)stopAnimatingLogon {
  if ([NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView stopAnimating];
  }
}

#pragma mark - 记录时间（5分钟自动登录）
/** 记录实盘登录成功时刻 */
- (void)recordTimeOfFirmLogonSucce {
  [SimuUser setUserFirmLogonSuccessTime:[NSDate timeIntervalSinceReferenceDate]];
}
/*
 * 获取实盘客户资料
 */
- (void)firmBindingYouguuAccountAndCustomerId:(NSString *)customerId {
  //传客户号
  [urlFactory sendValueCustomer:customerId];

  [[UserRealTradingInfo sharedInstance] logonSuccessResetUserInfo:_fundAccountStr];
  [RealTradeAuthInfo singleInstance].loginInfo = loginInfo;
  [RealTradeAuthInfo singleInstance].cookie = loginInfo.customerSessionId;
  [RealTradeAuthInfo singleInstance].urlFactory = urlFactory;

  HttpRequestCallBack *actualQuotationCallback = [[HttpRequestCallBack alloc] init];
  __weak StockLogonViewController *actualWeakSelf = self;
  actualQuotationCallback.onCheckQuitOrStopProgressBar = ^() {
    StockLogonViewController *actualStrongSelf = actualWeakSelf;
    if (actualStrongSelf) {
      return NO;
    } else {
      return YES;
    }
  };
  //请求成功
  actualQuotationCallback.onSuccess = ^(NSObject *obj) {
    StockLogonViewController *strongSelf = actualWeakSelf;
    if (strongSelf) {
      [strongSelf userDataRequestSuccess:obj];
      NSLog(@"客户资料 请求成功 ");
    }
  };

  //请求失败
  actualQuotationCallback.onFailed = ^() {
    StockLogonViewController *strongSelf = actualWeakSelf;
    if (strongSelf) {
      [strongSelf stopAnimatingLogon];
    }
    NSLog(@"************* 客户资料 请求失败 ************");
  };

  //调用请求接口
  [ActualQuotationUserInfoData requestUserInfoWithCallback:actualQuotationCallback
                                             andCustomerId:customerId
                                            withBrokerType:currentCompany.type];
}
/** 实盘登录失败 */
- (void)logonWithError:(BaseRequestObject *)error withException:(NSException *)ex {
  if ([NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView stopAnimating];
  }
  if (error == nil) {
    [NewShowLabel setMessageContent:@"请求错误，请重新请求"];
    return;
  }
  //验证码清空
  _verifyNumberTextField.text = @"";
  if ([error.status isEqualToString:@"0822"]) {
    //验证码重置
    [self refreshCaptchaImage:currentCompany.randUrl];
    //密码错误
    NSInteger failTime =
        [[UserRealTradingInfo sharedInstance] getUserRealTradeLogonWithAccountId:_fundAccountStr];
    if (failTime > 0) {
      failTime = (failTime > login_entry_limit ? 1 : failTime + 1);
    } else {
      failTime = 1;
    }
    //记录第五次失败时间
    [[UserRealTradingInfo sharedInstance] saveUserRealTradeFailDateWithAccountId:_fundAccountStr];
    if (login_entry_limit - failTime > 0) {
      NSString *failContent =
          [NSString stringWithFormat:@"帐号或密码错误，您还有%ld次重试机会。", (long)(login_entry_limit - failTime)];
      [NewShowLabel setMessageContent:failContent];
      [[UserRealTradingInfo sharedInstance] saveUserRealTradeLogonWithAccountId:_fundAccountStr
                                                                   withFailTime:failTime];
    } else {
      [NewShowLabel setMessageContent:@"密" @"码输入错误超过5次，您的账号已被锁" @"定，请在5分钟后重试"];
      [[UserRealTradingInfo sharedInstance] saveUserRealTradeLogonWithAccountId:_fundAccountStr
                                                                   withFailTime:failTime];
    }
  } else if ([error.status isEqualToString:@"0821"]) {
    //验证码重置
    [self refreshCaptchaImage:currentCompany.randUrl];
    [NewShowLabel setMessageContent:error.message];
  } else {
    [NewShowLabel setMessageContent:error.message];
  }
}
/*
 * 1.如果 优顾号和实盘乃是同一人所有 则同意登录
 * 2. 如果优顾号和实盘注册号不是同一人 则拒绝登录
 * 是否是同一个账号登录
 * 用户资料请求成功
 * 与优顾账号绑定
 */
- (void)userDataRequestSuccess:(NSObject *)obj {
  ActualQuotationUserInfoData *actualQuotationUserInfo = (ActualQuotationUserInfoData *)obj;
  //调用 实盘绑定接口
  HttpRequestCallBack *callBackll = [[HttpRequestCallBack alloc] init];
  __weak StockLogonViewController *weakActualSelf = self;
  callBackll.onCheckQuitOrStopProgressBar = ^() {
    StockLogonViewController *strongSelf = weakActualSelf;
    if (strongSelf) {
      //验证码重置
      // [strongSelf refreshCaptchaImage:currentCompany.randUrl];
      return NO;
    } else {
      return YES;
    }
  };
  //请求数据成功
  callBackll.onSuccess = ^(NSObject *obj) {
    StockLogonViewController *strongSelf = weakActualSelf;
    if (strongSelf) {
      [strongSelf firmBindingSuccess];
      [WFDataSharingCenter shareDataCenter].brokerUserId = _fundAccountStr;
      NSLog(@"****** 实盘绑定成功 ********");
    }
  };
  //失败
  callBackll.onFailed = ^() {
    [weakActualSelf stopAnimatingLogon];
    NSLog(@"实盘绑定失败");
  };
  callBackll.onError = ^(BaseRequestObject *obj, NSException *exc) {
    [weakActualSelf stopAnimatingLogon];
    if ([@"0111" isEqualToString:obj.status]) {
      //提示下
      [NewShowLabel setMessageContent:@"请使用绑定账号登陆," @"如"
                                                                      @"有疑问请咨询客服"];
    } else {
      [BaseRequester defaultErrorHandler](obj, exc);
    }
  };
  NSArray *array = actualQuotationUserInfo.arrayActualQuotationUserInfo;
  //
  //调用请求接口
  [ActualQuotationUserPinlessData requestYuuguUserAndActualQuotationUserWithUserInfo:array
                                                                     andWithCallback:callBackll
                                                                         andBrokerId:_fundAccountStr
                                                                      withBrokerType:currentCompany.type];
}

/** 实盘绑定成功 */
- (void)firmBindingSuccess {
  //保存或删除账户信息
  [self saveUserLoginedInfo];
  //记录登录时间
  [self recordTimeOfFirmLogonSucce];
  //清空密码和 刷新验证码
  [self receivVerifyNumber];
  _tradePasswordTextField.text = @"";
  _verifyNumberTextField.text = @"";
  AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
  UINavigationController *navigationController = app.viewController.navigationController;
  [navigationController popViewControllerAnimated:NO];

  if (_onLoginSuccessBlock) {
    _onLoginSuccessBlock(YES);
    [self stopAnimatingLogon];
  } else {
    //菊花停止
    [navigationController pushViewController:[[simuRealTradeVC alloc] initWithDictionary:nil]
                                    animated:YES];
    [self stopAnimatingLogon];
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self allObjResignFirstResponder];
}
/** 释放第一响应 */
- (void)allObjResignFirstResponder {
  [_clientNumberTextField resignFirstResponder];
  [_tradePasswordTextField resignFirstResponder];
  [_verifyNumberTextField resignFirstResponder];
}
/** 用户使用协议跳转 */
- (void)userTappedOnLink {
  [SchollWebViewController startWithTitle:@"优顾交易用户使用须知"
                                  withUrl:[[NSURL URLWithString:@"http://www.youguu.com/opms/html/" @"article/32/2014/1028/" @"2628.html"] absoluteString]];
}
- (IBAction)acceptYouGuuAgreement:(UIButton *)sender {
  if (isAcceptAgreement) {
    isAcceptAgreement = NO;
    [_tickImageView setImage:[UIImage imageNamed:@""]];
  } else {
    isAcceptAgreement = YES;
    [_tickImageView setImage:[UIImage imageNamed:@"小对号图标"]];
  }
}
- (IBAction)buttonDown:(UIButton *)sender {
  sender.backgroundColor = [UIColor clearColor];
}
- (IBAction)buttonUpOutside:(UIButton *)sender {
  sender.backgroundColor = [UIColor clearColor];
}

- (IBAction)showYouGuuTradeAgreement:(UIButton *)sender {
  sender.backgroundColor = [UIColor clearColor];
  [self userTappedOnLink];
}
@end
