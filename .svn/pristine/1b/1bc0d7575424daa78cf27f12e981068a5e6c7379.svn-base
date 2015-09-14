//
//  ProfitOrPlanDaysView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ProfitOrPlanDaysView.h"
#import "UILabel+SetProperty.h"
#import "StockUtil.h"

@implementation ProfitOrPlanDaysView

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    _dataBinded = NO;
    UIView *containerView =
        [[[UINib nibWithNibName:@"ProfitOrPlanDaysView" bundle:nil]
            instantiateWithOwner:self
                         options:nil] objectAtIndex:0];
    CGRect newFrame =
        CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    containerView.frame = newFrame;
    [self addSubview:containerView];
  }
  return self;
}

- (void)bindDataForProfitOrPlanDays:(EPPlanGoalViewData *)planGoalData {
  [self bindDataForProfitOrPlanDays:planGoalData withForceRefresh:NO];
}

///绑定数据
- (void)bindDataForProfitOrPlanDays:(EPPlanGoalViewData *)planGoalData
                   withForceRefresh:(BOOL)forceRefresh {
  if (_dataBinded && !forceRefresh) {
    return;
  }
  _dataBinded = YES;
  //绑定数据
  //得到 收益率的颜色

  CGFloat profitRate = planGoalData.currentProfit * 100;
  //如果盈利率为0.00% or -0.00%时，黑色显示
  if ([@"0.00" isEqualToString:[NSString stringWithFormat:@"%0.2f",
                                                          fabs(profitRate)]]) {
    profitRate = 0;
  }
  UIColor *currentProfitRateColor = [StockUtil getColorByFloat:profitRate];

  //后半段字体的颜色
  UIColor *secondColor = [Globle colorFromHexRGB:@"#454545"];

  //前半段字体的大小
  UIFont *font = [UIFont systemFontOfSize:20];
  //后半段字体的大小
  UIFont *secondFont = [UIFont systemFontOfSize:14];

  //当前收益 目标收益
  NSString *firstRate = [NSString stringWithFormat:@"%0.2f%%", profitRate];
  NSString *secondRate = [NSString
      stringWithFormat:@"%ld%%", (long)(planGoalData.targetProfit * 100)];

  //后半段文字
  NSString *secondText = [NSString stringWithFormat:@"/%@", secondRate];
  //运行天数 和 计划期限
  NSString *planDays =
      [NSString stringWithFormat:@"/%ld个月", (long)planGoalData.planTimeLimit];
  //运行天数的字段
  NSString *runningDays;
  if (planGoalData.runningDays < 0) {
    runningDays = @"0天";
  } else {
    runningDays =
        [NSString stringWithFormat:@"%ld天", (long)planGoalData.runningDays];
  }

  [self.currentRateLabel setAttributedTextWithFirstString:firstRate
                                             andFirstFont:font
                                            andFirstColor:currentProfitRateColor
                                          andSecondString:secondText
                                            andSecondFont:secondFont
                                           andSecondColor:secondColor];

  [self.runDayPlanLabel setAttributedTextWithFirstString:runningDays
                                            andFirstFont:font
                                           andFirstColor:secondColor
                                         andSecondString:planDays
                                           andSecondFont:secondFont
                                          andSecondColor:secondColor];
}
@end
