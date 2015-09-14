//
//  StockSearchTableViewCell.m
//  SimuStock
//
//  Created by Mac on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockSearchTableViewCell.h"
#import "PortfolioStockModel.h"

@implementation StockSearchTableViewCell

- (void)awakeFromNib {
  // Initialization code
  self.stoplitLineHeight.constant = 0.4f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)bindStockFunds:(StockFunds *)stock {
  self.lblStockCode.text = stock.stockCode;
  self.lblStockName.text = stock.name;

  if ([PortfolioStockManager isPortfolioStock:stock.code]) {
    self.stockHeight.constant = 35.f;
    self.lblStockGroupInfo.hidden = NO;
    self.lblStockGroupInfo.text = [self getGroupInfo:stock.code];
    self.lblStockGroupInfo.adjustsFontSizeToFitWidth = YES;
  } else {
    self.stockHeight.constant = 17.f;
    self.lblStockGroupInfo.hidden = YES;
    self.lblStockGroupInfo.text = @"";
  }
}

- (NSString *)getGroupInfo:(NSString *)stock8CharCode {
  NSMutableString *str = [[NSMutableString alloc] init];
  QuerySelfStockData *model =
      [PortfolioStockManager currentPortfolioStockModel].local;
  __block int groupNum = 0;
  [model.dataArray enumerateObjectsUsingBlock:^(QuerySelfStockElement *group,
                                                NSUInteger idx, BOOL *stop) {
    if ([group.stockCodeArray containsObject:stock8CharCode]) {
      if (groupNum < 4) {
        if (groupNum > 0) {
          [str appendString:@","];
        }
        [str appendString:@"\""];
        [str appendString:group.groupName];
        [str appendString:@"\""];
      }

      groupNum++;
    }
  }];
  if (groupNum == 0) {
    return @"";
  } else if (groupNum <= 4) {
    return [NSString stringWithFormat:@"已在%@中", str];
  } else {
    return [NSString stringWithFormat:@"已在%@等分组中", str];
  }
}

@end
