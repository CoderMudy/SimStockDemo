//
//  WFHistoryFirmCell.m
//  SimuStock
//
//  Created by moulin wang on 15/4/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFHistoryFirmCell.h"

@interface WFHistoryFirmCell ()
/** 配资的数目  */
@property(strong, nonatomic) IBOutlet UILabel *numMorey;
/** 配资的数目 的单位 千 或 万  */
@property(strong, nonatomic) IBOutlet UILabel *companyLabel;
/** 配资天数 */
@property(strong, nonatomic) IBOutlet UILabel *daysTime;
/** 浮动盈亏  */
@property(strong, nonatomic) IBOutlet UILabel *floatingProfitLossLabel;
/** 结算时间  */
@property(strong, nonatomic) IBOutlet UILabel *settlementOfTime;
/** 返还保证金  */
@property(strong, nonatomic) IBOutlet UILabel *theReturnDepositLabel;
/** 结算总资产  */
@property(strong, nonatomic) IBOutlet UILabel *settkenebtMorey;

@end

@implementation WFHistoryFirmCell

- (IBAction)tapAction:(UIButton *)sender {
  NSLog(@"dfadsfadsfasdfadf");
  if (self.degetale && [self.degetale respondsToSelector:@selector(cellDown)]) {
    [self.degetale cellDown];
  }
}

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
