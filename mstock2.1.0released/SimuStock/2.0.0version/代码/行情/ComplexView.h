//
//  ComplexView.h
//  SimuStock
//
//  Created by moulin wang on 14-7-8.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComplexView : UIView
//股票名称和大盘名称
@property(nonatomic, strong) UILabel *nameLab;
//领涨股名称
@property(nonatomic, strong) UILabel *leaderNameLab;
//最新价格
@property(nonatomic, strong) UILabel *curPriceLab;
//上升或下降数+涨跌幅
@property(nonatomic, strong) UILabel *changeLab;
//箭头视图
@property(nonatomic, strong) UIImageView *arrowImage;

@end
