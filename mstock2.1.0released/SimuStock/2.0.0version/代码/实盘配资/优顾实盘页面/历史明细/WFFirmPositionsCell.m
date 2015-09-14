//
//  WFFirmPositionsCell.m
//  SimuStock
//
//  Created by moulin wang on 15/4/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFFirmPositionsCell.h"
#import "CellBottomLinesView.h"

@interface WFFirmPositionsCell ()
/** 股票名称 */
@property(strong, nonatomic) IBOutlet UILabel *stockName;
/** 股票代码 */
@property(strong, nonatomic) IBOutlet UILabel *stockCode;
/** 买入价格 */
@property(strong, nonatomic) IBOutlet UILabel *purchasePrice;
/** 卖出价格 */
@property(strong, nonatomic) IBOutlet UILabel *sellOutPrice;
/** 成交数量（股） */
@property(strong, nonatomic) IBOutlet UILabel *transactionsNumber;

@end

@implementation WFFirmPositionsCell

- (void)awakeFromNib {
  // Initialization code
  [CellBottomLinesView addBottomLinesToCell:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
