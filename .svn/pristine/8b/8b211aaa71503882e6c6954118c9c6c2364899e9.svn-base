//
//  SimuTotalMatchViewController.m
//  SimuStock
//
//  Created by jhss on 15/8/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SimuTotalMatchViewController.h"
#import "MakingShareAction.h"
#import "CompetitionRankDetailVC.h"
#import "InvitationGoodFriendButton.h"
#import "PersonalRankingViewController.h"

@interface SimuTotalMatchViewController ()
/** 区分是 团体赛 还是 个人赛 个人赛 == YES */
@property(assign, nonatomic) BOOL lndividualOrGroupMatch;

/** 比赛导航条内容 */
@property(strong, nonatomic) NSArray *topArray;

@property(strong, nonatomic) PersonalRankingViewController *rankingVC;

@end

@implementation SimuTotalMatchViewController

- (id)initWithTitleName:(NSString *)titleName
            withMatchID:(NSString *)matchID
          withMatchType:(NSString *)matchType {
  self = [super init];
  if (self) {
    self.titleName = titleName;
    self.matchid = matchID;
    self.matchType = matchType;
  }
  return self;
}

- (void)tabSelected:(NSInteger)index {
}

////点击标签回调
- (void)changeToIndex:(NSInteger)index {
  pageIndex = index;
  CGFloat screenWidth = self.view.bounds.size.width;
  [_scrollView setContentOffset:CGPointMake(screenWidth * index, 0) animated:YES];
  if (index == 1) {
    if (!_groupDetailVC) {
      [self groupMatchVC];
    }
  }
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  if (!self.lndividualOrGroupMatch) {
    _scrollView.contentSize = CGSizeMake(WIDTH_OF_SCREEN * 2, _scrollView.bounds.size.height);
  }
  if (_rankDetailVC != nil) {
    [_rankDetailVC.simuCenterTabView reSetUpFrameSimuCenterTableView];
  }
  if (_rankingVC != nil) {
    [_rankingVC.simuTableView reSetUpFrameSimuCenterTableView];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  pageIndex = 0;
  self.topArray = @[ @"周盈利榜", @"月盈利榜", @"总盈利榜" ];
  [_topToolBar resetContentAndFlage:self.titleName Mode:TTBM_Mode_Leveltwo];
  _littleCattleView.hidden = YES;
  _indicatorView.hidden = YES;
  [self createInviteFriendBtn];
  [self creatrView];
}

/** 创建视图 */
- (void)creatrView {
  switch ([self.matchType intValue]) {
  case 978:
    //团体
    {
      self.lndividualOrGroupMatch = NO;
      [self caretrTopToolBar];
      //创建滚动视图
      [self createScrolView];
    }
    return;
  case 974:
  case 976:
  case 977:
  case 971:
  case 972:
  case 973:
    //个人
    {
      self.lndividualOrGroupMatch = YES;
      [self personalRankingView];
    }
    return;
  default:
    break;
  }
}

/** 团体赛 */
- (void)caretrTopToolBar {
  topToolbarView = [[TopToolBarView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, TOP_TABBAR_HEIGHT)
                                               DataArray:@[ @"个人排名", @"团队排名" ]
                                     withInitButtonIndex:0];
  topToolbarView.delegate = self;
  [_clientView addSubview:topToolbarView];
}

/** 邀请好友按钮 */
- (void)createInviteFriendBtn {
  //邀请好友按钮
  InvitationGoodFriendButton *invtationButton =
      [[InvitationGoodFriendButton alloc] initInvitationButtonWithTopBar:_topToolBar
                                                       withIndicatorView:_indicatorView];
  __weak SimuTotalMatchViewController *weakSelf = self;
  invtationButton.invitationButtonBlock = ^() {
    SimuTotalMatchViewController *strongSelf = weakSelf;
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

//个人比赛排名
- (void)persionMatchVC {

  CGRect frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, CGRectGetHeight(_scrollView.bounds));
  _rankDetailVC = [[CompetitionRankDetailVC alloc] initWithNibName:@"CompetitionRankDetailVC"
                                                            bundle:nil
                                                       withMatchID:self.matchid
                                                     withMatchType:self.matchType
                                                      withRankType:@"1"];
  _rankDetailVC.titleName = self.titleName;
  _rankDetailVC.view.frame = frame;
  [_rankDetailVC resetHeight:frame];
  [_scrollView addSubview:_rankDetailVC.view];
  [self addChildViewController:_rankDetailVC];
  [_rankDetailVC.simuCenterTabView resetButtons:self.topArray];

  __weak SimuTotalMatchViewController *weakSelf = self;
  _rankDetailVC.beginRefreshCompetitionBack = ^() {
    SimuTotalMatchViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView startAnimating];
      strongSelf.indicatorView.hidden = NO;
    }
  };
  _rankDetailVC.endRefreshCompetitionBack = ^() {
    SimuTotalMatchViewController *strongSelf = weakSelf;
    if (strongSelf) {
      strongSelf.indicatorView.hidden = YES;
      [strongSelf.indicatorView stopAnimating];
    }
  };
  [_rankDetailVC switchCompetitionRankVC:0];
}
//创建团体视图
- (void)groupMatchVC {
  CGRect frame = CGRectMake(WIDTH_OF_SCREEN, 0, WIDTH_OF_SCREEN, CGRectGetHeight(_scrollView.bounds));
  _groupDetailVC = [[CompetitionRankDetailVC alloc] initWithNibName:@"CompetitionRankDetailVC"
                                                             bundle:nil
                                                        withMatchID:self.matchid
                                                      withMatchType:self.matchType
                                                       withRankType:@"2"];
  _groupDetailVC.titleName = self.titleName;
  _groupDetailVC.view.frame = frame;
  _groupDetailVC.userName.text = @"学校";
  [_scrollView addSubview:_groupDetailVC.view];
  [self addChildViewController:_groupDetailVC];
  [_groupDetailVC.simuCenterTabView resetButtons:self.topArray];
  [_groupDetailVC resetHeight:frame];
  __weak SimuTotalMatchViewController *weakSelf = self;
  _groupDetailVC.beginRefreshCompetitionBack = ^() {
    SimuTotalMatchViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView startAnimating];
      strongSelf.indicatorView.hidden = NO;
    }
  };
  _groupDetailVC.endRefreshCompetitionBack = ^() {
    SimuTotalMatchViewController *strongSelf = weakSelf;
    if (strongSelf) {
      strongSelf.indicatorView.hidden = YES;
      [strongSelf.indicatorView stopAnimating];
    }
  };
  [_groupDetailVC switchCompetitionRankVC:0];
}
//创建滚动视图
- (void)createScrolView {
  _scrollView =
      [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOP_TABBAR_HEIGHT, WIDTH_OF_SCREEN,
                                                     CGRectGetHeight(_clientView.bounds) - TOP_TABBAR_HEIGHT)];
  _scrollView.contentSize = CGSizeMake(WIDTH_OF_SCREEN * 2, CGRectGetHeight(_clientView.bounds));
  _scrollView.pagingEnabled = YES;
  _scrollView.delegate = self;
  _scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.showsVerticalScrollIndicator = YES;
  _scrollView.bounces = NO;
  _scrollView.backgroundColor = [UIColor clearColor];
  [_clientView addSubview:_scrollView];
  //创建视图
  [self persionMatchVC];
}
//设置标示线  在滚动的代理方法里
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  if (scrollView == _scrollView) {
    if (scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x <= WIDTH_OF_SCREEN) {
      topToolbarView.maxlineView.frame = CGRectMake(
          scrollView.contentOffset.x / 2, topToolbarView.bounds.size.height - 3, WIDTH_OF_SCREEN / 2, 2.5);
    }
  }
}

