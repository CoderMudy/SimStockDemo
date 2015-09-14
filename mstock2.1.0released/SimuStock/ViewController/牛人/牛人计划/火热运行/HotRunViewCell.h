//
//  HotRunViewCell.h
//  SimuStock
//
//  Created by Jhss on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
/** 火热运行 cell样式  */
#import <UIKit/UIKit.h>
#import "HotRunInfoItem.h"

@interface HotRunViewCell : UITableViewCell

/** 计划名称 */
@property(weak, nonatomic) IBOutlet UILabel *runPalnName;
/** 计划运行状态 */
@property(weak, nonatomic) IBOutlet UILabel *runStatusLabel;
/** 计划购买状态 */
@property(weak, nonatomic) IBOutlet UILabel *runBuyStatusLabel;
/** 累计收益 */
@property(weak, nonatomic) IBOutlet UILabel *runProfitLabel;
/** 运行天数 */
@property(weak, nonatomic) IBOutlet UILabel *runDaysLabel;

/** 绑定火热运行数据 */
- (void)bindHotRunPlanCellData:(HotRunInfoItem *)item;

@end
