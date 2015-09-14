//
//  FirmSaleSellStockVC.h
//  SimuStock
//
//  Created by Yuemeng on 14-9-25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^getStockCodeBlock)(NSObject *);

/**
 类说明：实盘交易卖出页面选择股票页面
 */
@interface FirmSaleSellStockVC : BaseViewController
@property(nonatomic, copy) getStockCodeBlock getStockCodeBlock;
-(id)initWithCapital:(BOOL)capital;

@end
