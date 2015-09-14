//
//  StockUserView.m
//  SimuStock
//
//  Created by Mac on 15/1/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockUserView.h"
#import "SimuUtil.h"

@implementation StockUserView

/** 设置股友用户信息 */
-(void) setStockUser:(UserListItem *)stockUser{
  _stockUser = stockUser;
  [SimuUtil widthOfButton:self title:stockUser.nickName
                      titleColor:[self colorWithVIPType:stockUser.vipType]
                       font:Font_Height_14_0];
}

/** 执行点击跳转事件 */
-(void) performOnClick{
  self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
  dispatch_time_t time =
  dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
  dispatch_after(time, dispatch_get_main_queue(), ^{
    self.backgroundColor = [UIColor clearColor];
    [HomepageViewController showWithUserId:[self.stockUser.userId stringValue]
                                 titleName:self.stockUser.nickName
                                   matchId:MATCHID];
  });
}

///根据vip类型返回颜色
- (UIColor *)colorWithVIPType:(NSInteger)vipType {
  if (vipType == 1 || vipType == 2) {
    return [Globle colorFromHexRGB:Color_Red];
  } else {
    return [Globle colorFromHexRGB:Color_Blue_but];
  }
}

@end
