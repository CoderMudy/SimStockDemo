//
//  AllChatStockTVCell.h
//  SimuStock
//
//  Created by jhss_wyz on 15/7/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BarTopTweetData;
@class FTCoreTextView;

typedef void (^TopTopButtonClickBlock)();

typedef void (^TopUnTopButtonClickBlock)();

typedef void (^TopEliteButtonClickBlock)(BOOL, NSNumber *);

typedef void (^TopDeleteButtonClickBlock)(NSNumber *);

@interface AllChatStockTopTVCell : UITableViewCell

/** 标题 */
@property(strong, nonatomic) IBOutlet FTCoreTextView *titleView;
/** 精 小图标 */
@property(strong, nonatomic) IBOutlet UIImageView *eliteImageView;
/** 顶 小图标 */
@property(strong, nonatomic) IBOutlet UIImageView *topImageView;

/** 聊股标题的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewHeight;

/** 当前cell的数据 */
@property(strong, nonatomic) BarTopTweetData *topData;

/*********************对外block*********************/
/** 置顶按钮回调block */
@property(nonatomic, copy) TopTopButtonClickBlock topTopButtonClickBlock;
/** 取消置顶按钮回调block */
@property(nonatomic, copy) TopUnTopButtonClickBlock topUnTopButtonClickBlock;
/** 加精按钮回调block */
@property(nonatomic, copy) TopEliteButtonClickBlock topEliteButtonClickBlock;
/** 删除按钮回调block */
@property(nonatomic, copy) TopDeleteButtonClickBlock topDeleteButtonClickBlock;

/** 对外设置信息方法 */
- (void)refreshInfoWithBarTopTweetData:(BarTopTweetData *)topData;
/** 对外设置加精图标 */
- (void)resetEliteIcon:(BOOL)isElite;
/** 对外设置title高度 */
+ (CGFloat)heightFromTitle:(NSString *)title;

@end
