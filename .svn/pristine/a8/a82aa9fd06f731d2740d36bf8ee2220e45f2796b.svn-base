//
//  WFBankInfoData.m
//  SimuStock
//
//  Created by moulin wang on 15/4/21.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

@implementation WFBankData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[DataArray alloc] init];
  NSArray *bankList = dic[@"bankList"];
  for (NSDictionary *bankDic in bankList) {
    WFBankData *bankData = [[WFBankData alloc] init];
    bankData.bankName = bankDic[@"bankName"];
    bankData.bankLogo = bankDic[@"bankLogo"];
    bankData.bankNameAbbr = bankDic[@"bankNameAbbr"];
    bankData.bankID = [@([bankDic[@"bankId"] intValue]) stringValue];
    bankData.bankNameChar = bankDic[@"bankNameAbbr"];
    [self.dataArray.array addObject:bankData];
  }
}

@end

@implementation WFBankInfoData


+ (void)requestBankInfoWithCallbackWithType:(NSString *)type
                               withCallback:(HttpRequestCallBack *)callback {
  // NSString *url = [NSString
  // stringWithFormat:@"%@asteroid/bank/findBank?type={type}",adData_address];
  NSString *url =
      @"http://192.168.1.25:30588/asteroid/bank/findBank?type={type}";
  NSDictionary *dic = @{ @"type" : type };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[WFBankData class]
             withHttpRequestCallBack:callback];
}

@end
