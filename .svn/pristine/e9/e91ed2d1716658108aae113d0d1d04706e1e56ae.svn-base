//
//  ChangeHeadImageViewController.h
//  SimuStock
//
//  Created by jhss on 13-9-27.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "SimTopBannerView.h"
#import "JhssImageCache.h"

@interface ChangeHeadImageViewController
    : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
  /** 头像列表 */
  UITableView *headImageTableView;
  /** 头像数组 */
  NSArray *headArray;
  /** 已选中头像 */
  NSInteger selectedHeadPic;
  /** 按钮重复点击 */
  int64_t lastPressedTime;
}
/* 当前选中头像 */
@property(strong, nonatomic) UIImageView *currentHeadImageView;

@end
