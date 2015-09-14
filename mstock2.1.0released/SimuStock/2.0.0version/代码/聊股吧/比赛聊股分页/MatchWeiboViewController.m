//
//  MatchWeiboViewController.m
//  SimuStock
//
//  Created by Yuemeng on 15/1/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MatchWeiboViewController.h"
#import "MatchChatStockPageTableVC.h"
#import "MatchStockChatController.h"

@implementation MatchWeiboViewController

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title {
  self = [super initWithFrame:frame];
  if (self) {
    _matchTitle = title;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [_topToolBar resetContentAndFlage:_matchTitle Mode:TTBM_Mode_Leveltwo];

  /// 设定菊花位置
  [self resetIndicatorView];
  /// 创建发表按钮
  [self createPublishButton];
  /// 创建聊股TableViewController
  [self createTableView];
  /// 刷新数据
  [self.tableVC refreshButtonPressDown];
}

/** 设定菊花位置 */
- (void)resetIndicatorView {
  CGRect frame = _indicatorView.frame;
  frame.origin.x -= 50.0f;
  _indicatorView.frame = frame;
}

/** 创建发表按钮 */
- (void)createPublishButton {
  _publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _publishButton.frame = CGRectMake(WIDTH_OF_VIEWCONTROLLER - 50.0f, topToolBarHeight - 45.0f, 50.0f, 45.0f);
  _publishButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_15_0];
  [_publishButton setTitle:@"发表" forState:UIControlStateNormal];
  [_publishButton setTitleColor:[Globle colorFromHexRGB:Color_Publish]
                       forState:UIControlStateNormal];
  [_publishButton setBackgroundImage:[SimuUtil imageFromColor:Color_Blue_butDown]
                            forState:UIControlStateHighlighted];

  _publishButton.backgroundColor = [UIColor clearColor];
  [_topToolBar addSubview:_publishButton];
  __weak MatchWeiboViewController *weakSelf = self;
  [_publishButton setOnButtonPressedHandler:^{
    [weakSelf publishWeibo];
  }];
}

/** 创建聊股TableViewController */
- (void)createTableView {

  __weak MatchWeiboViewController *weakSelf = self;

  self.tableVC = [[MatchChatStockPageTableVC alloc] initWithFrame:self.clientView.bounds];
  self.tableVC.matchTitle = _matchTitle;

  self.tableVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };

  self.tableVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };

  [self.clientView addSubview:self.tableVC.view];
  [self addChildViewController:self.tableVC];
}

- (void)refreshButtonPressDown {
  [self.tableVC refreshButtonPressDown];
}

#pragma mark 发表
- (void)publishWeibo {

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self.indicatorView stopAnimating];
    return;
  }

  __weak MatchWeiboViewController *weakSelf = self;

  //发表聊股
  [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {

    MatchStockChatController *disVC = [[MatchStockChatController alloc]
        initWithContent:_matchTitle
            andCallBack:^(TweetListItem *item) {
              [weakSelf.tableVC.dataArray.array insertObject:item atIndex:0];
              weakSelf.tableVC.littleCattleView.hidden = YES;
              weakSelf.tableVC.dataArray.dataBinded = YES;
              [weakSelf.tableVC.tableView setTableFooterView:nil];
              weakSelf.tableVC.dataArray.dataComplete = NO;
              weakSelf.tableVC.footerView.hidden = weakSelf.tableVC.dataArray.dataComplete;
              [weakSelf.tableVC.tableView reloadData];
            }];
    [AppDelegate pushViewControllerFromRight:disVC];
  }];
}

@end
