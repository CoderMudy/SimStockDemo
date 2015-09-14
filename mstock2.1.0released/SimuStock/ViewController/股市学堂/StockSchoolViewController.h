//
//  StockSchoolViewController.h
//  SimuStock
//
//  Created by moulin wang on 14-4-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "SimTopBannerView.h"
#import "SimuTouchMoveView.h"

@interface StockSchoolViewController
    : BaseViewController <UIScrollViewDelegate, SimuTouchMoveViewDelegate> {
  NSArray *_nameArr;
  NSArray *_iconArr;
  //文章列表接口
  NSArray *_moduleIdArr;
  NSInteger buttonTag;

  //手动侧滑控件
  SimuTouchMoveView *stmv_touchView;
  UIScrollView *basemapScroll;
  //放置控件的背景图
  UIView *backgroundView;
}
@end
