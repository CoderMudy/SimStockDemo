//
//  SimuStockRegisterView.h
//  SimuStock
//
//  Created by jhss on 14-7-7.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThirdWayLogon.h"

#define logon_button_space 18
#define logon_button_height 36
#define logon_edge_width 4.5
#define qq_logon_tag 100
#define weixin_logon_tag 101
#define sinaWeibo_logon_tag 102
#define phoneNumber_logon_tag 103

@interface SimuStockRegisterView : UIView {
  ThirdWayLogon *thirdWayLogon;
}
@property(strong, nonatomic) UIButton *logonButton;
@property(strong, nonatomic) UILabel *titleLabel;
@property(assign, nonatomic) NSInteger isOtherLogin;

/** 创建登录界面 */
- (void)createRegisterViewContent;

@end
