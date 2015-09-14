//
//  HotRecommendTableViewCell.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserListItem.h"

@class CellBottomLinesView;
/** 用户名点击回调block，直接到其主页 */
typedef void (^userNameButtonBlock)(NSString *uid, NSString *nickName);

/** 热门推荐cell */
@interface HotRecommendCell : UITableViewCell {
  /** 标题Label */
  UILabel *_titleLabel;
  /** 用户名button */
  UIButton *_userNameButton;
  /** 评论Label */
  UILabel *_commentLabel;
  /** 赞Label */
  UILabel *_praiseLabel;
  /** 底线 */
  CellBottomLinesView *_cellBottomLinesView;
}

/** 用户名点击回调block，直接到其主页 */
@property(nonatomic, copy) userNameButtonBlock userNameButtonBlock;
/** 标题 */
@property(nonatomic, strong) NSString *title;
/** 用户名 */
@property(nonatomic, strong) NSString *userName;
/** 评论 */
@property(nonatomic, strong) NSString *comment;
/** 赞数 */
@property(nonatomic, strong) NSString *praise;
/** VIP Type */
@property(nonatomic, assign) UserVipType vipType;
/** uid */
@property(nonatomic, strong) NSString *uid;
/** nickName */
@property(nonatomic, strong) NSString *nickName;

/** 对外设置信息方法，必须在全部取得数据后调用 */
- (void)setInfo;

/** 隐藏底线方法 */
- (void)hideCellBottomLinesView:(BOOL)hide;

@end
