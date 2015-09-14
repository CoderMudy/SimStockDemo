//
//  CowThanBearData.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CowThanBearData.h"

@implementation CowThanBearData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  self.dataArray = [[NSMutableArray alloc] init];

  NSArray *list = dic[@"result"][@"list"];

  [list enumerateObjectsUsingBlock:^(NSDictionary *subDic, NSUInteger idx,
                                     BOOL *stop) {
    CowThanBearDataItem *item =
        [[CowThanBearDataItem alloc] initWithDic:subDic];
    [self.dataArray addObject:item];
  }];
}

+ (void)requsetCowThanBearData:(HttpRequestCallBack *)callback {
  NSString *url =
      [adData_address stringByAppendingString:@"asteroid/vote/cowThanBear"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[CowThanBearData class]
             withHttpRequestCallBack:callback];
}

@end

@implementation CowThanBearDataItem

- (instancetype)initWithDic:(NSDictionary *)dic {
  [self setValuesForKeysWithDictionary:dic];
  return self;
}

@end
