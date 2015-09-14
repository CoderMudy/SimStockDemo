//
//  WithdrawDetailCell.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/22.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WithdrawDetailCell.h"

@implementation WithdrawDetailCell

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

/////获取当前提现订单的状态
//-(NSString *)getWithdrawStatus:(int)status
//{
//  switch (status) {
//    case 0:
//      return @"正在处理";
//      break;
//    case 1:
//      return @"汇款完成";
//      break;
//    case 2:
//      return @"状态异常-关闭";
//      break;
//    default:
//      break;
//  }
//  return @"状态异常-关闭";
//}
@end
