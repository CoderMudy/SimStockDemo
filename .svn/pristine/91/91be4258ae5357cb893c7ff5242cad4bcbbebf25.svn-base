//
//  SimuShowUserHeadData.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuShowUserHeadData.h"
#import "JsonFormatRequester.h"

@implementation SimuShowUserHeadData

- (void)jsonToObject:(NSDictionary *)dic
{
    [super jsonToObject:dic];
    
    //得到用户的昵称和头像
    NSString * obj=dic[@"headpic"];
    if([obj isKindOfClass:[NSNull class]])
    {
        obj=@"";
    }
    self.headpicUrl=obj;
    self.nickname=dic[@"nickname"];
    self.sex=dic[@"sex"];

}

+ (void)requestSimuShowUserHeadDataWithCallback:(HttpRequestCallBack *)callback
{
    NSString *url = [user_address stringByAppendingString:@"/jhss/member/showuserhead/{ak}/{sid}/{userid}"];
    
    JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
    [request asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[SimuShowUserHeadData class]
               withHttpRequestCallBack:callback];
    
}

@end
