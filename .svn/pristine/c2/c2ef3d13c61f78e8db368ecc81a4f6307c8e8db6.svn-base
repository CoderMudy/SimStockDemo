//
//  WFHistoryListViewController.m
//  SimuStock
//
//  Created by moulin wang on 15/4/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFHistoryListViewController.h"
#import "WFHistoryListTableViewController.h"
#import "ComposeInterfaceUtil.h"

@interface WFHistoryListViewController () {
  WFHistoryListTableViewController *historyListTableView;
}
@end

@implementation WFHistoryListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.topToolBar resetContentAndFlage:@"历史明细" Mode:TTBM_Mode_Leveltwo];
  //创建tableView
  [self creatHistoryListTableView];

  _indicatorView.hidden = YES;

  //创建分享按钮
  [self creatShareButton];
}

//创建分享按钮
- (void)creatShareButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:@"分享" forState:UIControlStateNormal];
  button.backgroundColor = [UIColor clearColor];
  [button addTarget:self
                action:@selector(shareButtonAction:)
      forControlEvents:UIControlEventTouchUpInside];
  button.frame = CGRectMake(_topToolBar.bounds.size.width - 70,
                            _topToolBar.bounds.size.height - 44, 70, 44);
  button.titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_18_0];
  button.titleLabel.textAlignment = NSTextAlignmentCenter;
  [button setTitleColor:[Globle colorFromHexRGB:@"47eef6"]
               forState:UIControlStateNormal];
  [_topToolBar addSubview:button];
}
//分享按钮点击事件
- (void)shareButtonAction:(UIButton *)btn {
  if (![SimuUtil isExistNetwork]) {
    return;
  }
  //解析
  __weak WFHistoryListViewController *weakSelf = self;
  [WFPayUtil checkWFAccountBalanceWithOwner:self
      withCleanCallBack:^{
      }
      onWFAccountBalanceReady:^(WFAccountBalance *result) {
        weakSelf.accountBalanceInfo = result;
      }];
}

#pragma mark -创建tableView
- (void)creatHistoryListTableView {
  CGRect frameTabelView = CGRectMake(0, 0, self.clientView.bounds.size.width,
                                     self.clientView.bounds.size.height);
  historyListTableView = [[WFHistoryListTableViewController alloc]
      initWithNibName:@"WFHistoryListTableViewController"
               bundle:nil];
  historyListTableView.tableView.frame = frameTabelView;
  historyListTableView.tableView.separatorStyle =
      UITableViewCellSeparatorStyleNone;
  [self addChildViewController:historyListTableView];
  [self.clientView addSubview:historyListTableView.view];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
