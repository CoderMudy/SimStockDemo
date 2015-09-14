//
//  SingleUserApplyDetail.m
//  SimuStock
//
//  Created by Mac on 15/4/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SingleUserApplyDetail.h"

@implementation SingleUserApplyDetail

///在一个数组中 找到第一个uid=uid 的成员字典dic
- (NSDictionary *)findWithArray:(NSArray *)array
             andequalWithUserid:(NSString *)userid {
  if (!array || [array count] == 0 || !userid || [userid length] == 0) {
    return nil;
  }

  for (id dic in array) {
    if (dic && [[dic class] isSubclassOfClass:[NSDictionary class]]) {
      NSNumber *uid = [dic objectForKey:@"uid"];
      if ([[uid stringValue] isEqualToString:userid]) {
        return dic;
      }
    }
  }
  return nil;
}

@end
