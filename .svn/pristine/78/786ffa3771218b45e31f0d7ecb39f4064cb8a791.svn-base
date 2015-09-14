//
//  WithFundingUser.h
//  SimuStock
//
//  Created by Mac on 15/4/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WithFundingRequester.h"

/** 1.1是否存在配资账户响应结果 */
@interface WFAccountAvailable : BaseWithFundingResponseObject

#pragma mark ——————"data"
///是否存在配资账户
@property(nonatomic, assign) BOOL available;

@end

/** 1.2申领融资账户响应结果 */
@interface WFApplyForAccount : BaseWithFundingResponseObject

#pragma mark ——————"data"
///申领融资的账户
@property(nonatomic, copy) NSString *userid;

@end

/** 1.3查询融资账户信息响应结果 */
@interface WFQueryFinancingAccountInfo : BaseWithFundingResponseObject

#pragma mark ——————"data"
/** 用户ID */
@property(nonatomic, strong) NSString *userId;
/** 用户账户 */
@property(nonatomic, strong) NSString *accountStatus;
/** 账户总金额 */
@property(nonatomic, strong) NSString *accountAmount;
/** 在途金额 */
@property(nonatomic, strong) NSString *freezeAmount;
/** 币种 */
@property(nonatomic, strong) NSString *currencyType;
/** 创建时间 */
@property(nonatomic, strong) NSString *createDatetime;
/** 更新时间 */
@property(nonatomic, strong) NSString *updateDatetime;
/** 备注 */
@property(nonatomic, strong) NSString *remark;
/** 手机号 */
@property(nonatomic, strong) NSString *mobile;

@end

/** 1.4对接方账户与融资账户之间的自己划转响应结果 */
@interface WFFundsTransfer : BaseWithFundingResponseObject

#pragma mark ——————"data"
///资金划转是否成功
@property(nonatomic, assign) BOOL fundsTransfer;

@end

#pragma mark
#pragma mark 用户相关的调用

/** 配资模型之用户相关接口 */
@interface WithFundingUser : NSObject

/** 1.1判断某用户是否拥有融资账户 */
+ (void)checkWFAccountAvailableWithMoblie:(NSString *)mobile
                           withIdcardKind:(NSString *)idcardKind
                               withIdcard:(NSString *)idcard
                             withCallback:(HttpRequestCallBack *)callback;

/** 1.2申领融资账户(当没有融资账户时，要先申领融资账户) */
+ (void)applyForWFAccountWithMobile:(NSString *)mobile
                   withUserRealName:(NSString *)userRealName
                     withIdcardKind:(NSString *)idcardKind
                         withIdcard:(NSString *)idcard
                       withCallback:(HttpRequestCallBack *)callback;
/** 1.3融资账户的信息 */
+ (void)queryWFFinacingAccountInfoWithUserId:(NSString *)userid
                                withCallback:(HttpRequestCallBack *)callback;

/** 1.4对接方主账户与融资账户之间的资金划转 */
+ (void)fundsTransferBetweenAccountsWithUserId:(NSString *)userId
                               withTransAmount:(NSString *)transAmount
                                    withRemark:(NSString *)remark
                                 withDirection:(NSString *)direction
                                  withCallback:(HttpRequestCallBack *)callback;

@end
