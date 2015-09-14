//
//  InvitationGoodFriendButton.h
//  SimuStock
//
//  Created by 刘小龙 on 15/8/21.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Block.h"
/** 按钮点击回调事件 */
typedef void (^ButtonDownInvitationBlock)();

@class SimuIndicatorView;
@class SimTopBannerView;
@interface InvitationGoodFriendButton : BGColorUIButton

@property(copy, nonatomic) ButtonDownInvitationBlock invitationButtonBlock;

/** init 初始化  hide 是否隐藏菊花 参数： 导航栏条 和 菊花控件 */
- (id)initInvitationButtonWithTopBar:(SimTopBannerView *)topToolBar
                   withIndicatorView:(SimuIndicatorView *)indicatorView;

@end