#pragma mark scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

  if (scrollView == _scrollView) {
    CGPoint offset = scrollView.contentOffset;
    if (offset.x == 0) {
      [topToolbarView changTapToIndex:0];
    } else if (offset.x == WIDTH_OF_VIEWCONTROLLER) {
      [topToolbarView changTapToIndex:1];
    }
  }
}

/** 只有个人排名界面 */
- (void)personalRankingView {
  self.rankingVC =
      [[PersonalRankingViewController alloc] initWithNibName:@"PersonalRankingViewController"
                                                      bundle:nil
                                                 withMatchID:self.matchid
                                               withMatchType:self.matchType
                                                withRankType:@"1"];
  _rankingVC.titleName = self.titleName;
  _rankingVC.view.frame = _clientView.bounds;
  [_clientView addSubview:_rankingVC.view];
  [self addChildViewController:_rankingVC];
  [_rankingVC.simuTableView resetButtons:self.topArray];

  [_rankingVC resetHeight:_clientView.bounds];

  __weak SimuTotalMatchViewController *weakSelf = self;
  _rankingVC.beginRefreshCompetitionBack = ^() {
    SimuTotalMatchViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView startAnimating];
      strongSelf.indicatorView.hidden = NO;
    }
  };
  _rankingVC.endRefreshCompetitionBack = ^() {
    SimuTotalMatchViewController *strongSelf = weakSelf;
    if (strongSelf) {
      strongSelf.indicatorView.hidden = YES;
      [strongSelf.indicatorView stopAnimating];
    }
  };
  //数据请求
  [_rankingVC createCompetitionDetailsTableView:0];
}

@end
