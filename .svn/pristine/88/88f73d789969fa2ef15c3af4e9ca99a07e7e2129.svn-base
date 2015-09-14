//
//  RealTradeFundTransferResult.h
//  SimuStock
//
//  Created by Mac on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "SecuritiesBankInfo.h"

@interface RealTradeFundTransferResult : JsonRequestObject

/**申请号 */
@property(nonatomic, strong) NSString *applyID;

/**转出 - 证券转银行 */
+ (void)transferOutWithMoneyAmount:(NSString *)amount
                      withPassword:(NSString *)password
                       WitBankInfo:(RealTradeBankItem *)bankInfo
                      WithCallback:(HttpRequestCallBack *)callback;

/**转入 - 银行转证券 */
+ (void)transferInWithMoneyAmount:(NSString *)amount
                     withPassword:(NSString *)password
                      WitBankInfo:(RealTradeBankItem *)bankInfo
                     WithCallback:(HttpRequestCallBack *)callback;
@end
