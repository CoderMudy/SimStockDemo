//
//  StockNewsList.m
//  SimuStock
//
//  Created by Mac on 14-11-6.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "StockNewsList.h"

#import "JsonFormatRequester.h"

/*******************************************************************
 *******   行情资讯文章列表      **********************************************
 ***************************************/
@implementation StockNewsData

- (void)jsonToObject:(NSDictionary *)obj {

  self.newsTime = [obj[@"pubtime"] longLongValue];

  self.newsID = [SimuUtil changeIDtoStr:obj[@"id"]];

  self.newsTitle = [SimuUtil changeIDtoStr:obj[@"title"]];

  self.newsUrl = [SimuUtil changeIDtoStr:obj[@"url"]];
}

@end

@implementation StockNewsList

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];
  NSArray *array = dic[@"result"];
  for (NSDictionary *dic in array) {
    StockNewsData *item = [[StockNewsData alloc] init];
    [item jsonToObject:dic];
    [self.dataArray addObject:item];
  }
}
+ (void)requestNewsListWithType:(StockNewsType)type
                  withStockCode:(NSString *)stockCode
                     withFromId:(NSString *)fromId
                      withLimit:(NSString *)limit
                   withCallback:(HttpRequestCallBack *)callback {
  NSString *url;
  switch (type) {
  case StockNews:
    url = [market_address
        stringByAppendingString:@"/quote/info/newslist?code={code}&fromId={fromId}&limit={limit}"];
    break;
  case StockNewsBull:
    url = [market_address
        stringByAppendingString:@"/quote/info/bullist?code={code}&fromId={fromId}&limit={limit}"];
    break;
  case StockNewsIndustry:
    url = [market_address
        stringByAppendingString:@"/quote/info/indulist?code={code}&fromId={fromId}&limit={limit}"];
    break;
  }

  stockCode = stockCode ? stockCode : @"";
  NSDictionary *dic = @{ @"code" : stockCode, @"fromId" : fromId, @"limit" : limit };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[StockNewsList class]
             withHttpRequestCallBack:callback];
}

@end