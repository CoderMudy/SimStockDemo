//
//  MyGoldViewController.m
//  SimuStock
//
//  Created by jhss on 15/5/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyGoldClientVC.h"

@implementation MyGoldClientVC

- (void)viewDidLoad {
  [super viewDidLoad];
  //创建顶部topBar
  [self createTopBarView];
  //创建
  [self createMyGoldSubVC];
}

- (void)createMyGoldSubVC {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(refreshData)
                                               name:@"WriteInviteCodeSuccess"
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(refreshData)
                                               name:@"PersonalInfo"
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(refreshData)
                                               name:@"VoteSuccess"
                                             object:nil];
  if (!myGoldVC) {
    CGRect frame = CGRectMake(0, 0, self.clientView.bounds.size.width,
                              CGRectGetHeight(self.clientView.bounds));
    myGoldVC = [[MyGoldVC alloc] initWithFrame:frame];
  }
  __weak MyGoldClientVC *weakSelf = self;
  myGoldVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };
  myGoldVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };
  [self.clientView addSubview:myGoldVC.view];
  [self addChildViewController:myGoldVC];
  [myGoldVC refreshButtonPressDown];
}

- (void)refreshData {
  [myGoldVC refreshButtonPressDown];
}
- (void)createTopBarView {
  [_topToolBar resetContentAndFlage:@"我的金币" Mode:TTBM_Mode_Leveltwo];
}

- (void)refreshButtonPressDown {
  [myGoldVC refreshButtonPressDown];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}
- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
