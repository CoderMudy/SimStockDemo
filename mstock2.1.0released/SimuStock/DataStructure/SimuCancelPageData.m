//
//  SimuCancelPageData.m
//  SimuStock
//
//  Created by Mac on 13-8-15.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

@implementation SimuCancelElment

- (id)init {
  self = [super init];
  if (self != nil) {
    self.commissionid = nil;
    self.stockname = nil;
    self.stockcode = nil;
    self.price = nil;
    self.amount = nil;
    self.status = nil;
    self.time = nil;
    self.type = nil;
    self.tax = nil;
    self.charges = nil;
    self.money = nil;
  }
  return self;
}
- (void)dealloc {

  self.commissionid = nil;
  self.stockname = nil;
  self.stockcode = nil;
  self.price = nil;
  self.amount = nil;
  self.status = nil;
  self.time = nil;
  self.type = nil;
  self.tax = nil;
  self.charges = nil;
  self.money = nil;
  [super dealloc];
}

- (void)jsonToObject:(NSDictionary *)obj {
  self.commissionid = obj[@"commissionID"];
  self.stockname = obj[@"stockName"];
  self.stockcode = obj[@"stockCode"];
  self.price = obj[@"price"];
  self.amount = obj[@"amount"];
  self.status = obj[@"status"];
  self.time = obj[@"time"];
  self.type = obj[@"type"];
  self.tax = obj[@"yinhuashui"];
  self.charges = obj[@"yongjin"];
  CGFloat m_money = [self.price floatValue] * [self.amount intValue];
  self.money = [NSString stringWithFormat:@"%.2f", m_money];
}

@end

/************************************************************
 ************************* new class ************************
 ************************************************************
 */

@implementation SimuCancelPageData

- (void)jsonToObject:(NSDictionary *)dictionary {
  [super jsonToObject:dictionary];
  NSArray *dataarray = dictionary[@"result"];
  if (dataarray == nil)
    return;
  for (NSDictionary *obj in dataarray) {
    SimuCancelElment *elment = [[SimuCancelElment alloc] init];
    if (elment) {
      [elment jsonToObject:obj];
      [self.DataArray addObject:elment];
      [elment release];
    }
  }
}

- (id)init {
  self = [super init];
  if (self != nil) {
    //        self.pagetype=DataPageType_Simu_Cancellation;
    _DataArray = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc {

  [self.DataArray removeAllObjects];
  [_DataArray release];
  [super dealloc];
}

+ (void)queryTradeCancleInfoesByType:(NSString *)type
                         withMatchId:(NSString *)matchId
                       withPageIndex:(NSString*) page
                            FromTime:(NSString *)from_time
                             EndTime:(NSString *)end_time
                        withCallBack:(HttpRequestCallBack *)callback {
  NSMutableDictionary *parameters = [NSMutableDictionary new];
  parameters[@"matchid"] = matchId;
  parameters[@"type"] = type;
  parameters[@"page"] = page;
  parameters[@"size"] = @"30";
  NSString *m_startDate;
  NSString *m_endDate;

  if ([type isEqualToString:@"2"] == YES) {
    m_startDate = from_time ? from_time : @"2013-01-01";
    m_endDate = end_time ? end_time : @"2013-08-08";
  } else {
    m_startDate = @"0000-00-00";
    m_endDate = @"0000-00-00";
  }
  parameters[@"sdate"] = m_startDate;
  parameters[@"edate"] = m_endDate;
  NSString *url = [data_address
      stringByAppendingString:@"youguu/simtrade/doquery/{ak}/{sid}/{userid}/"
      @"{matchid}/{type}/{page}/{size}/{sdate}/" @"{edate}"] ;

  JsonFormatRequester *requester = [JsonFormatRequester new];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:parameters
                withRequestObjectClass:[SimuCancelPageData class]
               withHttpRequestCallBack:callback];
}

@end
