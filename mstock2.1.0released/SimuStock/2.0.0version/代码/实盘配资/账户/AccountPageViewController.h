//
//  AccountPageViewController.h
//  SimuStock
//
//  Created by Jhss on 15/4/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"

/** 账户页面 */
@interface AccountPageViewController : BaseViewController

/** 优顾账户  */
@property(weak, nonatomic) IBOutlet UILabel *youguuAccountLabel;
/** 股票账户 */
@property(weak, nonatomic) IBOutlet UILabel *stockAccountLabel;
/** 配资 */
@property(weak, nonatomic) IBOutlet UILabel *matchMoneyLabel;
/** 保证金（含盈亏） */
@property(weak, nonatomic) IBOutlet UILabel *marginLabel;
/** 浮动金额 */
@property(weak, nonatomic) IBOutlet UILabel *floatFullLabel;

@property (weak, nonatomic) IBOutlet UIView *wfView;
@property (weak, nonatomic) IBOutlet UIView *wfBottomView;

/** 点击进入优顾账户页面 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *youguuAccountButton;
- (IBAction)IBActionclickIntoYouguuAccountButtonPressidsender:(id)sender;

/** 充值按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *rechargeButton;
/** 点击充值按钮进入充值页面 */
- (IBAction)clickRechargeButtonMethod:(id)sender;
/** 提现按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *withDrawButton;
/** 点击提现按钮进入充值页面 */
- (IBAction)clickWithDrawMethod:(id)sender;

@end
