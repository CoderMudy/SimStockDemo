//
//  AdvancedVIPVC.m
//  SimuStock
//
//  Created by jhss on 15/5/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AdvancedVIPVC.h"
@implementation AdvancedVIPVC

- (void)viewDidLoad {
  [super viewDidLoad];
  //创建顶部topBar
  [self createTopBarView];
  //创建
  [self createMyGoldSubVC];
}
///创建顶部topBar
- (void)createTopBarView {
  [_topToolBar resetContentAndFlage:@"高级VIP专区" Mode:TTBM_Mode_Leveltwo];
  _indicatorView.hidden = YES;
}
- (void)createMyGoldSubVC {
  if (!VIPPrefectureVC) {
    CGRect frame =
        CGRectMake(0, 0, self.clientView.bounds.size.width, CGRectGetHeight(self.clientView.bounds));
    VIPPrefectureVC = [[VipPrefectureViewController alloc] initWithFrame:frame];
  }
  [self.clientView addSubview:VIPPrefectureVC.view];
}

@end
