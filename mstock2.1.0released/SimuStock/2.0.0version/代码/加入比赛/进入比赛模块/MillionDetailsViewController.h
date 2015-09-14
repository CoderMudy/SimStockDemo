//
//  MillionDetailsViewController.h
//  SimuStock
//
//  Created by moulin wang on 14-8-1.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MakingScreenShot.h"
#import "MakingShareAction.h"
#import "BaseViewController.h"
#import "MillionDetailsTableViewCell.h"
#import "MJRefresh.h"
#import "UIButton+block.h"
#import "TrendViewController.h"
#import "DataArray.h"

/** 比赛中用户页中的交易明细Tab页 */
@interface MillionDetailsViewController
    : BaseViewController <MJRefreshBaseViewDelegate, UITableViewDataSource,
                          UITableViewDelegate,
                          MillionDetailsTableViewCellDelegate> {
  //查询的用户id
  NSString *mpvc_appointuid;
  //昵称
  NSString *mpvc_titleName;
  //比赛id
  NSString *mpvc_matchID;
  //截屏
  MakingScreenShot *makingScreenShot;
  //图片截取成功，做分享
  MakingShareAction *shareAction;
  //对某一行的操作
  NSInteger tempRow;

  //没有数据
  UIView *noDataFootView;
  //表格视图用于显示盈利信息
  UITableView *milliontableView;
  MJRefreshFooterView *footerview;
  //数据
  DataArray *dataArray;
  /** 无网小牛 */
  LittleCattleView *newLittleCattleView;
}

@property(nonatomic, strong) NSString *titleName;
@property(nonatomic, strong) NSString *appointuid;
@property(nonatomic, strong) NSString *matchID;
@property(nonatomic, strong) UIViewController *simuMainVC;

- (id)initAappointuid:(NSString *)appointuid
            titleName:(NSString *)titleName
              matchID:(NSString *)matchID
               Object:(UIViewController *)controller;
//页面切换刷新按钮状态
- (void)refreshPageToggleButtonState:(BOOL)refresh;
@end
