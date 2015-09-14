//
//  BindBankCardViewController.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BindBankCardViewController.h"
#import "WeiboToolTip.h"
#import "BanksListView.h"
#import "SendVerifyCodeData.h"
#import "BankCounterDrawData.h"
#import "NSString+validate.h"

@interface BindBankCardViewController ()

@end

@implementation BindBankCardViewController

- (id)initWithBankBindedStatus:(BankBindedStatus)status
                          data:(BankInitDrawData *)data {
  if (self = [super init]) {
    _clientView.width = WIDTH_OF_SCREEN;
    _clientView.height = HEIGHT_OF_SCREEN - _topToolBar.bottom;
    _bankStatus = status;
    _bankInitDrawData = data;
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  NSLog(@"申请提现页面释放");
}

- (void)leftButtonPress {
  [_timer invalidate];
  [super leftButtonPress];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  [_topToolBar resetContentAndFlage:@"申请提现" Mode:TTBM_Mode_Leveltwo];
  _indicatorView.hidden = YES;
  _remainTime = 60;

  //注册键盘通知
  [self registerForKeyboardNotifications];

  //为了适配4s等，必须创建scrollView
  _scrollView = [[UIScrollView alloc] initWithFrame:_clientView.bounds];
  _scrollView.contentSize =
      CGSizeMake(_scrollView.width,
                 (_bankStatus == BankUnBinded)
                     ? (_clientView.height > 502 ? _clientView.height : 502)
                     : (_clientView.height > 455 ? _clientView.height : 455));
  _scrollView.backgroundColor = [UIColor clearColor];
  _scrollView.delegate = self;
  //  _scrollView.delaysContentTouches = NO;//开启后点击button后无法滑动
  [_clientView addSubview:_scrollView];

  //给scrollView添加tap手势，点击其他地方收键盘
  UITapGestureRecognizer *tap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(tapScrollView)];
  [_scrollView addGestureRecognizer:tap];

  //提交按钮
  UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
  submitButton.frame = _indicatorView.frame;
  [submitButton addOriginX:-17];
  [submitButton setTitle:@"提交" forState:UIControlStateNormal];
  [submitButton addTarget:self
                   action:@selector(submit)
         forControlEvents:UIControlEventTouchUpInside];
  [submitButton setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                     forState:UIControlStateNormal];
  [submitButton setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                          forState:UIControlStateHighlighted];
  submitButton.hidden = (_bankStatus == BankProcessing);
  [self.view addSubview:submitButton];

  //说明button
  _introButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [_introButton
      setFrame:CGRectMake(WIDTH_OF_SCREEN - 50,
                          ((_bankStatus == BankUnBinded) ? 67 : 59), 31, 31)];
  _introButton.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
  [_introButton setImage:[UIImage imageNamed:@"forget_password_up"]
                forState:UIControlStateNormal];
  [_introButton addTarget:self
                   action:@selector(introButtonClick)
         forControlEvents:UIControlEventTouchUpInside];
  [_introButton setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                          forState:UIControlStateHighlighted];
  _introButton.backgroundColor = [UIColor clearColor];
  [_scrollView addSubview:_introButton];

  //获取验证码按钮
  if (_bankStatus != BankProcessing) {
    _verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_verifyButton
        setFrame:CGRectMake((WIDTH_OF_SCREEN - 120),
                            ((_bankStatus == BankBinded) ? 339 : 467), 100,
                            31)];
    [_verifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_verifyButton setTitleColor:[Globle colorFromHexRGB:Color_Blue_but]
                        forState:UIControlStateNormal];
    [_verifyButton setTitleColor:[Globle colorFromHexRGB:Color_Gray]
                        forState:UIControlStateDisabled];
    _verifyButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_15_0];

    requesting = NO;
    __weak BindBankCardViewController *weakSelf = self;
    [_verifyButton setOnButtonPressedHandler:^{
      [weakSelf getVerificationCode];
    }];

    _verifyButton.backgroundColor = [UIColor clearColor];
    [_verifyButton setBackgroundImage:[UIImage imageNamed:@"buttonPressDown"]
                             forState:UIControlStateHighlighted];
    [_scrollView addSubview:_verifyButton];
  }

  //蓝色竖线
  UIView *blueLine = [[UIView alloc]
      initWithFrame:CGRectMake(0, (_verifyButton.height - 19) / 2, .5f, 19)];
  blueLine.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
  [_verifyButton addSubview:blueLine];

  //修改提现提示Label
  if (_bankStatus != BankUnBinded) {
    UILabel *tipLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(0, _scrollView.contentSize.height - 72,
                                 WIDTH_OF_SCREEN, 16)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.text = @"如需要修改提现信息请拨打客服热线";
    tipLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    tipLabel.font = [UIFont systemFontOfSize:Font_Height_15_0];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:tipLabel];
  }

  //客服热线 拨打电话，永远添加在scroll底下
  UILabel *serviceLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(60, _scrollView.contentSize.height - 60, 100,
                               30)];
  serviceLabel.backgroundColor = [UIColor clearColor];
  serviceLabel.text = @"客服热线 ：";
  serviceLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  serviceLabel.font = [UIFont systemFontOfSize:Font_Height_15_0];
  serviceLabel.textAlignment = NSTextAlignmentRight;
  [_scrollView addSubview:serviceLabel];

  //
  UILabel *numberLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(160, _scrollView.contentSize.height - 60, 100,
                               30)];
  numberLabel.backgroundColor = [UIColor clearColor];
  numberLabel.userInteractionEnabled = YES;
  numberLabel.text = @"010-53599702";
  numberLabel.textColor = [Globle colorFromHexRGB:Color_Blue_but];
  numberLabel.font = [UIFont systemFontOfSize:Font_Height_15_0];
  numberLabel.textAlignment = NSTextAlignmentLeft;
  [_scrollView addSubview:numberLabel];

  //整体居中对齐
  [SimuUtil widthOfLabel:serviceLabel font:Font_Height_15_0];
  [SimuUtil widthOfLabel:numberLabel font:Font_Height_15_0];
  serviceLabel.left =
      (WIDTH_OF_SCREEN - serviceLabel.width - numberLabel.width) / 2;
  numberLabel.left = serviceLabel.left + serviceLabel.width;

  //
  UITapGestureRecognizer *tapCallServ =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(callService)];
  [numberLabel addGestureRecognizer:tapCallServ];

  //客服QQ
  UILabel *servQQLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(0, _scrollView.contentSize.height - 30,
                               WIDTH_OF_SCREEN, 16)];
  servQQLabel.backgroundColor = [UIColor clearColor];
  servQQLabel.text = @"客服 QQ ：2457025683";
  servQQLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  servQQLabel.font = [UIFont systemFontOfSize:Font_Height_15_0];
  servQQLabel.textAlignment = NSTextAlignmentCenter;
  [_scrollView addSubview:servQQLabel];

  //根据是否绑定银行卡创建界面
  (_bankStatus == BankUnBinded) ? [self createBindBankCardViews]
                                : [self createSubmitViews];
}

