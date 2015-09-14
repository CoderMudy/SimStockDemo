//
//  CompetitionDetailsVC.h
//  SimuStock
//
//  Created by Yuemeng on 15/7/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvitationCodeView.h"
#import "CompetitionCycleView.h"

@class UserGradeView;
@class CompetitionRankDetailVC;
@class CompetitionDetailsViewController;
/*
 *  比赛详情XIB化页面
 */
@interface CompetitionDetailsVC : UIViewController <InvitationCodeViewDelegate, CompetitionCycleViewDelegate> {
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
  /** 详情网址 */
  NSString *_detailUrl;
  /** 邀请码 */
  InvitationCodeView *_invitationView;
  /** 百万资金赛参赛周期视图 */
  CompetitionCycleView *_comCycleView;
}

@property(weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property(weak, nonatomic) IBOutlet UILabel *matchDescLabel;
@property(weak, nonatomic) IBOutlet UILabel *matchTimeLabel;
@property(weak, nonatomic) IBOutlet UIButton *matchStatusBtn;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *matchBtnIndicator;
@property(weak, nonatomic) IBOutlet UserGradeView *userGradeView;
@property(weak, nonatomic) IBOutlet UIView *subInfoBackView;
@property(weak, nonatomic) IBOutlet UILabel *rewardPoolLabel;
@property(weak, nonatomic) IBOutlet UILabel *verifyCodeLabel;
@property(weak, nonatomic) IBOutlet UIButton *detailBtn;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *subInfoBackViewWidth;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *subInfoBackViewHeight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabelLeft;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *subscriLabelTop;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *matchBtnCenterY;
@property(weak, nonatomic) IBOutlet UIView *clientView;

/* 原父类属性 */
@property(nonatomic, strong) NSString *matchID;
@property(nonatomic, strong) NSString *titleName;
///比赛类型，Type（974:用户创建的比赛,976:已结束比赛,977:待开赛比赛,978:团队比赛）
@property(nonatomic, strong) NSString *mType;
@property(nonatomic, weak) CompetitionRankDetailVC *rankDetailVC;
@property(nonatomic, weak) CompetitionDetailsViewController *superVC;
/**
 *  是否web端报名
 */
@property(assign, nonatomic) BOOL webBool;
/**
 *  web页的URL
 */
@property(copy, nonatomic) NSString *webStringUrl;

- (id)initWithMatchID:(NSString *)matchID
        withTitleName:(NSString *)titleName
            withMtype:(NSString *)matchType
         withCalssObj:(CompetitionDetailsViewController *)superVC;

@end
