//
//  InviteFriendTableViewCell.h
//  SimuStock
//
//  Created by moulin wang on 14-7-29.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConcernedRequest.h"

/** 刷新列表页信息 */
typedef void (^updateInviteListAttentionStatus)(BOOL isAttention);

@protocol InviteFriendTableViewCellDelegate <NSObject>
@optional
- (void)shareButtonInviteFriendCallbackMethod:(NSInteger)tag;
- (void)shareButtonInviteFriendCallbackMethod:(NSInteger)tag row:(NSInteger)row;
@end

@interface InviteFriendTableViewCell
    : UITableViewCell <ConcernedRequestDelegate>

//分享
@property(nonatomic, strong) UIView *shareView;
//关注
@property(nonatomic, strong) UIButton *concernBut;
//关注图标
@property(nonatomic, strong) UIImageView *btnIcon;
//头像白色底图
@property(nonatomic, strong) UIView *whiteView;
//头像
@property(nonatomic, strong) UIImageView *userHeadImageView;
//头像按钮
@property(nonatomic, strong) UIButton *userHeadBtn;
//用户名
@property(nonatomic, strong) UILabel *nameLab;

//上分割线
@property(nonatomic, strong) UIView *topLineView;
@property(nonatomic, strong) UIView *bottomLineView;
// cell位置
@property(nonatomic, assign) NSInteger rowInt;
//菊花控件
@property(nonatomic, strong) UIActivityIndicatorView *attentionIndicatorView;
//关注请求
@property(nonatomic, strong) ConcernedRequest *conRequest;
@property(nonatomic, strong) NSString *userID;
@property(nonatomic, weak) id<InviteFriendTableViewCellDelegate> delegate;
//更新邀请页关注数据
@property(nonatomic, copy)updateInviteListAttentionStatus updateAttentionStatus;

@end
