//
//  CompetitionDetailsBaseVC.h
//  SimuStock
//
//  Created by jhss_wyz on 15/6/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface CompetitionDetailsTableAdapter : BaseTableAdapter

@end

@interface CompetitionDetailsTableVC : BaseTableViewController

/**
 * 比赛类型，Type（974:用户创建的比赛,976:已结束比赛,977:待开赛比赛,978:团队比赛）
 */
@property(nonatomic, strong) NSString *mType;

@property(nonatomic, strong) NSString *matchId;
/** 盈利榜类型 */
@property(nonatomic, strong) NSString *rankType;

@property(nonatomic, strong) NSString *titleName;

- (id)initWithFrame:(CGRect)frame
          withMTpye:(NSString *)mType
        withMatchID:(NSString *)matchID
       withRankType:(NSString *)rankType
      withTitleName:(NSString *)titleName;

@end
