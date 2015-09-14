//
//  StockSearchTableViewCell.h
//  SimuStock
//
//  Created by Mac on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockFunds.h"

@interface StockSearchTableViewCell : UITableViewCell

///添加自选股按钮
@property(weak, nonatomic) IBOutlet UIButton *btnAddStock;

///分割线
@property(weak, nonatomic) IBOutlet UIView *splitLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stoplitLineHeight;

///股票代码：6位
@property(weak, nonatomic) IBOutlet UILabel *lblStockCode;

///股票名称
@property(weak, nonatomic) IBOutlet UILabel *lblStockName;

///自选股分组信息
@property(weak, nonatomic) IBOutlet UILabel *lblStockGroupInfo;

///股票信息区高度约束
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *stockHeight;

- (void)bindStockFunds:(StockFunds *)stock;

@end
