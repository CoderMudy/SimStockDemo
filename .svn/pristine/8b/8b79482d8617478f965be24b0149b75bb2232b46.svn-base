//
//  RealNameAuthenticationViewController.h
//  SimuStock
//
//  Created by Jhss on 15/4/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "CellBottomLinesView.h"
#import "WFFinancingParse.h"
#import "UIButton+Block.h"

typedef void (^RealUserCertBlock)(BOOL success); //是否是已登录状态

@interface RealNameAuthenticationViewController
    : BaseViewController <UITextFieldDelegate>

/** 姓名 */
@property(weak, nonatomic) IBOutlet UITextField *realNameTF;
/** 身份证 */
@property(weak, nonatomic) IBOutlet UITextField *realIdCardTF;
/** 确定 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *confirmButton;
///点击”确认“按钮提交认证信息
- (IBAction)confirmSubmitInfomationButtonPress:(id)sender;
/** 阅读并同意注意事项点击按钮 */
@property(weak, nonatomic) IBOutlet UIButton *agreeButton;
/** 阅读并同意注意事项点击按钮 的点击事件*/
- (IBAction)checkAgreeButtonIsSelected:(id)sender;

/** 判断 阅读并同意注意事项点击按钮 是否被选中*/
@property(nonatomic) BOOL isSelected;

@property(nonatomic, copy) RealUserCertBlock realUsercertBlock;

- (id)initWithRealUserCertBlock:(RealUserCertBlock)block;

@end
