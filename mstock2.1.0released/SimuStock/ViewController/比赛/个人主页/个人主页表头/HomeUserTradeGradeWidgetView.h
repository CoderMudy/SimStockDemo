//
//  HomeUserTradeGradeWidgetView.h
//  SimuStock
//
//  Created by Jhss on 15/7/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
/** 个人主页  用户交易评级 */
#import <UIKit/UIKit.h>
#import "UserTradeGradeWidget.h"
#import "HomePageTableHeaderData.h"

@interface HomeUserTradeGradeWidgetView : UIView

/** 评级控件 */
@property(strong, nonatomic)
    IBOutlet UserTradeGradeWidget *userTradeGradeWidget;
/** 创建用户交易评级按钮 */
@property(weak, nonatomic) IBOutlet UIButton *userTradeGradeButton;

@property(strong, nonatomic) NSString *userId;

#pragma mark 用户交易评级控件生成及数据绑定
- (void)bindUserTradeGradeInfoWithItem:
    (HomePageTableHeaderData *)tableHeaderData;

@end
