//
//  SimuSchoolMatchsViewController.h
//  SimuStock
//
//  Created by jhss on 15/8/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

/**
 学校内部排名类
 */
#import "BaseViewController.h"
#import "TopToolBarView.h"
#import "SimuCenterTabView.h"

@class CompetitionRankDetailVC;
@interface SimuSchoolMatchsViewController : BaseViewController {
  ///创建上方导航栏
  TopToolBarView *topToolbarView;
}
@property(nonatomic, strong) CompetitionRankDetailVC *rankDetailVC;

/** 昵称 */
@property(nonatomic, strong) NSString *titleName;
/** 比赛id */
@property(nonatomic, copy) NSString *matchid;

/** 团队Id */
@property(nonatomic, copy) NSString *tempId;

/**  比赛类型*/
@property(nonatomic, strong) NSString *matchType;

@property(nonatomic, strong) NSString *shareTitle;

- (id)initWithTitleName:(NSString *)titleName
            withMatchID:(NSString *)matchId
             withTempID:(NSString *)tempID
          withMatchType:(NSString *)matchType;

@end
