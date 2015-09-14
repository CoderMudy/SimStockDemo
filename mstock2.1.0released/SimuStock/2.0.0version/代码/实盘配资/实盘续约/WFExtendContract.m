//
//  WFExtendContract.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

@implementation WFExtendContract

+ (void)applyForWFProductWithHsUserId:(NSString *)hsUserId
                        andContractNo:(NSString *)contractNo
                            andProdId:(NSString *)prodId
                          andProdTerm:(NSString *)prodTerm
                     andOrderAbstract:(NSString *)orderAbstract
                           andPayType:(NSString *)payType
                       andTotalAmount:(NSString *)totalAmount
                          andCallback:(HttpRequestCallBack *)callback {
  NSString *url = [With_Capital_address
      stringByAppendingFormat:@"stockFinWeb/contract/extendContract"];

  NSDictionary *jsonDictionary = @{
    @"hsUserId" : hsUserId,
    @"contractNo" : contractNo,
    @"prodId" : prodId,
    @"prodTerm" : prodTerm,
    @"orderAbstract" : orderAbstract,
    @"payType" : payType,
    @"totalAmount" : totalAmount,
  };

  // NSJSONWritingPrettyPrinted: Pass 0 if you don't care about the readability
  // of the generated string
  NSError *error;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                     options:0
                                                       error:&error];

  if (!jsonData) {
    NSLog(@"Got an error: %@", error);
    return;
  }
  NSString *jsonString =
      [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

  NSDictionary *parameters = @{ @"json" : jsonString };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:parameters
              withRequestObjectClass:[ApplyForWFProductResult class]
             withHttpRequestCallBack:callback];
}

@end
