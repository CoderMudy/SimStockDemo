//
//  FirmSaleSearchStockCell.h
//  SimuStock
//
//  Created by Yuemeng on 14/10/28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockDBManager.h"
/**
 实盘买入搜股票cell
 */
@interface FirmSaleSearchStockCell : UITableViewCell
/**设置cell信息*/
- (void)setInformationWithDBTableItem:(StockFunds *)tableDBItem;
@end
