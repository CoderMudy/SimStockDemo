//
//  ExpertViewController.h
//  SimuStock
//
//  Created by 刘小龙 on 15/9/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globle.h"
@class ExpertHomePageTbaleVC;
@class SimuMainViewController;

@interface ExpertViewController : UIViewController <ScrollToTopVC>

/** tableview */
@property(strong, nonatomic) ExpertHomePageTbaleVC *expertTableView;
/** 主控制器 */
@property(weak, nonatomic) SimuMainViewController *mainVC;

/**
 *  init构造函数
 *
 *  @param frame      大小
 *  @param controller SimuMainViewController
 *
 *  @return 实例化对象
 */
- (id)initWithFrame:(CGRect)frame withSimuMainViewController:(SimuMainViewController *)controller;

/**
 *  是否支持点击状态栏，返回顶部
 *
 *  @param scrollsToTop BOOL 支持=YES
 */
- (void)enableScrollsToTop:(BOOL)scrollsToTop;

@end
