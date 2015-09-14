//
//  CompetitionDetailsNewViewController.m
//  SimuStock
//
//  Created by Yuemeng on 15/7/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CompetitionDetailsViewController.h"
#import "CompetitionDetailsVC.h"
#import "MakingShareAction.h"
#import "SimuUtil.h"
#import "NewShowLabel.h"
#import "InvitationGoodFriendButton.h"

@implementation CompetitionDetailsViewController

- (id)initWithMatchID:(NSString *)matchID
        withTitleName:(NSString *)titleName
            withMtype:(NSString *)matchType {
  self = [super init];
  if (self) {
    self.matchID = matchID;
    self.mType = matchType;
    self.titleName = titleName;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _indicatorView.hidden = YES;
  [self resetTitle:_titleName];
  [self createInviteFriendBtn];
  //判断网络
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [_littleCattleView isCry:YES];
    return;
  }
  _storeUtil = [[StoreUtil alloc] initWithUIViewController:self];
  CompetitionDetailsVC *competitionDetailsVC = [[CompetitionDetailsVC alloc] initWithMatchID:self.matchID
                                                                               withTitleName:self.titleName
                                                                                   withMtype:self.mType
                                                                                withCalssObj:self];
  competitionDetailsVC.webBool = self.webBool;
  competitionDetailsVC.webStringUrl = self.webStringURL;
  competitionDetailsVC.view.frame = self.clientView.bounds;

  [self.clientView addSubview:competitionDetailsVC.view];
  [self addChildViewController:competitionDetailsVC];
}

- (void)createInviteFriendBtn {
  //邀请好友按钮
  InvitationGoodFriendButton *invtationButton =
      [[InvitationGoodFriendButton alloc] initInvitationButtonWithTopBar:_topToolBar
                                                       withIndicatorView:_indicatorView];
  __weak CompetitionDetailsViewController *weakSelf = self;
  invtationButton.invitationButtonBlock = ^() {
    CompetitionDetailsViewController *strongSelf = weakSelf;
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
  [matchDetailShareAction shareTitle:[NSString stringWithFormat:@"%@很不错，你也来试试 ", self.titleName]
                             content:[NSString stringWithFormat:@"#优顾炒股#%@很不错，你也来试试 " @"%@ (分享自@优顾炒股官方)", self.titleName, matchDetailShareUrl]
                               image:[UIImage imageNamed:@"shareIcon"]
                      withOtherImage:nil
                        withShareUrl:matchDetailShareUrl
                       withOtherInfo:[NSString stringWithFormat:@"#优顾炒股#%@很不错，你也来试试 " @"%@ (分享自@优顾炒股官方)", self.titleName, matchDetailShareUrl]];
}
@end
