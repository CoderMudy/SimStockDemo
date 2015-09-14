//
//  SiuSellStockViewCell.h
//  SimuStock
//
//  Created by Mac on 13-12-18.
//  Copyright (c) 2013年 Mac. All rights reserved.
//
/*
 *类说明：cell
 */
#import <UIKit/UIKit.h>
#import "SimuPositionPageData.h"
#import "SimuRankPositionPageData.h"
#import "CellBottomLinesView.h"

@interface SiuSellStockViewCell : UITableViewCell 

/**  股票名称*/
@property (weak, nonatomic) IBOutlet UILabel *stockName;
/**  盈亏率*/
@property (weak, nonatomic) IBOutlet UILabel *stockPorfit;
/**  可卖股数*/
@property (weak, nonatomic) IBOutlet UILabel *stockSellVlom;
/**  股票代码*/
@property (weak, nonatomic) IBOutlet UILabel *stockNum;

@property (weak, nonatomic) IBOutlet CellBottomLinesView *bottomLines;


//设定数据
- (void)setCellData:(PositionInfo *)element;

@end
