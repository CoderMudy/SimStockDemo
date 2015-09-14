//
//  TradingFirmLogonViewController.m
//  SimuStock
//
//  Created by jhss on 14-9-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

@implementation TradingFirmLogonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  arrowType_fundType = arrow_down;
  arrowType_stockSort = arrow_down;
  [self createNavBar];
  [self createCustomizeKeyBoard];
  [self createMainView];
  [self requestCompanyList];
}
/**
 *请求券商列表，和账号类型
 */
- (void)requestCompanyList {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onSuccess = ^(NSObject *obj) {
      self.companyList = (RealTradeSecuritiesCompanyList *)obj;
      NSString *fundAccountNum = [[UserRealTradingInfo sharedInstance]
          getUserInfo:SaveTypeUserTradingID];
      if (fundAccountNum == nil || fundAccountNum.length < 1) {
        //      if ([self.companyList.result count] < 1) {
        //        self.currentCompany=[self.companyList.result objectAtIndex:0];
        //        self.currentAccountType=[self.currentCompany.accountTypes
        //        objectAtIndex:0];
        //        [stockSortBtn setTitle:self.currentCompany.name
        //        forState:UIControlStateNormal];
        //        [fundAccountBtn setTitle:self.currentAccountType.name
        //        forState:UIControlStateNormal];
        //      }else
        //      {
        //接口都完善之后去掉
        self.currentCompany = self.companyList.result[0];
        NSLog(@"companys.result = %@ \n type =%@", self.companyList.result,
              self.currentCompany.accountTypes);
        self.currentAccountType =
            self.currentCompany.accountTypes[0];
        [stockSortBtn setTitle:self.currentCompany.name
                      forState:UIControlStateNormal];
        [fundAccountBtn setTitle:self.currentAccountType.name
                        forState:UIControlStateNormal];
        //}
      } else {
        //读取缓存
        [self showUserSavedInfo];
      }
      [stockSortBtn setTitleColor:[Globle colorFromHexRGB:@"454545"]
                         forState:UIControlStateNormal];
      [fundAccountBtn setTitleColor:[Globle colorFromHexRGB:@"454545"]
                           forState:UIControlStateNormal];
      [stockPlatFormTableView reloadData];
      [fundSortTableView reloadData];
      [self refreshCaptchaImage:self.currentCompany.randUrl];
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
      [NewShowLabel setMessageContent:obj.message];
  };
  callback.onFailed =
      ^{ [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE]; };
  [RealTradeSecuritiesCompanyList
      loadSecuritiesCompanyListWithCallback:callback];
}
- (void)showUserSavedInfo {
  NSString *fundAccountNum =
      [[UserRealTradingInfo sharedInstance] getUserInfo:SaveTypeUserTradingID];
  if (fundAccountNum == nil || fundAccountNum.length < 1) {
    saveInfoSwitch.on = NO;
  } else {
    //显示保存后的信息
    NSString *companyName = [[UserRealTradingInfo sharedInstance]
        getUserInfo:SaveTypeUserTradingCompany];
    ;
    if (companyName != nil && [companyName length] > 0) {
      [stockSortBtn setTitle:companyName forState:UIControlStateNormal];
    }
    NSString *accountType =
        [[UserRealTradingInfo sharedInstance] getUserInfo:SaveTypeAccountType];
    if (accountType != nil && [accountType length] > 0) {
      [fundAccountBtn setTitle:accountType forState:UIControlStateNormal];
    }
    _fundAccountStr = fundAccountNum;
    [self fundAccountEncryption:fundAccountNum];
    saveInfoSwitch.on = YES;
    for (RealTradeSecuritiesCompany *comp in self.companyList.result) {
      if ([comp.name isEqualToString:companyName]) {
        self.currentCompany = comp;
      }
    }
    for (RealTradeSecuritiesAccountType *type in self.currentCompany
             .accountTypes) {
      if ([type.name isEqualToString:accountType]) {
        self.currentAccountType = type;
      }
    }
  }
}
- (void)refreshCaptchaImage:(NSString *)url {
  if (url == nil || [url length] < 1) {
    return;
  }
  [indicator startAnimating];
  verifyNumberBtn.hidden = YES;
  verifyNumberImageView.hidden = YES;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
      [indicator stopAnimating];
      return NO;
  };
  callback.onSuccess = ^(NSObject *obj) {
      [verifyNumberImageView setImage:(UIImage *)obj];
      verifyNumberBtn.hidden = YES;
      verifyNumberImageView.hidden = NO;
      [verifyNumberBtn setTitle:@"重试" forState:UIControlStateNormal];
  };
  callback.onFailed = ^{
      //    [indicator stopAnimating];
      verifyNumberBtn.hidden = NO;
      [verifyNumberBtn setTitle:@"重试" forState:UIControlStateNormal];
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
      //      [indicator stopAnimating];
      verifyNumberBtn.hidden = NO;
      [verifyNumberBtn setTitle:@"重试" forState:UIControlStateNormal];
  };
  RealTradeCaptchaImageRequester *requester =
      [[RealTradeCaptchaImageRequester alloc] init];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[UIImage class]
               withHttpRequestCallBack:callback];
}
/**
 *创建导航栏
 */
