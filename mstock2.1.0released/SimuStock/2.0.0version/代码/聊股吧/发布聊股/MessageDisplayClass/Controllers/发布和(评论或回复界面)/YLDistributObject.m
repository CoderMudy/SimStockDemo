//
//  YL_DistributObject.m
//  SimuStock
//
//  Created by Mac on 15/1/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "YLDistributObject.h"

@implementation YLDistributObject

-(id)initWithnickName:(NSString *)nick andUid:(NSString *)uid
{
  if (self = [super init])
  {
    self.nickName=nick;
    self.UserID=uid;
  }
  return self;
}


@end
