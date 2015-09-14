//
//  ChangeUserInfoRequest.m
//  SimuStock
//
//  Created by jhss on 14-8-2.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ChangeUserInfoRequest.h"
#import "JsonFormatRequester.h"

@implementation CustomeAvatarRequestObject

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.headpic = dic[@"headpic"];
}

@end

@implementation ChangeUserInfoRequest

//修改和签名
+ (void)changeNickname:(NSString *)newNickname
           withNewSignature:(NSString *)newSignature
                 withSyspic:(NSString *)syspicUrl
                withPicFile:(JhssPostData *)picFile
    withHttpRequestCallBack:(HttpRequestCallBack *)callback {
  if (newNickname && newSignature && syspicUrl && picFile)
    return;

  NSMutableDictionary *dicionary = [[NSMutableDictionary alloc] init];
  // base64截取
  NSString *inHeadImage =
      syspicUrl ? syspicUrl
                : [CommonFunc base64StringFromText:[SimuUtil getUserImageURL]];
  if ([inHeadImage hasPrefix:@"~"]) {
    inHeadImage = [CommonFunc textFromBase64String:inHeadImage];
  }

  NSString *inSignature =
      newSignature
          ? [CommonFunc base64StringFromText:newSignature]
          : [CommonFunc base64StringFromText:[SimuUtil getUserSignature]];
  NSString *inNickname =
      newNickname
          ? [CommonFunc base64StringFromText:newNickname]
          : [CommonFunc base64StringFromText:[SimuUtil getUserNickName]];

  dicionary[@"sex"] = @"0";
  dicionary[@"nickname"] = inNickname;
  dicionary[@"userid"] = [SimuUtil getUserID];
  dicionary[@"signature"] = inSignature;
  if (picFile) {
    dicionary[@"pic"] = picFile;
  } else {
    dicionary[@"syspic"] = inHeadImage;
  }

  NSString *url = [user_address
      stringByAppendingString:@"jhss/member/uploaduserpic/{ak}/{sid}"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST_M"
               withRequestParameters:dicionary
              withRequestObjectClass:[CustomeAvatarRequestObject class]
             withHttpRequestCallBack:callback];
}

@end
