//
//  PlanTimeView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PlanTimeView.h"
#import "ProcessInputData.h"
#import "StockUtil.h"

@implementation PlanTimeView

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    UIView *containerView = [[[UINib nibWithNibName:@"PlanTimeView" bundle:nil]
        instantiateWithOwner:self
                     options:nil] objectAtIndex:0];
    CGRect newFrame =
        CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    containerView.frame = newFrame;
    [self addSubview:containerView];
  }
  return self;
}

- (void)awakeFromNib {
}

//绑定数据 当前收益
- (void)bindDataForCell:(UserOrProjectNotPurchasedNotRunning *)user {
  //计划开始时间

  self.functionTimeLabel.text =
      [SimuUtil getDayDateFromCtime:@(user.planStartTime)];
  //目标收益
  UIColor *targetColor = [StockUtil getColorByFloat:user.targetProfit];
  NSString *targetString =
      [NSString stringWithFormat:@"%0.0f%%", user.targetProfit * 100];
  [ProcessInputData attributedTextWithString:targetString
                                   withColor:targetColor
                                 withUILabel:_targetProfitLabel];

  //止损线
  UIColor *stopColor = [StockUtil getColorByFloat:user.stopLossLine];
  NSString *stopNumber =
      [NSString stringWithFormat:@"%0.0f%%", user.stopLossLine * 100];
  [ProcessInputData attributedTextWithString:stopNumber
                                   withColor:stopColor
                                 withUILabel:_stopLineLabel];
  //计划期限
  self.planTimeLimitLabel.text =
      [NSString stringWithFormat:@"%ld个月", (long)user.planTimeLimit];
}

@end
