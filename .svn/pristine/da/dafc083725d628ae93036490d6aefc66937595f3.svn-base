//
//  SimuUser.h
//  SimuStock
//
//  Created by Mac on 14-9-15.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, YLBpushType) {
  UserBpushAllCount = 0,      //推送总数
  UsercommentCount = 1,       //评论个数
  UsermentionCount = 2,       //@我个数
  UserfollowCount = 3,        //关注个数
  UserpreiseCount = 4,        //被赞个数
  UserSystemMessageCount = 5, //用户系统消息个数
  UserStockWarning = 6,       //股价预警个数
  UserVipCount = 7,           // Vip消息个数
//  UserTraceMessage = 8,       //牛人计划追踪消息个数
};

#import "UserBpushInformationNum.h"

@interface SimuUser : NSObject

/** 当退出登录时 */
+ (void)onLoginOut;

/** 设置session被获取时的时间*/
+ (void)setSessionSavedTime:(int64_t)time;

/** 返回session被获取时的时间 */
+ (int64_t)getSessionSavedTime;

/** 用户实盘登录时刻 */
+ (void)setUserFirmLogonSuccessTime:(int64_t)time;
/** 返回用户实盘登录时间 */
+ (BOOL)getUserFirmLogonSuccessStatus;

/** 保存历史登录信息 */
+ (void)saveUsernameHistoryInfo:(NSString *)userName;

/** 获取历史登录信息 */
+ (NSMutableArray *)userNameHistoryInfo;

@end
