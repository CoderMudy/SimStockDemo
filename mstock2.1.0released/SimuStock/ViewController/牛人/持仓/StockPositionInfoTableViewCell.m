//
//  StockPositionInfoTableViewCell.m
//  SimuStock
//
//  Created by Mac on 15/7/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockPositionInfoTableViewCell.h"
#import "Globle.h"
#import "StockUtil.h"

@implementation StockPositionInfoTableViewCell

- (void)awakeFromNib {
  //左边的弧形条
  _ivLine.clipsToBounds = YES;
  self.clipsToBounds = YES;
  CALayer *userLayer = _ivLine.layer;
  [userLayer setCornerRadius:6.0];
  userLayer.borderWidth = 1;

  NSArray *buttons = @[ _btnBuy, _btnSell, _btnMarket, _btnTradeList ];
  [buttons enumerateObjectsUsingBlock:^(BGColorUIButton *button, NSUInteger idx,
                                        BOOL *stop) {

    [button.layer setMasksToBounds:YES];
    button.layer.cornerRadius = 11.f;
    [button.layer
        setBorderColor:[[Globle
                           colorFromHexRGB:Color_Blue_but] CGColor]]; //描边颜色
    [button.layer setBorderWidth:0.5]; //描边粗细

    button.normalBGColor = [Globle colorFromHexRGB:Color_White];
    button.highlightBGColor = [Globle colorFromHexRGB:Color_Blue_but];
    button.normalTitleColor = [Globle colorFromHexRGB:Color_Blue_but];
    button.highlightTitleColor = [Globle colorFromHexRGB:Color_White];
    [button setTitleColor:[Globle colorFromHexRGB:Color_Gray]
                 forState:UIControlStateDisabled];
  }];

  __weak StockPositionInfoTableViewCell *weakSelf = self;
  [_btnBuy setOnButtonPressedHandler:^{
    if (weakSelf.buyAction) {
      weakSelf.buyAction(weakSelf.positionInfo);
    }
  }];
  [_btnSell setOnButtonPressedHandler:^{
    if (weakSelf.sellAction) {
      weakSelf.sellAction(weakSelf.positionInfo);
    }
  }];
  [_btnMarket setOnButtonPressedHandler:^{
    if (weakSelf.marketAction) {
      weakSelf.marketAction(weakSelf.positionInfo);
    }
  }];
  [_btnTradeList setOnButtonPressedHandler:^{
    if (weakSelf.tradeListAction) {
      weakSelf.tradeListAction(weakSelf.positionInfo);
    }
  }];
}

- (void)bindPositionInfo:(PositionInfo *)positionInfo {
  self.positionInfo = positionInfo;

  //股票名称(代码)
  _lblStock.text = [NSString
      stringWithFormat:@"%@（%@）", positionInfo.stockName,
                       [StockUtil sixStockCode:positionInfo.stockCode]];

  ///持仓率
  if ([@"" isEqualToString:positionInfo.positionRate]) {
    _lblPositionRate.text = @"";
  } else {
    _lblPositionRate.text =
        [positionInfo.positionRate stringByAppendingString:@"仓"];
  }

  //盈亏金额(盈亏率)
  NSString *format =
      [StockUtil getPriceFormatWithTradeType:positionInfo.tradeType];
  NSString *profit = [NSString stringWithFormat:format, positionInfo.profit];

  UIColor *profitColor = [StockUtil getColorByProfit:positionInfo.profitRate];
  NSMutableAttributedString *profitAndRateText =
      [[NSMutableAttributedString alloc]
          initWithString:[NSString stringWithFormat:@"%@ (%@)", profit,
                                                    positionInfo.profitRate]];
  [profitAndRateText addAttribute:NSForegroundColorAttributeName
                            value:profitColor
                            range:NSMakeRange(0, [profit length])];
  [profitAndRateText
      addAttribute:NSForegroundColorAttributeName
             value:profitColor
             range:NSMakeRange([profit length] + 2,
                               [positionInfo.profitRate length])];
  _lblProfit.attributedText = profitAndRateText;

  //当前价
  NSString *curPrice =
      [NSString stringWithFormat:format, positionInfo.curPrice];
  UIColor *curPriceColor =
      [StockUtil getColorByProfit:positionInfo.changePercent];
  NSMutableAttributedString *curPriceAndChangeRateText = [
      [NSMutableAttributedString alloc]
      initWithString:[NSString stringWithFormat:@"%@ (%@)", curPrice,
                                                positionInfo.changePercent]];
  [curPriceAndChangeRateText addAttribute:NSForegroundColorAttributeName
                                    value:curPriceColor
                                    range:NSMakeRange(0, [curPrice length])];
  [curPriceAndChangeRateText
      addAttribute:NSForegroundColorAttributeName
             value:curPriceColor
             range:NSMakeRange([curPrice length] + 2,
                               [positionInfo.changePercent length])];

  _lblCurPrice.attributedText = curPriceAndChangeRateText;
  //成本价
  _lblBuyPrice.text =
      [NSString stringWithFormat:format, positionInfo.costPrice];

  //持股数量(可卖数)
  if (_showSellableAmount) {
    _lblStockAmount.text =
        [NSString stringWithFormat:@"%@ (可卖%lld)", positionInfo.amount,
                                   positionInfo.sellableAmount];
  } else {
    _lblStockAmount.text =
        [NSString stringWithFormat:@"%@", positionInfo.amount];
  }

  //持股市值
  _lblPositonStockValue.text =
      [NSString stringWithFormat:format, positionInfo.value];

  if (positionInfo.bProfit) {
    _ivLine.layer.borderColor = [[Globle colorFromHexRGB:@"#ae1e20"] CGColor];
    [self drawGradientColor:0];
  } else {
    _ivLine.layer.borderColor = [[Globle colorFromHexRGB:@"#077636"] CGColor];
    [self drawGradientColor:1];
  }
}

//绘制渐变色
- (void)drawGradientColor:(NSInteger)colorType {
  UIGraphicsBeginImageContext(_ivLine.frame.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
  CGFloat colors[2][8] = {{195.0 / 255.0, 34.0 / 255.0, 36.0 / 255.0, 1,
                           219.0 / 255.0, 26.0 / 255.0, 27.0 / 255.0, 1},
                          {8.0 / 255.0, 133.0 / 255.0, 61.0 / 255.0, 1,
                           9.0 / 255.0, 149.0 / 255.0, 68.0 / 255.0, 1}};
  CGGradientRef gradient =
      CGGradientCreateWithColorComponents(rgb, colors[colorType], NULL, 2);
  CGColorSpaceRelease(rgb);
  CGContextDrawLinearGradient(
      context, gradient, CGPointMake(0, _ivLine.frame.size.height),
      CGPointMake(0, 0), kCGGradientDrawsAfterEndLocation);
  _ivLine.image = UIGraphicsGetImageFromCurrentImageContext();
  CGGradientRelease(gradient);
}

//展开或收缩
- (void)fold:(BOOL)fold {
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(stop)];
  CGFloat height = fold ? FoldHeight : UnFoldHeight;
  _ivTriangle.hidden = !fold;
  _buttonContainer.hidden = fold;
  self.frame = CGRectMake(0, 0, self.frame.size.width, height);

  [UIView commitAnimations];
}

@end
