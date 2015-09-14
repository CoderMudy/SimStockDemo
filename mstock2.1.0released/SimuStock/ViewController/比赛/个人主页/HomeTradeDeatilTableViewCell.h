//
//  HomeTradeDeatilTableViewCell.h
//  SimuStock
//
//  Created by jhss on 15/7/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetListItem.h"
#import "SimuPositionPageData.h"
#import "FTCoreTextView.h"

@protocol HomeTradeDeatilTableViewCellDelegate <NSObject>
//可实现
@optional
- (void)bidButtonTriggersCallbackMethod:(NSInteger)tag row:(NSInteger)row;
@end

@interface HomeTradeDeatilTableViewCell : UITableViewCell

/**  时间*/
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;
/**  分享按钮*/
@property(weak, nonatomic) IBOutlet UIButton *shareBtn;
/**  买入按钮*/
@property(weak, nonatomic) IBOutlet UIButton *buyBtn;
/**  卖出按钮*/
@property(weak, nonatomic) IBOutlet UIButton *sellBtn;
/**  左上角小图标*/
@property(weak, nonatomic) IBOutlet UIImageView *pictureType;

/**  左上角图片背景*/
@property(weak, nonatomic) IBOutlet UIImageView *backBlueImageView;
/**  图片背景下的白色view*/
@property(weak, nonatomic) IBOutlet UIImageView *backWhiteView;
/**  竖分割线*/
@property(weak, nonatomic) IBOutlet UIView *bigGrayView;
/**  灰色分割线*/
@property(weak, nonatomic) IBOutlet UIView *cuttingLine;
/**  白色分割线*/
@property(weak, nonatomic) IBOutlet UIView *whiteCuttingLine;
/**  股票信息*/
@property(weak, nonatomic) IBOutlet FTCoreTextView *coreTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coreTextViewHeight;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *whiteLineHeight;
/**   竖分割线宽度*/
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *bigGrayWidth;

@property(nonatomic) CGFloat cellHeight;

//行数
@property(nonatomic, assign) NSInteger row;

///获得界面数据
- (void)bindTradeData:(TweetListItem *)item;

- (void)hiddenButtons:(BOOL)hidden;

@property(nonatomic, weak) id<HomeTradeDeatilTableViewCellDelegate> delegate;
//计算cell的高度
+ (CGFloat)cellHeightWithTweetListItem:(TweetListItem *)item withShowButtons:(BOOL)showButtons;
//点击买入   卖出    分享  按钮
+ (void)bidButtonTriggersCallbackMethod:(NSInteger)tag
                                    row:(NSInteger)row
                             shareImage:(UIImage *)shareImage
                          shareUserName:(NSString *)userName
                               homeData:(TweetListItem *)homeData;

@end
