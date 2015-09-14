//
//  MyChatStockViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-12-12.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MyIssuanceViewController.h"
#import "MyIssuanceTableVC.h"

@implementation MyIssuanceViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableController =
      [[MyIssuanceTableVC alloc] initWithFrame:self.view.bounds];
  self.tableController.tableView.backgroundColor =
      [Globle colorFromHexRGB:@"#F7F7F7"];
  self.tableController.tableView.separatorStyle =
      UITableViewCellSeparatorStyleNone;
  [self addChildViewController:self.tableController];
  [self.view addSubview:self.tableController.view];

  __weak MyIssuanceViewController *weakSelf = self;
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
