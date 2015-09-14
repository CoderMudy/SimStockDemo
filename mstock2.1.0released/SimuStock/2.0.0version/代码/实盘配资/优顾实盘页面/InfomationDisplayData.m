//
//  InfomationDisplayData.m
//  SimuStock
//
//  Created by moulin wang on 15/4/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

@implementation InfomationDisplayData

@end

@implementation InfomationDisplayRequest

- (void)jsonToObject:(NSDictionary *)dic {
  self.infomationDisplayArray = [NSMutableArray array];
  [super jsonToObject:dic];
  //解析数据
}

+ (void)updateInfomationDisplay:(HttpRequestCallBack *)callback {
}

@end
