//
//  ApplyActulTradingInfoView.h
//  SimuStock
//
//  Created by jhss_wyz on 15/3/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyActulTradingInfoView : UIView

/** 冻结保证金数额 */
@property(weak, nonatomic) IBOutlet UILabel *freezeDepositLabel;
/** 管理费数额 */
@property(weak, nonatomic) IBOutlet UILabel *managementFeeLable;

/** 冻结保证金标题 */
@property(weak, nonatomic) IBOutlet UILabel *depositTitle;
/** 管理费标题 */
@property(weak, nonatomic) IBOutlet UILabel *managementFeeTitle;

/** 总金额 */
@property(weak, nonatomic) IBOutlet UILabel *totalAmount;

/** 冻结保证金说明按钮 */
@property(weak, nonatomic) IBOutlet UIButton *depositInstructionBtn;
/** 账户管理费说明按钮 */
@property(weak, nonatomic) IBOutlet UIButton *feeInstructionBtn;

/** 通过ApplyActulTradingDayView.xib创建选项视图 */
+ (ApplyActulTradingInfoView *)applyActulTradingInfoView;

/** 设置子控件 */
- (void)setupSubviews;

/** 设置冻结保证金数额 */
- (void)setupTradingInfoWithfreezeDeposit:(NSString *)freezeDepositString;

/** 设置管理费数额 */
- (void)setupTradingInfoWithmanagementFee:(NSString *)managementFeeString;

/** 设置合计支付金额 */
- (void)setupTotalAmount:(NSString *)totalAmount;

@end
