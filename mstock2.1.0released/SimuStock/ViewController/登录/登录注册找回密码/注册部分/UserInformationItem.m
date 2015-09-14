//
//  UserInformationItem.m
//  SimuStock
//
//  Created by jhss on 13-10-8.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "UserInformationItem.h"

#import "JsonFormatRequester.h"

@implementation LoginInfo

- (void)jsonToObject:(NSDictionary *)dic {
  self.sessionId = dic[@"sessionid"];
  self.userName = dic[@"username"];
  self.certifySignature = dic[@"certifySignature"];
  self.userInfo = [[UserListItem alloc] init];
  [self.userInfo jsonToObject:dic];
}

@end

@implementation UserInformationItem

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  //为二次登录提供数据
  self.mNickName = dic[@"nickname"];
  self.mUserName = dic[@"username"];
  self.mSessionID = dic[@"sessionid"];

  [SimuUtil setUserID:[SimuUtil changeIDtoStr:dic[@"userid"]]];

  self.mStatus = dic[@"status"];
  self.mUserID = [SimuUtil getUserID];
  self.mHeadImage = dic[@"headpic"] ? dic[@"headpic"] : @"";
  self.mstockFirmFlag = [SimuUtil changeIDtoStr:dic[@"stockFirmFlag"]];

  [SimuUtil setUserVipType:dic[@"vipType"]];
  [SimuUtil setStockFirmFlag:self.mstockFirmFlag];
  [SimuUtil setUserImageURL:self.mHeadImage];
  [SimuUtil setSesionID:self.mSessionID];
  [SimuUtil setUserNiceName:self.mNickName];
  [SimuUtil setUserName:self.mUserName];
  [SimuUtil setUserSignature:dic[@"signature"] ? dic[@"signature"] : @""];
}

+ (void)requestLoginWithUserName:(NSString *)userName
                    withPassword:(NSString *)password
                    withCallback:(HttpRequestCallBack *)callback {

  NSString *url =
      [user_address stringByAppendingString:
                        @"jhss/member/dologonnew/{ak}/{username}/{userpwd}"];

  NSDictionary *dic = @{
    @"username" : [CommonFunc base64StringFromText:userName],
    @"userpwd" : [CommonFunc
        base64StringFromText:
            [password
                stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[UserInformationItem class]
             withHttpRequestCallBack:callback];
}

@end
