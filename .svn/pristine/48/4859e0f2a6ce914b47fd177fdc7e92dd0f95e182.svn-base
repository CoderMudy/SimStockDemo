//
//  MyInfoCell.h
//  SimuStock
//
//  Created by jhss on 14-7-29.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyInfomationItem.h"

@interface MyInfoCell : UITableViewCell

///名称
@property(strong, nonatomic) UILabel *rowNameLabel;

///手机号
@property(strong, nonatomic) UILabel *phoneLabel;

///头像
@property(strong, nonatomic) UIImageView *headImageView;

///名称对应的内容
@property(strong, nonatomic) UILabel *rowContentLabel;

///箭头
@property(strong, nonatomic) UIImageView *arrowImageView;

//上分界线
@property(strong, nonatomic) UIView *topLine_downView;
@property(strong, nonatomic) UIView *topLine_upView;
//下分界线
@property(strong, nonatomic) UIView *bottomLine_downView;
@property(strong, nonatomic) UIView *bottomLine_upView;


- (void)bindUserInfo:(MyInfomationItem *)item
       withIndexPath:(NSIndexPath *)indexPath
withRowToBindTypeDic:(NSDictionary *)rowToBindTypeDic;

@end
