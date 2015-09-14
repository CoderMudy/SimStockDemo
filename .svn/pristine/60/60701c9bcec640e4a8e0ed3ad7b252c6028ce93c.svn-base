//
//  SimuMatchInfo.m
//  SimuStock
//
//  Created by jhss on 15/8/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SimuMatchInfo.h"
#import "JsonFormatRequester.h"

@implementation SimuMatchInfo

#pragma mark 个人排名

+ (void)getGroupMatchWithInput:(NSDictionary *)dic
                 withMatchType:(NSString *)type
                  withCallback:(HttpRequestCallBack *)callback {
   NSString *url = data_address;
  int i = 2; //总排行
  if ([type isEqualToString:@"week"]) {
    i = 0;
  } else if ([type isEqualToString:@"month"]) {
    i = 1;
  }
  url = [url stringByAppendingFormat:@"youguu/match/rank/group?"];
  NSString *dataStr = [NSString
                       stringWithFormat:
                       @"type=%d&startid={startid}&reqnum={reqnum}&mid={mid}", i];
  url = [url stringByAppendingString:dataStr];
  
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[PersionMatchListResult class]
             withHttpRequestCallBack:callback];
  
  
  
}

//学校内部排名
+ (void)getSchoolMatchWithInput:(NSDictionary *)dic
                 withMatchType:(NSString *)type
                  withCallback:(HttpRequestCallBack *)callback {
  NSString *url = data_address;
  int i = 2; //总排行
  if ([type isEqualToString:@"week"]) {
    i = 0;
  } else if ([type isEqualToString:@"month"]) {
    i = 1;
  }
  url = [url stringByAppendingFormat:@"youguu/match/rank/group_member?"];
  NSString *dataStr = [NSString
                       stringWithFormat:
                       @"type=%d&startid={startid}&reqnum={reqnum}&teamId={teamId}", i];
  url = [url stringByAppendingString:dataStr];
  
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SchoolMatchListResult class]
             withHttpRequestCallBack:callback];
  
  
  
}

@end
#pragma mark  --- 个人排名
@implementation PersionMatchListResult

- (void)jsonToObject:(NSDictionary *)dic {
  if (dic[@"result"] == nil) {
    return;
  }
  NSArray *userinfo = dic[@"result"];
  NSMutableArray *resultArrayM = [NSMutableArray array];
  [userinfo enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx,
                                         BOOL *stop) {
    [resultArrayM
     addObject:[SimuPersionMatchItem withGroupMatchInfoWithDictionary:dic]];
  }];
  self.matchList = resultArrayM;
}
- (NSArray *)getArray {
  return _matchList;
}


@end

//个人排名
@implementation SimuPersionMatchItem

+ (instancetype)withGroupMatchInfoWithDictionary:(NSDictionary *)dic {
  return [[SimuPersionMatchItem alloc] initWithDictionary:dic];
}
-(instancetype)initWithDictionary:(NSDictionary *)dic{

  if (self = [super init]) {
    self.profitLabel = dic[@"profit"];
    self.rankNum = [dic[@"rank"]stringValue];
    self.teamName = dic[@"teamName"];
    self.teamId = [dic[@"teamId"]stringValue];
  }
  
  return self;
}

@end

#pragma mark  --学校内部排名

@implementation SchoolMatchListResult

- (void)jsonToObject:(NSDictionary *)dic {
  if (dic[@"result"] == nil) {
    return;
  }
  NSArray *userinfo = dic[@"result"];
  NSMutableArray *resultArrayM = [NSMutableArray array];
  [userinfo enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx,
                                         BOOL *stop) {
    [resultArrayM
     addObject:[SimuSchoolMatchItem withSchoolMatchInfoWithDictionary:dic]];
  }];
  self.matchList = resultArrayM;
}
- (NSArray *)getArray {
  return _matchList;
}


@end

//学校内部排名
@implementation SimuSchoolMatchItem

+ (instancetype)withSchoolMatchInfoWithDictionary:(NSDictionary *)dic {
  return [[SimuSchoolMatchItem alloc] initWithDictionary:dic];
}
-(instancetype)initWithDictionary:(NSDictionary *)dic{
  
  if (self = [super init]) {
    self.profitLabel = dic[@"profit"];
    self.rankNum = [dic[@"rank"]stringValue];
    self.personalName = dic[@"realName"];
    self.teamId = [dic[@"teamId"]stringValue];
    self.uid = [dic[@"uid"] stringValue];
  }
  
  return self;
}


@end


