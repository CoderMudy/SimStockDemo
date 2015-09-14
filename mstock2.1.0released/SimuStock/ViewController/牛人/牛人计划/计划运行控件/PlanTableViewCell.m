//
//  PlanTableViewCell.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

@implementation PlanTableViewCell

//xib
- (void)awakeFromNib {
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

//绑定数据 当前收益
-(void)bindDataForCell:(UserOrProjectNotPurchasedNotRunning *)user
{
  //计划开始时间
  self.functionTimeLabel.text = user.planStartTime;
  //目标收益
  self.targetProfitLabel.text = [ProcessInputData floatingPointNumberIntoPercentage:user.targetProfit];
  //止损线
  self.stopLineLabel.text = [ProcessInputData floatingPointNumberIntoPercentage:user.stopLossLine];
  //计划期限
  self.planTimeLimitLabel.text = [NSString stringWithFormat:@"%@个月",user.planTimeLimit];
}

@end
