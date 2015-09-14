//
//  UserMarqueeItem.h
//  SimuStock
//
//  Created by Mac on 15/4/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"
typedef NS_ENUM(NSInteger, MarqueeStatus) {
  MarqueeApply = 0,  /// 申请
  MarqueeProfit = 1, /// 盈利
};

@interface UserMarqueeItem : BaseRequestObject2
///用户id
@property(nonatomic, strong) NSString *Userid;
///用户跑马灯类型
@property(nonatomic) MarqueeStatus status;
///金额
@property(nonatomic) double amout;
@end
