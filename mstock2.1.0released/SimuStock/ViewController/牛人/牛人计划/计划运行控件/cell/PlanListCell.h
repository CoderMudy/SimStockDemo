//
//  PlanListCell.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanListCell : UITableViewCell
/** 持仓盈亏 */
@property (weak, nonatomic) IBOutlet UILabel *positionProfitLossLable;
/** 持股市值 */
@property (weak, nonatomic) IBOutlet UILabel *stockMarketValueLabel;
/** 资金余额 */
@property (weak, nonatomic) IBOutlet UILabel *capitalBalanceLabel;
/** 总资产 */
@property (weak, nonatomic) IBOutlet UILabel *totalAssetsLabel;

@end
