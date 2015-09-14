//
//  RoundHeadImage.h
//  SimuStock
//
//  Created by Mac on 15/5/5.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Block.h"
#import "UserListItem.h"

/** 圆圆的头像，有1个dp的白边，点击有按下态，点击跳转个人主页 */
@interface RoundHeadImage : UIView

/** 用户 */
@property(strong, nonatomic) UserListItem *user;
/** 头像 */
@property(strong, nonatomic) UIImageView *headPicImageView;
/** 头像按钮 */
@property(strong, nonatomic) BGColorUIButton *headPicBotton;

/** 绑定用户数据 */
- (void)bindUserListItem:(UserListItem *)user;

/** 绑定牛人筛选页面默认头像*/
- (void)bindlittleCattleUserListItem:(UserListItem *)user;

@end
