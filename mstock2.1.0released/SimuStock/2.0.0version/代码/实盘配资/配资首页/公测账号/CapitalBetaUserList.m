//
//  CapitalBetaUserList.m
//  SimuStock
//
//  Created by 刘小龙 on 15/5/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CapitalBetaUserList.h"

@implementation CapitalBetaUserList
///判断是不是 公测用户 允许申请配资账号
+(BOOL)betaUserListName:(NSString *)userID
{
  return YES;
  //获取plist文件
  NSString *path = [[NSBundle mainBundle] pathForResource:@"BetaUserListName" ofType:@"plist"];
  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
  for (int i = 0;  i < dictionary.count; i++) {
    NSString *key = [NSString stringWithFormat:@"%d",i];
    NSString *userName = dictionary[key];
    if ([userID isEqualToString:userName]) {
      return YES;
    }
  }
  return NO;
}

@end
