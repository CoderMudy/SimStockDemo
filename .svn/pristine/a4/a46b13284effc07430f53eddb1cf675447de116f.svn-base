//
//  MyInfomationItem.m
//  SimuStock
//
//  Created by jhss on 13-10-11.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "MyInfomationItem.h"
#import "JsonFormatRequester.h"

@implementation BindStatus

- (void)jsonToObject:(NSDictionary *)subDict {
  self.type = [subDict[@"type"] integerValue];
  self.openId = subDict[@"openid"];
  self.thirdNickname = [SimuUtil changeIDtoStr:subDict[@"thirdNickname"]];
  self.token = subDict[@"token"];
}

@end

@implementation MyInfomationItem

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.mHeadPic = dic[@"headpic"] ? dic[@"headpic"] : @"";
  self.mMethod = dic[@"method"];
  self.mNickName = dic[@"nickname"];
  self.mSex = dic[@"sex"];
  self.mSignature = dic[@"signature"];

  self.mStyle = dic[@"style"];
  self.mUserID = [SimuUtil changeIDtoStr:dic[@"userid"]];
  self.mUserName = dic[@"username"];

  self.mPhoneNumber = dic[@"phone"] ? dic[@"phone"] : @"";
  self.mInviteCode = [SimuUtil changeIDtoStr:dic[@"inviteCode"]];
  self.rating = dic[@"rating"];
  self.vipType = (UserVipType)[dic[@"vipType"] intValue];

  self.stockFirmFlag = [SimuUtil changeIDtoStr:dic[@"stockFirmFlag"]];

  [SimuUtil setUserVipType:[@(self.vipType) stringValue]];
  [SimuUtil setStockFirmFlag:self.stockFirmFlag];
  [SimuUtil setUserImageURL:self.mHeadPic];
  [SimuUtil setUserNiceName:self.mNickName];
  [SimuUtil setUserName:self.mUserName];

  //绑定关系
  self.bindDictionary = [[NSMutableDictionary alloc] init];
  NSArray *bindArray = dic[@"bindArray"];
  for (NSMutableDictionary *subDict in bindArray) {
    BindStatus *bindStatus = [[BindStatus alloc] init];
    [bindStatus jsonToObject:subDict];
    self.bindDictionary[@(bindStatus.type)] = bindStatus;
  }
}

- (NSDictionary *)mappingDictionary {
  return @{
    @"bindDictionary" : @{
      NSStringFromClass([NSNumber class]) :
          NSStringFromClass([BindStatus class])
    }
  };
}

/** 是否可以解绑微信 */
- (BOOL)canUnbindWeixin {
  return _bindDictionary[@(UserBindTypeWeixinRegister)] != nil;
}

/** 是否可以解绑QQ */
- (BOOL)canUnbindQQ {
  return _bindDictionary[@(UserBindTypeQQ)] != nil;
}

/** 是否可以解绑新浪微博 */
- (BOOL)canUnbindSinaWeibo {
  return _bindDictionary[@(UserBindTypeSinaWeibo)] != nil;
}

+ (void)requestMyInfomationWithCallBack:(HttpRequestCallBack *)callback {

  NSString *url = [user_address
      stringByAppendingString:@"jhss/member/showmyinfo/{ak}/{sid}/{userid}"];

  NSDictionary *dic = @{ @"userid" : [SimuUtil getUserID] };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[MyInfomationItem class]
             withHttpRequestCallBack:callback];
}
@end

@implementation ThirdPartLogon

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  //保存用户名和密码
  [SimuUtil setUserPassword:dic[@"password"]];
  [SimuUtil setUserName:dic[@"username"]];
  //初始化用户数据
  [SimuUtil setUserID:[SimuUtil changeIDtoStr:dic[@"userid"]]];
  [SimuUtil setSesionID:[SimuUtil changeIDtoStr:dic[@"sessionid"]]];
  [SimuUtil setUserName:dic[@"username"]];
  [SimuUtil setUserNiceName:dic[@"nickname"]];
  [SimuUtil setUserSignature:dic[@"signature"]];
  NSString *headpic = dic[@"headpic"];
  if (!headpic) {
    headpic = @"";
  }
  [SimuUtil setUserImageURL:headpic];
}

+ (void)logonDoThirdPartAuthWithUid:(NSString *)uid
                      withLogonType:(NSString *)logonType
                          withToken:(NSString *)token
                       withCallback:(HttpRequestCallBack *)callback {
  NSString *thirdPartAutoLogonUrl = user_address;
  thirdPartAutoLogonUrl = [thirdPartAutoLogonUrl
      stringByAppendingString:@"jhss/member/doThirdPartAuth/"];
  thirdPartAutoLogonUrl = [thirdPartAutoLogonUrl
      stringByAppendingFormat:@"%@/%@/%@/%@", [SimuUtil getAK], uid, logonType,
                              token];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:thirdPartAutoLogonUrl
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[ThirdPartLogon class]
             withHttpRequestCallBack:callback];
}
@end