- (void)createNavBar {
  _indicatorView.hidden = YES;
  [_topToolBar resetContentAndFlage:@"交易登录" Mode:TTBM_Mode_Leveltwo];
  //右上角登录按钮
  UIButton *logonButton = [UIButton buttonWithType:UIButtonTypeCustom];
  logonButton.frame = CGRectMake(self.view.bounds.size.width - 60,
                                 _topToolBar.frame.size.height - 44, 60, 44);
  [logonButton setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                         forState:UIControlStateHighlighted];
  [logonButton setOnButtonPressedHandler:^{ [self logonSuccess]; }];
  //  [logonButton addTarget:self
  //                  action:@selector(logonSuccess:)
  //        forControlEvents:UIControlEventTouchUpInside];
  [_topToolBar addSubview:logonButton];
  //右上角登录label
  UILabel *logonLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(self.view.bounds.size.width - 60,
                               _topToolBar.frame.size.height - 44, 60, 44)];
  logonLabel.textAlignment = NSTextAlignmentCenter;
  logonLabel.text = @"登录";
  logonLabel.backgroundColor = [UIColor clearColor];
  logonLabel.textColor = [Globle colorFromHexRGB:@"4dfdff"];
  logonLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  [_topToolBar addSubview:logonLabel];
}
/**
 *主界面
 */
