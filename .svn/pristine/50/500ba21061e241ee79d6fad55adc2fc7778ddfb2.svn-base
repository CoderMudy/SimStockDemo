//
//  SimuSchoolMatchTableVC.h
//  SimuStock
//
//  Created by jhss on 15/8/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "BaseTableViewController.h"

@interface SimuSchoolMatchTableAdapter : BaseTableAdapter
/**  排名类型*/
@property(nonatomic, strong) NSString *matchsType;
@end

@interface SimuSchoolMatchTableVC : BaseTableViewController
/**
 * 比赛类型，Type（974:用户创建的比赛,976:已结束比赛,977:待开赛比赛,978:团队比赛）
 */
@property(nonatomic, strong) NSString *mType;
/** 比赛团ID */
@property(nonatomic, strong) NSString *matchId;

/** 团队ID */
@property(nonatomic, strong) NSString *tempId;

/** 盈利榜类型 */
@property(nonatomic, strong) NSString *rankType;

@property(nonatomic, strong) NSString *titleName;

/**  排名类型*/
@property(nonatomic, strong) NSString *matchsType;

- (id)initWithFrame:(CGRect)frame
              Mtype:(NSString *)type
        withMatchId:(NSString *)matchId
         withTempId:(NSString *)tempID
       withRankType:(NSString *)rankType
      withTitleName:(NSString *)titleName
     withMatchsType:(NSString *)matchsType;

@end
