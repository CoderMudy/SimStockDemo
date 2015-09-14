//
//  KLineUtil.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "KLineUtil.h"

@implementation KLineUtil

+ (float)roundUp:(float)value {
  return floorf(value * 100.f + 0.5) / 100.f;
}

+ (float)roundUp3:(float)value {
  return floorf(value * 1000.f + 0.5) / 1000.f;
}

@end
