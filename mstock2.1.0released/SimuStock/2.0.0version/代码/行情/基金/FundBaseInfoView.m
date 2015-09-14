//
//  FundBaseInfoView.m
//  SimuStock
//
//  Created by Mac on 15/5/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FundBaseInfoView.h"
#import "StockUtil.h"

///当前价文字大小
static CGFloat CurPriceTextSize = 40.f;

///价格增幅和比率的文字大小
static CGFloat ChangeValueAndRateTextSize = 16.f;

///其他信息的文字大小
static CGFloat OtherInfoTextSize = 11.5f;

///默认显示的值
static NSString *VALUE_DEFALT = @"--";

///内容项的颜色
static UIColor *labelColor;

///内容项对应的值得默认颜色
static UIColor *ValueDefaultColor;

///底部列之间的间距
static CGFloat bottomColumnGap = 8.f;

@implementation FundBaseInfoView {

  UIFont *curPriceFont;
  UIFont *changeValueAndRateFont;
  UIFont *f10Font;

  NSMutableParagraphStyle *alignCenterStyle;

  NSMutableParagraphStyle *alignLeftStyle;

  NSMutableParagraphStyle *alignRightStyle;
}

- (void)measure {
  CGFloat width = self.bounds.size.width / 2.f;
  CGFloat topPrice = 2.f;
  curPriceRect = CGRectMake(0, topPrice, width, CurPriceTextSize + 2);

  CGFloat topAddition = topPrice + CurPriceTextSize + 1;
  changeValueAndRateRect =
      CGRectMake(0, topAddition, width, ChangeValueAndRateTextSize + 2);
}

/** 上部Key */
static NSArray *keysTop;
/** 下部Key */
static NSArray *keysBottom;

- (void)resetDefaultValues {
  keysTop = @[ @"最高", @"最低", @"今开", @"昨收" ];
  valuesTop = [
      @[ VALUE_DEFALT, VALUE_DEFALT, VALUE_DEFALT, VALUE_DEFALT ] mutableCopy];
  keysBottom = @[
    @"单位净值",
    @"累计净值",
    @"折溢价率",
    @"资产净值",
    @"基金份额",
    @"成交量"
  ];
  valuesBottom = [@[
    VALUE_DEFALT,
    VALUE_DEFALT,
    VALUE_DEFALT,
    VALUE_DEFALT,
    VALUE_DEFALT,
    VALUE_DEFALT
  ] mutableCopy];
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    alignCenterStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [alignCenterStyle setAlignment:NSTextAlignmentCenter];

    alignLeftStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [alignLeftStyle setAlignment:NSTextAlignmentLeft];

    alignRightStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [alignRightStyle setAlignment:NSTextAlignmentRight];

    curPriceFont = [UIFont systemFontOfSize:CurPriceTextSize];
    changeValueAndRateFont =
        [UIFont systemFontOfSize:ChangeValueAndRateTextSize];
    f10Font = [UIFont systemFontOfSize:OtherInfoTextSize];

    labelColor = [Globle colorFromHexRGB:@"#939393"];
    ValueDefaultColor = [Globle colorFromHexRGB:@"#454545"];

    self.backgroundColor = [UIColor clearColor];

    [self resetDefaultValues];

    [self measure];
    [self bindFundCurStatus:nil];
  }
  return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

  //绘制最新价
  CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),
                                 priceColor.CGColor);
  [currentPrice drawInRect:curPriceRect
                  withFont:curPriceFont
             lineBreakMode:NSLineBreakByWordWrapping
                 alignment:NSTextAlignmentCenter];
  //            withAttributes:@{
  //              NSFontAttributeName : curPriceFont,
  //              NSParagraphStyleAttributeName : alignCenterStyle,
  //              NSForegroundColorAttributeName : priceColor
  //            }];
  [changeValueAndRate drawInRect:changeValueAndRateRect
                        withFont:changeValueAndRateFont
                   lineBreakMode:NSLineBreakByWordWrapping
                       alignment:NSTextAlignmentCenter];

  //  [changeValueAndRate drawInRect:changeValueAndRateRect
  //                  withAttributes:@{
  //                    NSFontAttributeName : changeValueAndRateFont,
  //                    NSParagraphStyleAttributeName : alignCenterStyle,
  //                    NSForegroundColorAttributeName : priceColor
  //                  }];

  //绘制右上部分：max, min, open, last price
  CGFloat width = self.bounds.size.width;
  CGFloat leftX = width * 7.f / 12.f;
  CGFloat rightX = width * 7.f / 9.f;
  CGFloat topMargin = 2.f;
  CGFloat rowHeight = textSize + lineSpace;
  [keysTop
      enumerateObjectsUsingBlock:^(NSString *lbl, NSUInteger idx, BOOL *stop) {
        NSInteger row = idx / 2;
        CGFloat x = idx % 2 == 0 ? leftX : rightX;
        CGFloat yLabel = topMargin + rowHeight * row * 2;
        CGFloat yValue = yLabel + rowHeight;

        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),
                                       labelColor.CGColor);
        [lbl drawAtPoint:CGPointMake(x, yLabel) withFont:f10Font];
        //        [lbl drawAtPoint:CGPointMake(x, yLabel)
        //            withAttributes:@{
        //              NSFontAttributeName : f10Font,
        //              NSParagraphStyleAttributeName : alignLeftStyle,
        //              NSForegroundColorAttributeName : labelColor
        //            }];
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),
                                       ValueDefaultColor.CGColor);
        if (stockInfo) {
          [valuesTop[idx] drawAtPoint:CGPointMake(x, yValue) withFont:f10Font];
          //          [valuesTop[idx] drawAtPoint:CGPointMake(x, yValue)
          //                       withAttributes:@{
          //                         NSFontAttributeName : f10Font,
          //                         NSParagraphStyleAttributeName :
          //                         alignLeftStyle,
          //                         NSForegroundColorAttributeName :
          //                         valueDefaultColor
          //                       }];
        } else {
          [valuesTop[idx] drawAtPoint:CGPointMake(x + textSize / 2.f, yValue)
                             withFont:f10Font];
          //          [valuesTop[idx] drawAtPoint:CGPointMake(x + textSize /
          //          2.f, yValue)
          //                       withAttributes:@{
          //                         NSFontAttributeName : f10Font,
          //                         NSParagraphStyleAttributeName :
          //                         alignCenterStyle,
          //                         NSForegroundColorAttributeName :
          //                         valueDefaultColor
          //                       }];
        }
      }];

  CGFloat bottomLineSpace = 5.f;
  CGFloat yBottomStart = topMargin + rowHeight * 4 + bottomLineSpace;

  CGFloat bottomWidth = (width - bottomColumnGap) / 3;

  CGFloat bottomRowHeight = textSize + bottomLineSpace;
  [keysBottom
      enumerateObjectsUsingBlock:^(NSString *lbl, NSUInteger idx, BOOL *stop) {
        NSInteger row = idx / 3;
        CGFloat x = bottomColumnGap + bottomWidth * (idx % 3);
        CGFloat yLabel = yBottomStart + bottomRowHeight * row;
        CGFloat xValue = x + textSize * 3;
        CGFloat widthValue = x + bottomWidth - bottomColumnGap - xValue;
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),
                                       labelColor.CGColor);
        [lbl drawAtPoint:CGPointMake(x, yLabel) withFont:f10Font];
        //        [lbl drawAtPoint:CGPointMake(x, yLabel)
        //            withAttributes:@{
        //              NSFontAttributeName : f10Font,
        //              NSParagraphStyleAttributeName : alignLeftStyle,
        //              NSForegroundColorAttributeName : labelColor
        //            }];
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),
                                       ValueDefaultColor.CGColor);
        if (stockInfo) {
          if (idx % 3 == 2) {
            xValue -= textSize * 2;
            widthValue += textSize * 2;
          }
          [valuesBottom[idx]
                 drawInRect:CGRectMake(xValue, yLabel, widthValue, rowHeight)
                   withFont:f10Font
              lineBreakMode:NSLineBreakByWordWrapping
                  alignment:NSTextAlignmentRight];
          //          [valuesBottom[idx]
          //                  drawInRect:CGRectMake(xValue, yLabel, widthValue,
          //                  rowHeight)
          //              withAttributes:@{
          //                NSFontAttributeName : f10Font,
          //                NSParagraphStyleAttributeName : alignRightStyle,
          //                NSForegroundColorAttributeName : valueDefaultColor
          //              }];
        } else {
          [valuesBottom[idx]
                 drawInRect:CGRectMake(xValue, yLabel, textSize * 5, rowHeight)
                   withFont:f10Font
              lineBreakMode:NSLineBreakByWordWrapping
                  alignment:NSTextAlignmentCenter];
          //          [valuesBottom[idx]
          //                  drawInRect:CGRectMake(xValue, yLabel, textSize *
          //                  5, rowHeight)
          //              withAttributes:@{
          //                NSFontAttributeName : f10Font,
          //                NSParagraphStyleAttributeName : alignCenterStyle,
          //                NSForegroundColorAttributeName : valueDefaultColor
          //              }];
        }

      }];
}

