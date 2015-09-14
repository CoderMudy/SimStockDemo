//
//  ChangeNickNameViewController.m
//  SimuStock
//
//  Created by Mac on 14-8-1.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ChangeNickNameViewController.h"
#import "SimuUtil.h"
#import "NetLoadingWaitView.h"
#import "JsonFormatRequester.h"
#import "ChangeUserInfoRequest.h"

#define NICKNAME_MAXCHARS 12

@implementation ChangeNickNameViewController

- (id)initWithNickname:(NSString *)nickname {
  if (self = [super init]) {
    self.nickname = nickname;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createMainView];
  tfNickname.text = self.nickname;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  //显示键盘
  [tfNickname resignFirstResponder];
}

#pragma mark
#pragma mark------界面设计-------
//导航栏
- (void)createMainView {

  CGRect frame = self.view.bounds;
  _indicatorView.hidden = YES;
  [_topToolBar resetContentAndFlage:@"更改名字" Mode:TTBM_Mode_Leveltwo];

  //保存按钮
  UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
  btnSave.frame = CGRectMake(self.view.frame.size.width - 60,
                             _topToolBar.frame.size.height - 44, 60, 44);
  [btnSave setTitle:@"保存" forState:UIControlStateNormal];
  btnSave.titleLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
  [btnSave setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                forState:UIControlStateNormal];
  [btnSave setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                     forState:UIControlStateHighlighted];
  [btnSave addTarget:self
                action:@selector(onSaveButtonPressed)
      forControlEvents:UIControlEventTouchUpInside];
  [_topToolBar addSubview:btnSave];

  tfNickname = [[ExtendedTextField alloc]
      initWithFrame:CGRectMake(27, 14, frame.size.width - 27 * 2, 35)];
  [tfNickname setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |
                                  UIViewAutoresizingFlexibleRightMargin];
  [tfNickname setAutocapitalizationType:UITextAutocapitalizationTypeNone];
  [tfNickname setAutocorrectionType:UITextAutocorrectionTypeNo];
  [tfNickname setPlaceholder:@"请输入昵称"];
  [tfNickname setTextColor:[Globle colorFromHexRGB:@"454545"]];
  [tfNickname setFont:[UIFont boldSystemFontOfSize:14.6]];
  //_tfNickname.textAlignment=NSTextAlignmentCenter;
  tfNickname.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  tfNickname.text = self.nickname;
  tfNickname.clearButtonMode = UITextFieldViewModeWhileEditing;
  tfNickname.borderStyle = UITextBorderStyleRoundedRect;
  tfNickname.delegate = self;
  [tfNickname setMaxLength:12];
  NSLog(@"nickname: %@", tfNickname);

  [self.clientView addSubview:tfNickname];

  UILabel *hint = [[UILabel alloc] init];
  hint.frame = CGRectMake(27, 14 + 35 + 2, 300, 50);
  hint.text = @"好名字能让你的股友更容易记住你";
  hint.textAlignment = NSTextAlignmentLeft;
  hint.textColor = [Globle colorFromHexRGB:@"939393"];
  hint.font = [UIFont boldSystemFontOfSize:Font_Height_13_0];
  hint.backgroundColor = [Globle colorFromHexRGB:@"#f7f7f7"];

  [self.clientView addSubview:hint];
}

- (BOOL)validNickname:(NSString *)dict_user_nickName {
  //昵称限制条件
  //  NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
  //  NSPredicate *pred =
  //      [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
  if ([dict_user_nickName length] == 0) {
    [NewShowLabel setMessageContent:@"请输入昵称"];
    return NO;
  } else if ([dict_user_nickName length] < 3 ||
             [dict_user_nickName length] > 12) {
    [NewShowLabel setMessageContent:@"昵称长度为3-12位"];
    return NO;
    //  } else if (![pred evaluateWithObject:dict_user_nickName]) {
    //    [NewShowLabel
    //    setMessageContent:@"用户名由3-12位中文、字母或数字组成，请重新输入"];
    //    return NO;
  }
  return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [tfNickname resignFirstResponder];
}
//保存昵称
- (void)onSaveButtonPressed {
  //  [_tfNickname resignFirstResponder];
  //过滤两侧的空格
  NSString *newNickname = [tfNickname.text
      stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

  if (![self validNickname:newNickname]) {
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    if ([NetLoadingWaitView isAnimating]) {
      [NetLoadingWaitView stopAnimating];
    }
    return NO;
  };
  __weak ChangeNickNameViewController *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
    ChangeNickNameViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf onNicknameChanged:newNickname];
    }
  };

  //加入阻塞
  if (![NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView startAnimating];
  }

  [ChangeUserInfoRequest changeNickname:newNickname
                       withNewSignature:nil
                             withSyspic:nil
                            withPicFile:nil
                withHttpRequestCallBack:callback];
}

- (void)onNicknameChanged:(NSString *)newNickname {

  [SimuUtil setUserNiceName:newNickname];
  [NewShowLabel setMessageContent:@"昵称修改成功"];
  [self leftButtonPress];

  [[NSNotificationCenter defaultCenter] postNotificationName:NT_Nickname_Change
                                                      object:nil];
}

#pragma mark - 左键返回
- (void)leftButtonPress {
  [tfNickname resignFirstResponder];
  [super leftButtonPress];
}

@end
