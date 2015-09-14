//
//  WithdrawInfoView.h
//  SimuStock
//
//  Created by jhss_wyz on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellBottomLinesView.h"
#import "UIButton+Block.h"
@class InputTextFieldView;

@interface LianLianWithdrawInfoView : UIView

/** 提现信息 */
@property(weak, nonatomic) IBOutlet UILabel *withdrawInfoLable;

/** 账户余额标题 */
@property(weak, nonatomic) IBOutlet UILabel *accountBalanceLable;
/** 账户余额 */
@property(weak, nonatomic) IBOutlet UILabel *accountBalanceAccountLable;
/** 手续费标题 */
@property(weak, nonatomic) IBOutlet UILabel *serviceFeeLable;
/** 手续费 */
@property(weak, nonatomic) IBOutlet UILabel *serviceFeeAccountLable;

/** 提取现额标题 */
@property(weak, nonatomic) IBOutlet UILabel *withdrawLable;
/** 提取现额输入框 */
@property(weak, nonatomic) IBOutlet InputTextFieldView *inputMoney;

/** 到账金额标题 */
@property(weak, nonatomic) IBOutlet UILabel *receivedLable;
/** 到账金额 */
@property(weak, nonatomic) IBOutlet UILabel *receivedAccountLable;

/** 提现信息视图 */
@property(weak, nonatomic) IBOutlet UIView *withdrawView;

/** 温馨提示标题 */
@property(weak, nonatomic) IBOutlet UILabel *promptLable;
/** 温馨提示内容 */
@property(weak, nonatomic) IBOutlet UILabel *promptInfoLable;

/** 确认提现按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *determineWithdrawBtn;

/** 设置子控件 */
- (void)setupSubviews;

///用户账户资产查询
- (void)UsersAssetsInquiry;
@end
