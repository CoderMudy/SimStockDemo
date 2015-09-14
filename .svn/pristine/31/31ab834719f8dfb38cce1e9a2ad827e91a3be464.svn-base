//
//  WFBankCarInformation.h
//  SimuStock
//
//  Created by moulin wang on 15/4/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
//协议按钮点击事件
@protocol WFBankCarInformationDelegate <NSObject>

///跳转高度
-(void)ChangeScrollviewHight;

@end

@interface WFBankCarInformation : UIView<UITextFieldDelegate>

@property(nonatomic,assign) id<WFBankCarInformationDelegate> delegate;
//点击按钮
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
/** 银行名称 */
@property (strong, nonatomic) IBOutlet UILabel *bankInformationLabel;
/** 储蓄卡卡号 */
//@property (strong, nonatomic) IBOutlet UITextField *bankNO;
@property(weak, nonatomic) IBOutlet UITextField *MainTextField;

@property(assign, nonatomic) int bankID;

@end
