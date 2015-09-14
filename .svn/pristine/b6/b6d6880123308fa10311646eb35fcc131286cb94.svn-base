//
//  TraceMessageViewController.m
//  SimuStock
//
//  Created by jhss on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "TraceMessageViewController.h"

@implementation TraceMessageViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  //创建顶部topBar
  [self createTopBarView];
  [self createTraceMessageVC];
}

///创建顶部topBar
- (void)createTopBarView {
  [_topToolBar resetContentAndFlage:@"追踪消息" Mode:TTBM_Mode_Leveltwo];
}

- (void)createTraceMessageVC {
  if (!_traceMessageVC) {
    CGRect frame = CGRectMake(0, 0, self.clientView.bounds.size.width,
                              CGRectGetHeight(self.clientView.bounds));
    _traceMessageVC =
        [[TraceMessageTableViewController alloc] initWithFrame:frame];
  }
  __weak TraceMessageViewController *weakSelf = self;
  _traceMessageVC.showTableFooter = YES;
  _traceMessageVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };
  _traceMessageVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };
  [self.clientView addSubview:_traceMessageVC.view];
  [self addChildViewController:_traceMessageVC];
  [_traceMessageVC refreshButtonPressDown];
}

- (void)refreshButtonPressDown {
  [_traceMessageVC refreshButtonPressDown];
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
@end