- (void)callService {
  //拨打客服号码
  NSString *number = @"01053599702";
  NSURL *backURL = [NSURL
      URLWithString:[NSString stringWithFormat:@"telprompt://%@", number]];
  [[UIApplication sharedApplication] openURL:backURL];
}

#pragma mark 如果已经绑定银行卡，则直接进入提交页面
- (void)createSubmitViews {

  //创建文字及输入框
  NSArray *titles = @[
    @"提现金额 ：",
    @"税后提现 ：",
    @"用户昵称 ：",
    @"手机号码 ：",
    @"姓       名 ： ",
    @"身份证号 ：",
    @"开户银行 ：",
    @"银行卡号 ：",
    @"手机验证 ："
  ];

  //创建标签、textField
  for (NSInteger i = 0; i < titles.count; i++) {
    //处理中页面不显示手机绑定
    if (_bankStatus == BankProcessing && i == 8) {
      break;
    }
    //标题label
    UILabel *titleLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(20, 27 + 40 * i, 80, 15)];
    titleLabel.text = titles[i];
    titleLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    titleLabel.font = [UIFont systemFontOfSize:Font_Height_15_0];
    titleLabel.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:titleLabel];

    //输入框
    UITextField *textField = [[UITextField alloc]
        initWithFrame:CGRectMake(100, 19 + 40 * i,
                                 (WIDTH_OF_SCREEN - (i < 8 ? 120 : 240)), 31)];
    //不是手机绑定
    if (i < 8) {
      textField.enabled = NO;
      NSMutableString *string =
          [NSMutableString stringWithString:_bankInitDrawData.stringArray[i]];
      if (i == 3) {
        [string replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
      } else if (i == 5) {
        [string replaceCharactersInRange:NSMakeRange(10, 4) withString:@"****"];
      } else if (i == 7) {
        //银行账户16~19位，隐藏除首尾4位的所有位为*
        NSMutableString *asterisk = [NSMutableString stringWithString:@""];
        for (NSInteger i = 0; i < string.length - 8; i++) {
          [asterisk appendString:@"*"];
        }
        [string replaceCharactersInRange:NSMakeRange(4, string.length - 8)
                              withString:asterisk];
      }
      textField.text = string;
    } else {
      textField.borderStyle = UITextBorderStyleRoundedRect;
      textField.textAlignment = NSTextAlignmentLeft;
      textField.keyboardType = UIKeyboardTypeNumberPad;
      _verifyCodeTextField = textField;
    }
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate = self;
    textField.tag = 101 + i;
    textField.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    if (i < 2) {
      textField.textColor = [Globle colorFromHexRGB:@"C70000"]; //红色
    }
    [_scrollView addSubview:textField];
  }
}

