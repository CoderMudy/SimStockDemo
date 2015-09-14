//
//  FundHoldStockTableViewCell.h
//  SimuStock
//
//  Created by Mac on 15/5/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FundHoldStockList.h"

@interface FundHoldStockTableViewCell : UITableViewCell

///股票名称
@property(weak, nonatomic) IBOutlet UILabel *lblStockName;

///股票名称
@property(weak, nonatomic) IBOutlet UILabel *lblStockCode;

///当前价
@property(weak, nonatomic) IBOutlet UILabel *lblCurPrice;

@property(weak, nonatomic) IBOutlet UILabel *lblChange;

///分割线
@property(weak, nonatomic) IBOutlet UIView *separatorLine;

- (void)bindFundHoldStock:(FundHoldStock *)stock;

@end
