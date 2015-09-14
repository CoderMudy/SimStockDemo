//
//  UserDataModel.m
//  SimuStock
//
//  Created by Mac on 14-11-4.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "UserDataModel.h"

#import "JsonFormatRequester.h"

@implementation UserDataModel

+ (void)resetPasswordWithPhoneNum:(NSString *)phoneNum
                       withPassword:(NSString *)password
                      withCallback:(HttpRequestCallBack *)callback {
  
  
  NSString *url = [user_address
                   stringByAppendingString:
                   @"jhss/member/doRetrievePwd/{phone}/{password}"];
  
  NSDictionary *dic = @{ @"phone" : phoneNum, @"password" : password };
  
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[UserDataModel class]
             withHttpRequestCallBack:callback];
}

+ (void)authSessionWithCallback:(HttpRequestCallBack *)callback{
  NSString *url = [user_address
                   stringByAppendingString:
                   @"jhss/member/authSession/{ak}/{sessionid}/{userid}"];
  
  NSDictionary *dic = @{ @"sessionid" : [SimuUtil getSesionID],
                         @"userid" : [SimuUtil getUserID] };
  
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[UserDataModel class]
             withHttpRequestCallBack:callback];
}

@end
