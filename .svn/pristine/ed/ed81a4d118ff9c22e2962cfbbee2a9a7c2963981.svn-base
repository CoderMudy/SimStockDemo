//
//  WFRegularExpression.h
//  SimuStock
//
//  Created by moulin wang on 15/4/22.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
//枚举 定义 身份证 姓名 银行卡号
typedef NS_ENUM(NSInteger, BankIdentityInfo) {
	//姓名
	FullName = 0,
	//身份证号
	IdentityCardNumber,
	//储蓄卡号
	BankCardNumber
};

@interface WFRegularExpression : NSObject
/**
 *  正则表达是 只判断 位数的合法性
 */
+ (BOOL)judgmentFullNameLegitimacy:(NSString *)fullName
withBankIdentityInfo:(BankIdentityInfo)bankIdentity;

/**
 *  判断 银行卡号的有效性 和 身份证的有效性
 */
- (BOOL)judgmentDetermineLegalityOfTheIdentityCardOfBankCards:(NSString *)number
withBankIdentityInfo:
(BankIdentityInfo)bankIdentity;

+ (WFRegularExpression *)shearRegularExpression;

@end
