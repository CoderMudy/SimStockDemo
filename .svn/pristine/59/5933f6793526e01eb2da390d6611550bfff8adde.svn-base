//
//  ThirdBindingResult.m
//  SimuStock
//
//  Created by jhss on 14-11-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ThirdBindingResult.h"
#import "JsonFormatRequester.h"
#import "UserInformationItem.h"

@implementation ThirdBindingResult

- (void)jsonToObject:(NSDictionary *)obj {
  [super jsonToObject:obj];
  //三方登录绑定已有账号
  NSString *status = obj[@"status"];
  if ([status isEqualToString:@"0000"]) {

    UserInformationItem *item = [[UserInformationItem alloc] init];
    NSString *headImageUrl = obj[@"headpic"];
    if (headImageUrl) {
      [SimuUtil setUserImageURL:headImageUrl];
    }

    //保存用户名和密码
    [SimuUtil setUserName:obj[@"username"]];
    [SimuUtil setUserPassword:obj[@"password"]];

    //初始化用户数据
    [SimuUtil setUserID:[SimuUtil changeIDtoStr:obj[@"userid"]]];

    item.mUserID = [SimuUtil getUserID];
    [SimuUtil setSesionID:obj[@"sessionid"]];
    [SimuUtil setUserName:obj[@"username"]];
    [SimuUtil setUserNiceName:obj[@"nickname"]];
    [SimuUtil setUserSignature:obj[@"signature"]];
  }
}

+ (void)registerOfThirdPartWithOpenId:(NSString *)openId
                        withLogonType:(NSString *)logonType
                      withNewNickName:(NSString *)newNickName
                      withOldNickName:(NSString *)oldNickName
                        withHeadImage:(NSString *)headImage
                       withInviteCode:(NSString *)inviteCode
                         withCallBack:(HttpRequestCallBack *)callback {
  //获取分辨率
  //屏幕尺寸
  CGRect rect = [[UIScreen mainScreen] bounds];
  CGSize size = rect.size;
  CGFloat width = size.width;
  CGFloat height = size.height;
  //分辨率
  CGFloat scale_screen = [UIScreen mainScreen].scale;
  NSString *scaleScreenStr =
      [NSString stringWithFormat:@"%1.0fX%1.0f", width * scale_screen,
                                 height * scale_screen];
  NSString *systemNameStr = [[[UIDevice currentDevice] systemName]
      stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSString *bindNewIDUrl = user_address;
  bindNewIDUrl = [bindNewIDUrl
      stringByAppendingString:@"jhss/member/bindRandomAccount/{ak}/{openid}/"
      @"{logontype}/{newnickname}/{uuid}/{model}/"
      @"{screen}/{systemname}/{networktype}/" @"{checkcarrier}/"
      @"{headimage}?thirdNickname={oldnickname}&" @"inviteCode={invitecode}"];
  NSString *ak = [SimuUtil getAK];
  NSString *uuid = [SimuUtil getUUID];
  NSString *model =
      [CommonFunc base64StringFromText:[[UIDevice currentDevice] model]];
  NSString *networkType = [SimuUtil getNetWorkType];
  NSString *checkCarrier =
      [CommonFunc base64StringFromText:[SimuUtil checkCarrier]];
  newNickName = [CommonFunc base64StringFromText:newNickName];
  headImage = [CommonFunc base64StringFromText:headImage];
  oldNickName = [CommonFunc base64StringFromText:oldNickName];
  NSDictionary *dict = @{
    @"ak" : ak,
    @"openid" : openId,
    @"logontype" : logonType,
    @"newnickname" : newNickName,
    @"uuid" : uuid,
    @"model" : model,
    @"screen" : scaleScreenStr,
    @"systemname" : systemNameStr,
    @"networktype" : networkType,
    @"checkcarrier" : checkCarrier,
    @"headimage" : headImage,
    @"oldnickname" : oldNickName,
    @"invitecode" : inviteCode
  };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:bindNewIDUrl
                   WithRequestMethod:@"GET"
               withRequestParameters:dict
              withRequestObjectClass:[ThirdBindingResult class]
             withHttpRequestCallBack:callback];
}
@end