- (void)createMainView {
  NSArray *sortNameArray =
      @[@"开户券商：", @"账号类型：",
          @"交易账号：", @"交易密码：",
          @"验证码："];
  for (int st = 0; st < 5; st++) {
    //左侧名称
    UILabel *leftLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(20, (1 + st) * tradeStock_verticalSpace - 22,
                                 70, 14)];
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
    leftLabel.textAlignment = NSTextAlignmentRight;
    leftLabel.textColor = [Globle colorFromHexRGB:@"086dae"];
    leftLabel.text = sortNameArray[st];
    [self.clientView addSubview:leftLabel];
    if (st == 4) {
      leftLabel.textAlignment = NSTextAlignmentLeft;
    }
    //右侧分割线
    UIView *outtingLine = [[UIView alloc]
        initWithFrame:CGRectMake(20, (1 + st) * tradeStock_verticalSpace,
                                 self.view.frame.size.width - 2 * 20, 1)];
    outtingLine.backgroundColor = [Globle colorFromHexRGB:@"086dae"];
    [self.clientView addSubview:outtingLine];
  }
  //选择股票平台
  stockSortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  stockSortBtn.frame = CGRectMake(
      tradeStock_leftFixedSpace, tradeStock_verticalSpace - 28,
      self.view.frame.size.width - tradeStock_leftFixedSpace - 20, 28);
  [stockSortBtn setBackgroundColor:[UIColor clearColor]];
  [stockSortBtn setTitle:@"请选择开户券商" forState:UIControlStateNormal];
  [stockSortBtn setTitleColor:[Globle colorFromHexRGB:@"939393"]
                     forState:UIControlStateNormal];
  stockSortBtn.contentHorizontalAlignment =
      UIControlContentHorizontalAlignmentLeft;
  stockSortBtn.contentVerticalAlignment =
      UIControlContentVerticalAlignmentCenter;
  stockSortBtn.titleLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
  stockSortBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
  [stockSortBtn addTarget:self
                   action:@selector(selectStockPlatform:)
         forControlEvents:UIControlEventTouchUpInside];
  [self.clientView addSubview:stockSortBtn];
  //右侧箭头1
  fsRowArrow = [[UIImageView alloc]
      initWithFrame:CGRectMake(self.view.frame.size.width - 20 - 15 - 10,
                               tradeStock_verticalSpace - 10 - 6, 15, 10)];
  fsRowArrow.image = [UIImage imageNamed:@"logon_pull_down.png"];
  arrowType_stockSort = arrow_down;
  [self.clientView addSubview:fsRowArrow];
  //选择资金账号
  fundAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  fundAccountBtn.frame = CGRectMake(
      tradeStock_leftFixedSpace, tradeStock_verticalSpace * 2 - 28,
      self.view.frame.size.width - tradeStock_leftFixedSpace - 20, 28);
  [fundAccountBtn setBackgroundColor:[UIColor clearColor]];
  [fundAccountBtn setTitle:@"请选择账号类型" forState:UIControlStateNormal];
  [fundAccountBtn setTitleColor:[Globle colorFromHexRGB:@"939393"]
                       forState:UIControlStateNormal];
  fundAccountBtn.contentHorizontalAlignment =
      UIControlContentHorizontalAlignmentLeft;
  fundAccountBtn.contentVerticalAlignment =
      UIControlContentVerticalAlignmentCenter;
  fundAccountBtn.titleLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
  fundAccountBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
  [fundAccountBtn addTarget:self
                     action:@selector(selectFundSort:)
           forControlEvents:UIControlEventTouchUpInside];
  [self.clientView addSubview:fundAccountBtn];
  //右侧箭头2
  seRowArrow = [[UIImageView alloc]
      initWithFrame:CGRectMake(self.view.frame.size.width - 20 - 15 - 10,
                               tradeStock_verticalSpace * 2 - 10 - 6, 15, 10)];
  seRowArrow.image = [UIImage imageNamed:@"logon_pull_down.png"];
  arrowType_stockSort = arrow_down;
  [self.clientView addSubview:seRowArrow];
  //资金账号
  fundAccountTextField = [[UITextField alloc]
      initWithFrame:CGRectMake(tradeStock_leftFixedSpace,
                               tradeStock_verticalSpace * 3 - 25,
                               self.view.frame.size.width -
                                   tradeStock_leftFixedSpace - 20 - 55 - 10,
                               20)];
  fundAccountTextField.delegate = self;
  fundAccountTextField.placeholder = @"请输入交易账号";
  fundAccountTextField.keyboardType = UIKeyboardTypeDefault;
  fundAccountTextField.contentVerticalAlignment =
      UIControlContentVerticalAlignmentCenter;
  fundAccountTextField.textAlignment = NSTextAlignmentLeft;
  fundAccountTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  fundAccountTextField.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  fundAccountTextField.backgroundColor = [UIColor clearColor];
  fundAccountTextField.font = [UIFont systemFontOfSize:15.0f];
  [self.clientView addSubview:fundAccountTextField];
  //屏蔽对fundaccountTextField操作
  UIButton *coverFundTFButton = [UIButton buttonWithType:UIButtonTypeCustom];
  coverFundTFButton.frame = CGRectMake(
      tradeStock_leftFixedSpace,
      tradeStock_verticalSpace * 3 - tradeStock_verticalSpace,
      self.view.frame.size.width - tradeStock_leftFixedSpace - 20 - 55 - 10,
      tradeStock_verticalSpace);
  coverFundTFButton.userInteractionEnabled = YES;
  coverFundTFButton.backgroundColor = [UIColor clearColor];
  [coverFundTFButton addTarget:self
                        action:@selector(fundTFBecomeFirstResponding)
              forControlEvents:UIControlEventTouchUpInside];
  [self.clientView addSubview:coverFundTFButton];
  // fundAccountTextField.text=@"000030000421";
  //保存账户信息
  saveInfoSwitch = [[CheckNumberButton alloc]
      initWithFrame:CGRectMake(self.view.frame.size.width - 75.0,
                               tradeStock_verticalSpace * 3 - 27, 55, 25)];
  [saveInfoSwitch.bgButton addTarget:self
                              action:@selector(selectButton:)
                    forControlEvents:UIControlEventTouchUpInside];
  [self.clientView addSubview:saveInfoSwitch];
  //交易密码
  tradePasswordTextField = [[UITextField alloc]
      initWithFrame:CGRectMake(tradeStock_leftFixedSpace,
                               tradeStock_verticalSpace * 4 - 25,
                               self.view.frame.size.width -
                                   tradeStock_leftFixedSpace - 20,
                               20)];
  tradePasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  tradePasswordTextField.placeholder = @"请输入交易密码";
  tradePasswordTextField.delegate = self;
  [tradePasswordTextField setSecureTextEntry:YES];
  //®tradePasswordTextField.text=@"123321";
  tradePasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
  tradePasswordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  tradePasswordTextField.textColor = [Globle colorFromHexRGB:@"454545"];
  tradePasswordTextField.backgroundColor = [UIColor clearColor];
  tradePasswordTextField.font = [UIFont systemFontOfSize:Font_Height_14_0];
  tradePasswordTextField.inputView = customKeyBoard;
  tradePasswordTextField.delegate = self;
  tradePasswordTextField.contentVerticalAlignment =
      UIControlContentVerticalAlignmentCenter;
  tradePasswordTextField.textAlignment = NSTextAlignmentLeft;
  [self.clientView addSubview:tradePasswordTextField];
  //验证码
  verifyNumberImageView = [[UIImageView alloc]
      initWithFrame:CGRectMake(self.view.frame.size.width - 60 - 20,
                               tradeStock_verticalSpace * 5 - 25, 60, 25)];
  verifyNumberImageView.backgroundColor =
      [Globle colorFromHexRGB:Color_BG_Common];
  verifyNumberImageView.contentMode = UIViewContentModeScaleAspectFit;
  [self.clientView addSubview:verifyNumberImageView];

  verifyNumberTextfield = [[UITextField alloc]
      initWithFrame:CGRectMake(tradeStock_leftFixedSpace - 15,
                               tradeStock_verticalSpace * 5 - 25,
                               self.view.frame.size.width -
                                   tradeStock_leftFixedSpace - 20 - 60,
                               20)];
  verifyNumberTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
  verifyNumberTextfield.delegate = self;
  verifyNumberTextfield.keyboardType = UIKeyboardTypeNumberPad;
  verifyNumberTextfield.font = [UIFont systemFontOfSize:Font_Height_14_0];
  verifyNumberTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
  verifyNumberTextfield.textColor = [Globle colorFromHexRGB:@"454545"];
  [verifyNumberTextfield setBackgroundColor:[UIColor clearColor]];
  verifyNumberTextfield.contentVerticalAlignment =
      UIControlContentVerticalAlignmentCenter;
  verifyNumberTextfield.textAlignment = NSTextAlignmentLeft;
  [self.clientView addSubview:verifyNumberTextfield];
  //重刷透明按钮
  verifyNumberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  verifyNumberBtn.frame = CGRectMake(self.view.frame.size.width - 58 - 20,
                                     tradeStock_verticalSpace * 5 - 27, 58, 25);
  [verifyNumberBtn
      setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                forState:UIControlStateHighlighted];
  [verifyNumberBtn setTitle:@"重试" forState:UIControlStateNormal];
  verifyNumberBtn.titleLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
  [verifyNumberBtn setBackgroundColor:[Globle colorFromHexRGB:@"31bce9"]];
  [verifyNumberBtn.layer setMasksToBounds:YES];
  [verifyNumberBtn.layer setCornerRadius:5.0];
  [verifyNumberBtn addTarget:self
                      action:@selector(receivVerifyNumber)
            forControlEvents:UIControlEventTouchUpInside];
  [self.clientView addSubview:verifyNumberBtn];
  //等待菊花
  indicator = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  indicator.center = verifyNumberImageView.center;
  [self.clientView addSubview:indicator];
  //竖分割线(3)
  UIView *verticalLine_3 = [[UIView alloc]
      initWithFrame:CGRectMake(self.view.frame.size.width - 20 - 60 - 3.5,
                               tradeStock_verticalSpace * 3 - 20, 0.5, 16)];
  verticalLine_3.backgroundColor = [Globle colorFromHexRGB:@"086dae"];
  [self.clientView addSubview:verticalLine_3];
  //竖分割线(5)
  UIView *verticalLine_5 = [[UIView alloc]
      initWithFrame:CGRectMake(self.view.frame.size.width - 20 - 60 - 3.5,
                               tradeStock_verticalSpace * 5 - 20, 0.5, 16)];
  verticalLine_5.backgroundColor = [Globle colorFromHexRGB:@"086dae"];
  [self.clientView addSubview:verticalLine_5];
  //创建表格1
  [self createTableViewWithRect:CGRectMake(20, tradeStock_verticalSpace - 0.01,
                                           self.clientView.frame.size.width - 2 * 20,
                                           0.01)];
  //创建表格2
  [self createTableViewWithRect:CGRectMake(
                                    20, tradeStock_verticalSpace * 2 - 0.01,
                                    self.clientView.frame.size.width - 2 * 20, 0.01)];
}
#pragma mark---------------------SimuKeyBoardViewDelegate---------------------
- (void)fundTFBecomeFirstResponding {
  [fundAccountTextField becomeFirstResponder];
}
/**
 *缓存用户信息
 */