#pragma mark 未绑定银行卡，则先进绑定银行卡页面
- (void)createBindBankCardViews {
  //创建文字及输入框
  NSArray *titles = @[
    @"提现金额 ：",
    @"税后提现 ：",
    @"用户昵称 ：",
    @"手机号码 ：",
    @"姓       名 ： ",
    @"身份证号 ：",
    @"开户银行 ：",
    @"银行卡号 ：",
    @"银行卡号 ：",
    @"手机验证 ："
  ];

  // textField默认值
  NSArray *placehoders = @[
    @"",
    @"",
    @"",
    @"",
    @"请输入真实姓名",
    @"请输入18位居民身份证号",
    @"请选择开户银行",
    @"请输入银行卡号",
    @"请再次输入银行卡号",
    @""
  ];

  _unbindedTextFieldArray =
      [[NSMutableArray alloc] initWithCapacity:titles.count];

  //创建标签、textField
  for (NSInteger i = 0; i < titles.count; i++) {
    //标题label
    UILabel *titleLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(20,
                                 25 + (i < 5 ? 36 : 48) * i + (i < 5 ? 0 : -48),
                                 80, 15)];
    titleLabel.text = titles[i];
    if (i < 4) {
      titleLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    } else {
      titleLabel.textColor = [Globle colorFromHexRGB:Color_Blue_but];
    }
    titleLabel.font = [UIFont systemFontOfSize:Font_Height_15_0];
    titleLabel.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:titleLabel];

    if (i == 1) {
      _introButton.center =
          CGPointMake(_introButton.centerX, titleLabel.centerY);
    }

    //蓝色分割线
    if (i > 3) {
      UIView *blueLineView = [[UIView alloc]
          initWithFrame:CGRectMake(20, 53 + (i < 5 ? 36 : 48) * i +
                                           (i < 5 ? 0 : -48),
                                   (WIDTH_OF_SCREEN - 40), 1)];
      blueLineView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
      [_scrollView addSubview:blueLineView];
    }

    //输入框
    UITextField *textField = [[UITextField alloc]
        initWithFrame:CGRectMake(100,
                                 17 + (i < 5 ? 36 : 48) * i + (i < 5 ? 0 : -48),
                                 (WIDTH_OF_SCREEN - (i < 9 ? 120 : 220)), 31)];
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate = self;
    textField.tag = 201 + i;
    textField.placeholder = placehoders[i];
    textField.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    if (i < 2) {
      textField.textColor = [Globle colorFromHexRGB:@"C70000"]; //红色
    }

    if (i < 4) {
      NSMutableString *string =
          [NSMutableString stringWithString:_bankInitDrawData.stringArray[i]];
      if (i == 3) {
        [string replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        textField.textColor = [Globle colorFromHexRGB:Color_Gray];
      }
      textField.text = string;
    }

    if (i == 3 || i == 5 || i == 7 || i == 8 || i == 9) {
      textField.keyboardType = UIKeyboardTypeNumberPad;
    }

    //验证码
    if (i == 9) {
      _verifyCodeTextField = textField;
      _verifyButton.center =
          CGPointMake(_verifyButton.centerX, textField.centerY);
    }

    //前4项从服务器返回，不可编辑
    if (i < 4) {
      textField.enabled = NO;
    }
    [_scrollView addSubview:textField];
    [_unbindedTextFieldArray addObject:textField];
  }
}

#pragma mark - 键盘相关
- (void)registerForKeyboardNotifications {
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardWasShown:)
             name:UIKeyboardDidShowNotification
           object:nil];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardWillBeHidden:)
             name:UIKeyboardWillHideNotification
           object:nil];
}

