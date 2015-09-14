//
//  LogonDataParsingClass.h
//  SimuStock
//
//  Created by jhss on 14-7-7.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BindingViewController.h"

@interface LogonDataParsingClass : NSObject {
  /** 三方登录方式 */
  NSInteger tempThirdLogonType;
  /** 三方type */
  NSInteger tempShareType;
}
@property(copy, nonatomic) NSString *tempUid;
@property(copy, nonatomic) NSString *tempNickName;
@property(copy, nonatomic) NSString *tempHeadImage;
@property(copy, nonatomic) NSString *tempThirdPartImage;
@property(copy, nonatomic) NSString *tempTitleName;
/** 三方登录请求入口 */
- (void)thirdPartAutoLogon:(NSString *)uid
             withLogonType:(NSString *)logonType
                 withToken:(NSString *)token;
/** 三方向绑定页传递的数据 */
- (void)logonDataMessagePassingWithUid:(NSString *)uid
                          withNickName:(NSString *)nickName
                   withThirdLogonImage:(NSString *)logonImage
                         withTitleName:(NSString *)titleName
                 withThirdWayIconImage:(NSString *)thirdWayIconImage
                         withShareType:(NSInteger)shareType;
@end
