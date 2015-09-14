//
//  WFAuthenticationViewController.m
//  SimuStock
//
//  Created by Jhss on 15/4/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

@interface WFAuthenticationViewController ()

@end

@implementation WFAuthenticationViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  //显示“身份验证”并且隐藏刷新按钮
  [_topToolBar resetContentAndFlage:@"身份验证" Mode:TTBM_Mode_Leveltwo];
  _indicatorView.hidden = YES;
  //设置右上角“客服热线”按钮
  [self setupServiceTelBtn];
  _clientView.alpha = 0;


\


  // Do any additional setup after loading the view from its nib.
}
/** 设置右上角“客服热线”按钮 */
- (void)setupServiceTelBtn {
  
  self.Service_Tel_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
  self.Service_Tel_Btn.frame =
      CGRectMake(self.view.frame.size.width - 80,
                 _topToolBar.frame.size.height - 44, 80, 44);
  [self.Service_Tel_Btn setTitle:@"客服热线\n010-684654"
                        forState:UIControlStateNormal];
  self.Service_Tel_Btn.titleLabel.font =
      [UIFont systemFontOfSize:Font_Height_12_0];
  self.Service_Tel_Btn.titleLabel.numberOfLines = 0;
  [self.Service_Tel_Btn setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                             forState:UIControlStateNormal];
  [self.Service_Tel_Btn
      setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                forState:UIControlStateHighlighted];
  [self.Service_Tel_Btn addTarget:self
                           action:@selector(clickOnHotlineButton:)
                 forControlEvents:UIControlEventTouchUpInside];
  [self.topToolBar addSubview:self.Service_Tel_Btn];
}


/** “客服热线”按钮点击响应函数（拨打客服热线电话：010684654） */
- (void)clickOnHotlineButton:(UIButton *)clickedBtn {
  //  NSString *number = @"010684654";
  //  NSURL *backURL = [NSURL
  //                    URLWithString:[NSString
  //                    stringWithFormat:@"telprompt://%@", number]];
  //  [[UIApplication sharedApplication] openURL:backURL];

  NSMutableString *str =
      [[NSMutableString alloc] initWithFormat:@"tel:%@", @"010684654"];
  UIWebView *callWebview = [[UIWebView alloc] init];
  [callWebview
      loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
  [self.view addSubview:callWebview];
}

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
/** 解析 是否申请融资账户 */
- (IBAction)clickAffirmSubmitMessages:(id)sender {
  
  
}

//验证码
- (IBAction)clickGainSecurityCodePress:(id)sender {
  
  if (![SimuUtil isExistNetwork]) {
    return;
  }
  HttpRequestCallBack *callBack = [[HttpRequestCallBack alloc] init];
  //解析
  __weak WFAuthenticationViewController *weakSelf = self;
  
  callBack.onSuccess = ^(NSObject *obj) {
    WFAuthenticationViewController *strongSelf = weakSelf;
    if (strongSelf) {
    }
  };
  callBack.onError = ^(BaseRequestObject *obj, NSException *exc) {
    WFAuthenticationViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [BaseRequester defaultErrorHandler];
    }
  };
  callBack.onFailed = ^{
    WFAuthenticationViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [BaseRequester defaultFailedHandler];
    }
  };
  
}


/**
 *键盘回收
 */
- (void)resignKeyBoardResponder {
  [self.Input_Cellphone_Number resignFirstResponder];
  [self.Input_Security_Code resignFirstResponder];
}
//验证码输入只能输入数字
- (BOOL)isValidateMobile:(NSString *)mobile {
  NSString *phoneRegex = @"^[0-9]{0,6}$";
  NSPredicate *phoneTest =
      [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
  return [phoneTest evaluateWithObject:mobile];
}








@end
