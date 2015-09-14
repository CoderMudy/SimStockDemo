//
//  SimuHavePrizeViewController.h
//  SimuStock
//
//  Created by jhss on 15/8/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "TopToolBarView.h"
#import "SimuCenterTabView.h"

#import "InvitationCodeView.h"
#import "CompetitionCycleView.h"

typedef enum _btnTitleType {
  btnFirstTitleType = 1,
  btnSecondTitleType = 2,
  btnThirdTitleType = 3,
  btnFourthTitleType = 4,
  btnFiveTitleType = 5,

} btnTitleType;

@class UserGradeView;
@class CompetitionDetailsViewController;
/**
 *  有奖比赛详情页面
 */
@interface SimuHavePrizeViewController
    : BaseViewController <InvitationCodeViewDelegate, CompetitionCycleViewDelegate> {
  ///创建上方导航栏
  TopToolBarView *topToolbarView;
  /** 详情数据 */
  NSMutableArray *_detailArr;
  /** 百万千万赛周期列表数据 */
  NSMutableArray *_cycleArr;
  /** 等待比赛提示框 */
  BOOL _wait;
  /** 登录刷新判断 */
  BOOL _logInBool;
  /** 参赛按钮判断 */
  BOOL _entryButtonbool;
  /** 连续点击判断 */
  BOOL _evenPointBool;
  /** 邀请码输入错误判断 */
  BOOL invitationBool;
  /** 钻石参赛判断 */
  BOOL _diamondbool;
  /** 弹出框键盘判断 */
  BOOL _popBool;
  /** 首次进入判断 */
  BOOL _firstRequestDone;
  /** WebView */
  UIWebView *_webView;
  /** 邀请码 */
  InvitationCodeView *_invitationView;
  /** 百万资金赛参赛周期视图 */
  CompetitionCycleView *_comCycleView;
      
  BGColorUIButton *jionBtn;
}

@property(assign, nonatomic) BOOL webBool;
/**
 *  web 链接
 */
@property(copy, nonatomic) NSString *webStringURL;

@property(strong, nonatomic) UIActivityIndicatorView *matchBtnIndicator;
/** 昵称 */
@property(nonatomic, strong) NSString *titleName;
/** 比赛id */
@property(nonatomic, copy) NSString *matchid;
/**
 * 比赛类型，Type（974:用户创建的比赛,976:已结束比赛,977:待开赛比赛,978:团队比赛）
 */
@property(nonatomic, strong) NSString *matchType;

/** webUrl */
@property(nonatomic, strong) NSString *mainUrl;

/**
 *  构造函数
 *
 *  @param titleName        标题
 *  @param matchID          比赛ID
 *  @param matchType        比赛类型
 *  @param createPersonName 创建人名称
 *
 *  @return 实例对象
 */
- (id)initWithTitleName:(NSString *)titleName
            withMatchID:(NSString *)matchID
          withMatchType:(NSString *)matchType
            withMainUrl:(NSString *)mainUrl;

@end