- (void)selectButton:(UIButton *)button {
}
/**
 *重载缓存信息
 */
- (void)reloadCacheInfo {
  [self showUserSavedInfo];
  //是否保存
  saveInfoSwitch.on = [[[UserRealTradingInfo sharedInstance]
      getUserInfo:SaveTypeAccountSaveStatus] integerValue];
  //资金账号
  _fundAccountStr =
      [[UserRealTradingInfo sharedInstance] getUserInfo:SaveTypeUserTradingID];
  if (_fundAccountStr != nil && [_fundAccountStr length] > 0) {
    [self fundAccountEncryption:_fundAccountStr];
  }
}
- (void)receivVerifyNumber {
  //验证码重置
  [self refreshCaptchaImage:self.currentCompany.randUrl];
}
//设置光标位置
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
    fundAccountTextField.text = [fundAcc
        stringByReplacingCharactersInRange:NSMakeRange(4, [fundAcc length] - 4)
                                withString:tempStr];
  } else if (strLength > 8) {
    fundAccountTextField.text =
        [fundAcc stringByReplacingCharactersInRange:NSMakeRange(4, 4)
                                         withString:@"●●●●"];
  } else {
    fundAccountTextField.text = fundAcc;
  }
}
/**
 *平台目录 + 账号类型
 */
