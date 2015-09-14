//
//  AwardsSetUpView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/8/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AwardsSetUpView.h"
#import "UIButton+Block.h"
#import "WeiboToolTip.h"
#import "GetUserBandPhoneNumber.h"
#import "SimuUtil.h"
#import "NewShowLabel.h"
#import "BaseRequester.h"
#import "phoneRegisterViewController.h"
#import "AppDelegate.h"
#import "ExplanationTipView.h"

@implementation AwardsSetUpView
- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    UIView *containerView = [
        [[UINib nibWithNibName:@"AwardsSetUpView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    containerView.frame = newFrame;
    [self addSubview:containerView];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  _awardsSwitch.layer.cornerRadius = 15.0f;
  _awardsSwitch.layer.masksToBounds = YES;
  //放重复点击
  __weak AwardsSetUpView *weakSelf = self;
  [self.doubtButton setOnButtonPressedHandler:^{
    AwardsSetUpView *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf endEdit];
      [strongSelf doubtButtonDownUpInside];
    }
  }];
}
/** 疑问按钮点击事件 */
- (void)doubtButtonDownUpInside {
  //弹出提示框
  NSString *message = @"为" @"确" @"保" @"奖" @"金" @"发放，比赛创建后会有优顾客"
      @"服人员与您联系。优顾"
      @"履行奖金的发放，由此产生的税费由优顾代缴。";

  [ExplanationTipView showAwardsMatchExplantionTipViewWithMessage:message];
}

/** 开关按钮 */
- (IBAction)awardsSwitchValueChanged:(UISwitch *)sender {
  //点击开关
  if (sender.on) {
    NSLog(@"开");
    //判断 有没有绑定手机号
    [self judgeBindingMobilePhoneNumber];
  } else {
    NSLog(@"关");
    if (self.awardsSwitchOffBlock) {
      self.awardsSwitchOffBlock();
    }
  }
}

/** 判断有没有绑定手机号 */
- (void)judgeBindingMobilePhoneNumber {
  NSString *phone = [SimuUtil getUserPhone];
  if ([phone isEqualToString:@""]) {
    //如果本地没有  就从网络上请求一次
    [self requestUsePhone];
  }else{
    //已绑定
    if (self.awardsSwitchOnBlock) {
      self.awardsSwitchOnBlock();
    }
  }
}

-(void)requestUsePhone
{
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel setMessageContent:@"网络不给力,请检查网络"];
    return;
  }
  if (self.startIndicatorBlock) {
    self.startIndicatorBlock();
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak AwardsSetUpView *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^() {
    AwardsSetUpView *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.stopIndicatorBlock) {
        strongSelf.stopIndicatorBlock();
      }
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    AwardsSetUpView *strongSelf = weakSelf;
    if (strongSelf) {
      if (!strongSelf.awardsSwitch.on) {
        return ;
      }
      GetUserBandPhoneNumber *userBindPhone = (GetUserBandPhoneNumber *)obj;
      if (userBindPhone.phoneNumber && userBindPhone.phoneNumber.length > 0) {
        if (strongSelf.awardsSwitchOnBlock) {
          strongSelf.awardsSwitchOnBlock();
        }
      } else {
        //没有手机号
        [strongSelf.awardsSwitch setOn:NO animated:YES];
        //跳转到 手机号 绑定页面
        [strongSelf goToBindingPhoneNumber];
      }
    }
  };
  callback.onFailed = ^() {
    AwardsSetUpView *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.awardsSwitch setOn:NO animated:YES];
    }
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *exc){
    AwardsSetUpView *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.awardsSwitch setOn:NO animated:YES];
      if (obj.message) {
        [NewShowLabel setMessageContent:obj.message];
      }else{
        [NewShowLabel showNoNetworkTip];
      }
    }
  };
  [GetUserBandPhoneNumber checkUserBindPhonerWithCallback:callback];
}


/** 没有手机号 */
- (void)goToBindingPhoneNumber {
  [WeiboToolTip showMakeSureWithTitle:@"有奖比赛"
      largeContent:@"创" @"建" @"有"
      @"奖比赛为保证优顾客服与您联系,请您先绑定手" @"机。"
      lineSpacing:1.0f
      contentTopSpacing:15.0f
      contentBottomSpacing:20.0f
      sureButtonTitle:@"前往绑定"
      cancelButtonTitle:nil
      sureblock:^{
        //绑定
        NSString *titleStr = @"绑定手机";
        NSString *hintStr = @"绑" @"定"
            @"手机后，可以通过手机号登录和找回密码，提" @"高账" @"户"
            @"安全性。设置密码后可以通过手机号" @"与密码进行登" @"录。";
        CGRect frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN);
        PhoneRegisterViewController *bindPhoneVC =
            [[PhoneRegisterViewController alloc] initWithFrame:frame
                                                withTitleLabel:titleStr
                                                 withHintLabel:hintStr];
        [AppDelegate pushViewControllerFromRight:bindPhoneVC];
      }
      cancleblock:^{
      }];
}

- (void)endEdit {
  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
  [mainWindow endEditing:YES];
}

@end
