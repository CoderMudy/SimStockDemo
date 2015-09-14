//
//  StockChannelNewsViewController.h
//  SimuStock
//
//  Created by Mac on 15/5/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "SimTopBannerView.h"
#import "SimuTouchMoveView.h"

#import "SimuIndicatorView.h"

#import "TopToolBarUIScrollView.h"
#import "StockNewsListTableViewController.h"
#import "FileStoreUtil.h"

 
/** 股市内参页面 */
@interface StockChannelNewsViewController
    : BaseViewController<UIScrollViewDelegate, TopToolBarUIScrollViewDelegate> {
  ///当前页面索引
  NSInteger pageIndex;
  ///当前选中的栏目
  NewsChannelItem *selectedChannel;

  //创建上方导航栏
  TopToolBarUIScrollView* topToolbarView;
  //创建承载滚动视图
  UIScrollView *_scrollView;

  NSMutableDictionary *channelVCs;

  NewsChannelList *myChannelList;
  NewsChannelList *moreChannelList;
  
  CGRect * rectframe;
  /// 滑动偏移量
  CGPoint offsetX;
}
/** 顶部右侧“说明”按钮 */
@property(strong, nonatomic) UIButton *instructionBtn;
@end
