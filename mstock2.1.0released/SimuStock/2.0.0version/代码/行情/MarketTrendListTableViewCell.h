//
//  MarketTrendListTableViewCell.h
//  SimuStock
//
//  Created by jhss on 15/7/28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketConst.h"
#import "CellBottomLinesView.h"

@interface MarketTrendListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLab;
@property (weak, nonatomic) IBOutlet UILabel *curPriceLab;
@property (weak, nonatomic) IBOutlet CellBottomLinesView *topSplitView;

@property (weak, nonatomic) IBOutlet UILabel *dataPerLab;
/** 绑定智能选股 */
-(void) bindRecommendStock:(NSDictionary*) dic
    withRecommendStockType:(RecommendStockType) recommendStockType;
@end
