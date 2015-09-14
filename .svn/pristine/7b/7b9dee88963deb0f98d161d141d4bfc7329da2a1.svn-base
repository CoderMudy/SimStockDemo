//
//  MessageSystemView.m
//  SimuStock
//
//  Created by moulin wang on 14-11-28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MessageSystemViewController.h"
@implementation MessageSystemViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  //创建顶部topBar
  [self createTopBarView];
  
  [self createTraceMessageVC];
}

///创建顶部topBar
- (void)createTopBarView {
  [_topToolBar resetContentAndFlage:@"系统消息" Mode:TTBM_Mode_Leveltwo];
}

- (void)createTraceMessageVC {
  if (!_systemMsgVC) {
    self.view.backgroundColor = [Globle colorFromHexRGB:@"#F7F7F7"];
    CGRect frame = CGRectMake(0, 0, self.clientView.bounds.size.width,
                              CGRectGetHeight(self.clientView.bounds));
    _systemMsgVC = [[SystemMessageTableVC alloc] initWithFrame:frame];
  }
  __weak MessageSystemViewController *weakSelf = self;
  _systemMsgVC.showTableFooter = YES;
  _systemMsgVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };
  _systemMsgVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };
  [self.clientView addSubview:_systemMsgVC.view];
  [self addChildViewController:_systemMsgVC];
  [_systemMsgVC refreshButtonPressDown];
}

- (void)refreshButtonPressDown {
  [_systemMsgVC refreshButtonPressDown];
}
@end
