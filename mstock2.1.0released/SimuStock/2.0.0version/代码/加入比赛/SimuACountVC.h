//
//  simuACountVC.h
//  SimuStock
//
//  Created by Mac on 14-7-29.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuGainsView.h"
#import "SimuIndicatorView.h"
#import "SimuRankView.h"
#import "Globle.h"
#import "PosttionTableViewCell.h"
#import "simuSellViewController.h"
#import "JhssImageCache.h"
#import "SimuRankPositionPageData.h"
#import "BaseRequester.h"
#import "HomeUserInformationData.h"
#import "DataArray.h"
#import "UserGradeView.h"
#import "BaseNoTitleViewController.h"

@class UserListItem;

/*
 *类说明：参加比赛账户页面
 */
@interface SimuACountVC : BaseNoTitleViewController <UITableViewDelegate, UITableViewDataSource> {
  //浮动盈亏控件
  SimuGainsView *sav_gainsView;
  //盈利利率排名控件
  SimuRankView *sav_rankView;

  //设定持仓
  UITableView *ssvc_postableview;

  //当前选中的用户
  SelectedRow scvc_selectedRow;
  //当前持仓，选中前表格cell高度
  float scvc_notselHeight;
  //当前仓位
  NSString *ssvc_curposition;
  //头像链接
  NSString *avatarUrl;

  UIImageView *sttbv_headimageview;

  DataArray *dataArray;

  /** 用户评级控件 */
  UserGradeView *_userGradeView;
}

/** 用户Id */
@property(copy, nonatomic) NSString *userId;
/** 用户名 */
@property(copy, nonatomic) NSString *userName;
/** 比赛Id */
@property(copy, nonatomic) NSString *matchId;
/** 用户VIP */
@property(copy, nonatomic) NSString *vipType;

/** 开始加载，通知父容器*/
@property(copy, nonatomic) CallBackAction beginRefreshCallBack;

/** 结束加载，通知父容器*/
@property(copy, nonatomic) CallBackAction endRefreshCallBack;


@property(nonatomic, copy) BuyOrSellStock buyStockAction;
@property(nonatomic, copy) BuyOrSellStock sellStockAction;

- (id)initWithFrame:(CGRect)frame
        withMatchId:(NSString *)marchId
         withUserID:(NSString *)userId
       withUserName:(NSString *)userName;

- (BOOL)dataBinded;
- (void)refreshButtonPressDown;

@end

@interface SimuMacthAccountVC : BaseViewController

@property(nonatomic, strong) SimuACountVC *accountVC;
/** 用户Id */
@property(copy, nonatomic) NSString *userId;
/** 用户名 */
@property(copy, nonatomic) NSString *userName;
/** 比赛Id */
@property(copy, nonatomic) NSString *matchId;

@property(copy, nonatomic) NSString *titleName;

@property(nonatomic, copy) BuyOrSellStock buyStockAction;
@property(nonatomic, copy) BuyOrSellStock sellStockAction;

- (id)initWithMatchId:(NSString *)marchId
           withUserID:(NSString *)userId
         withUserName:(NSString *)userName
            withTitle:(NSString *)titleName;

@end
