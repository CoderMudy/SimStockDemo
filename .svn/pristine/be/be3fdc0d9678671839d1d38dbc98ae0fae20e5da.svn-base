//
//  MyGoldViewController.m
//  SimuStock
//
//  Created by jhss on 15/5/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyGoldViewController.h"

@implementation MyGoldViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  //创建顶部topBar
  [self createTopBarView];
  //创建
  [self createMyGoldSubVC];
}

-(void)createMyGoldSubVC{
    if (!myGoldVC) {
        myGoldVC = [[MyGoldVC alloc]init];
    }

  [self.clientView addSubview:myGoldVC.view];
}
- (void)createTopBarView {
  [_topToolBar resetContentAndFlage:@"我的金币" Mode:TTBM_Mode_Leveltwo];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


@end
