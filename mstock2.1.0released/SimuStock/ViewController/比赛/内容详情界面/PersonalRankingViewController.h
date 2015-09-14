//
//  PersonalRankingViewController.h
//  SimuStock
//
//  Created by 刘小龙 on 15/8/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseNoTitleViewController.h"
#import "SimuCenterTabView.h"

#import "CompetitionDetailsTableVC.h"

@interface PersonalRankingViewController : BaseNoTitleViewController
@property (weak, nonatomic) IBOutlet UIView *tableViewRanking;

@property (weak, nonatomic) IBOutlet SimuCenterTabView *simuTableView;

/** tableView */
@property(strong, nonatomic) CompetitionDetailsTableVC *detailsTbaleView;

@property(strong, nonatomic) NSMutableDictionary *rankVCs;
/**  头 */
@property (weak, nonatomic) IBOutlet UIView *headView;

/**
 * 比赛类型，Type（974:用户创建的比赛,976:已结束比赛,977:待开赛比赛,978:团队比赛）
 */
@property(nonatomic, strong) NSString *mType;

@property(nonatomic, strong) NSString *matchId;
/** 盈利榜类型 */
@property(nonatomic, strong) NSString *rankType;
@property(nonatomic, assign) BOOL isSchoolRank;

@property(nonatomic, strong) NSString *titleName;

/** 开始加载，通知父容器*/
@property(copy, nonatomic) CallBackAction beginRefreshCompetitionBack;

/** 结束加载，通知父容器*/
@property(copy, nonatomic) CallBackAction endRefreshCompetitionBack;


- (void)resetHeight:(CGRect)frame;


/** 初始化对象 */
-(void)createCompetitionDetailsTableView:(NSInteger)index;

/** init */
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
          withMatchID:(NSString *)matchID
        withMatchType:(NSString *)matchType
         withRankType:(NSString *)rankType;

@end
