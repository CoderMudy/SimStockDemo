//
//  BaseNoTitleViewController.h
//  SimuStock
//
//  Created by Mac on 15/4/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LittleCattleView.h"

@interface BaseNoTitleViewController : UIViewController

/** 容器VC设置的frame */
@property(assign, nonatomic) CGRect frameInParent;

/** 小牛视图，使用isCry:(BOOL)来切换哭牛和笑牛。setInformation设置笑牛标签*/
@property(strong, nonatomic) LittleCattleView *littleCattleView;

/** 使用指定的frame大小设置页面的大小 */
- (id)initWithFrame:(CGRect)frame;

/**
 返回当前页面是否用户可视状态
 */
- (BOOL)isVisible;

- (void)performBlock:(void (^)())block withDelaySeconds:(float)delayInSeconds;

@end
