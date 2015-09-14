//
//  PlanTableViewCell.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertPlanData.h"

@interface PlanTableViewCell : UITableViewCell
/** 计划运行时间 */
@property (weak, nonatomic) IBOutlet UILabel *functionTimeLabel;

/** 目标收益 */
@property (weak, nonatomic) IBOutlet UILabel *targetProfitLabel;

/** 止损线 */
@property (weak, nonatomic) IBOutlet UILabel *stopLineLabel;

/** 计划期限 */
@property (weak, nonatomic) IBOutlet UILabel *planTimeLimitLabel;

//cell绑定数据
-(void)bindDataForCell:(UserOrProjectNotPurchasedNotRunning *)user;

@end

