//
//  SessionIDVerificationProcess.h
//  SimuStock
//
//  Created by jhss on 14-7-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

//自动登录
#import "LoginProcess.h"

#define sid_one_day_time 86400
#define sid_seven_days_time 604800
#define sid_out_of_date @"sidOutofDate"

@interface SessionIDVerificationProcess : NSObject {
  //之前保存sid时间
  long long previousSaveSidTime;
  //当前时间
  long long currentTime;

  //自动登录
  LoginProcess *autoLogin;
}
//外部访问登录操作
+ (SessionIDVerificationProcess *)shareSidVerification;
@end
