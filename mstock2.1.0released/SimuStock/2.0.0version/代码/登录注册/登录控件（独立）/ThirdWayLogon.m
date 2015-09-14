//
//  ThirdWayLogon.m
//  SimuStock
//
//  Created by jhss on 14-7-7.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ThirdWayLogon.h"
#import <ShareSDK/ShareSDK.h>
#import "SimuUtil.h"
#import "NetLoadingWaitView.h"

#import "NewShowLabel.h"

@implementation ThirdWayLogon
@synthesize delegate;

#pragma mark-------三方授权过程-------
- (void)getAuthWithShareType:(NSInteger)shareType {
  NSLog(@"getAuth");
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  //开始授权
  AppDelegate *_appDelegate =
      (AppDelegate *)[UIApplication sharedApplication].delegate;
  //三方类型
  ShareType type = (ShareType)shareType;
  id<ISSAuthOptions> authOptions =
      [ShareSDK authOptionsWithAutoAuth:YES
                          allowCallback:NO
                                 scopes:nil
                          powerByHidden:YES
                         followAccounts:nil
                          authViewStyle:SSAuthViewStyleFullScreenPopup
                           viewDelegate:_appDelegate.jhssViewDelegate
                authManagerViewDelegate:_appDelegate.jhssViewDelegate];
  //隐藏sharesdk标识
  [authOptions setPowerByHidden:YES];
  [self getAuthInfo:type withAuthOptions:authOptions];
}
#pragma mark----授权页自定义导航栏-----

//获取用户信息
- (void)getAuthInfo:(NSInteger)shareType
    withAuthOptions:(id<ISSAuthOptions>)authOptions {
  [ShareSDK cancelAuthWithType:(ShareType)shareType];
  [ShareSDK
      getUserInfoWithType:(ShareType)shareType
              authOptions:authOptions
                   result:^(BOOL result, id<ISSPlatformUser> userInfo,
                            id<ICMErrorInfo> error) {
                       if (result) {
                         [NetLoadingWaitView startAnimating];

                         if (shareType == ShareTypeSinaWeibo) {
                           //新浪微博
                           [self fillSinaWeiboUser:userInfo];
                         }
                         if (shareType == ShareTypeWeixiSession) {
                           //微信
                           [self fillWeiXinUser:userInfo];
                         }
                         if (shareType == ShareTypeQQSpace) {
                           //腾讯微博
                           [self fillTecentWeiboUser:userInfo];
                         }
                       } else {
                         if ([NetLoadingWaitView isAnimating]) {
                           [NetLoadingWaitView stopAnimating];
                         }
                         if ([error errorCode] == 20003) {
                           //账号被封
                           [NewShowLabel setMessageContent:@"您"
                                         @"的帐号存在异常，暂时无法"
                                         @"访问。"];
                         } else
                           [NewShowLabel
                               setMessageContent:error.errorDescription];
                       }
                   }];
}
- (NSString *)updateUserInfoValue:(NSString *)keyName
                     withUserInfo:(id<ISSPlatformUser>)userInfo {
  id value = [userInfo sourceData][keyName];
  if (![value isKindOfClass:[NSString class]]) {
    if ([value respondsToSelector:@selector(stringValue)]) {
      value = [value stringValue];
    } else {
      value = @"";
    }
  }
  return value;
}
#pragma mark
#pragma mark-------------------获取sina，QQ信息函数--------------------------
- (void)fillTecentWeiboUser:(id<ISSPlatformUser>)userInfo {

  NSDictionary *dic = [userInfo sourceData];
  NSString *nickname = dic[@"nickname"];
  NSString *uid = [[userInfo credential] uid];
  NSString *largeAvatarUrl = dic[@"figureurl_qq_2"];
  NSString *token = [[userInfo credential] token];

  if (self.delegate) {
    [self.delegate rowThirdPartWithToken:token
                              withOpenId:uid
                            withNickName:nickname
                                withType:UserBindTypeBindQQ2Exist];
  } else
    //三方登录
    [self thirdPartRegister:uid
               withNickName:nickname
              withHeadImage:largeAvatarUrl
              withShareType:ShareTypeQQSpace
                  withToken:token
         withThirdPartImage:@"QQlogo"
                  withTitle:@"腾讯QQ"];
}
- (void)fillWeiXinUser:(id<ISSPlatformUser>)userInfo {
  NSDictionary *dic = [userInfo sourceData];
  NSString *nickname = dic[@"nickname"];

  NSString *largeAvatarUrl = dic[@"headimgurl"];
  NSString *token = [[userInfo credential] token];

  if (self.delegate) {
    //个人信息页_三方绑定
    
    NSString *uid = [[userInfo credential] uid];
    [self.delegate rowThirdPartWithToken:token
                              withOpenId:uid
                            withNickName:nickname
                                withType:UserBindTypeBindWeixin2Exist];
  } else {
    NSString *uid = [NSString stringWithFormat:@"%@", dic[@"openid"]];
    [self thirdPartRegister:uid
               withNickName:nickname
              withHeadImage:largeAvatarUrl
              withShareType:ShareTypeWeixiSession
                  withToken:token
         withThirdPartImage:@"微信LOGO"
                  withTitle:@"微信"];
  }
}
- (void)fillSinaWeiboUser:(id<ISSPlatformUser>)userInfo {
  NSDictionary *dic = [userInfo sourceData];
  NSString *nickname = dic[@"screen_name"];
  NSString *largeAvatarUrl = dic[@"avatar_large"];
  NSString *token = [[userInfo credential] token];

  if (self.delegate) {
    //个人信息页_三方绑定
    
    NSString *uid = [[userInfo credential] uid];
    [self.delegate rowThirdPartWithToken:token
                              withOpenId:uid
                            withNickName:nickname
                                withType:UserBindTypeBindSinaWeibo2Exist];
  } else {
    NSString *uid = [NSString stringWithFormat:@"%@", dic[@"id"]];
    [self thirdPartRegister:uid
               withNickName:nickname
              withHeadImage:largeAvatarUrl
              withShareType:ShareTypeSinaWeibo
                  withToken:token
         withThirdPartImage:@"新浪LOGO"
                  withTitle:@"新浪微博"];
  }
}
//切换界面
- (void)thirdPartRegister:(NSString *)uid
             withNickName:(NSString *)nickName
            withHeadImage:(NSString *)headImage
            withShareType:(NSInteger)shareType
                withToken:(NSString *)token
       withThirdPartImage:(NSString *)thirdPartImage
                withTitle:(NSString *)titleName {
  // temp
  tempUid = uid;
  tempNickName = nickName;
  tempHeadImage = headImage;
  tempThirdPartImage = thirdPartImage;
  tempTitleName = titleName;
  tempShareType = shareType;

  NSString *logonType = nil;
  //已绑定状态保存到数据库
  switch (shareType) {
  case ShareTypeSinaWeibo: {
    logonType = @"3";
  } break;
  case ShareTypeQQSpace: {
    logonType = @"2";
  } break;
  case ShareTypeWeixiSession: {
    logonType = @"7";
  } break;
  default:
    break;
  }
  //三方登录操作
  logonDataParsing = [[LogonDataParsingClass alloc] init];
  [logonDataParsing logonDataMessagePassingWithUid:tempUid
                                      withNickName:tempNickName
                               withThirdLogonImage:tempHeadImage
                                     withTitleName:tempTitleName
                             withThirdWayIconImage:tempThirdPartImage
                                     withShareType:tempShareType];
  [logonDataParsing thirdPartAutoLogon:uid
                         withLogonType:logonType
                             withToken:token];
}
@end
