//
//  HomepageViewController.h
//  SimuStock
//
//  Created by moulin wang on 14-5-21.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MakingScreenShot.h"
#import "MakingShareAction.h"
#import "simuSellViewController.h"
#import "HomeUserInformationData.h"
#import "UserInfoNotificationUtil.h"
#import "UserGradeView.h"
#import "HomePageUserInfoView.h"
#import "HomePageTableHeaderView.h"
#import "HomePageTableHeaderPresentation.h"
#import "HomePageChatStockTableVC.h"

@class UserListItem;
@class UserTradeGradeWidget;
@class HomeSimuProfitLineView;
@class SimuTouchMoveView;
@class MoreSelectedView;

typedef void (^homePageTableOnSuccess)(BOOL isRequestSuccess);

/**个人主页*/
@interface HomepageViewController
    : BaseViewController <ShareStatDelegate, HomePageChatStockTVCProtocol, UIAlertViewDelegate> {

  ///警告框
  UIView *_alertbrackView;

  ///截屏
  MakingScreenShot *_makingScreenShot;
  ///图片截取成功，做分享
  MakingShareAction *_shareAction;
  ///判断初次进入界面
  BOOL _initialBool;

  ///对某一行的操作
  NSInteger _tempRow;
  ///未登录时记录cell中所点的买入、卖出股票
  NSString *_cell_trade_button_stockCode;
  NSString *_cell_trade_button_stockName;
  ///总盈利率和排名
  NSString *_endProfitRate;
  NSString *_userRanking;

  ///可拉伸图片(背景图)
  UIImageView *_stretchImage;
  ///手动侧滑控件
  SimuTouchMoveView *_stmv_touchView;
  ///存放数据
  NSMutableDictionary *_informationDic;
  ///个人主页显示每条聊股的table控制器
  HomePageChatStockTableVC *tableVC;
  ///优顾V认证标志
  UILabel *_vSignView;
}

///用户信息变更通知
@property(nonatomic, strong) UserInfoNotificationUtil *userInfoNotificationUtil;
///昵称
@property(nonatomic, strong) NSString *titleName;
/** 分组浮窗 */
@property(nonatomic, strong) MoreSelectedView *moreSelectedView;
/**牛人计划id*/
@property(nonatomic, strong) NSString *accountId;
/**是否购买牛人计划*/
@property(nonatomic) BOOL isShowSuper;
///查询的用户id
@property(nonatomic, strong) NSString *userId;
///比赛id
@property(nonatomic, strong) NSString *matchID;
@property(nonatomic) BOOL isSelf;
@property(nonatomic) BOOL jumpBool;
/** 赞的数量 */
@property(nonatomic) NSInteger fansNumber;
@property(nonatomic) NSInteger viptype;

@property(strong, nonatomic) HomePageTableHeaderData *tableHeaderData;
@property(strong, nonatomic) HomePageTableHeaderView *tableHeaderView;
@property(strong, nonatomic) HomePageTableHeaderPresentation *tableHeaderPresentation;

///头像链接
@property(nonatomic, strong) NSString *pictureUrl;
/**改界面的初始化方法*/
- (id)initUserId:(NSString *)userId titleName:(NSString *)titleName matchID:(NSString *)matchId;

+ (void)showWithUserId:(NSString *)userId
             titleName:(NSString *)titleName
               matchId:(NSString *)matchId;

@end
