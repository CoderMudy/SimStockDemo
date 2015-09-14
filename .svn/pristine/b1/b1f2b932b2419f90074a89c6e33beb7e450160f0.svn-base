//
//  CompetitionDetailsNewViewController.h
//  SimuStock
//
//  Created by Yuemeng on 15/7/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "StoreUtil.h"

/*
 *  比赛详情新VC
 */
@interface CompetitionDetailsViewController : BaseViewController

@property(nonatomic, strong) NSString *matchID;
@property(nonatomic, strong) NSString *titleName;

///比赛类型，Type（974:用户创建的比赛,976:已结束比赛,977:待开赛比赛,978:团队比赛）
@property(nonatomic, strong) NSString *mType;
/** 商城兑换、支付工具类 */
@property(nonatomic, strong) StoreUtil *storeUtil;

/**
 *  是否web页报名
 */
@property(assign, nonatomic) BOOL webBool;
/**
 *  web 链接
 */
@property(copy, nonatomic) NSString *webStringURL;
/**
 *  构造函数init
 *
 *  @param matchID   比赛id
 *  @param titleName 标题
 *  @param matchType 比赛类型
 *
 *  @return 实例对象
 */
- (id)initWithMatchID:(NSString *)matchID
        withTitleName:(NSString *)titleName
            withMtype:(NSString *)matchType;

@end
