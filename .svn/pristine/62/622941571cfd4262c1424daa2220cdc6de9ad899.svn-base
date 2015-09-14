//
//  SimuSchoolMatchsViewController.m
//  SimuStock
//
//  Created by jhss on 15/8/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SimuSchoolMatchsViewController.h"
#import "MakingShareAction.h"
#import "CompetitionRankDetailVC.h"
#import "InvitationGoodFriendButton.h"

@interface SimuSchoolMatchsViewController ()

@end

@implementation SimuSchoolMatchsViewController
- (id)initWithTitleName:(NSString *)titleName
            withMatchID:(NSString *)matchId
             withTempID:(NSString *)tempID
          withMatchType:(NSString *)matchType {
  self = [super init];
  if (self) {
    self.titleName = titleName;
    self.matchType = matchType;
    self.tempId = tempID;
    self.matchid = matchId;
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  _indicatorView.hidden = YES;
  [_topToolBar resetContentAndFlage:self.titleName Mode:TTBM_Mode_Leveltwo];
  [self createInviteFriendBtn];
  [self schoolMatchVC];
}
- (void)createInviteFriendBtn {
  //邀请好友按钮
  InvitationGoodFriendButton *invtationButton =
      [[InvitationGoodFriendButton alloc] initInvitationButtonWithTopBar:_topToolBar
                                                       withIndicatorView:_indicatorView];
  __weak SimuSchoolMatchsViewController *weakSelf = self;
  invtationButton.invitationButtonBlock = ^() {
    SimuSchoolMatchsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf shareMatchAction];
    }
  };
}

- (void)shareMatchAction {
  MakingShareAction *matchDetailShareAction = [[MakingShareAction alloc] init];
  matchDetailShareAction.shareModuleType = ShareModuleTypeStockMatchRank;
  NSString *matchDetailShareUrl =
      [NSString stringWithFormat:@"http://www.youguu.com/opms/fragment/html/fragment.html"];
  //分享内容加在otherInfo中
  [matchDetailShareAction shareTitle:[NSString stringWithFormat:@"%@很不错，你也来试试 ", self.shareTitle]
                             content:[NSString stringWithFormat:@"#优顾炒股#%@很不错，你也来试试 " @"%@ (分享自@优顾炒股官方)", self.shareTitle, matchDetailShareUrl]
                               image:[UIImage imageNamed:@"shareIcon"]
                      withOtherImage:nil
                        withShareUrl:matchDetailShareUrl
                       withOtherInfo:[NSString stringWithFormat:@"#优顾炒股#%@很不错，你也来试试 " @"%@ (分享自@优顾炒股官方)", self.shareTitle, matchDetailShareUrl]];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [_rankDetailVC.simuCenterTabView reSetUpFrameSimuCenterTableView];
}

//校内个人比赛排名
- (void)schoolMatchVC {

  CGRect frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, CGRectGetHeight(_clientView.bounds));

  _rankDetailVC = [[CompetitionRankDetailVC alloc] initWithNibName:@"CompetitionRankDetailVC"
                                                            bundle:nil
                                                       withMatchID:self.matchid
                                                     withMatchType:nil
                                                      withRankType:nil];

  _rankDetailVC.isSchoolRank = YES;
  _rankDetailVC.tempID = self.tempId;
  _rankDetailVC.titleName = self.titleName;
  _rankDetailVC.view.frame = frame;
  [_clientView addSubview:_rankDetailVC.view];
  [self addChildViewController:_rankDetailVC];
  NSArray *array = @[ @"周盈利榜", @"月盈利榜", @"总盈利榜" ];
  [_rankDetailVC.simuCenterTabView resetButtons:array];
  [_rankDetailVC resetHeight:frame];

  __weak SimuSchoolMatchsViewController *weakSelf = self;
  _rankDetailVC.beginRefreshCompetitionBack = ^() {
    SimuSchoolMatchsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView startAnimating];
      strongSelf.indicatorView.hidden = NO;
    }
  };
  _rankDetailVC.endRefreshCompetitionBack = ^() {
    SimuSchoolMatchsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      strongSelf.indicatorView.hidden = YES;
      [strongSelf.indicatorView stopAnimating];
    }
  };

  [_rankDetailVC switchCompetitionRankVC:0];
}

@end
