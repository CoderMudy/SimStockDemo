//
//  MyChatStockViewController.h
//  SimuStock
//
//  Created by jhss_wyz on 15/5/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
@class TopToolBarView;
@class MyIssuanceViewController;
@class MyCollectTweetViewController;
@class MyCommentViewController;

@interface MyChatStockViewController : BaseViewController

/** 当前滚动页面索引 */
@property(assign, nonatomic) NSInteger pageIndex;

/** 创建上方导航栏 */
@property(strong, nonatomic) TopToolBarView *topToolbarView;

/** 创建承载滚动视图 */
@property(strong, nonatomic) UIScrollView *scrollView;

/** 我发表的视图控制器 */
@property(strong, nonatomic) MyIssuanceViewController *myIssuanceVC;

/** 我的评论视图控制器 */
@property(strong, nonatomic) MyCommentViewController *myCommentVC;

/** 我的收藏视图控制器 */
@property(strong, nonatomic) MyCollectTweetViewController *myCollectTweetVC;

@end
