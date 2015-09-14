//
//  SecuritiesBankInfo.h
//  SimuStock
//
//  Created by Mac on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

@interface RealTradeBankItem : NSObject <ParseJson>

/**币种 */
@property(nonatomic, strong) NSString *currencyType;

/**银行代码 */
@property(nonatomic, strong) NSString *bankCode;

/**银行名称 */
@property(nonatomic, strong) NSString *bankName;

/**银行账户 */
@property(nonatomic, strong) NSString *bankAccount;

/**资金账户 */
@property(nonatomic, strong) NSString *moneyAccount;

/**名称 */
@property(nonatomic, strong) NSString *name;

@end

@interface RealTradeCurrencyType : NSObject <ParseJson>

/**币种字母简写，例如：RMB, HKD, USD */
@property(nonatomic, strong) NSString *abbr;

/**币种名称，例如：人民币, 港币, 美元 */
@property(nonatomic, strong) NSString *name;

@end

@interface SecuritiesBankInfo : JsonRequestObject

/**银行信息 */
@property(nonatomic, strong) NSMutableArray *banks;

/**币种 */
@property(nonatomic, strong) NSMutableArray *currencyTypes;

/**加载银行卡信息 */
+ (void)loadSecuritiesBankInfoWithUrl:(NSString *)url
                         WithCallback:(HttpRequestCallBack *)callback;

@end
