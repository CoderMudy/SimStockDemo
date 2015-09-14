//
//  MyChatStockViewController.h
//  SimuStock
//
//  Created by moulin wang on 14-12-12.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseNoTitleViewController.h"
#import "Globle.h"

@class MyIssuanceTableVC;
@class WBImageView;

@interface MyIssuanceViewController
    : BaseNoTitleViewController <UIScrollViewDelegate>

///个人主页显示每条聊股的table控制器
@property(strong, nonatomic) MyIssuanceTableVC *tableController;

/** 开始加载，通知父容器*/
@property(copy, nonatomic) CallBackAction beginRefreshCallBack;

/** 结束加载，通知父容器*/
@property(copy, nonatomic) CallBackAction endRefreshCallBack;

- (void)refreshButtonPressDown;

@end
