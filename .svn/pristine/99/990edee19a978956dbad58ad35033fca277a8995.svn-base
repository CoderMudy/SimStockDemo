//
//  StockPriceRemindTableVC.h
//  SimuStock
//
//  Created by jhss on 15/7/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
#import "StockAlarmTableViewCell.h"
typedef void (^ClearBtnDisplay)();
typedef void (^ClearBtnHidden)();
@interface StockPriceRemindTableAdapter : BaseTableAdapter

@end

@interface StockPriceRemindTableVC : BaseTableViewController
- (void)clearStockAlarmData;
@property(copy, nonatomic) ClearBtnDisplay clearBtnDisplay;
@property(copy, nonatomic) ClearBtnHidden clearBtnHidden;
@end