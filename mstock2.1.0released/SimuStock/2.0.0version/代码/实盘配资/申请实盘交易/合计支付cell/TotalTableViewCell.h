//
//  TotalTableViewCell.h
//  SimuStock
//
//  Created by Mac on 15/5/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Block.h"

@interface TotalTableViewCell : UITableViewCell

typedef void (^AgreementButtonClickBlock)(
    BOOL btnState); //当按钮被点击时，block返回

/** 冻结保证金数额 */
@property(weak, nonatomic) IBOutlet UILabel *freezeDepositLabel;
/** 管理费数额 */
@property(weak, nonatomic) IBOutlet UILabel *managementFeeLable;

/** 冻结保证金标题 */
@property(weak, nonatomic) IBOutlet UILabel *depositTitle;
/** 管理费标题 */
@property(weak, nonatomic) IBOutlet UILabel *managementFeeTitle;

/** 冻结保证金说明按钮 */
@property(weak, nonatomic) IBOutlet UIButton *depositInstructionBtn;
/** 账户管理费说明按钮 */
@property(weak, nonatomic) IBOutlet UIButton *feeInstructionBtn;

/** 同意协议按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *haveReadBtn;
/** 协议按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *protocolBtn;

@property(copy, nonatomic) AgreementButtonClickBlock block;

/** 设置子控件 */
- (void)setupSubviews;

/** 设置冻结保证金数额 或者 设置管理费数额*/
- (void)setupTradingInfoWithLabelStyle:(UILabel *)tradingLabel
                     WithTradingNumber:(NSString *)tradingAmount;

@end
