//
//  ExpertViewController.m
//  SimuStock
//
//  Created by 刘小龙 on 15/9/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExpertViewController.h"
#import "ExpertHomePageTbaleVC.h"
#import "ExpertRecommendViewController.h"

@interface ExpertViewController ()
/** 控件的大小  */
@property(assign, nonatomic) CGRect frame;
/** head头 */
@property(strong, nonatomic) ExpertRecommendViewController *recommendVC;

@end

@implementation ExpertViewController

- (id)initWithFrame:(CGRect)frame withSimuMainViewController:(SimuMainViewController *)controller {
  self = [super init];
  if (self) {
    self.mainVC = controller;
    self.frame = frame;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.frame = self.frame;
  [self createTableView];
}

/** 创建tableview */
- (void)createTableView {
  if (_expertTableView == nil) {
    _recommendVC =
        [[ExpertRecommendViewController alloc] initWithNibName:@"ExpertRecommendViewController"
                                                        bundle:nil];
    _recommendVC.view.backgroundColor = [UIColor whiteColor];
    _expertTableView =
        [[ExpertHomePageTbaleVC alloc] initWithFrame:self.frame withMainViewController:self.mainVC];
    [_expertTableView addChildViewController:_recommendVC];

    [self addChildViewController:_expertTableView];
    [self.view addSubview:_expertTableView.view];
    [_expertTableView refreshButtonPressDown];
    __weak ExpertViewController *weakSelf = self;
    _expertTableView.gameAdvertisingBlock = ^() {
      ExpertViewController *strongSelf = weakSelf;
      if (strongSelf) {
        [strongSelf.recommendVC.advViewVC requestImageAdvertiseList];
      }
    };
  }
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  [_expertTableView.tableView setTableHeaderView:_recommendVC.view];
  _expertTableView.view.frame = self.view.frame;
}

- (void)enableScrollsToTop:(BOOL)scrollsToTop {
  _expertTableView.tableView.scrollsToTop = scrollsToTop;
}

@end
