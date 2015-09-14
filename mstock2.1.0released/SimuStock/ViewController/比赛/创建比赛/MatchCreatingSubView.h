//
//  MatchCreatingVC.h
//  SimuStock
//
//  Created by Yuemeng on 15/7/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTipView.h"

@class BaseViewController;
@class MatchCreatingViewController;

@protocol refreshSuperViewControllerDataDelegate <NSObject>

- (void)refreshCurrentPage;

@end

/*
 *  创建比赛页面
 */
@interface MatchCreatingSubView
    : UIViewController <UITextViewDelegate, UITextFieldDelegate,UIAlertViewDelegate> {
  DateTipView *_dateTipView;
  BOOL _isStartTime;
  NSString *_startTimeStr;
  NSString *_endTimeStr;
  /** 存储比赛模板 */
  NSArray *_matchTemplateArray;
  /** 比赛模板ID */
  NSString *_templateID;
  /** 是否选中钻石创建比赛 */
  BOOL _isDiamondMatch;
  /** 钻石数量 */
  NSInteger _numberOfUsingDiamond;
  NSString *_matchFundInfo;
  MatchCreatingViewController *_superVC;
  /** 邀请码 */
  NSString *_tempInvitationCode;
  NSArray *_code4Labels;
  /** 来自哪方面的请求 */
  NSInteger _requestTag;
}

@property(weak, nonatomic) IBOutlet UITextField *matchNameTextField;
@property(weak, nonatomic) IBOutlet UITextView *matchInfoTextView;
@property(weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

@property(weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property(weak, nonatomic) IBOutlet UIButton *endTimeBtn;
//游标X坐标
@property(weak, nonatomic) IBOutlet UIImageView *blueCursor;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *blueCursorXCons;
// tap手势
@property(strong, nonatomic) IBOutlet UITapGestureRecognizer *tap10;
@property(strong, nonatomic) IBOutlet UITapGestureRecognizer *tap100;
@property(strong, nonatomic) IBOutlet UITapGestureRecognizer *tap1000;
//
@property(weak, nonatomic) IBOutlet UIButton *codeBtn;

@property(weak, nonatomic) IBOutlet UIView *inviteCodeView;
@property(weak, nonatomic) IBOutlet UIView *codeView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *line1Width;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *line2Width;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *line3Width;
@property(weak, nonatomic) IBOutlet UILabel *code1Label;
@property(weak, nonatomic) IBOutlet UILabel *code2Label;
@property(weak, nonatomic) IBOutlet UILabel *code3Label;
@property(weak, nonatomic) IBOutlet UILabel *code4Label;

@property(weak, nonatomic) IBOutlet UILabel *diamondLeftLabel;
@property(weak, nonatomic) IBOutlet UILabel *diamondMidLabel;
@property(weak, nonatomic) IBOutlet UILabel *diamondRightLabel;
@property(weak, nonatomic) IBOutlet UILabel *fund10Label;
@property(weak, nonatomic) IBOutlet UILabel *fund100Label;
@property(weak, nonatomic) IBOutlet UILabel *fund1000Label;

/** 获取邀请码连续点击判断 */
@property(weak, nonatomic) id<refreshSuperViewControllerDataDelegate> delegate;
- (instancetype)initWithSuperVC:(MatchCreatingViewController *)superVC;
- (void)validateMatch;
- (void)rechargeDataRequest;
- (void)buyNowProductId:(NSString *)productId;

@end
