//
//  DepositTopUpViewController.h
//  SimuStock
//
//  Created by jhss_wyz on 15/3/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"

@interface DepositTopUpViewController : BaseViewController

@property(assign, nonatomic) NSInteger addBigPrice;

@property(assign, nonatomic) NSInteger addLittlePrice;

/**
 contractNo：充值保证金的合约号
 minDeposit：最低充值金额（单位：分）
 */
- (instancetype)initWithContractNo:(NSString *)contractNo;

@end
