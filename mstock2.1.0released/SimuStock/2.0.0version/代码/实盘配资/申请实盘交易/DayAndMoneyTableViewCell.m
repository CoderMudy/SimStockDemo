//
//  DayAndMoneyTableViewCell.m
//  SimuStock
//
//  Created by Mac on 15/5/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "DayAndMoneyTableViewCell.h"
#import "WFInquireProductInfo.h"
@implementation DayAndMoneyTableViewCell

- (void)bindMoney:(WFProductListInfo *)productInfo {
  _titleLabel.text = @"选择操盘金额";
  _titleLabelsmall.text = @"";
  _timeLabel.text = @"";

  [self setSelectedButtonFrame:productInfo.amounts];
  NSMutableArray *btnInfoArray = [NSMutableArray array];

  for (int i = 0; i < [productInfo.amounts count]; i++) {
    NSString *amountStr = productInfo.amounts[i];
    WFProductButtonStateData *btnData = [[WFProductButtonStateData alloc] init];
    if ([amountStr isEqualToString:@""]) {
      btnData.Amount = amountStr;
      btnData.State = YES;
    } else {
      NSInteger amount = [amountStr integerValue];
      amount = amount / 100;
      if (amount >= 10000) {
        btnData.Amount =
            [NSString stringWithFormat:@"%ld万元", (long)amount / 10000];
      } else {
        btnData.Amount = [NSString stringWithFormat:@"%ld元", (long)amount];
      }
      if ([productInfo.amountStatusA count] > i) {
        btnData.State = [productInfo.amountStatusA[i] boolValue];
      } else {
        btnData.State = YES;
      }
    }
    [btnInfoArray addObject:btnData];
  }
  [self.selectedButtons addButton:btnInfoArray];
  self.selectedButtons.section = 0;
}

- (void)bindDays:(NSArray *)days {
  _titleLabel.text = @"选择操盘天数";
  _titleLabelsmall.text = @"(交易日)";

  [self setSelectedButtonFrame:days];
  NSMutableArray *btnInfoArray = [NSMutableArray array];
  for (int i = 0; i < [days count]; i++) {
    WFProductButtonStateData *btnData = [[WFProductButtonStateData alloc] init];
    NSString *day = days[i];
    if ([day isEqualToString:@""]) {
      btnData.State = YES;
      [btnInfoArray addObject:btnData];
      continue;
    }
    btnData.Amount = [NSString stringWithFormat:@"%@天", days[i]];
    btnData.State = NO;
    [btnInfoArray addObject:btnData];
  }
  [self.selectedButtons addButton:btnInfoArray];
  self.selectedButtons.section = 2;
}

- (void)awakeFromNib {
}

- (void)setSelectedButtonFrame:(NSArray *)array {

  if (array) {
    int numTimer = (int)([array count] + 3) / 4;
    self.selectedButtons.frame =
        CGRectMake(0, 26, self.width, 41 * numTimer + 1);
  } else {
    self.selectedButtons.frame = CGRectMake(0, 26, self.width, 41 + 1);
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

@end
