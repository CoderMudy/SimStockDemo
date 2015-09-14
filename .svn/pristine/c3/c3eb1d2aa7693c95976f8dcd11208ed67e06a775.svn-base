//
//  SimuStockRegisterView.m
//  SimuStock
//
//  Created by jhss on 14-7-7.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuStockRegisterView.h"
#import <ShareSDK/ShareSDK.h>
#import "SimuUtil.h"
#import "UIImage+ColorTransformToImage.h"
#import "UserLogonViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>

@implementation SimuStockRegisterView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self createRegisterViewContent];
  }
  return self;
}
- (void)createRegisterViewContent {
  //标题
  _titleLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(0, 0 + logon_edge_width, self.width,
                               logon_button_height)];
  _titleLabel.backgroundColor = [UIColor clearColor];
  _titleLabel.text = @"首次登录即送10万元模拟资金";
  _titleLabel.font = [UIFont boldSystemFontOfSize:17];
  _titleLabel.textColor = [Globle colorFromHexRGB:@"becfdb"];
  _titleLabel.textAlignment = NSTextAlignmentCenter;
  [self addSubview:_titleLabel];
  // QQ账号按钮
  if ([TencentOAuth iphoneQQInstalled]) {
    [self createLogonButtonWithIcon:@"QQ_logo"
                          withTitle:@"QQ帐号登录"
                          withIndex:qq_logon_tag];
  }

  if ([WXApi isWXAppSupportApi]) { //[WXApi isWXAppInstalled]
    //微信账号按钮
    [self createLogonButtonWithIcon:@"微信_logo"
                          withTitle:@"微信帐号登录"
                          withIndex:weixin_logon_tag];
  }
  // sina账号
  [self createLogonButtonWithIcon:@"sina_logo.png"
                        withTitle:@"微博帐户登录"
                        withIndex:sinaWeibo_logon_tag];
  //手机号
  [self createLogonButtonWithIcon:@"phoneNumberIcon"
                        withTitle:@"手机号/用户名登录"
                        withIndex:phoneNumber_logon_tag];
}

- (void)refreshLogonButton {
}

- (void)createLogonButtonWithIcon:(NSString *)iconImage
                        withTitle:(NSString *)titleName
                        withIndex:(NSInteger)buttonIndex {
  //按钮白底
  UIView *whiteBackgroundView = [[UIView alloc]
      initWithFrame:CGRectMake((self.width - 190) / 2,
                               logon_edge_width + 22 + logon_button_height +
                                   (buttonIndex - 100) * (logon_button_height +
                                                          logon_button_space),
                               190, logon_button_height)];
  whiteBackgroundView.backgroundColor = [UIColor whiteColor];
  [whiteBackgroundView.layer
      setBorderColor:[Globle colorFromHexRGB:@"e2e2e2"].CGColor];
  [whiteBackgroundView.layer setBorderWidth:0.5];
  whiteBackgroundView.userInteractionEnabled = YES;
  [self addSubview:whiteBackgroundView];
  if (![WXApi isWXAppSupportApi] && buttonIndex > 100) {
    whiteBackgroundView.frame = CGRectMake(
        (self.width - 190) / 2,
        logon_edge_width + 22 + logon_button_height +
            (buttonIndex - 101) * (logon_button_height + logon_button_space),
        190, logon_button_height);
  }
  //表层按钮
  _logonButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _logonButton.tag = buttonIndex;
  _logonButton.frame = CGRectMake(0, 0, 190, logon_button_height);
  UIImage *highLightImage =
      [UIImage imageFromView:_logonButton
          withBackgroundColor:[Globle colorFromHexRGB:@"ababab"]];
  [_logonButton setBackgroundImage:highLightImage
                          forState:UIControlStateHighlighted];
  [_logonButton addTarget:self
                   action:@selector(selectLogonWay:)
         forControlEvents:UIControlEventTouchUpInside];
  [whiteBackgroundView addSubview:_logonButton];
  // icon
  UIImageView *iconImageView = [[UIImageView alloc] init];
  switch (buttonIndex) {
  case 100: {
    iconImageView.frame = CGRectMake(10, 5, 22, 25);
  } break;
  case 101: {
    iconImageView.frame = CGRectMake(8, 5, 26, 25);
  } break;
  case 102: {
    iconImageView.frame = CGRectMake(8, 5, 26, 25);
  } break;
  case 103: {
    iconImageView.frame = CGRectMake(12, 5, 18, 25);
  } break;
  default:
    break;
  }
  iconImageView.image = [UIImage imageNamed:iconImage];
  iconImageView.contentMode = UIViewContentModeScaleToFill;
  [whiteBackgroundView addSubview:iconImageView];
  // title
  UILabel *logonSortNameLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 170,
                                                logon_button_height)];
  logonSortNameLabel.textAlignment = NSTextAlignmentCenter;
  logonSortNameLabel.font = [UIFont systemFontOfSize:15];
  logonSortNameLabel.backgroundColor = [UIColor clearColor];
  logonSortNameLabel.text = titleName;
  logonSortNameLabel.textColor = [Globle colorFromHexRGB:Color_Red];
  [whiteBackgroundView addSubview:logonSortNameLabel];
}

/**区分登录来源*/
- (void)logonEntranceType {
  /**来自于主页 1 */
  /**来自于其他页面 2 */
  NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
  [myUser setInteger:_isOtherLogin forKey:@"isOtherLogin"];
  [myUser synchronize];
}

- (void)selectLogonWay:(UIButton *)button {
  //登录位置
  [self logonEntranceType];
  [button setBackgroundColor:[UIColor clearColor]];
  thirdWayLogon = [[ThirdWayLogon alloc] init];
  switch (button.tag) {
  case qq_logon_tag: {
    [thirdWayLogon getAuthWithShareType:ShareTypeQQSpace];
  } break;
  case weixin_logon_tag: {
    [thirdWayLogon getAuthWithShareType:ShareTypeWeixiSession];
  } break;
  case sinaWeibo_logon_tag: {
    [thirdWayLogon getAuthWithShareType:ShareTypeSinaWeibo];
  } break;
  case phoneNumber_logon_tag: {
    [AppDelegate
        pushViewControllerFromRight:[[UserLogonViewController alloc] init]];
  } break;
  default:
    break;
  }
}

@end
