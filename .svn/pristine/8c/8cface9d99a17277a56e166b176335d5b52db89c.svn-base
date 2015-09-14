//
//  ConfirmPayView.h
//  SimuStock
//
//  Created by Jhss on 15/6/5.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Block.h"
@interface ConfirmPayView : UIView

/** "支付金额"显示标签 */
@property(weak, nonatomic) IBOutlet UILabel *payMoneyLabel;
/** 需要支付的金额 */
@property(weak, nonatomic) IBOutlet UILabel *payMoneyNumberLabel;
/** 账户余额 */
@property(weak, nonatomic) IBOutlet UILabel *accountBalanceLabel;
/** 确认支付按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *confirmPayButton;

/** 确认支付的视图 */
+ (ConfirmPayView *)createdConfirmPayInfoView;

- (void)settingUpWithPayMoneyLabel:(NSString *)titleLabel
           WithPayMoneyNumberLabel:(NSString *)numberLabel
           WithAccountBalanceLabel:(NSString *)accounBalance;

@end
