//
//  MyCollectTweetViewController.m
//  SimuStock
//
//  Created by Mac on 14/12/12.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

@implementation MyCollectTweetViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [_topToolBar resetContentAndFlage:@"我的收藏" Mode:TTBM_Mode_Leveltwo];
  [_littleCattleView setInformation:@"快去收藏喜欢的聊股吧"];
  [self createTableView];
  [self.weiboListViewController refreshButtonPressDown];
}



-(void) createTableView {
  
  __weak MyCollectTweetViewController* weakSelf = self;
  
  self.weiboListViewController = [[WeiboListViewController alloc] initWithFrame:self.clientView.bounds withTitle:@""];
  self.weiboListViewController.showFavorite = NO;
  
  self.weiboListViewController.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };
  
  self.weiboListViewController.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };
  
  self.weiboListViewController.requestWeiboListCallBack = ^(NSNumber *fromId, NSInteger reqNum, HttpRequestCallBack *callback){
    [TweetList requestGetFaverateTweetListWithFromId:fromId
                                          withReqNum:reqNum
                                        withCallback:callback];
  };
  
  self.weiboListViewController.preWeiboListBindingCallBack = ^(TweetList *tweetList){
    for (TweetListItem *weibo in tweetList.tweetListArray) {
      [WBCoreDataUtil insertCollectTid:weibo.tstockid];
    };
  };
  
  [self.clientView addSubview:self.weiboListViewController.view];
  [self addChildViewController:self.weiboListViewController];
}

- (void)refreshButtonPressDown{
  [self.weiboListViewController refreshButtonPressDown];
}

@end
