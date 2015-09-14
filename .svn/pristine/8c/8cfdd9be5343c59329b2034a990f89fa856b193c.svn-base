//
//  FirmSaleSellStockCell.m
//  SimuStock
//
//  Created by Yuemeng on 14-9-28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "FirmSaleSellStockCell.h"

#import "TopAndBottomAlignmentLabel.h"
#import "StockUtil.h"

@interface FirmSaleSellStockCell () {
  //股票名称
  TopAndBottomAlignmentLabel *_stockNameLabel;
  //股票代码
  TopAndBottomAlignmentLabel *_stockCodeLabel;
  //盈亏率背景图
  //    UIView *_stockProfitView;
  //盈亏率
  UILabel *_stockProfitLabel;
  //可卖股数
  UILabel *_stockCouldSellAmount;
}

@end

@implementation FirmSaleSellStockCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    [self createUI];
  }
  return self;
}

- (void)createUI {
  self.backgroundColor = [UIColor clearColor];

  CGFloat labelWidth = WIDTH_OF_SCREEN / 3.0;
  CGFloat labelHeight = self.bounds.size.height;

  //股票名称
  _stockNameLabel =
      [[TopAndBottomAlignmentLabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight / 2)];
  _stockNameLabel.text = @"";
  _stockNameLabel.textAlignment = NSTextAlignmentCenter;
  _stockNameLabel.verticalAlignment = VerticalAlignmentBottom; //底部居中对齐
  _stockNameLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
  _stockNameLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
  [self addSubview:_stockNameLabel];

  //股票代码
  _stockCodeLabel =
      [[TopAndBottomAlignmentLabel alloc] initWithFrame:CGRectMake(0, labelHeight / 2, labelWidth, labelHeight / 2)];
  _stockCodeLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
  _stockCodeLabel.text = @"";
  _stockCodeLabel.textAlignment = NSTextAlignmentCenter;
  _stockCodeLabel.verticalAlignment = VerticalAlignmentTop; //顶部居中对齐
  _stockCodeLabel.textColor = [Globle colorFromHexRGB:Color_Stock_Code];
  [self addSubview:_stockCodeLabel];

  //    //盈亏率背景图（红、绿色）
  //    CGFloat spaceVertical =
  //    labelHeight*0.4;//还需要具体确定，目前为高度的0.5
  ////    CGFloat spaceHorizontal =
  /// spaceVertical*2;//还需要具体确定，目前为高度的0.4，暂时先按字符数量算
  //    _stockProfitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
  //    labelWidth-Font_Height_14_0*3, labelHeight-spaceVertical)];
  //    _stockProfitView.center = self.center;//由于label是等分的，所以肯定居中
  //    _stockProfitView.layer.cornerRadius = labelHeight/10.0;
  //    [self addSubview:_stockProfitView];

  //盈亏率
  _stockProfitLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, 0, labelWidth, labelHeight)];
  //    _stockProfitLabel.backgroundColor = [UIColor clearColor];
  _stockProfitLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
  _stockProfitLabel.text = @"";
  _stockProfitLabel.textAlignment = NSTextAlignmentCenter;
  _stockProfitLabel.textColor = [UIColor whiteColor]; //靠背景色来区别颜色
  [self addSubview:_stockProfitLabel];

  //可卖股数
  _stockCouldSellAmount =
      [[UILabel alloc] initWithFrame:CGRectMake(labelWidth * 2, 0, labelWidth, labelHeight)];
  //    _stockCouldSellAmount.backgroundColor = [UIColor clearColor];
  _stockCouldSellAmount.font = [UIFont systemFontOfSize:Font_Height_14_0];
  _stockCouldSellAmount.text = @"";
  _stockCouldSellAmount.textAlignment = NSTextAlignmentCenter;
  _stockCouldSellAmount.textColor = [Globle colorFromHexRGB:Color_Dark];
  [self addSubview:_stockCouldSellAmount];

  //底边灰线。因为tableView自带的分割线不管cell有没有数据都会显示分割线，显得特别乱。
  //上(分割线)
  UIView *upLineView =
      [[UIView alloc] initWithFrame:CGRectMake(0.0, self.bounds.size.height - 1.0, WIDTH_OF_SCREEN, 0.5)];
  upLineView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  [self.contentView addSubview:upLineView];
  //下(分割线)
  UIView *downLineView =
      [[UIView alloc] initWithFrame:CGRectMake(0.0, self.bounds.size.height - 0.5, WIDTH_OF_SCREEN, 0.5)];
  downLineView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [self.contentView addSubview:downLineView];
}

#pragma mark - 外部调用，设置数据
- (void)setCellData:(PositionResult *)data {
  if (!data) {
    return;
  }

  NSInteger availiableStockAmount = [data.availableStock integerValue];
  //如果可用股份小于0，则不显示cell
  if (availiableStockAmount <= 0) {
    return;
  }

  _stockNameLabel.text = data.stockName;
  _stockCodeLabel.text = data.stockCode;
  _stockProfitLabel.text = data.profitLossRate;
  _stockCouldSellAmount.text = [data.availableStock stringValue];

  //给文字上色
  CGFloat profit = [_stockProfitLabel.text floatValue];
  _stockProfitLabel.textColor = [StockUtil getColorByFloat:profit];
}

#pragma mark - 配资数据 复制
- (void)setCapitalData:(WFfirmStockListData *)data {
  if (!data) {
    return;
  }

  NSInteger availiableStockAmount = [data.enableAmount integerValue];
  if (availiableStockAmount <= 0) {
    return;
  }

  _stockNameLabel.text = data.stockName;
  _stockCodeLabel.text = data.stockCode;
  _stockProfitLabel.text = data.profitRate;
  _stockCouldSellAmount.text = data.enableAmount;

  CGFloat profit = [_stockProfitLabel.text floatValue];
  _stockProfitLabel.textColor = [StockUtil getColorByFloat:profit];
}

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