static CGFloat textSize = 14.f;
static CGFloat lineSpace = 1.f;

- (void)bindFundCurStatus:(FundCurStatus *)data {
  stockInfo = data;

  if (stockInfo) {
    NSString *formatter = [NSString
        stringWithFormat:@"%%.%ldf", (long)stockInfo.fund.decimalDigits];

    currentPrice = [NSString stringWithFormat:formatter, stockInfo.curPrice];
    priceColor = [@"0.000" isEqualToString:currentPrice]
                     ? ValueDefaultColor
                     : [StockUtil getColorByFloat:(stockInfo.curPrice -
                                                   stockInfo.closePrice)];
    changeValueAndRate = [stockInfo getChangeValueAndRate];

    valuesTop[0] = [NSString stringWithFormat:formatter, stockInfo.highPrice];
    valuesTop[1] = [NSString stringWithFormat:formatter, stockInfo.lowPrice];
    valuesTop[2] = [NSString stringWithFormat:formatter, stockInfo.openPrice];
    valuesTop[3] = [NSString stringWithFormat:formatter, stockInfo.closePrice];

    valuesBottom[0] = [NSString stringWithFormat:@"%.4f", stockInfo.unitNAV];
    valuesBottom[1] =
        [NSString stringWithFormat:@"%.4f", stockInfo.accuUnitNAV];
    valuesBottom[2] =
        [NSString stringWithFormat:@"%+.2f%%", stockInfo.discountRate];
    valuesBottom[3] = [StockUtil formatAmount:stockInfo.NAVEnd isVolum:NO];
    valuesBottom[4] = [StockUtil formatAmount:stockInfo.latestShare isVolum:NO];
    valuesBottom[5] =
        [StockUtil formatAmount:stockInfo.totalAmount isVolum:YES];
  } else {
    currentPrice = VALUE_DEFALT;
    changeValueAndRate = VALUE_DEFALT;
    priceColor = ValueDefaultColor;

    [self resetDefaultValues];
  }
  [self setNeedsDisplay];
}

@end
