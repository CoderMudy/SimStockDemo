//
//  CompetitionRankDetailVC.m
//  SimuStock
//
//  Created by jhss_wyz on 15/6/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CompetitionRankDetailVC.h"
#import "SimuCenterTabView.h"

@interface CompetitionRankDetailVC () <SimuCenterTabViewDelegate>

@end

@implementation CompetitionRankDetailVC
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
- (void)viewDidLoad {
  [super viewDidLoad];
  self.rankVCs = [@{} mutableCopy];
  _simuCenterTabView.delegate = self;
}

//_simuCenterTabView delegate
- (void)tabSelected:(NSInteger)index {
  [self switchCompetitionRankVC:index];
}

- (void)resetHeight:(CGRect)frame {
  self.view.frame = frame;
  self.rankDetailsView.height = self.view.height - self.headView.bottom;
  self.rankDetailsView.width = self.view.width;
  self.currentRankVC.tableView.height = self.rankDetailsView.height;
  self.currentRankVC.tableView.width = self.rankDetailsView.width;
}

- (void)switchCompetitionRankVC:(NSInteger)index {

  //学校内部排名
  if (_isSchoolRank) {
    [self GoToSchoolViewWithIndex:index];
    return;
  }
  //个人排名
  if ([_rankType isEqualToString:@"1"]) {
    [self GoToPersonalViewWithIndex:index];
    return;
  } else if ([_rankType isEqualToString:@"2"]) {
    //团队排名
    [self GoToGroundViewWithIndex:index];
    return;
  } else {
    //普通
    [self GotoRankDeatilsViewWithIndex:index];
  }
}
- (void)GotoRankDeatilsViewWithIndex:(NSInteger)index {
  CompetitionDetailsTableVC *detailsTVC = self.rankVCs[@(index)];
  if (detailsTVC == nil) {
    NSDictionary *dic;
    if (_simuCenterTabView.buttonArray.count == 2) {
      dic = @{ @1 : @"total", @0 : @"week" };
    } else {
      dic = @{ @2 : @"total", @1 : @"month", @0 : @"week" };
    }

    detailsTVC = [[CompetitionDetailsTableVC alloc] initWithFrame:self.rankDetailsView.bounds
                                                        withMTpye:self.mType
                                                      withMatchID:self.matchId
                                                     withRankType:dic[@(index)]
                                                    withTitleName:self.titleName];
    detailsTVC.beginRefreshCallBack = self.beginRefreshCompetitionBack;
    detailsTVC.endRefreshCallBack = self.endRefreshCompetitionBack;
    detailsTVC.showTableFooter = YES;
    self.rankVCs[@(index)] = detailsTVC;
  }

  [self.rankDetailsView addSubview:detailsTVC.view];
  [self addChildViewController:detailsTVC];

  if (self.currentRankVC && self.currentRankVC != detailsTVC) {
    [self.currentRankVC.view removeFromSuperview];
    [self.currentRankVC removeFromParentViewController];
  }
  self.currentRankVC = detailsTVC;
  if (self.currentRankVC.tableView.height != self.rankDetailsView.height) {
    self.currentRankVC.tableView.height = self.rankDetailsView.height;
  }

  if (![detailsTVC dataBinded]) {
    [detailsTVC refreshButtonPressDown];
  }
}
//团队
- (void)GoToGroundViewWithIndex:(NSInteger)index {

  SimuGroupMatchTableVC *groupVC = self.rankVCs[@(index)];

  if (groupVC == nil) {
    NSDictionary *dic;

    dic = @{ @2 : @"total", @1 : @"month", @0 : @"week" };

    groupVC = [[SimuGroupMatchTableVC alloc] initWithFrame:self.rankDetailsView.bounds
                                                 withMType:self.mType
                                               withMtahcID:self.matchId
                                              withRankType:dic[@(index)]
                                             withTilteName:self.titleName];
    groupVC.beginRefreshCallBack = self.beginRefreshCompetitionBack;
    groupVC.endRefreshCallBack = self.endRefreshCompetitionBack;
    groupVC.showTableFooter = YES;
    self.rankVCs[@(index)] = groupVC;
  }

  [self.rankDetailsView addSubview:groupVC.view];
  [self addChildViewController:groupVC];

  if (self.groupVC && self.groupVC != groupVC) {
    [self.groupVC.view removeFromSuperview];
    [self.groupVC removeFromParentViewController];
  }
  self.groupVC = groupVC;
  if (self.groupVC.tableView.height != self.rankDetailsView.height) {
    self.groupVC.tableView.height = self.rankDetailsView.height;
  }

  if (![groupVC dataBinded]) {
    [groupVC refreshButtonPressDown];
  }
}
//个人排名
- (void)GoToPersonalViewWithIndex:(NSInteger)index {

  SimuMatchsTableVC *matchVC = self.rankVCs[@(index)];

  if (matchVC == nil) {
    NSDictionary *dic;

    dic = @{ @2 : @"total", @1 : @"month", @0 : @"week" };

    matchVC = [[SimuMatchsTableVC alloc] initWithFrame:self.rankDetailsView.bounds
                                             withMType:self.mType
                                           withMtahcID:self.matchId
                                          withRankType:dic[@(index)]
                                         withTilteName:self.titleName
                                        withMatchsType:_rankType];
    matchVC.beginRefreshCallBack = self.beginRefreshCompetitionBack;
    matchVC.endRefreshCallBack = self.endRefreshCompetitionBack;
    matchVC.showTableFooter = YES;
    self.rankVCs[@(index)] = matchVC;
  }

  [self.rankDetailsView addSubview:matchVC.view];
  [self addChildViewController:matchVC];

  if (self.matchsVC && self.matchsVC != matchVC) {
    [self.matchsVC.view removeFromSuperview];
    [self.matchsVC removeFromParentViewController];
  }
  self.matchsVC = matchVC;
  if (self.matchsVC.tableView.height != self.rankDetailsView.height) {
    self.matchsVC.tableView.height = self.rankDetailsView.height;
  }

  if (![matchVC dataBinded]) {
    [matchVC refreshButtonPressDown];
  }
}
//学校内部排名
- (void)GoToSchoolViewWithIndex:(NSInteger)index {
  SimuSchoolMatchTableVC *schoolVC = self.rankVCs[@(index)];

  if (schoolVC == nil) {
    NSDictionary *dic;

    dic = @{ @2 : @"total", @1 : @"month", @0 : @"week" };
    schoolVC = [[SimuSchoolMatchTableVC alloc] initWithFrame:self.rankDetailsView.bounds
                                                       Mtype:self.mType
                                                 withMatchId:self.matchId
                                                  withTempId:self.tempID
                                                withRankType:dic[@(index)]
                                               withTitleName:self.titleName
                                              withMatchsType:_rankType];

    schoolVC.beginRefreshCallBack = self.beginRefreshCompetitionBack;
    schoolVC.endRefreshCallBack = self.endRefreshCompetitionBack;
    schoolVC.showTableFooter = YES;
    self.rankVCs[@(index)] = schoolVC;
  }

  [self.rankDetailsView addSubview:schoolVC.view];
  [self addChildViewController:schoolVC];

  if (self.schoolVC && self.schoolVC != schoolVC) {
    [self.schoolVC.view removeFromSuperview];
    [self.schoolVC removeFromParentViewController];
  }
  self.schoolVC = schoolVC;
  if (self.schoolVC.tableView.height != self.rankDetailsView.height) {
    self.schoolVC.tableView.height = self.rankDetailsView.height;
  }

  if (![schoolVC dataBinded]) {
    [schoolVC refreshButtonPressDown];
  }
}

/** 对外提供的刷新方法 */
- (void)foreignProvideRefreshWithIndex:(NSInteger)index {
}

@end
