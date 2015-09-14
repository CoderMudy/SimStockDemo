//
//  CompetitionRankDetailVC.h
//  SimuStock
//
//  Created by jhss_wyz on 15/6/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNoTitleViewController.h"
#import "CompetitionDetailsTableVC.h"

#import "SimuMatchsTableVC.h"
#import "SimuGroupMatchTableVC.h"
#import "SimuSchoolMatchTableVC.h"

@class SimuCenterTabView;

@interface CompetitionRankDetailVC : BaseNoTitleViewController

@property(weak, nonatomic) IBOutlet SimuCenterTabView *simuCenterTabView;
@property(weak, nonatomic) IBOutlet UIView *rankDetailsView;
@property(weak, nonatomic) IBOutlet UIView *headView;
@property(strong, nonatomic) NSMutableDictionary *rankVCs;
@property(strong, nonatomic) CompetitionDetailsTableVC *currentRankVC;

@property(nonatomic, strong) SimuMatchsTableVC *matchsVC;
@property(nonatomic, strong) SimuGroupMatchTableVC *groupVC;
@property(nonatomic, strong) SimuSchoolMatchTableVC *schoolVC;

@property(weak, nonatomic) UIButton *selectedBtn;

@property(weak, nonatomic) IBOutlet UILabel *userName;

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

@property(copy, nonatomic) NSString *tempID;

- (void)switchCompetitionRankVC:(NSInteger)index;
- (void)resetHeight:(CGRect)frame;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
          withMatchID:(NSString *)matchID
        withMatchType:(NSString *)matchType
         withRankType:(NSString *)rankType;

/** 对外提供的刷新方法 */
- (void)foreignProvideRefreshWithIndex:(NSInteger)index;

@end
