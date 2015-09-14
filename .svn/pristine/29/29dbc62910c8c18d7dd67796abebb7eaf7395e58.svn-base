//
//  NewsChannelList.m
//  SimuStock
//
//  Created by Mac on 15/5/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "NewsChannelList.h"
#import "JsonFormatRequester.h"

@implementation NewsChannelItem

- (void)jsonToObject:(NSDictionary*)dic {
  self.channleID = [dic[@"id"] stringValue];
  self.name = dic[@"name"];
  if (dic[@"isEditable"]) {
    self.isEditable = [dic[@"isEditable"] boolValue];
  } else {
    if ([self.channleID intValue] == 1) {
      self.isEditable = NO;
    } else
      self.isEditable = YES;
  }
  self.isVisible = YES;
}

@end

@implementation NewsChannelList

- (void)jsonToObject:(NSDictionary*)dic {
  _channels = [[NSMutableArray alloc] init];
  NSArray* result = dic[@"result"];
  [result enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx,
                                       BOOL* stop) {
    NewsChannelItem* item = [[NewsChannelItem alloc] init];
    [item jsonToObject:obj];
    [_channels addObject:item];
  }];
}

- (NSArray*)getArray {
  return _channels;
}

- (NSDictionary*)mappingDictionary {
  return @{ @"channels" : NSStringFromClass([NewsChannelItem class]) };
}

+ (void)requestChannelListWithCallBack:(HttpRequestCallBack*)callback {
  NSString* url =
      [market_address stringByAppendingString:@"/quote/info/channel"];
  JsonFormatRequester* request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[NewsChannelList class]
             withHttpRequestCallBack:callback];
}

@end

@implementation NewsInChannelItem

- (void)jsonToObject:(NSDictionary*)dic {
  self.id2 = [dic[@"id"] longLongValue];
  self.title = dic[@"title"];
  self.url = dic[@"url"];
  self.publishTime = [dic[@"pubtime"] longLongValue];
}

@end

@implementation NewsListInChannel

- (void)jsonToObject:(NSDictionary*)dic {
  _newsList = [[NSMutableArray alloc] init];
  NSArray* result = dic[@"result"];
  [result enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx,
                                       BOOL* stop) {
    NewsInChannelItem* item = [[NewsInChannelItem alloc] init];
    [item jsonToObject:obj];
    [_newsList addObject:item];
  }];
}

- (NSArray*)getArray {
  return _newsList;
}

+ (void)requestNewsListWithInputParmeters:(NSDictionary*)dic
                             withCallBack:(HttpRequestCallBack*)callback {
  NSString* url = [market_address
      stringByAppendingString:
          @"quote/info/channelinfo?cid={cid}&fromId={fromId}&limit={limit}"];
  JsonFormatRequester* request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[NewsListInChannel class]
             withHttpRequestCallBack:callback];
}

@end
