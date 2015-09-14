//
//  PersonalRankingViewController.m
//  SimuStock
//
//  Created by 刘小龙 on 15/8/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PersonalRankingViewController.h"

@interface PersonalRankingViewController () <SimuCenterTabViewDelegate>

@end

@implementation PersonalRankingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
          withMatchID:(NSString *)matchID
        withMatchType:(NSString *)matchType
         withRankType:(NSString *)rankType {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.matchId = matchID;
    self.mType = matchType;
    self.rankType = rankType;
  }
  return self;
}

- (void)tabSelected:(NSInteger)index {
  [self createCompetitionDetailsTableView:index];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.rankVCs = [@{} mutableCopy];
  self.simuTableView.delegate = self;
}

- (void)resetHeight:(CGRect)frame {
  self.view.frame = frame;
  self.tableViewRanking.height = self.view.height - self.headView.bottom;
  self.tableViewRanking.width = self.view.width;
  self.detailsTbaleView.tableView.height = self.tableViewRanking.height;
  self.detailsTbaleView.tableView.width = self.tableViewRanking.width;
}

-(void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
}

- (void)createCompetitionDetailsTableView:(NSInteger)index {
  CompetitionDetailsTableVC *detailsVC = self.rankVCs[@(index)];
  if (detailsVC == nil) {
    NSDictionary *dic;
    if (_simuTableView.buttonArray.count == 2) {
      dic = @{ @1 : @"total", @0 : @"week" };
    } else {
      dic = @{ @2 : @"total", @1 : @"month", @0 : @"week" };
    }

    detailsVC = [[CompetitionDetailsTableVC alloc] initWithFrame:self.tableViewRanking.bounds
                                                       withMTpye:self.mType
                                                     withMatchID:self.matchId
                                                    withRankType:dic[@(index)]
                                                   withTitleName:self.titleName];
    detailsVC.beginRefreshCallBack = self.beginRefreshCompetitionBack;
    detailsVC.endRefreshCallBack = self.endRefreshCompetitionBack;
    detailsVC.showTableFooter = YES;
    self.rankVCs[@(index)] = detailsVC;
  }

  [self.tableViewRanking addSubview:detailsVC.view];
  [self addChildViewController:detailsVC];
  if (self.detailsTbaleView && self.detailsTbaleView != detailsVC) {
    [self.detailsTbaleView.view removeFromSuperview];
    [self.detailsTbaleView removeFromParentViewController];
  }
  self.detailsTbaleView = detailsVC;
  if (self.detailsTbaleView.tableView.height != self.tableViewRanking.height) {
    self.detailsTbaleView.tableView.height = self.tableViewRanking.height;
  }
  if (![detailsVC dataBinded]) {
    [detailsVC refreshButtonPressDown];
  }
}

@end
