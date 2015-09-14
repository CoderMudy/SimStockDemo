//
//  UserRealTradingInfo.h
//  SimuStock
//
//  Created by jhss on 14-10-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  SaveTypeUserTradingIDCustomerNumber = 1,      /**< 用户账号 客户号 */
  SaveTypeUserTradingIDFundNumber = 2,
  SaveTypeUserTradingCompany = 3, /**< 开户券商 */
  SaveTypeAccountTypeCustomerNumber = 4,        /**< 客户号 */
  SaveTypeAccountTypeFundNumber = 5, /** 资金号 */
  SaveTypeSelectedType = 6, /** 选中类型 */
  SaveTypeAccountSaveStatus = 7,  /**< 账号保存状态 */
} SaveType;

@interface UserRealTradingInfo : NSObject
/**定义唯一对象*/
+ (UserRealTradingInfo *)sharedInstance;
+ (id)allocWithZone:(NSZone *)zone;
/**保存信息*/
- (void)saveUserInfo:(SaveType)saveType withSaveContent:(NSString *)saveContent;
/**删除某项信息*/
- (void)deleteUserInfo:(SaveType)saveType;
/**获取某项信息*/
- (NSString *)getUserInfo:(SaveType)saveType;
/**实盘交易,不同账号的失败次数*/
- (void)saveUserRealTradeLogonWithAccountId:(NSString *)accountId
                               withFailTime:(NSInteger)failTime;
/**实盘交易,不同账号的失败时间*/
- (void)saveUserRealTradeFailDateWithAccountId:(NSString *)accountId;
/**实盘交易,获取失败次数*/
- (NSInteger)getUserRealTradeLogonWithAccountId:(NSString *)accountId;
/**实盘交易，不同账号的失败时间*/
- (NSDate *)getUserFailLogonTimeWithAccountId:(NSString *)accountId;
/**实盘登录成功，重置信息*/
- (void)logonSuccessResetUserInfo:(NSString *)accountId;
@end
