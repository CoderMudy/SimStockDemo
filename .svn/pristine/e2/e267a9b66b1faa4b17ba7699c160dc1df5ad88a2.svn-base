//
//  SelfStockTableHeaderView.h
//  SimuStock
//
//  Created by Mac on 15/5/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Block.h"

@interface SelfStockTableHeaderView : UIView

@property(weak, nonatomic) IBOutlet BGColorUIButton *btnSort;

@property(weak, nonatomic) IBOutlet UIImageView *iconSort;

@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *sortIndicator;

@property(nonatomic, strong) IBOutlet UIView *loginView;

@property(nonatomic, strong) IBOutlet BGColorUIButton *btnLogin;

///分组的宽度
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *groupWidth;
///显示分组名称
@property(weak, nonatomic) IBOutlet UILabel *lblGroup;

///切换分组的图标
@property(weak, nonatomic) IBOutlet UIImageView *imgSwitchGroup;
///切换分组的图标的宽度
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *arrowWidth;

///分组切换按钮，无登录状态下不显示
@property(strong, nonatomic) IBOutlet UIButton *groupButton;

- (void)bindGroup:(NSString *)groupName;
@end
