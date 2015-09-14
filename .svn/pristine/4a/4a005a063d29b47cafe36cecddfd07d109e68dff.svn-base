//
//  CattleVSBearUserVoteData.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CowThanBearUserVoteData.h"

@implementation CowThanBearUserVoteData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

+ (void)requestCattleVSBearUserVoteData:(NSString *)voteFlag
                           withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [adData_address
      stringByAppendingFormat:@"asteroid/vote/userVote?voteflag=%@", voteFlag];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[CowThanBearUserVoteData class]
             withHttpRequestCallBack:callback];
}

@end
