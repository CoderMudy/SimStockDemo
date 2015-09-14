//
//  AddBankCardSmallView.h
//  SimuStock
//
//  Created by jhss_wyz on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBankCardSmallView : UIView

/** 添加银行卡图标 */
@property(weak, nonatomic) IBOutlet UIButton *addCardImageBtn;
/** 添加银行卡文字 */
@property(weak, nonatomic) IBOutlet UIButton *addCardLableBtn;
/** 添加银行卡按钮 */
@property(weak, nonatomic) IBOutlet UIButton *addCardButton;

/** 分割线视图 */
@property(weak, nonatomic) IBOutlet UIView *marginView;

/** 设置子控件 */
- (void)setupSubviews;

/** 设置添加银行卡按钮显示的效果 */
- (void)SetAddBankcardBtnState:(BOOL)couldAdd;

@end
