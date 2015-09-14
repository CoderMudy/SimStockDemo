//
//  AddBankCardBigView.h
//  SimuStock
//
//  Created by jhss_wyz on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBankCardBigView : UIView

/** 添加银行卡按钮 */
@property(weak, nonatomic) IBOutlet UIButton *addCardBtn;
/** 添加银行卡标题 */
@property(weak, nonatomic) IBOutlet UILabel *addCardLable;
/** 分割线 */
@property(weak, nonatomic) IBOutlet UIView *marginLine;

/** 设置子控件 */
- (void)setupSubviews;

@end
