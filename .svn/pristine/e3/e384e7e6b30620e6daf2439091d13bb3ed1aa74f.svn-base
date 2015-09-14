//
//  UserGradeView.h
//  SimuStock
//
//  Created by Mac on 15/5/5.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Block.h"

@class UserListItem;
@class Flowers;

/** 用户评级控件，包含花、皇冠、实盘和楼主标识 */
@interface UserGradeView : UIView

@property(nonatomic, strong) UserListItem *user;

/** 昵称 */
@property(nonatomic, strong) TitleColorChangedUIButton *lblNickName;

///用户评级
@property(nonatomic, strong) Flowers *flowers;
@property(nonatomic, assign) BOOL showUserGrade;

///皇冠，38*28
@property(nonatomic, strong) UIImageView *crownImageView;
@property(nonatomic, assign) BOOL showVip;

///实盘
@property(nonatomic, strong) UIImageView *realTradeImageView;
@property(nonatomic, assign) BOOL showRealTrade;

///楼主标识
@property(nonatomic, strong) UIImageView *originalPosterImageView;
@property(nonatomic, assign) BOOL showOriginalPoster;

/** 是否是楼主 */
@property(nonatomic) BOOL isOriginalPoster;

///绑定数据后，内容所占的宽度，小于等于frame的宽度
@property(nonatomic, assign) CGFloat contentWidth;

/** 绑定用户信息，并指定是否为楼主 */
- (void)bindUserListItem:(UserListItem *)item isOriginalPoster:(BOOL)isOriginalPoster;

/** 新的绑定方法 必须传入字体的大小 */
- (void)bindUserListItem:(UserListItem *)item
                withFont:(CGFloat)font
      withOriginalPoster:(BOOL)isOriginalPoster;

@end
