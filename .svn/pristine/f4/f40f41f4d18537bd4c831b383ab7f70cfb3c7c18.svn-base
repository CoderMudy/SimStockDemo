//
//  BaseWeiboItem.m
//  SimuStock
//
//  Created by Mac on 14/11/27.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseWeiboItem.h"

@implementation WeiboContent

- (void)jsonToObject:(NSDictionary *)dic {

  NSLog(@"微博内容%@", dic);
  self.writer = [[UserListItem alloc] init];
  [self.writer jsonToObject:dic];
  self.ctime = [dic[@"ctime"] longLongValue];
  self.content = dic[@"content"];
  self.type = [dic[@"type"] intValue];
  self.stype = [dic[@"stype"] intValue];
  self.tstockid = [dic[@"tstockid"] longLongValue];
  self.timelineid = [dic[@"timelineid"] longLongValue];
  self.title = dic[@"title"];
  self.position = dic[@"position"];
  self.imgs = dic[@"imgs"];
}

@end

@implementation SourceWeiboContent

- (void)jsonToObject:(NSDictionary *)dic {
  self.writer = [[UserListItem alloc] init];
  self.writer.userId = dic[@"o_uid"];
  self.writer.nickName = dic[@"o_nick"];

  self.ctime = [dic[@"o_ctime"] longLongValue];
  self.content = dic[@"o_content"];
  self.type = [dic[@"o_type"] intValue];
  self.stype = [dic[@"o_stype"] intValue];
  self.tstockid = [dic[@"o_tstockid"] longLongValue];
  self.position = dic[@"o_position"];
  self.imgs = dic[@"o_imgs"];
}

@end

@implementation BaseWeiboItem

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  self.elite = [dic[@"elite"] boolValue];
  self.barId = [dic[@"barId"] longLongValue];
  self.topType = (BarTopType)[dic[@"topType"] intValue];
  self.uid = [dic[@"uid"] longLongValue];

  self.favourteTime = [dic[@"favourteTime"] longLongValue];
}

@end

@implementation WeiboItemInList

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  self.praise = [dic[@"praise"] intValue];
  self.share = [dic[@"share"] intValue];
  self.comment = [dic[@"comment"] intValue];
  self.collect = [dic[@"collect"] intValue];
  self.floor = [dic[@"floor"] intValue];

  self.collectNum = [dic[@"collect_num"] intValue];
  self.praiseNum = [dic[@"praise_num"] intValue];

  self.content = [[WeiboContent alloc] init];
  [self.content jsonToObject:dic];
  if (dic[@"source"]) {
    self.sourceContent = [[SourceWeiboContent alloc] init];
    [self.sourceContent jsonToObject:dic[@"source"]];
  }
}

@end
