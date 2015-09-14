//
//  ExpertHomePageTbaleVC.h
//  SimuStock
//
//  Created by 刘小龙 on 15/9/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
@class ExpertNavigationView;


/** 刷新广告数据 */
typedef void (^RefreshGameAdvertisingBlock)();

/**
 *  控制器
 */
@interface ExpertHomePageAdapter : BaseTableAdapter
/** 头 */
@property(strong, nonatomic) ExpertNavigationView *headNavigationView;
@end

/**
 *  tableView
 */
@interface ExpertHomePageTbaleVC : BaseTableViewController
/**
 *  父类的控制器
 */
@property(weak, nonatomic) SimuMainViewController *mainVC;

/** 刷新数据时 回调Block */
@property(copy, nonatomic) RefreshGameAdvertisingBlock gameAdvertisingBlock;

/**
 *  init构造函数
 *
 *  @param frame      控件大小
 *  @param controller SimuMainViewController
 *
 *  @return 实例化对象
 */
- (id)initWithFrame:(CGRect)frame withMainViewController:(SimuMainViewController *)controller;

@end
