//
//  BankInitDrawData.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/22.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"

/*
 *  申请提现初始化接口
 */
@interface BankInitDrawData : JsonRequestObject
///用户昵称
@property(nonatomic, copy) NSString *nickName;
///身份证号
@property(nonatomic, copy) NSString *certNo;
///银行账户
@property(nonatomic, copy) NSString *bankAccount;
///真实姓名
@property(nonatomic, copy) NSString *realName;
///手机号
@property(nonatomic, copy) NSString *phone;
///开户银行
@property(nonatomic, copy) NSString *bankName;
///税后提现
@property(nonatomic) double taxBalance;
///提现金额
@property(nonatomic) double cash;
///用户ID
@property(nonatomic) int64_t userId;
//“0022”：未绑定手机
//“0301”：无此用户银行卡信息。
@property(nonatomic,copy) NSString *extraStatus;

@property(nonatomic,strong) NSArray *bankList;



///将以上直接封装为NSString数组
@property(nonatomic, strong) NSMutableArray *stringArray;
///请求银行卡绑定
+ (void)requestBankInitDrawData:(HttpRequestCallBack *)callback;
///查询单挑提现信息
+ (void)requestGetWalletFlowData:(NSString *)tradeFee
                    withCallback:(HttpRequestCallBack *)callback;



@end
