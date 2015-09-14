//
//  HomeAssetInfoSuperView.h
//  SimuStock
//
//  Created by Jhss on 15/7/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Block.h"
#import "HomePageTableHeaderData.h"
#import "SimuRankPageData.h"
#import "HomePageTableHeaderData.h"

@interface HomeAssetInfoSuperView : UIView

/** 总资产 */
@property(weak, nonatomic) IBOutlet UILabel *totalAssetsLabel;
/** 总排行 */
@property(weak, nonatomic) IBOutlet UILabel *totalRankLabel;
/** 股票数值 */
@property(weak, nonatomic) IBOutlet UILabel *stockValueLabel;
/** 持股盈亏 */
@property(weak, nonatomic) IBOutlet UILabel *profitAndLossLabel;
/** 资金余额 */
@property(weak, nonatomic) IBOutlet UILabel *fundBalanceLabel;
/** 聊股数 */
@property(weak, nonatomic) IBOutlet UILabel *chatNumberLabel;
/** 成功率 */
@property(weak, nonatomic) IBOutlet UILabel *successRateLabel;
/** 平均持股天数 */
@property(weak, nonatomic) IBOutlet UILabel *holdTimeLabel;
/** 产看交易明细按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *transactionDetailsBtn;

/** user数据 */
@property(strong, nonatomic) HomePageTableHeaderData *userInformationData;

/** 绑定资产信息 */
- (void)bindTotalAssetsAndOtherDisplayRelatedData:
    (HomePageTableHeaderData *)informationDic;

@end
