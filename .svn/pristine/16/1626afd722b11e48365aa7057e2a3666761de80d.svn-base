//
//  SimuTotalMatchViewController.h
//  SimuStock
//
//  Created by jhss on 15/8/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "TopToolBarView.h"

#import "SimuCenterTabView.h"

@class CompetitionRankDetailVC;

@interface SimuTotalMatchViewController
    : BaseViewController <UIScrollViewDelegate, TopToolBarViewDelegate, SimuCenterTabViewDelegate> {

  NSInteger pageIndex;

  ///创建上方导航栏
  TopToolBarView *topToolbarView;

  //创建承载滚动视图
  UIScrollView *_scrollView;
}
/** 个人排名 */
@property(nonatomic, strong) CompetitionRankDetailVC *rankDetailVC;

/** 团体排名 */
@property(nonatomic, strong) CompetitionRankDetailVC *groupDetailVC;

/** 昵称 */
@property(nonatomic, strong) NSString *titleName;
/** 比赛id */
@property(nonatomic, copy) NSString *matchid;
/**
 * 比赛类型，Type（974:用户创建的比赛,976:已结束比赛,977:待开赛比赛,978:团队比赛）
 */
@property(nonatomic, strong) NSString *matchType;

- (id)initWithTitleName:(NSString *)titleName
            withMatchID:(NSString *)matchID
          withMatchType:(NSString *)matchType;

@end
