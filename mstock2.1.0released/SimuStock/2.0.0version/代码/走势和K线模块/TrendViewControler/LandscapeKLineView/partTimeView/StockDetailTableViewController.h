//
//  StockDetailTableViewController.h
//  SimuStock
//
//  Created by Yuemeng on 15/6/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
#import "StockUtil.h"

@interface StockDetailTableAdapter : BaseTableAdapter

@property(nonatomic, strong) SecuritiesInfo *securitiesInfo;

@end

/*
 *  交易明细
 */
@interface StockDetailTableViewController : BaseTableViewController

@property(nonatomic, strong) SecuritiesInfo *securitiesInfo;

- (id)initWithFrame:(CGRect)frame
 withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo;

@end
