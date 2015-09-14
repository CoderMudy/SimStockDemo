//
//  HomePageUserInfoView.h
//  SimuStock
//
//  Created by Jhss on 15/7/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundHeadImage.h"
#import "UIButton+Block.h"
#import "UserGradeView.h"
#import "HomePageTableHeaderData.h"
#import "HomeUserInformationData.h"

@interface HomePageUserInfoView : UIView

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *userNameLeft;
@property(weak, nonatomic) IBOutlet UIView *allView;
/** 拉伸图片 */
@property(weak, nonatomic) IBOutlet UIImageView *stretchImage;
/** 用户头像背景色 */
@property(weak, nonatomic) IBOutlet UIImageView *userHeaderBGImageView;
/** 用户头像 */
@property(weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
/** 用户头像的点击按钮 */
@property(weak, nonatomic) IBOutlet UIButton *headerButton;
/** 用户昵称 */
@property(strong, nonatomic) IBOutlet UserGradeView *nickNameView;
/** 持仓按钮 */
@property(weak, nonatomic) IBOutlet UIButton *positionButton;
/** 追踪按钮 */
@property(weak, nonatomic) IBOutlet UIButton *followButton;
/** 关注按钮 */
@property(weak, nonatomic) IBOutlet UIButton *attentionButton;
/** 粉丝按钮 */
@property(weak, nonatomic) IBOutlet UIButton *fansButton;
/** 用户签名 */
@property(weak, nonatomic) IBOutlet UILabel *signatureLabel;
/** V认证 */
@property(weak, nonatomic) IBOutlet UILabel *vSignView;
/** 粉丝的数量 */
@property(nonatomic) NSInteger fansNumber;
/** 存放按钮 */
@property(strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonArray;
//竖线
@property(weak, nonatomic) IBOutlet UIView *verticalLine;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *verticalLineWidth;
@property(weak, nonatomic) IBOutlet UIView *verticalLineMiddle;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *verticalLineMiddleWidth;
@property(weak, nonatomic) IBOutlet UIView *verticalLineRight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *verticalLineRightWidth;

@property(strong, nonatomic) HomeUserInformationData *userInfoItem;
- (void)bindUserInfoData:(HomePageTableHeaderData *)informationDic;

@end
