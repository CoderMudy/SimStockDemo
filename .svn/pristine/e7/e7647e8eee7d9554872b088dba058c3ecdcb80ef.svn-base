//
//  FillInInviteClientVC.m
//  SimuStock
//
//  Created by jhss on 15/5/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FillInInvitationCodeClientVC.h"
#import "SimuUtil.h"
#import "NewShowLabel.h"
#import "BaseRequester.h"
#import "GetGoldWrapper.h"
@implementation FillInInvitationCodeClientVC

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createTopBarView];
  [self createFillInInviteVC];
}

- (void)createTopBarView {
  [_topToolBar resetContentAndFlage:@"填写邀请码" Mode:TTBM_Mode_Leveltwo];
  _indicatorView.hidden = YES;
  //创建确认按钮
  [self createConfirmBtn];
}

///创建确认按钮
- (void)createConfirmBtn {
  UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  confirmBtn.frame = CGRectMake(self.view.bounds.size.width - 60,
                                _topToolBar.bounds.size.height - 45, 60, 45);
  confirmBtn.backgroundColor = [UIColor clearColor];
  [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:Font_Height_16_0]];
  [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
  [confirmBtn setTitle:@"确定" forState:UIControlStateHighlighted];

  [confirmBtn setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                   forState:UIControlStateNormal];
  //按钮选中中视图
  UIImage *rightImage = [[UIImage imageNamed:@"return_touch_down"]
      resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 14, 14)];
  [confirmBtn setBackgroundImage:rightImage forState:UIControlStateHighlighted];

  //防止重复点击
  __weak FillInInvitationCodeClientVC *blockSelf = self;
  ButtonPressed buttonPressed = ^{
    FillInInvitationCodeClientVC *strongSelf = blockSelf;
    if (strongSelf) {
      [strongSelf confirmButtonPress:confirmBtn];
    }
  };
  [confirmBtn setOnButtonPressedHandler:buttonPressed];
  [self.view addSubview:confirmBtn];
}

- (void)confirmButtonPress:(UIButton *)btn {
  
  if (fillInInvitationCodeVC.inviteCodeTF.text.length == 0) {
    [NewShowLabel setMessageContent:@"请填写邀请码"];
    return;
  }
  //无网判断
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak FillInInvitationCodeClientVC *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
    FillInInvitationCodeClientVC *strongSelf = weakSelf;
    if (strongSelf) {
      NSLog(@"填写邀请码成功!");
      [super leftButtonPress];
      [[NSNotificationCenter defaultCenter]
          postNotificationName:@"WriteInviteCodeSuccess"
                        object:nil];
    }
  };

  callback.onFailed = ^{
    NSLog(@"填写邀请码失败。。。");
  };

  callback.onError = ^(BaseRequestObject *error, NSException *exc) {
    [BaseRequester defaultErrorHandler](error, exc);
  };
  [GetGoldWrapper
      saveInviteCodeWithCallback:callback
                   andInviteCode:fillInInvitationCodeVC.inviteCodeTF.text];
}

///创建✨填写邀请码✨VC
- (void)createFillInInviteVC {
  if (!fillInInvitationCodeVC) {
    fillInInvitationCodeVC = [[FillInInvitationCodeVC alloc]
        initWithNibName:@"FillInInvitationCodeVC"
                 bundle:nil];
    fillInInvitationCodeVC.view.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN);
    
  }
  self.clientView.clipsToBounds = YES;
  [self.clientView addSubview:fillInInvitationCodeVC.view];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
@end
