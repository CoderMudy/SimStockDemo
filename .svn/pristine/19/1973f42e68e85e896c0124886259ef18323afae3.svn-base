//
//  ExpertFilterViewController.m
//  SimuStock
//
//  Created by jhss on 15/9/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExpertFilterViewController.h"
#import "ExpertFilterTableVC.h"

@implementation ExpertFilterViewController

- (id)initWithExpertFilterConditions:(ExpertFilterCondition *)conditions {
  if (self = [super init]) {
    _filterConditions = conditions;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //创建顶部topBar
  [self createTopBarView];
  //创建
  [self createExpertFilterSubVC];

  __weak ExpertFilterViewController *weakSelf = self;

  _expertFilterTableVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
    weakSelf.indicatorView.hidden = NO;
  };
  _expertFilterTableVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
    weakSelf.indicatorView.hidden = YES;
  };
  [_expertFilterTableVC refreshButtonPressDown];
}

- (void)createExpertFilterSubVC {
  if (!_expertFilterTableVC) {
    _expertFilterTableVC = [[ExpertFilterTableVC alloc] initWithFrame:self.clientView.bounds
                                            withExpertFilterCondition:_filterConditions];
  }

  [self.clientView addSubview:_expertFilterTableVC.view];
  [self addChildViewController:_expertFilterTableVC];
}

/** 是否加载更多 */
- (BOOL)supportAutoLoadMore {
  return YES;
}

- (void)refreshButtonPressDown {
  [_expertFilterTableVC refreshButtonPressDown];
}
- (void)createTopBarView {
  [_topToolBar resetContentAndFlage:@"牛人筛选" Mode:TTBM_Mode_Leveltwo];
  _indicatorView.hidden = YES;
}
@end