- (void)keyboardWasShown:(NSNotification *)aNotification {
  NSDictionary *info = [aNotification userInfo];
  CGSize kbSize =
      [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  UIEdgeInsets contentInsets =
      UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 54, 0.0);
  _scrollView.contentInset = contentInsets;
  _scrollView.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  _scrollView.contentInset = contentInsets;
  _scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - scrollView相关
- (void)tapScrollView {
  [self.view endEditing:YES];
}

#pragma mark - 按钮点击
#pragma mark ⭐️提交
- (void)submit {
  //如果已绑定直接提交
  if (_bankStatus == BankBinded) {
    [self requestBankCounterDrawData];
  } else {
    //必须检测每一项textField是否为空，是否正确则由每一个textField单独判断
    [self checkInfoComplete];
  }
}

#pragma mark 说明按钮
- (void)introButtonClick {
  //隐藏键盘
  [self.view endEditing:YES];

  //提现说明
  [WeiboToolTip showWithdrawIntroduction];
}

#pragma mark 获取验证码
- (void)getVerificationCode {
  if (requesting) {
    return;
  }

  //发送验证码
  [self requestPhoneVerifyCodeWithNum:0];
  //禁用变会并倒计时
  _verifyButton.enabled = NO;
  [_verifyButton setTitle:@"重新获取(60)" forState:UIControlStateDisabled];

  _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                            target:self
                                          selector:@selector(timeCutDown)
                                          userInfo:nil
                                           repeats:YES];
}

- (void)timeCutDown {
  [_verifyButton setTitle:[NSString stringWithFormat:@"重新获取(%ld)",
                                                     (long)--_remainTime]
                 forState:UIControlStateDisabled];
  if (_remainTime <= 0) {
    _remainTime = 60;
    [_timer invalidate];
    _verifyButton.enabled = YES;
  }
}

#pragma mark - 输入框代理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  //如果是选择银行
  if (textField.tag == 207) {
    //隐藏键盘
    [self.view endEditing:YES];

    [BanksListView showMJNIndexView:^(NSString *bankName) {
      textField.text = bankName;
    } contentArray:_bankInitDrawData.bankList];
    return NO;
  }
  return YES;
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  // switch
  //根据哪个输入框来判断文字替换
  NSLog(@"textField.tag:%ld", (long)textField.tag);
  NSInteger existedLength = textField.text.length;
  NSInteger selectedLength = range.length;
  NSInteger replaceLength = string.length;
  NSInteger length = existedLength - selectedLength + replaceLength;
  NSInteger tag = textField.tag;
  switch (tag) {
  case 109:
  case 210: {
    //手机验证码6位
    if (length > 6) {
      return NO;
    }
    return [NSString validataNumberInput:string];
  } break;
  case 205: {
    //姓名最长8个汉字，限定中文（合并再做）
    if (length > 16) {
      return NO;
    }
  } break;
  case 206: {
    //身份证最长18位
    if (length > 18) {
      return NO;
    }
    return [NSString validataIdCardNumberOnInput:string];
  } break;
  case 208:
  case 209: {
    //银行卡最长19+4位
    if (length > 19) {
      return NO;
    }
    return [NSString validataNumberInput:string];
  } break;

  default:
    break;
  }

  return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

  switch (textField.tag) {
  case 205: {
    BOOL canResign = [NSString validataChineseNameOnEnd:textField.text];
    if (!canResign) {
      [NewShowLabel setMessageContent:@"请输入中文姓名"];
    }
  } break;
  case 206: {
    BOOL canResign = [NSString validataIdCardNumberOnEnd:textField.text];
    if (!canResign) {
      [NewShowLabel setMessageContent:@"请输入正确的身份证号"];
    }
  } break;
  case 209: {
    //检测是否和208一致
    for (UITextField *lastTextField in _unbindedTextFieldArray) {
      if (lastTextField.tag == 208) {
        if (![lastTextField.text isEqualToString:textField.text]) {
          [NewShowLabel setMessageContent:@"两" @"次" @"输"
                        @"入的银行卡号不一致"];
        }
      }
    }
  } break;

  default:
    break;
  }
  return YES;
}

#pragma mark - 网络相关
#pragma mark 无网提示
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
}

#pragma mark 给绑定手机发送验证码
- (void)requestPhoneVerifyCodeWithNum:(NSInteger)num {
  if (num >= 3) {
    return;
  }

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }
  requesting = YES;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak BindBankCardViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    BindBankCardViewController *strongSelf = weakSelf;
    if (strongSelf) {
      requesting = NO;
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    [NewShowLabel setMessageContent:@"验" @"证" @"码"
                  @"已发送至您的手机，请查收"];
  };

  callback.onFailed = ^{
    [weakSelf setNoNetwork];
    [self requestPhoneVerifyCodeWithNum:num + 1];
  };

  [SendVerifyCodeData
      requestPhoneVerifyCodeWithPhoneNumber:_bankInitDrawData.phone
                                       type:CodeTypeGetCash
                                   callback:callback];
}

