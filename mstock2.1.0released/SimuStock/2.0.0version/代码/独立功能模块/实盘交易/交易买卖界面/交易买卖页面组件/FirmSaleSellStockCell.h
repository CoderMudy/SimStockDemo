//
//  FirmSaleSellStockCell.h
//  SimuStock
//
//  Created by Yuemeng on 14-9-28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PositionData.h"
#import "GetStockFirmPositionData.h"

/** 类说明:实盘交易的卖出页面选择股票tableViewCell */
@interface FirmSaleSellStockCell : UITableViewCell
/** 设置数据方法 */
- (void)setCellData:(PositionResult *)data;

/** 配资数据 */
-(void)setCapitalData:(WFfirmStockListData *)data;
@end
