//
//  BaiDuPush.m
//  SimuStock
//
//  Created by jhss on 14-11-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaiDuPush.h"
#import "NSStringCategory.h"
@implementation BaiDuPushRequester

- (void)jsonToObject:(NSDictionary *)dic {
  
}
@end


@implementation BaiDuPush
+ (void)pushBindUserUseridWithBaiduUid:(NSString *)baiduUid
                      withBaiduChannel:(NSString *)baiduChannel
                          withCallback:(HttpRequestCallBack *)callback
{
  NSString *akString = [SimuUtil getAK];
  NSString *sessionIdString = [SimuUtil getSesionID];
  if(sessionIdString==nil || [sessionIdString length]< 3 )
    return;
  NSString *userID = [SimuUtil getUserID];
  if(userID==nil || [userID isEqualToString:@"-1"])
    return;
  NSString *uaString =[CommonFunc textFromBase64String:[[SimuUtil getDevicesModel] URLEncodedString]];
  NSString *networkString = [SimuUtil getNetWorkType];
  NSString *url = [NSString stringWithFormat:@"%@bind/pushuser/userrecode/binduser/%@/%@/%@/%@/%@/%@/%@",push_address, akString, sessionIdString, userID, baiduUid, baiduChannel ,uaString, networkString];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[BaiDuPush class]
             withHttpRequestCallBack:callback];
}

///绑定用户
+ (void)pushBindUserWithToken:(NSString *)token
                 withCallback:(HttpRequestCallBack *)callback
{
  NSString *akString = [SimuUtil getAK];
  NSString *userID = [SimuUtil getUserID];
  if(userID==nil || [userID isEqualToString:@"-1"])
    return;

  NSString *url = [NSString stringWithFormat:@"%@bind/pushuser/userrecode/bind?uid=%@&ak=%@&token=%@",push_address,userID, akString,token];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[BaiDuPushRequester class]
             withHttpRequestCallBack:callback];
}
///解绑用户
+ (void)pushDelBindUserWithCallback:(HttpRequestCallBack *)callback
{
  NSString *akString = [SimuUtil getAK];
  NSString *userID = [SimuUtil getUserID];
  if(userID==nil || [userID isEqualToString:@"-1"])
    return;
  
  NSString *url = [NSString stringWithFormat:@"%@bind/pushuser/userrecode/clearBind?ak=%@&uid=%@",push_address, akString,userID];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[BaiDuPushRequester class]
             withHttpRequestCallBack:callback];
}


@end
