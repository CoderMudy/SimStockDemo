//
//  DepositTopUpView.h
//  SimuStock
//
//  Created by jhss_wyz on 15/3/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Block.h"

@class InputTextFieldView;

@interface DepositTopUpView : UIControl

/** 保证金充值相关信息视图 */
@property(weak, nonatomic) IBOutlet UIView *infoView;
/** 当前资产标题 */
@property(weak, nonatomic) IBOutlet UILabel *amountTitleLable;
/** 当前资产金额 */
@property(weak, nonatomic) IBOutlet UILabel *amountLable;

/** 保证金剩余标题 */
@property(weak, nonatomic) IBOutlet UILabel *depositTitleLable;
/** 保证金剩余金额 */
@property(weak, nonatomic) IBOutlet UILabel *depositLeftLable;

/** 左右灰色分割线 */
@property(weak, nonatomic) IBOutlet UIView *verticalLine;

/** 警戒线图标 */
@property(weak, nonatomic) IBOutlet UIImageView *cordonImageView;
/** 平仓线图标 */
@property(weak, nonatomic) IBOutlet UIImageView *closePositionImageView;
/** 警戒线标题 */
@property(weak, nonatomic) IBOutlet UILabel *cordonInfoTitleLable;
/** 平仓线标题 */
@property(weak, nonatomic) IBOutlet UILabel *closePositionTitleLable;
/** 警戒线信息 */
@property(weak, nonatomic) IBOutlet UILabel *cordonInfoLable;
/** 平仓线信息 */
@property(weak, nonatomic) IBOutlet UILabel *closePositionLable;

/** 上下视图分割线 */
@property(weak, nonatomic) IBOutlet UIView *horizontalLine;

/** 充值保证金金额输入框 */
@property(weak, nonatomic) IBOutlet InputTextFieldView *inputMoney;
/** 输入框下方的线 */
@property(weak, nonatomic) IBOutlet UIView *inputLine;

/** 输入框下方的说明文字 */
@property(weak, nonatomic) IBOutlet UILabel *instructionLable;

@end