- (void)createTableViewWithRect:(CGRect)frame {
  if (frame.origin.y < tradeStock_verticalSpace) {
    stockPlatFormTableView = [[UITableView alloc] initWithFrame:frame];
    stockPlatFormTableView.delegate = self;
    stockPlatFormTableView.dataSource = self;
    stockPlatFormTableView.bounces = NO;
    stockPlatFormTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    stockPlatFormTableView.userInteractionEnabled = YES;
    [stockPlatFormTableView.layer setBorderWidth:0.5f];
    [stockPlatFormTableView.layer
        setBorderColor:[Globle colorFromHexRGB:@"bfbfbf"].CGColor];
    [self.clientView addSubview:stockPlatFormTableView];
  } else {
    fundSortTableView = [[UITableView alloc] initWithFrame:frame];
    fundSortTableView.delegate = self;
    fundSortTableView.dataSource = self;
    fundSortTableView.bounces = NO;
    fundSortTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    fundSortTableView.userInteractionEnabled = YES;
    [fundSortTableView.layer setBorderWidth:0.5f];
    [fundSortTableView.layer
        setBorderColor:[Globle colorFromHexRGB:@"bfbfbf"].CGColor];
    [self.clientView addSubview:fundSortTableView];
  }
}
/**
 *保存账户信息
 */
- (void)saveUserLoginedInfo {
  if (saveInfoSwitch.on == YES) {
    //过滤无效保存
    if ([_fundAccountStr length] < 1) {
      return;
    }
    //保存平台名称
    NSString *companyName = self.currentCompany.name;
    if (companyName != nil && [companyName length] > 0) {
      [[UserRealTradingInfo sharedInstance]
             saveUserInfo:SaveTypeUserTradingCompany
          withSaveContent:companyName];
    }
    //保存账号类型
    NSString *accountType = self.currentAccountType.name;
    [[UserRealTradingInfo sharedInstance] saveUserInfo:SaveTypeAccountType
                                       withSaveContent:accountType];
    [[UserRealTradingInfo sharedInstance] saveUserInfo:SaveTypeUserTradingID
                                       withSaveContent:_fundAccountStr];
  } else {
    //保存平台名称
    [[UserRealTradingInfo sharedInstance]
           saveUserInfo:SaveTypeUserTradingCompany
        withSaveContent:@"德邦证券[测试]"];
    [[UserRealTradingInfo sharedInstance] saveUserInfo:SaveTypeAccountType
                                       withSaveContent:@"客户号"];
    [[UserRealTradingInfo sharedInstance] saveUserInfo:SaveTypeUserTradingID
                                       withSaveContent:@""];
  }
}
/**
 *自定义键盘
 */
