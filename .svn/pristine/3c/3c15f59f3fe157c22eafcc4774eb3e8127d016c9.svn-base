//
//  WithFundingUser.m
//  SimuStock
//
//  Created by Mac on 15/4/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#pragma mark 是否存在配资账户响应结果
@implementation WFAccountAvailable

- (void)jsonToObject:(NSDictionary *)dic {
  self.available = [dic[@"data"] boolValue];
}

@end

#pragma mark 1.2申领融资账户响应结果
@implementation WFApplyForAccount

- (void)jsonToObject:(NSDictionary *)dic {
  self.userid = [dic[@"data"][@"userid"] string];
}

@end

#pragma mark 1.3查询融资账户信息响应结果
@implementation WFQueryFinancingAccountInfo

- (void)jsonToObject:(NSDictionary *)dic {
  self.userId = [dic[@"data"][@"userId"] string];
  self.accountStatus = [dic[@"data"][@"accountStatus"] string];
  self.accountAmount = [dic[@"data"][@"accountAmount"] string];
  self.freezeAmount = [dic[@"data"][@"freezeAmount"] string];
  self.currencyType = [dic[@"data"][@"currencyType"] string];
  self.createDatetime = [dic[@"data"][@"createDatetime"] string];
  self.updateDatetime = [dic[@"data"][@"updateDatetime"] string];
  self.remark = [dic[@"data"][@"remark"] string];
  self.mobile = [dic[@"data"][@"mobile"] string];
}

@end

#pragma mark 1.4划转资金的响应结果
@implementation WFFundsTransfer

- (void)jsonToObject:(NSDictionary *)dic {
  self.fundsTransfer = [dic[@"data"] boolValue];
}

@end

#pragma mark
#pragma mark 用户相关的调用

@implementation WithFundingUser

+ (void)checkWFAccountAvailableWithMoblie:(NSString *)mobile
                           withIdcardKind:(NSString *)idcardKind
                               withIdcard:(NSString *)idcard
                             withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [with_funding_address stringByAppendingFormat:@"api/pzapi"];
  NSDictionary *jsonDictionary = @{
    @"mobile" : mobile,
    @"idcardKind" : idcardKind,
    @"idcard" : idcard,
  };

  NSDictionary *parameters =
      [jsonDictionary transformJsonDicToParaDicWithCodeString:@"832001"];

  WithFundingRequester *request = [[WithFundingRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:parameters
              withRequestObjectClass:[WFAccountAvailable class]
             withHttpRequestCallBack:callback];
}





@end
