//
//  SelfAddStockGroupViewController.m
//  SimuStock
//
//  Created by jhss on 15/6/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ModifySelfGroupViewController.h"
#import "PortfolioStockModel.h"

@implementation ModifySelfGroupViewController

- (instancetype)initWithData:(QuerySelfStockData *)data {
  if (self = [super init]) {
    _data = data;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //创建顶部topBar
  [self createTopBarView];
  //创建
  [self createMyGoldSubVC];
}

- (void)createMyGoldSubVC {
  if (!_selfAddStockGroupVC) {
    _selfAddStockGroupVC = [[SelfGroupsTableViewController alloc] init];
  }

  [self.clientView addSubview:_selfAddStockGroupVC.view];
  [self addChildViewController:_selfAddStockGroupVC];
}
- (void)createTopBarView {
  [_topToolBar resetContentAndFlage:@"编辑分组" Mode:TTBM_Mode_Leveltwo];
  self.indicatorView.hidden = YES;
}

- (void)leftButtonPress {
  NSLog(@"☀️同步分组信息");
  [PortfolioStockManager synchronizePortfolioStock];
  [super leftButtonPress];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
