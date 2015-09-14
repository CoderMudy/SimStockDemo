//
//  StockBarDetailHeaderView.h
//  SimuStock
//
//  Created by Yuemeng on 14-12-1.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^followButtonClickBlock)(void);
@class FTCoreTextView;

@interface StockBarDetailHeaderView : UIView
{
  CGFloat _selfHeight;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coreTextViewHeight;
/** 白色底框 */
@property(strong, nonatomic) IBOutlet UIView *whiteView;
/** 头像 */
@property(strong, nonatomic) IBOutlet UIImageView *logoImageView;
/** 吧名称 */
@property(strong, nonatomic) IBOutlet UILabel *desLabel;
/** 吧主名称 */
@property(strong, nonatomic) IBOutlet FTCoreTextView *coreTextView;
/** 底部高度 */
@property (strong, nonatomic) IBOutlet UIView *bottomView;
/** 关注人数 */
@property(strong, nonatomic) IBOutlet UILabel *followersLabel;
/** 股聊数 */
@property(strong, nonatomic) IBOutlet UILabel *postNumLabel;
/** 关注按钮 */
@property(strong, nonatomic) IBOutlet UIButton *followButton;
/** 关注按钮回调 */
@property(nonatomic, copy) followButtonClickBlock followButtonClickBlock;
/** 重设自身高度 */
- (void)resetHeight;
/** 根据内容设置新高度 */
- (void)setNewHeight;

@end
