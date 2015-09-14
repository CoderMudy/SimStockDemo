//
//  BaseSecuritiesCurStatusVC.m
//  SimuStock
//
//  Created by Mac on 15/6/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseSecuritiesCurStatusVC.h"

@implementation BaseSecuritiesCurStatusVC

- (void)refreshSecuritesData {
}

- (void)clearSecuritesData {
}
/** 返回行情数据的View用于截屏分享 */
- (UIView *)curStatusViewForShare {
  return nil;
}

///涨跌幅
- (NSString *)riseRate {
  return @"";
}

///最新价
- (NSString *)curPrice {
  return @"";
}

@end
