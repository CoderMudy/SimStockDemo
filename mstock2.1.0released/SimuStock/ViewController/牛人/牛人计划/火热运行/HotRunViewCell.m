//
//  HotRunViewCell.m
//  SimuStock
//
//  Created by Jhss on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "HotRunViewCell.h"
#import "StockUtil.h"
#import "UILabel+SetProperty.h"

@implementation HotRunViewCell

- (void)awakeFromNib {

  //设置运行天数的颜色
  self.runDaysLabel.textColor = [Globle colorFromHexRGB:Color_Red];
  self.runStatusLabel.textColor = [Globle colorFromHexRGB:Color_Blue_but];
  self.runBuyStatusLabel.textColor = [Globle colorFromHexRGB:@"#f45145"];

  ///内容根据label大小自动缩小
  self.runDaysLabel.adjustsFontSizeToFitWidth = YES;
  self.runProfitLabel.adjustsFontSizeToFitWidth = YES;
  self.runPalnName.adjustsFontSizeToFitWidth = YES;
}

///达标状态
- (void)setHotRunPlanStatus:(HotRunInfoItem *)item {
  if ([item.status isEqualToString:@"4"]) {
    self.runStatusLabel.text = @"已达标";
    self.runBuyStatusLabel.text = [self setBuyStatus:item.buystatus];
  } else if ([item.status isEqualToString:@"5"]) {
    self.runStatusLabel.text = @"未达标";
    self.runBuyStatusLabel.text = [self setBuyStatus:item.buystatus];
  } else {
    self.runBuyStatusLabel.hidden = YES;
    self.runStatusLabel.text = [self setBuyStatus:item.buystatus];
    self.runStatusLabel.textColor = [Globle colorFromHexRGB:@"#f45145"];
  }
}
///购买状态
- (NSString *)setBuyStatus:(NSString *)buyStatus {
  NSString *statusStr;
  if ([buyStatus isEqualToString:@"1"]) {
    statusStr = @"已购买";
  } else {
    statusStr = @"";
  }
  return statusStr;
}
- (void)bindHotRunPlanCellData:(HotRunInfoItem *)item {
  //计划名称
  self.runPalnName.text = item.name;
  //计划状态
  [self setHotRunPlanStatus:item];
  //如果是自己的计划显示“我的计划”
  if ([item.uid isEqualToString:[SimuUtil getUserID]]) {
    self.runStatusLabel.text = @"我的计划";
  }
  //当前收益
  NSString *Profit = [NSString
      stringWithFormat:@"%.2f%%",
                       [@([item.profitRate floatValue] * 100) floatValue]];
  //目标收益
  NSString *GoalProfit = [NSString
      stringWithFormat:@" /%.0f%%",
                       [@([item.goalProfit floatValue] * 100) floatValue]];
  [self.runProfitLabel
      setAttributedTextWithFirstString:Profit
                          andFirstFont:[UIFont
                                           systemFontOfSize:Font_Height_20_0]
                         andFirstColor:[StockUtil
                                           getColorByChangePercent:Profit]
                       andSecondString:GoalProfit
                         andSecondFont:[UIFont
                                           systemFontOfSize:Font_Height_10_0]
                        andSecondColor:[Globle
                                           colorFromHexRGB:Color_Text_Common]];
  //运行天数
  NSString *runDayNum = [item.runDay stringByAppendingString:@"天"];
  //计划期限
  NSString *planMonthsNum =
      [NSString stringWithFormat:@" /%@个月", item.goalMonths];

  [self.runDaysLabel
      setAttributedTextWithFirstString:runDayNum
                          andFirstFont:[UIFont
                                           systemFontOfSize:Font_Height_20_0]
                         andFirstColor:[Globle colorFromHexRGB:@"#f45145"]
                       andSecondString:planMonthsNum
                         andSecondFont:[UIFont
                                           systemFontOfSize:Font_Height_10_0]
                        andSecondColor:[Globle
                                           colorFromHexRGB:Color_Text_Common]];
}

@end
