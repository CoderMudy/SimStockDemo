//
//  TopWeiboCell.h
//  SimuStock
//
//  Created by Yuemeng on 14-12-1.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BarTopTweetData;
@class FTCoreTextView;

typedef void (^topTopButtonClickBlock)();

typedef void (^topUnTopButtonClickBlock)();

typedef void (^topEliteButtonClickBlock)(BOOL, NSNumber *);

typedef void (^topDeleteButtonClickBlock)(NSNumber *);

/** 全部分页 置顶股聊cell */
@interface TopWeiboCell : UITableViewCell

/** 标题 */
@property(strong, nonatomic) IBOutlet FTCoreTextView *titleView;
/** 精 小图标 */
@property(strong, nonatomic) IBOutlet UIImageView *eliteImageView;
/** 顶 小图标 */
@property(strong, nonatomic) IBOutlet UIImageView *topImageView;

/** 数据指针 */
@property(strong, nonatomic) BarTopTweetData *topData;

/*********************对外block*********************/
/** 置顶按钮回调block */
@property(nonatomic, copy) topTopButtonClickBlock topTopButtonClickBlock;
/** 取消置顶按钮回调block */
@property(nonatomic, copy) topUnTopButtonClickBlock topUnTopButtonClickBlock;
/** 加精按钮回调block */
@property(nonatomic, copy) topEliteButtonClickBlock topEliteButtonClickBlock;
/** 删除按钮回调block */
@property(nonatomic, copy) topDeleteButtonClickBlock topDeleteButtonClickBlock;

/** 对外设置信息方法 */
- (void)refreshInfoWithBarTopTweetData:(BarTopTweetData *)topData;
/** 对外设置加精图标 */
- (void)resetEliteIcon:(BOOL)isElite;
/** 对外设置title高度 */
+ (CGFloat)heightFromTitle:(NSString *)title;

@end
