//
//  MarketTrendListTableViewCell.m
//  SimuStock
//
//  Created by jhss on 15/7/28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MarketTrendListTableViewCell.h"
#import "SimuUtil.h"
#import "StockUtil.h"

@implementation MarketTrendListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/** 绑定智能选股 */
- (void)bindRecommendStock:(NSDictionary *)dic
    withRecommendStockType:(RecommendStockType)recommendStockType {
  
  self.nameLabel.text = [SimuUtil changeIDtoStr:dic[@"name"]];
  NSString *firstType = [dic[@"firstType"] stringValue];
  NSString *formatTemplate = [StockUtil isFund:firstType] ? @"%0.3f" : @"%0.2f";
  NSString *curPrice =
  [NSString stringWithFormat:formatTemplate, [dic[@"curPrice"] floatValue]];
  self.curPriceLab.text = curPrice;
  
  NSString *dataPer = dic[@"val"];
  self.dataPerLab.text = dataPer;
  
  switch (recommendStockType) {
    case RecommendStockTypeRocket:
      self.curPriceLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
      self.dataPerLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
      break;
      
    case RecommendStockTypeTopest:
      self.curPriceLab.textColor = [StockUtil getColorByText:dataPer];
      self.dataPerLab.textColor = [StockUtil getColorByText:dataPer];
      break;
      
    case RecommendStockType5Coming:
      self.curPriceLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
      self.dataPerLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
      break;
      
    case RecommendStockTypeMACD:
      self.curPriceLab.textColor = [StockUtil getColorByText:dataPer];
      self.dataPerLab.textColor = [StockUtil getColorByText:dataPer];
      break;
      
    case RecommendStockTypeHotBuy:
      self.curPriceLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
      self.dataPerLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
      break;
  }
}

@end
