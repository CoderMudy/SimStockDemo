//
//  ActulTradingRenewcontractViewController.h
//  SimuStock
//
//  Created by jhss_wyz on 15/3/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"

@interface ActulTradingRenewContractViewController : BaseViewController
////contractNo合约号
/** 传入合约号和产品Id */
- (instancetype)initWithContractNo:(NSString *)contractNo
                         andProdId:(NSString *)prodId;

@end
