//
//  MyCommentViewController.m
//  SimuStock
//
//  Created by jhss_wyz on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyCommentViewController.h"
#import "MyCommentTableVC.h"

@implementation MyCommentViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableController =
      [[MyCommentTableVC alloc] initWithFrame:self.view.bounds];
  self.tableController.tableView.backgroundColor =
      [Globle colorFromHexRGB:@"#F7F7F7"];
  self.tableController.tableView.separatorStyle =
      UITableViewCellSeparatorStyleNone;
  [self addChildViewController:self.tableController];
  [self.view addSubview:self.tableController.view];

  __weak MyCommentViewController *weakSelf = self;
  self.tableController.beginRefreshCallBack = ^{
    if (weakSelf.beginRefreshCallBack) {
      weakSelf.beginRefreshCallBack();
    }
  };

  self.tableController.endRefreshCallBack = ^{
    if (weakSelf.endRefreshCallBack) {
      weakSelf.endRefreshCallBack();
    }
  };

  [self refreshButtonPressDown];
}

- (void)refreshButtonPressDown {
  //点击刷新按钮时网络请求
  [self.tableController refreshButtonPressDown];
}

@end
