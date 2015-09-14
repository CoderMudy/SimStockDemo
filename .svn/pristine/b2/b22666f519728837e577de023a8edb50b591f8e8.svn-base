//
//  MarketListTableViewCell.m
//  SimuStock
//
//  Created by moulin wang on 14-7-11.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MarketListTableViewCell.h"
#import "SimuUtil.h"
#import "StockUtil.h"

@implementation MarketListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    [self greateUnitGridView];
  }
  return self;
}
- (void)greateUnitGridView {
  //  float leftMargin = 0;
  float nameWidth = WIDTH_OF_SCREEN / 3.f;
  //  float dataPerWidth = 80.0f;
  //  float middleWidth = 90;
  CGFloat fixSpace = 18;
  CGFloat marginLeft = -15;

  //股票名称
  _nameLab = [[UILabel alloc]
      initWithFrame:CGRectMake(fixSpace, 8.0, nameWidth - fixSpace, 16.0)];
  _nameLab.text = @"";
  _nameLab.textAlignment = NSTextAlignmentLeft;
  _nameLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  _nameLab.font = [UIFont boldSystemFontOfSize:15.0];
  _nameLab.backgroundColor = [UIColor clearColor];
  [self addSubview:_nameLab];

  //股票代码
  _codeLab = [[UILabel alloc]
      initWithFrame:CGRectMake(fixSpace, 27.0, nameWidth - fixSpace, 13.0)];
  _codeLab.text = @"";
  _codeLab.textAlignment = NSTextAlignmentLeft;
  _codeLab.textColor = [Globle colorFromHexRGB:Color_Gray];
  _codeLab.font = [UIFont systemFontOfSize:13.0];
  _codeLab.backgroundColor = [UIColor clearColor];
  [self addSubview:_codeLab];

  //最新价格
  _curPriceLab = [[UILabel alloc]
      initWithFrame:CGRectMake(fixSpace + nameWidth + marginLeft,
                               (90.0 - 42.0) / 4, nameWidth - fixSpace, 21.0)];
  _curPriceLab.text = @"";
  _curPriceLab.textAlignment = NSTextAlignmentRight;
  _curPriceLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  _curPriceLab.font = [UIFont systemFontOfSize:20.0];
    _curPriceLab.backgroundColor = [UIColor clearColor];
  [self addSubview:_curPriceLab];

  //涨跌幅度
  _dataPerLab = [[UILabel alloc]
      initWithFrame:CGRectMake(nameWidth * 2, (90.0 - 32.0) / 4,
                               nameWidth - fixSpace, 16.0)];
  _dataPerLab.text = @"";
  _dataPerLab.textAlignment = NSTextAlignmentRight;
  _dataPerLab.font = [UIFont systemFontOfSize:20];
  _dataPerLab.backgroundColor = [UIColor clearColor];
  _dataPerLab.adjustsFontSizeToFitWidth = YES;
  [self addSubview:_dataPerLab];

  //上
  _upLineView = [[UIView alloc]
      initWithFrame:CGRectMake(0.0, 45.0 - 1.0, WIDTH_OF_SCREEN, 0.5)];
  _upLineView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  [self addSubview:_upLineView];
  //下
  _downLineView = [[UIView alloc]
      initWithFrame:CGRectMake(0.0, 45.0 - 0.5, WIDTH_OF_SCREEN, 0.5)];
  _downLineView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [self addSubview:_downLineView];
}
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

  self.nameLab.text = [SimuUtil changeIDtoStr:dic[@"name"]];
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
