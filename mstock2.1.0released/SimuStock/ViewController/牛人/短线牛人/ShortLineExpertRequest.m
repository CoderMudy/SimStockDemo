//
//  ShortLineExpertRequest.m
//  SimuStock
//
//  Created by Jhss on 15/5/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

@implementation ShortLineExpertDataModel

- (void)jsonToObject:(NSDictionary *)dic {
  if (dic[@"result"] == nil) {
    return;
  }
  NSDictionary *resultDic = dic[@"result"];
  self.rankList = [NSMutableArray array];
  NSMutableArray *newRankArr = [NSMutableArray array];
  [resultDic[@"rankList"] enumerateObjectsUsingBlock:^(NSDictionary *obj,
                                                             NSUInteger idx,
                                                             BOOL *stop) {
    RankListDataModel *rankLisData = [RankListDataModel rankListDataWithDictionary:obj];
    [newRankArr addObject:rankLisData];
  }];
  self.rankList = newRankArr;
}
- (NSArray *)getArray {
  return _rankList;
}

@end

@implementation RankListDataModel

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
  if (self = [super init]) {
     self.fansCount = [dic[@"fansCount"] stringValue];
     self.istockCount = [dic[@"istockCount"] stringValue];
     self.positionCount = [dic[@"positionCount"] stringValue];
     self.profit = [dic[@"profit"] stringValue];
     self.profitRate = [dic[@"profitRate"] stringValue];
     self.rank = [dic[@"rank"] stringValue];
     self.successRate = [dic[@"successRate"] stringValue];
     self.tradeCount = [dic[@"tradeCount"] stringValue];
     self.uid = [dic[@"uid"] stringValue];
    
  }
  return self;
}
+ (instancetype)rankListDataWithDictionary:(NSDictionary *)dic {
  return [[[self class] alloc] initWithDictionary:dic];
}

@end



@implementation ShortLineExpertRequest

+ (void)conductShortLineExpertRequestWithReqNum:(NSString *)reqNum WithFromId:(NSString *)fromId  WithCallback:(HttpRequestCallBack *)callback {
  NSString *url =
  [NSString stringWithFormat:@"http://192.168.1.28:30180/youguu/newRank/shortLine?reqNum=%@&fromId=%@", reqNum,fromId];
  
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[ShortLineExpertDataModel class]
             withHttpRequestCallBack:callback];
}
@end
