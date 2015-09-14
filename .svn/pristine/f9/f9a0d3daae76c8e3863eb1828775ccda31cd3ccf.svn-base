//
//  WFBindBankCardViewController.m
//  SimuStock
//
//  Created by moulin wang on 15/4/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFBindBankCardViewController.h"

@interface WFBindBankCardViewController () {
  //加个滚动视图
  UIScrollView *_myScrollView;

  /** 银行卡信息 */
  WFBankCarInformation *_bankCarInfo;
  /** 身份信息 */
  WFIdentityInformation *_identityInfo;
}

@end
@implementation WFBindBankCardViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [_topToolBar resetContentAndFlage:@"银行卡绑定" Mode:TTBM_Mode_Leveltwo];
  _indicatorView.hidden = YES;
  //创建界面
  [self createScrollView];
  [self creatView];
  //创建客服电话 和 确认提交按钮
  [self creatCreateCustomerServicePhoneAndSubmissionButton];
}

/** 创建一个滚动器 */
- (void)createScrollView {
  _myScrollView = [[UIScrollView alloc] init];
  _myScrollView.frame =
      CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN - 45);
  _myScrollView.contentSize = CGSizeMake(WIDTH_OF_SCREEN, _myScrollView.height);
  _myScrollView.showsVerticalScrollIndicator = NO;
  [_clientView addSubview:_myScrollView];
  
  UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
  [_myScrollView addGestureRecognizer:tap];
}
-(void)tapClick
{
  [self.view endEditing:NO];
  _myScrollView.contentOffset=CGPointMake(0, 0);
}
//创建界面
- (void)creatView {
  _identityInfo = [[[NSBundle mainBundle] loadNibNamed:@"WFIdentityInformation"
                                                  owner:nil
                                                options:nil] lastObject];
  _identityInfo.frame =
      CGRectMake(0, 10, CGRectGetWidth(_identityInfo.bounds),
                 CGRectGetHeight(_identityInfo.bounds));
  [_myScrollView addSubview:_identityInfo];

  _bankCarInfo = [[[NSBundle mainBundle] loadNibNamed:@"WFBankCarInformation"
                                                owner:nil
                                              options:nil] lastObject];
  _bankCarInfo.delegate=self;
  _bankCarInfo.frame = CGRectMake(0, CGRectGetMaxY(_identityInfo.frame) + 10,
                                  CGRectGetWidth(_bankCarInfo.bounds),
                                  CGRectGetHeight(_bankCarInfo.bounds));
  [_myScrollView addSubview:_bankCarInfo];
}
////delegate 的高度
///跳转高度
-(void)ChangeScrollviewHight
{
  _myScrollView.contentOffset = CGPointMake(0, 160);
}

//创建客服电话 和 确认提交按钮
- (void)creatCreateCustomerServicePhoneAndSubmissionButton {

  UIButton *createServicePhone = [UIButton buttonWithType:UIButtonTypeCustom];
  createServicePhone.frame =
      CGRectMake(CGRectGetWidth(_topToolBar.bounds) - 80,
                 _topToolBar.frame.size.height - 44, 80, 45 );
  [createServicePhone setTitle:@"客服热线" forState:UIControlStateNormal];
  [createServicePhone setTitleColor:[Globle colorFromHexRGB:@"30f0ff"]
                           forState:UIControlStateNormal];
  createServicePhone.backgroundColor = [UIColor clearColor];
  [createServicePhone addTarget:self
                         action:@selector(createServicePhoneAction)
               forControlEvents:UIControlEventTouchUpInside];
  createServicePhone.titleLabel.textAlignment = NSTextAlignmentLeft;
  createServicePhone.titleLabel.font =
      [UIFont systemFontOfSize:Font_Height_17_0];
  [_topToolBar addSubview:createServicePhone];

  UIButton *submissionButton = [UIButton buttonWithType:UIButtonTypeCustom];
  submissionButton.frame =
      CGRectMake((CGRectGetWidth(self.clientView.bounds) - 150) * 0.5,
                 CGRectGetMaxY(_bankCarInfo.frame) + 30, 150, 40);
  [submissionButton setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
  [submissionButton setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateHighlighted];
  [submissionButton setTitle:@"确认提交" forState:UIControlStateNormal];
  submissionButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_15_0];
  submissionButton.layer.cornerRadius = submissionButton.height * 0.5;
  submissionButton.layer.masksToBounds = YES;
  [submissionButton addTarget:self
                       action:@selector(submissionButtonAction)
             forControlEvents:UIControlEventTouchUpInside];
  submissionButton.backgroundColor = [Globle colorFromHexRGB:@"fe8519"];
  [_myScrollView addSubview:submissionButton];
}
/** “客服电话”按钮的触发方法 */
- (void)createServicePhoneAction {
  NSMutableString *str =
  [[NSMutableString alloc] initWithFormat:@"tel:%@", @"01053599702"];
  UIWebView *callWebview = [[UIWebView alloc] init];
  [callWebview
   loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
  [self.view addSubview:callWebview];
}
/** 确认提交按钮的触发方法 */
- (void)submissionButtonAction {
  
  if (![SimuUtil isExistNetwork])
  {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  if (_bankCarInfo.bankID==0)
  {
    [NewShowLabel setMessageContent:@"请选择银行卡类型"];
    return;
  }
  if ([_bankCarInfo.MainTextField.text length]>0)
  {
    //@"6217900100002760703"
    [self requestBindBankCardWithRealName:_identityInfo.identityLabelName.text
                       withIdentityNumber:_identityInfo.identityNumberLabel.text
                          withBankCardNum:_bankCarInfo.MainTextField.text
                               withBankID:_bankCarInfo.bankID];

  }
  else
  {
    [NewShowLabel setMessageContent:@"请绑定您的银行卡"];
  }
}

#pragma mark - 绑定银行卡
- (void)requestBindBankCardWithRealName:(NSString *)realName
                     withIdentityNumber:(NSString *)identityNum
                        withBankCardNum:(NSString *)bankCardNum
                             withBankID:(int)bankCardID {
  __weak WFBindBankCardViewController *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^() {
    WFBindBankCardViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    WFBindBankRequestData *bindBankInfoData = (WFBindBankRequestData *)obj;
    if ([bindBankInfoData.status isEqualToString:@"0000"]) {
      [NewShowLabel setMessageContent:@"银行卡绑定成功"];
    } else {
      [NewShowLabel setMessageContent:@"银行卡绑定失败"];
    }
  };
  callback.onFailed = ^() {
    NSLog(@"发送请求 失败");
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    NSLog(@"发送请求 错误");
    if ([obj.status isEqualToString:@"0201"]) {
      [NewShowLabel setMessageContent:obj.message];
    }
  };

  [WFBindBankRequestData requestBindBankWithRealName:realName
                              withIdentityCardNumber:identityNum
                                  withBankCardNumber:bankCardNum
                                          withBankid:bankCardID
                                        withCallback:callback];
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

@end
