//
//  SingleUserApplyDetail.h
//  SimuStock
//
//  Created by Mac on 15/4/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserListItem.h"
#import "UserMarqueeItem.h"

@interface SingleUserApplyDetail : BaseRequestObject2
///用户信息
@property(nonatomic, strong) UserListItem *userListItem;
///用户申请金额
@property(nonatomic, strong) UserMarqueeItem *userMarqueeItem;
///在一个数组中 找到第一个uid=uid 的成员字典dic
- (NSDictionary *)findWithArray:(NSArray *)array
             andequalWithUserid:(NSString *)userid;
@end
