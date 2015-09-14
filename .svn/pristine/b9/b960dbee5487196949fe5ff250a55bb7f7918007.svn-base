//
//  FinancialDetailsCell.m
//  SimuStock
//
//  Created by moulin wang on 15/4/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FinancialDetailsCell.h"
#import "ProcessInputData.h"


@interface FinancialDetailsCell ()
/**
 *  名字 项目名称
 */
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  日期
 */
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
/**
 *  金额
 */
@property (strong, nonatomic) IBOutlet UILabel *moreyLabel;

@end

@implementation FinancialDetailsCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)bindDataForCell:(WFfinancialDetailsModeData *)mode
{
  self.nameLabel.text = mode.flowDesc;
  self.timeLabel.text = [SimuUtil getDateFromCtime:@([mode.flowDatetime longLongValue])];
  NSString *flowAmount = [ProcessInputData convertMoneyString:mode.flowAmount];
  UIColor *color = [Globle colorFromHexRGB:Color_Gray];
  if ([flowAmount doubleValue] != 0) {
    color = [flowAmount doubleValue] > 0 ? [Globle colorFromHexRGB:Color_Red] : [Globle colorFromHexRGB:Color_Green];
  }
  self.moreyLabel.textColor = color;
  self.moreyLabel.text = flowAmount;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
