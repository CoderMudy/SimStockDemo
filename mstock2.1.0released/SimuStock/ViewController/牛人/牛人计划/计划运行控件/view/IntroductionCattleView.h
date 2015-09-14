//
//  IntroductionCattleView.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertPlanData.h"
#import "FTCoreTextView.h"

@interface IntroductionCattleView : UIView
///简介
@property(weak, nonatomic) IBOutlet FTCoreTextView *introductionView;

///牛人计划介绍文字的高度
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *introduceHeight;

//数据绑定
- (CGFloat)bindData:(UserDescData *)desc;
@end