- (void)createCustomizeKeyBoard {
  customKeyBoard = [[CustomizeNumberKeyBoard alloc]
      initWithFrame:CGRectMake(0, self.view.frame.size.height - 222,
                               self.view.frame.size.width, 222)];
  customKeyBoard.delegate = self;
}
#pragma mark
#pragma mark-------资金账号delegate-----
- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  if ([string isEqualToString:@"\n"]) {
    return YES;
  }
  NSString *toBeString =
      [textField.text stringByReplacingCharactersInRange:range
                                              withString:string];
  //资金账号
  if (textField == fundAccountTextField) {
    //明文-1
    if (_fundAccountStr != nil) {
      _fundAccountStr =
          [_fundAccountStr stringByReplacingCharactersInRange:range
                                                   withString:string];
    } else {
      _fundAccountStr =
          [textField.text stringByReplacingCharactersInRange:range
                                                  withString:string];
    }
    //得到输入框里的内容
    NSString *toBeString;
    if (range.location >= 4 && range.location < 8 && range.length == 0 &&
        [string length] == 1) {
      toBeString = [textField.text stringByReplacingCharactersInRange:range
                                                           withString:@"●"];
    } else {
      toBeString = [textField.text stringByReplacingCharactersInRange:range
                                                           withString:string];
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
  else if (textField == tradePasswordTextField) {
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
#pragma mark
#pragma mark-------自定义键盘delegate------
- (void)selectRandomMethod:(NSString *)theValue {
  //删除、确定键
  if ([theValue isEqualToString:@"clear"]) {
    NSString *text = tradePasswordTextField.text;
    NSInteger lenth = [text length] - 1;
    if (lenth > -1) {
      text = [text substringToIndex:[text length] - 1];
    }
    tradePasswordTextField.text = text;
    if ([tradePasswordTextField.text length] == 0) {
    }
    return;
  } else if ([theValue isEqualToString:@"enter"]) {
    [tradePasswordTextField resignFirstResponder];
    return;
  }
  NSString *oldValue =
      [NSString stringWithFormat:@"%@", tradePasswordTextField.text];
  //限制密码长度
  if ([oldValue length] > 15) {
    return;
  }
  NSString *newValue = [oldValue stringByAppendingString:theValue];
  [tradePasswordTextField setText:newValue];
}
/**
 *选择证券平台
 */
- (void)selectStockPlatform:(UIButton *)button {
  if (arrowType_stockSort == arrow_up) {
    [self performSelector:@selector(selectFundSort:) withObject:nil];
  }
  [self.clientView bringSubviewToFront:stockPlatFormTableView];
  if (arrowType_fundType == arrow_down) {
    //下拉
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.05 * [self.companyList.result count]];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    fsRowArrow.image = [UIImage imageNamed:@"logon_pull_up.png"];
    arrowType_fundType = arrow_up;
    float platformHeght = 0;
    platformHeght = [self.companyList.result count] * 42;
    if (platformHeght > 300.0f) {
      platformHeght = 300.0f;
    }
    stockPlatFormTableView.frame = CGRectMake(
        20, tradeStock_verticalSpace - 0.5, self.view.frame.size.width - 2 * 20,
        platformHeght);
    [stockPlatFormTableView reloadData];
    [UIView commitAnimations];
  } else {
    //回弹
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.05 * [self.companyList.result count]];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    fsRowArrow.image = [UIImage imageNamed:@"logon_pull_down.png"];
    arrowType_fundType = arrow_down;
    stockPlatFormTableView.frame =
        CGRectMake(20, tradeStock_verticalSpace - 0.5,
                   self.view.frame.size.width - 20 - 20, 0.5);
    [stockPlatFormTableView reloadData];
    [UIView commitAnimations];
  }
}
/**
 *选择账号类型
 */
- (void)selectFundSort:(UIButton *)button {
  [self.clientView bringSubviewToFront:fundSortTableView];
  if (arrowType_stockSort == arrow_down) {
    //下拉
    [UIView beginAnimations:nil context:nil];
    [UIView
        setAnimationDuration:0.05 * [self.currentCompany.accountTypes count]];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    float fundSortHeight = 0;
    fundSortHeight = [self.currentCompany.accountTypes count] * 42;
    if (fundSortHeight > 300.0f) {
      fundSortHeight = 300.0f;
    }
    fundSortTableView.frame =
        CGRectMake(20, tradeStock_verticalSpace * 2 - 0.5,
                   self.view.frame.size.width - 20 - 20,
                   fundSortHeight);
    seRowArrow.image = [UIImage imageNamed:@"logon_pull_up.png"];
    arrowType_stockSort = arrow_up;
    [fundSortTableView reloadData];
    [UIView commitAnimations];
  } else {
    //回弹
    [UIView beginAnimations:nil context:nil];
    [UIView
        setAnimationDuration:0.05 * [self.currentCompany.accountTypes count]];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    fundSortTableView.frame =
        CGRectMake(20, tradeStock_verticalSpace * 2 - 0.5,
                   self.view.frame.size.width - 20 - 20, 0.5);
    seRowArrow.image = [UIImage imageNamed:@"logon_pull_down.png"];
    arrowType_stockSort = arrow_down;
    [fundSortTableView reloadData];
    [UIView commitAnimations];
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
  NSDate *previousDate = [[UserRealTradingInfo sharedInstance]
      getUserFailLogonTimeWithAccountId:_fundAccountStr];

  NSTimeInterval timeInterval = [previousDate timeIntervalSinceNow];
  NSInteger failTime = [[UserRealTradingInfo sharedInstance]
      getUserRealTradeLogonWithAccountId:_fundAccountStr];
  if (previousDate != nil && failTime == login_entry_limit) {
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

- (void)logonSuccess { //:(UIButton *)button
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
  }
  //先停止小菊花
  if ([indicator isAnimating]) {
    [indicator stopAnimating];
  }
  [self fundTableView];
  [self releaseTextFieldResponder];
  NSLog(@"stockSortBtn = %@, fundAcc = %@", stockSortBtn.titleLabel.text,
        fundAccountBtn.titleLabel.text);
  //判空
  if ([stockSortBtn.titleLabel.text isEqualToString:@"请选择开户券商"]) {
    [NewShowLabel setMessageContent:@"您还没有选择开户券商"];
    return;
  } else if ([fundAccountBtn.titleLabel.text
                 isEqualToString:@"请选择账号类型"]) {
    [NewShowLabel setMessageContent:@"您还没有选择账号类型"];
    return;
  } else if ([_fundAccountStr length] < 1) {
    [NewShowLabel setMessageContent:@"您还没有输入资金账户"];
    return;
  } else if ([tradePasswordTextField.text length] < 1) {
    [NewShowLabel setMessageContent:@"您还没有输入交易密码"];
    return;
  } else if ([verifyNumberTextfield.text length] < 1) {
    [NewShowLabel setMessageContent:@"您还没有输入验证码"];
    return;
  }
  //密码输入错误超过5次，您的账号已被锁定，请在5分钟后重试
  if (![self checkInputContent]) {
    return;
  }
  NSLog(@"saveInfoSwitch.on = %d", saveInfoSwitch.on);
  //保存下滑动条状态
  NSString *switchStatus = [NSString stringWithFormat:@"%d", saveInfoSwitch.on];
  if (switchStatus && [switchStatus integerValue] > 0) {
    [[UserRealTradingInfo sharedInstance] saveUserInfo:SaveTypeAccountSaveStatus
                                       withSaveContent:switchStatus];
  }
  NSString *accountType =
      [NSString stringWithFormat:@"%ld", (long)self.currentAccountType.type];
  NSString *account = _fundAccountStr;
  NSString *password = tradePasswordTextField.text;
  NSString *captcheCode = verifyNumberTextfield.text;

  id<RealTradeUrlFactory> urlFactory =
      [RealTradeUrls getRealTradeUrlFactoryByType:self.currentCompany.type]; //TODO 东莞的type？
  [urlFactory setUrlPrefix:self.currentCompany.url];
  
  //根据证券商名 来选择登录后的请求类型
  NSString *stringNameQuanShang = stockSortBtn.titleLabel.text;
  for (RealTradeSecuritiesCompany *realTDS in self.companyList.result) {
    NSString *nameQuanShang = realTDS.name;
    if ([stringNameQuanShang isEqualToString:nameQuanShang]) {
      NSLog(@"%@ 的要求请求类型为 %@",nameQuanShang,realTDS.method);
      [urlFactory sendValueForLongon:realTDS.method];
      [urlFactory sendvalueforBrokerID:realTDS.num];
    }
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  __weak TradingFirmLogonViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
      TradingFirmLogonViewController *strongSelf = weakSelf;
      if (strongSelf) {
        return NO;
      } else
        return YES;
  };

  //返回成功
  callback.onSuccess = ^(NSObject *obj) {
      TradingFirmLogonViewController *strongSelf = weakSelf;
      if (strongSelf) {
        if ([NetLoadingWaitView isAnimating]) {
          [NetLoadingWaitView stopAnimating];
        }
        //保存账户信息
        if (saveInfoSwitch.on == YES) {
          [strongSelf saveUserLoginedInfo];
        }
        [[UserRealTradingInfo sharedInstance]
            logonSuccessResetUserInfo:_fundAccountStr];
        RealTradeLoginResponse *loginInfo = (RealTradeLoginResponse *)obj;
        [RealTradeAuthInfo singleInstance].loginInfo = loginInfo;
        [RealTradeAuthInfo singleInstance].cookie = loginInfo.customerSessionId;
        [RealTradeAuthInfo singleInstance].urlFactory = urlFactory;

      }
  };
  callback.onFailed = ^() {
      TradingFirmLogonViewController *strongSelf = weakSelf;
      if (strongSelf) {
        if ([NetLoadingWaitView isAnimating]) {
          [NetLoadingWaitView stopAnimating];
        }
        [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
        //验证码重置
        [strongSelf refreshCaptchaImage:self.currentCompany.randUrl];
      }
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
      TradingFirmLogonViewController *strongSelf = weakSelf;
      if (strongSelf) {
        [strongSelf logonWithError:error withException:ex];
      }
  };
  [NetLoadingWaitView stopAnimating];
  if (![NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView startAnimating];
  }
  if ([[urlFactory getLoginPath] length] < 1) {
    return;
  }
  [RealTradeLoginResponse loginWithUrl:[urlFactory getLoginPath]
                           withCaptcha:captcheCode
                       withAccountType:accountType
                           withAccount:account
                          withPassword:password
                          withCallback:callback];
}
- (void)logonWithError:(BaseRequestObject *)error
         withException:(NSException *)ex {
  if ([NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView stopAnimating];
  }
  if (error == nil) {
    [NewShowLabel setMessageContent:@"请求错误，请重新请求"];
    return;
  }
  //验证码清空
  verifyNumberTextfield.text = @"";
  if ([error.status isEqualToString:@"0822"]) {
    //验证码重置
    [self refreshCaptchaImage:self.currentCompany.randUrl];
    //密码错误
    NSInteger failTime = [[UserRealTradingInfo sharedInstance]
        getUserRealTradeLogonWithAccountId:_fundAccountStr];
    if (failTime > 0) {
      failTime = (failTime > login_entry_limit ? 1 : failTime + 1);
    } else {
      failTime = 1;
    }
    //记录第五次失败时间
    [[UserRealTradingInfo sharedInstance]
        saveUserRealTradeFailDateWithAccountId:_fundAccountStr];
    if (login_entry_limit - failTime > 0) {
      NSString *failContent = [NSString
          stringWithFormat:
              @"帐号或密码错误，您还有%ld次重试机会。",
              (long)(login_entry_limit - failTime)];
      [NewShowLabel setMessageContent:failContent];
      [[UserRealTradingInfo sharedInstance]
          saveUserRealTradeLogonWithAccountId:_fundAccountStr
                                 withFailTime:failTime];
    } else {
      [NewShowLabel setMessageContent:@"密"
                    @"码输入错误超过5次，您的账号已被锁"
                    @"定，请在5分钟后重试"];
      [[UserRealTradingInfo sharedInstance]
          saveUserRealTradeLogonWithAccountId:_fundAccountStr
                                 withFailTime:failTime];
    }
  } else if ([error.status isEqualToString:@"0821"]) {
    //验证码重置
    [self refreshCaptchaImage:self.currentCompany.randUrl];
    [NewShowLabel setMessageContent:error.message];
  } else {
    [NewShowLabel setMessageContent:error.message];
  }
}
//取消当前响应
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  //解决问题：表格打开，点击表格外部
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint tempPoint = [touch locationInView:self.clientView];
  CGRect platFormRect = stockPlatFormTableView.frame;
  CGRect fundRect = fundSortTableView.frame;
  if (CGRectContainsPoint(platFormRect, tempPoint) &&
      platFormRect.size.height > 10.0f) {
    return;
  }
  if (CGRectContainsPoint(fundRect, tempPoint) && fundRect.size.height > 10.0) {
    return;
  }
  [self fundTableView];
  [self releaseTextFieldResponder];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  [self fundTableView];
  float pageHeight = self.view.frame.size.height;
  if (textField == verifyNumberTextfield && pageHeight <= 480) {
    CGRect frame = self.clientView.frame;
    [UIView animateWithDuration:0.3
                     animations:^{
                       self.clientView.frame =
                             CGRectMake(0, frame.origin.y - 50,
                                        frame.size.width, frame.size.height);
                     }];
    for (UIView *view in self.clientView.subviews) {
      if (view.frame.origin.y < fundAccountBtn.frame.origin.y) {
        view.hidden = YES;
      }
    }
  }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
  float pageHeight = self.view.frame.size.height;
  if (textField == verifyNumberTextfield && pageHeight <= 480) {
    CGRect frame = self.clientView.frame;
    [UIView animateWithDuration:0.3 animations:^{
      self.clientView.frame =
      CGRectMake(0, frame.origin.y + 50,
                 frame.size.width, frame.size.height);
    } completion:^(BOOL finished) {
      if (finished) {
        for (UIView *view in self.clientView.subviews) {
          if (view.frame.origin.y < fundAccountBtn.frame.origin.y) {
            view.hidden = NO;
          }
        }
      }
    }];
  }
}
- (void)fundTableView {
  fsRowArrow.image = [UIImage imageNamed:@"logon_pull_up.png"];
  arrowType_fundType = arrow_up;
  [self performSelector:@selector(selectStockPlatform:) withObject:nil];
}
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
//  if (action == @selector(copy:) || action == @selector(cut:) || action ==
//  @selector(selectAll:) || action == @selector(select:)) {
//    return NO;
//  }else
//    return YES;
//}

/**
 *释放键盘
 */
- (void)releaseTextFieldResponder {
  //释放键盘
  for (UITextField *subText in self.clientView.subviews) {
    [subText resignFirstResponder];
  }
}
#pragma mark
#pragma mark--------表格协议函数-----
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  if (tableView == stockPlatFormTableView) {
    return [self.companyList.result count];
  } else
    return [self.currentCompany.accountTypes count];
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 42.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"cellID";
  TradeLogonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    cell = [[TradeLogonCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:cellID];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleGray;
  if (tableView == stockPlatFormTableView) {
    RealTradeSecuritiesCompany *company =
        self.companyList.result[indexPath.row];
    cell.leftTitle.text = company.name;
  } else {
    RealTradeSecuritiesAccountType *accountType =
        self.currentCompany.accountTypes[indexPath.row];
    cell.leftTitle.text = accountType.name;
  }
  return cell;
}
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //选择平台类型
  if (tableView == stockPlatFormTableView) {
    RealTradeSecuritiesCompany *company =
        self.companyList.result[indexPath.row];
    [stockSortBtn setTitle:company.name forState:UIControlStateNormal];
    self.currentCompany = company;
    RealTradeSecuritiesAccountType *accountType =
        self.currentCompany.accountTypes[0];
    self.currentAccountType = accountType;
    [fundAccountBtn setTitle:accountType.name forState:UIControlStateNormal];
    [self performSelector:@selector(selectStockPlatform:) withObject:nil];
    //需要重新刷新验证码
    [self refreshCaptchaImage:self.currentCompany.randUrl];
  } else {
    //选择账号类型
    RealTradeSecuritiesAccountType *accountType =
        self.currentCompany.accountTypes[indexPath.row];
    self.currentAccountType = accountType;
    [fundAccountBtn setTitle:accountType.name forState:UIControlStateNormal];
    [self performSelector:@selector(selectFundSort:) withObject:nil];
    //[self refreshCaptchaImage:self.currentCompany.randUrl];
  }
}
- (void)dealloc {
  NSLog(@"shifang");
}
@end
