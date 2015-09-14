//
//  WithdrawalCashViewController.h
//  SimuStock
//
//  Created by jhss_wyz on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, WithdrawType) {
  /** 优顾 */
  YouGuuWithdrawType = 1,
  /** 连连 */
  LianLianWithdrawType = 2,
  /** 易宝 */
  YeeBaoWithdrawType = 3,
};
@interface LianLianWithdrawalCashViewController : BaseViewController

@property(nonatomic) WithdrawType SelectType;

- (id)initWithNumber:(WithdrawType)type;
@end
