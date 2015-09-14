//
//  WithdrawDetailCell.h
//  SimuStock
//
//  Created by jhss_wyz on 15/4/22.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawDetailCell : UITableViewCell

/** 提现时间 */
@property(weak, nonatomic) IBOutlet UILabel *withdrawDatetime;
/** 提现金额 */
@property(weak, nonatomic) IBOutlet UILabel *withdrawAmount;
/** 提现状态 */
@property(weak, nonatomic) IBOutlet UILabel *withdrawStatus;
/** cell下方的分割视图 */
@property(weak, nonatomic) IBOutlet UIView *marginView;

/////获取当前提现订单的状态
//-(NSString *)getWithdrawStatus:(int)status;
@end
