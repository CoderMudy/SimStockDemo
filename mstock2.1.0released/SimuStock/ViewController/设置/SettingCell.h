//
//  SettingCell.h
//  SimuStock
//
//  Created by jhss on 14-5-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell

///底图
@property(strong, nonatomic) UIImageView *settingBackImageView;

///每项名称
@property(strong, nonatomic) UILabel *settingNameLabel;
//@property(strong, nonatomic) UILabel *totalLabel;

///每栏图标
@property(strong, nonatomic) UIImageView *iconImageView;

///箭头
@property(strong, nonatomic) UIImageView *arrowImageView;

///每行按钮
@property(strong, nonatomic) UIButton *settingButton;

/////对号背景
//@property(strong, nonatomic) UIImageView *pushBackImageView;
//
/////对号
//@property(strong, nonatomic) UIImageView *pigeonImageView;
//
/////透明按钮
//@property(strong, nonatomic) UIButton *isSelectPushButton;

///显示刷新频率
@property(strong, nonatomic) UILabel *refreshLabel;

///分界线上灰
@property(strong, nonatomic) UIView *downView;

///下白
@property(strong, nonatomic) UIView *upView;

@end
