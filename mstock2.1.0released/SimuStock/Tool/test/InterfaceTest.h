//
//  InterfaceTest.h
//  SimuStock
//
//  Created by Mac on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterfaceTest : NSObject

/** 测试加载银行卡信息 */
+(void) testLoadSecuritiesBankInfo;

/** 测试撤单 */
+(void) testRevoke;

/** 测试获取验证码 */
+(void) testCaptchaImage;

/** 测试获取券商列表 */
+(void) testSecuritiesCompanyList;




@end
