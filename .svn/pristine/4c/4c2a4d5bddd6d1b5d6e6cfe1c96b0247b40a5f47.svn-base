//
//  EPPlanPositionView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "EPPlanPositionView.h"
#import "EPTradeDetailView.h"

@implementation EPPlanPositionView

+ (EPPlanPositionView *)createEPPlanPositionView {
  NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"EPPlanPositionView"
                                                 owner:self
                                               options:nil];
  return [array lastObject];
}

///数据绑定
- (void)bindDataForPositionView:(EPexpertPositionData *)data {

  self.currentPositionRateLabel.text = [NSString stringWithFormat:@"%0.2f%%",data.positionRate * 100];
  self.dataPosition = data;
}

- (IBAction)seeTradingRecordButtonAction:(UIButton *)sender {
  if (_dataPlan.planState == PlanStateRecruitmengPeriod) {
    [NewShowLabel setMessageContent:@"牛人计划未开始运行"];
    return;
  }

  EPTradeDetailView *vc =
      [[EPTradeDetailView alloc] initWithExpertPlanData:_dataPlan];
  [AppDelegate pushViewControllerFromRight:vc];
}
@end
