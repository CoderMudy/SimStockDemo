//
//  GoldCoinNumData.m
//  SimuStock
//
//  Created by jhss_wyz on 15/8/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "GoldCoinNumData.h"
#import "JsonFormatRequester.h"
#import "CommonFunc.h"

@implementation GoldCoinNumData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.uid = dic[@"uid"];
  self.coinBalance = dic[@"coinBalance"];
  self.headpic = dic[@"headpic"];
}

+ (void)requestGoldCoinNumWithCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [game_address stringByAppendingString:@"game/hall/coinbalance"];
  url = [NSString
      stringWithFormat:@"%@/%@/%@", url,
                       [CommonFunc base64StringFromText:[SimuUtil getAK]],
                       [CommonFunc base64StringFromText:[SimuUtil getUserID]]];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[GoldCoinNumData class]
             withHttpRequestCallBack:callback];
}

@end
