//
//  SystemMessageList.m
//  SimuStock
//
//  Created by Mac on 14-11-5.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SystemMessageList.h"
#import "JsonFormatRequester.h"
#import "HTMLParser.h"

@implementation SystemMsgData

- (void)jsonToObject:(NSDictionary *)dic {

  self.mID = [SimuUtil changeIDtoStr:dic[@"id"]];

  self.mTitle = dic[@"title"];

  self.mType = [SimuUtil changeIDtoStr:dic[@"type"]];

  self.mTime = [dic[@"ctime"] longLongValue];

  //时间转换成用户可读模式
  NSDate *date =
      [[NSDate alloc] initWithTimeIntervalSince1970:self.mTime / 1000.0];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
  NSString *data_content = [dateFormatter stringFromDate:date];
  self.mstrTime = [SimuUtil changeAbsuluteTimeToRelativeTime:data_content];

  self.mMsgContent = dic[@"msg"];
  NSError *error = nil;
  NSString *html = self.mMsgContent;
  HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];

  if (error) {
    NSLog(@"Error: %@", error);
    return;
  }

  HTMLNode *bodyNode = [parser body];

  HTMLNode *pNode = [bodyNode findChildTags:@"p"][0];
  NSArray *nodeArray = [pNode children];

  NSMutableString *changedString = [[NSMutableString alloc] init];
  [nodeArray
      enumerateObjectsUsingBlock:^(HTMLNode *node, NSUInteger idx, BOOL *stop) {
        if ([[node tagName] isEqualToString:@"text"]) {
          [changedString appendString:[node rawContents]];
        } else if ([[node tagName] isEqualToString:@"a"]) {
          NSString *href = [node getAttributeNamed:@"href"];
          [changedString appendFormat:@"<a href=\"%@\" alt=\"%@\">", href,
                                      [node contents]];
        }
      }];
  self.mMsgContent = changedString;
  NSLog(@"%@", changedString);
}

@end

@implementation SystemMessageList

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];
  NSArray *array = dic[@"result"];
  for (NSDictionary *dic in array) {
    SystemMsgData *item = [[SystemMsgData alloc] init];
    [item jsonToObject:dic];
    [self.dataArray addObject:item];
  }
}


- (NSArray *)getArray {
  return _dataArray;
}
+ (void)requestMessageListWithDic:(NSDictionary *)dic
                     withCallback:(HttpRequestCallBack *)callback {

  NSString *url = [data_address
      stringByAppendingString:
          @"youguu/assist/notice/list?fromid={fromid}&reqnum={reqnum}"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SystemMessageList class]
             withHttpRequestCallBack:callback];
}

@end
