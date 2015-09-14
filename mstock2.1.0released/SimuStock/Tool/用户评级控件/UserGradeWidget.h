//
//  UserGradeWidget.h
//  SimuStock
//
//  Created by Yuemeng on 15/3/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserListItem;
@class Flowers;

/** 用户评级控件，包含花、皇冠、实盘和楼主标识 */
@interface UserGradeWidget : UIView {
  ///用户评级
  Flowers *_flowers;
  
  ///皇冠，38*28
  UIImageView *_crown;
  
  ///实盘
  UIImageView *_realTrade;
  
  ///楼主标识
  UIImageView *_originalPoster;

  BOOL _isHasFlowers;
  BOOL _isHasCrown;
  BOOL _isHasReal;

  /** 当前控件总宽度 */
  CGFloat _currentWidth;
}

/** 是否是楼主 */
@property(nonatomic) BOOL isOriginalPoster;


/**
 * 设置信息及根据用户名控件设置frame，限制用户名+控件的总体长度，如果整体过长则会调整用户名控件过长部分。主页专用(320居中)
 */
- (void)resetInfoAndCenterFrameNoFlowerWithItem:(UserListItem *)item
                                   nickNameView:(UIView *)nickNameView;
/**
 * 设置信息及根据用户名控件设置frame，限制用户名+控件的总体长度，如果整体过长则会调整用户名控件过长部分
 */
- (void)resetInfoAndFrameWithItem:(UserListItem *)item
                     nickNameView:(UIView *)nickNameView
                        maxLength:(CGFloat)maxLength;
/**
 * (牛人排行、主页专用，没有花朵)设置信息及根据用户名控件设置frame，限制用户名+控件的总体长度，如果整体过长则会调整用户名控件过长部分
 */
- (void)resetInfoAndFrameNoFlowerWithItem:(UserListItem *)item
                             nickNameView:(UIView *)nickNameView
                                maxLength:(CGFloat)maxLength;
@end
