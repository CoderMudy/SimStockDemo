//
//  FirmSaleSearchStockCell.m
//  SimuStock
//
//  Created by Yuemeng on 14/10/28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "FirmSaleSearchStockCell.h"

#define DISTANCE_OF_EDGE 30.0

@interface FirmSaleSearchStockCell () {
  //股票代码
  UILabel *_stockCodeLabel;
  //股票名称
  UILabel *_stockNameLabel;
  //上(分割线)
  UIView *_upLineView;
  //下(分割线)
  UIView *_downLineView;
}
@end

@implementation FirmSaleSearchStockCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    [self createUI];
  }
  return self;
}

- (void)createUI {

  self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  //股票代码
  _stockCodeLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(DISTANCE_OF_EDGE, 0, Font_Height_14_0 * 6, HEIGHT_OF_BUY_CELL)];
  _stockCodeLabel.backgroundColor = [UIColor clearColor];
  _stockCodeLabel.textColor = [Globle colorFromHexRGB:Color_Stock_Code];
  _stockCodeLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
  _stockCodeLabel.backgroundColor = [UIColor clearColor];

  //股票名称
  _stockNameLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(_stockCodeLabel.right, 0, Font_Height_14_0 * 4, HEIGHT_OF_BUY_CELL)];
  _stockNameLabel.backgroundColor = [UIColor clearColor];
  _stockNameLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  _stockNameLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
  _stockNameLabel.backgroundColor = [UIColor clearColor];

  //底边灰线。因为tableView自带的分割线不管cell有没有数据都会显示分割线，显得特别乱。
  //上(分割线)
  _upLineView =
      [[UIView alloc] initWithFrame:CGRectMake(0.0, HEIGHT_OF_BUY_CELL - 1.0, WIDTH_OF_SCREEN, 0.5)];
  _upLineView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];

  //下(分割线)
  _downLineView =
      [[UIView alloc] initWithFrame:CGRectMake(0.0, HEIGHT_OF_BUY_CELL - 0.5, WIDTH_OF_SCREEN, 0.5)];
  _downLineView.backgroundColor = [Globle colorFromHexRGB:Color_White];

  [self.contentView addSubview:_stockCodeLabel];
  [self.contentView addSubview:_stockNameLabel];
  [self.contentView addSubview:_upLineView];
  [self.contentView addSubview:_downLineView];
}

//设置cell信息
- (void)setInformationWithDBTableItem:(StockFunds *)tableDBItem {
  _stockCodeLabel.text = tableDBItem.stockCode;
  _stockNameLabel.text = tableDBItem.name;
  [SimuUtil widthOfLabel:_stockNameLabel font:Font_Height_14_0];
}

@end
