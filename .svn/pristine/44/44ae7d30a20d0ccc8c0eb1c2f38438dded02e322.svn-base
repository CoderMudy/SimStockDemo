//
//  MyCommentViewController.h
//  SimuStock
//
//  Created by jhss_wyz on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseNoTitleViewController.h"
#import "Globle.h"

@class WBImageView;
@class MyCommentTableVC;

@class WBImageView;

@interface MyCommentViewController
    : BaseNoTitleViewController <UIScrollViewDelegate>
///个人主页显示每条聊股的table控制器
@property(strong, nonatomic) MyCommentTableVC *tableController;

/** 开始加载，通知父容器*/
@property(copy, nonatomic) CallBackAction beginRefreshCallBack;

/** 结束加载，通知父容器*/
@property(copy, nonatomic) CallBackAction endRefreshCallBack;

- (void)refreshButtonPressDown;

@end
