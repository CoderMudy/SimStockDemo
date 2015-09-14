//
//  WFFinancialDetailsData.m
//  SimuStock
//
//  Created by moulin wang on 15/4/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFFinancialDetailsData.h"

@implementation WFAccountInfoData

-(void)jsonToDict:(NSDictionary *)dic
{
  
}

@end


@implementation WFfinancialDetailsModeData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  //解析
  NSDictionary *resultDic = dic[@"result"];
  NSDictionary *accountDic = resultDic[@"account"];
  if (accountDic.count != 0 || accountDic) {
   //账户信息 暂不处理
  }
  NSArray *cash_flow_list = resultDic[@"cash_flow_list"];
  if (cash_flow_list.count == 0 || cash_flow_list == nil) {
    return;
  }
  self.array = [[NSMutableArray alloc] init];
  for (NSDictionary *subDic in cash_flow_list) {
    WFfinancialDetailsModeData *mode = [[WFfinancialDetailsModeData alloc] init];
    mode.accountBalance = subDic[@"accountBalance"];
    mode.flowAmount = [@([subDic[@"flowAmount"] intValue]) stringValue];
    mode.flowDatetime = subDic[@"flowDatetime"];
    mode.flowDesc = subDic[@"flowDesc"];
    mode.flowType = subDic[@"flowType"];
    mode.youguuID = [subDic[@"youguuId"] intValue];
    [self.array addObject:mode];
  }
  
}

@end

@implementation WFFinancialDetailsData

+ (void)requestFinancialDetailsModeData:(NSString *)fromld
                           withPageSize:(NSString *)pageSize
                           withCallbacl:(HttpRequestCallBack *)callback {
  NSString *url =
      [NSString stringWithFormat:
                    @"%@account/cash_flow?fromld={fromld}&pageSize={pageSize}",
                    WF_Payment_Address];
  NSDictionary *dic = @{ @"fromld" : fromld, @"pageSize" : pageSize };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[WFfinancialDetailsModeData class]
             withHttpRequestCallBack:callback];
}

@end
