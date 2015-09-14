//
//  FeedbackListWrapper.m
//  SimuStock
//
//  Created by moulin wang on 14-11-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

/**类说明（设置－意见反馈）*/
#import "FeedbackListWrapper.h"
#import "JsonFormatRequester.h"

@implementation FeedbackListWrapper
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];
  NSArray *array = dic[@"result"];
  for (NSDictionary *subDict in array) {
    //拼接数据放在数组中
    NSString *aStr = subDict[@"a"];
    NSString *qStr = subDict[@"q"];
    NSString *aTimeStr = subDict[@"atime"];
    NSString *qTimeStr = subDict[@"qtime"];
    NSString *string =
        [NSString stringWithFormat:@"%@#%@#%@#%@#%@", aStr, subDict[@"headpic"],
                                   qStr, aTimeStr, qTimeStr];
    [self.dataArray addObject:string];
  }
}
+ (void)requestFeedbackListWithCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [user_address stringByAppendingString:
                        @"jhss/member/showfeedbacklist/{ak}/{sid}/{userid}"];

  NSDictionary *dic = @{
    @"ak" : [SimuUtil getAK],
    @"sid" : [SimuUtil getSesionID],
    @"userid" : [SimuUtil getUserID]
  };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[FeedbackListWrapper class]
             withHttpRequestCallBack:callback];
}
@end