#pragma mark 提交前检测
- (void)checkInfoComplete {
  __block BOOL isCompleted = YES;
  //检测所有输入框是否完整，两次输入的银行账户是否完全相等
  [_unbindedTextFieldArray
      enumerateObjectsUsingBlock:^(UITextField *textField, NSUInteger idx,
                                   BOOL *stop) {
        if (textField.text.length == 0) {
          switch (idx) {
          case 4: {
            //姓名
            [NewShowLabel setMessageContent:@"请输入姓名"];
          } break;
          case 5: {
            //身份证号
            [NewShowLabel setMessageContent:@"请输入身份证号"];
          } break;
          case 6: {
            //开户银行
            [NewShowLabel setMessageContent:@"请输入开户银行"];
          } break;
          case 7: {
            //银行账户
            [NewShowLabel setMessageContent:@"请输入银行卡号"];
          } break;
          case 8: {
            //银行账户
            [NewShowLabel setMessageContent:@"请再次输入银行卡号"];
          } break;
          case 9: {
            //手机验证
            [NewShowLabel setMessageContent:@"请输入手机验证码"];
          } break;

          default:
            break;
          }
          *stop = YES;
          isCompleted = NO;
        } else {
          //将数据封装进_bankInitDrawData
          switch (idx) {
          case 4: {
            //姓名
            _bankInitDrawData.realName = textField.text;
          } break;
          case 5: {
            //身份证号
            _bankInitDrawData.certNo = textField.text;
          } break;
          case 6: {
            //开户银行
            _bankInitDrawData.bankName = textField.text;
          } break;
          case 7: {
            //银行账户
            _bankInitDrawData.bankAccount = textField.text;
          } break;

          default:
            break;
          }
        }
      }];

  //如果所有数据完整，则开始提交
  if (isCompleted) {
    //检测两次银行卡输入是否一致
    if (_bankStatus == BankUnBinded) {
      UITextField *bankCardTF = (UITextField *)[self.view viewWithTag:208];
      UITextField *bankCardAgainTF = (UITextField *)[self.view viewWithTag:209];
      if (![bankCardTF.text isEqualToString:bankCardAgainTF.text]) {
        [NewShowLabel setMessageContent:@"两" @"次" @"输" @"入"
                      @"的银行卡号不一致"];
        return;
      }
    }
    [self requestBankCounterDrawData];
  }
}

#pragma mark 提交
- (void)requestBankCounterDrawData {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak BindBankCardViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    BindBankCardViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    [NewShowLabel setMessageContent:[(BankCounterDrawData *)obj message]];
    BindBankCardViewController *strongSelf = weakSelf;
    //通知我的收入主页刷新
    if (_submitSuccessed) {
      _submitSuccessed();
    }
    [strongSelf leftButtonPress];
  };

  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  //  callback.onError = ^(BaseRequestObject *obj, NSException *exp) {
  //    NSLog(@"%@", obj.status);
  //    NSLog(@"%@", obj.message);
  //  };

  [BankCounterDrawData
      requestBankCounterDrawDataWithDic:[self createBankDictionary]
                               callback:callback];
}

- (NSDictionary *)createBankDictionary {
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  [dic setObject:[SimuUtil getUserName] forKey:@"userName"];
  [dic setObject:[SimuUtil getUserNickName] forKey:@"nickName"];
  [dic setObject:_bankInitDrawData.realName forKey:@"realName"];
  [dic setObject:_bankInitDrawData.phone forKey:@"phone"];
  [dic setObject:_bankInitDrawData.bankName forKey:@"bankName"];
  [dic setObject:_bankInitDrawData.bankAccount forKey:@"bankAccount"];
  [dic setObject:[NSString stringWithFormat:@"%.2f", _bankInitDrawData.cash]
          forKey:@"cash"];
  [dic setObject:_verifyCodeTextField.text forKey:@"verifyCode"];
  [dic setObject:_bankInitDrawData.certNo forKey:@"certNo"];
  [dic setObject:[NSString
                     stringWithFormat:@"%.2f", _bankInitDrawData.taxBalance]
          forKey:@"taxDone"];
  return [dic copy];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
