//
//  FundHoldStocksViewController2.h
//  SimuStock
//
//  Created by Mac on 15/5/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"

/** 基金持股明细 */
@interface FundHoldStocksViewController : BaseViewController

/** 基金代码 */
@property(nonatomic, strong) NSString *fundCode;

/** 基金名称 */
@property(nonatomic, strong) NSString *fundName;

- (id)initWithFundCode:(NSString *)fundCode withFundName:(NSString *)fundName;

@end
