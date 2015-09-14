//
//  MarketHomeWrapper.m
//  SimuStock
//
//  Created by Mac on 14-11-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MarketHomeWrapper.h"
#import "PacketCompressPointFormatRequester.h"

@implementation MarketHomeWrapper

- (void)packetCompressPointToObject:(NSMutableArray *)tableDataArray {
  self.dataArray = [[NSMutableArray alloc] initWithArray:tableDataArray];
}

-(NSArray*) getArray{
  return self.dataArray;
}

+ (void)requestMarketHomeWithCallback:(HttpRequestCallBack *)callback {
  PacketCompressPointFormatRequester *requester =
      [[PacketCompressPointFormatRequester alloc] init];
  NSString *url =
      [market_address stringByAppendingString:@"quote/stocklist2/home3"];

  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[MarketHomeWrapper class]
               withHttpRequestCallBack:callback];
}

@end
