//
//  ChatStockPageBaseTVC.h
//  SimuStock
//
//  Created by jhss_wyz on 15/7/21.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ChatStockPageTVCell.h"

static const CGFloat CSPTVCell_Time_Bottom_HasUserNameView = 44.f;
static const CGFloat CSPTVCell_Space_Between_Time_Tittle = 12.f;
static const CGFloat CSPTVCell_Space_Between_Tittle_Content = 6.f;
static const CGFloat CSPTVCell_Space_Between_Content_ContentImage = 6.f;
static const CGFloat CSPTVCell_Space_Between_RPContent_RPContentImage = 8.f;
static const CGFloat CSPTVCell_Space_Between_RPTop_ContentImage = 15.f;
static const CGFloat CSPTVCell_Space_Between_Bottom_Top = 15.f;
static const CGFloat CSPTVCell_Space_Between_RPTopView_Top = 3.f;
static const CGFloat CSPTVCell_Height_RPTopBKView = 7.f;
static const CGFloat CSPTVCell_Bottom_Extra_Height = 43.f;
static const CGFloat CSPTVCell_RPBKView_Bottom_Extra_Height = 7.f;

static const CGFloat CSPTVCell_Content_Left_Space = 17.f;
static const CGFloat CSPTVCell_Content_Right_Space = 10.f;
static const CGFloat CSPTVCell_Space_Between_ReplayBKViewRight_RPContentViewRight = 5.f;
static const CGFloat CSPTVCell_Space_Between_ReplayBKViewLeft_RPContentViewLeft = 5.f;

typedef NS_ENUM(NSUInteger, ChatStockPageDeleteCellType) {
  ChatStockPageDelete = 1,       /// 删除一条聊股
  ChatStockPageCancleCollect = 2 /// 取消收藏
};

@interface ChatStockPageBaseTableAdapter : BaseTableAdapter <ChatStockPageTVCellDelegate>

/** 删除聊股后的回调 */
@property(copy, nonatomic) DeleteTStockClickBlock deleteOneCellCallBack;
/** 取消收藏后的回调 */
@property(copy, nonatomic) CancleCollectTStockClickBlock cancleCollectCallBack;

/** 放置分享弹出框的View */
@property(nonatomic, weak) UIView *clientView;

/** 绑定聊股标题、聊股内容、聊股图片数据 */
+ (CGFloat)bindTittleAndContentAndContentImageAtCell:(ChatStockPageTVCell *)cell
                                        andIndexPath:(NSIndexPath *)indexPath
                                    andTopViewBottom:(CGFloat)bottom
                                        andTableView:(UITableView *)tableView
                                  andHasUserNameView:(BOOL)hasNameView;

/** 绑定聊股内容及聊股图片数据 */
+ (CGFloat)bindContentAndContentImageAtCell:(ChatStockPageTVCell *)cell
                               andIndexPath:(NSIndexPath *)indexPath
                           andTopViewBottom:(CGFloat)bottom
                               andTableView:(UITableView *)tableView
                         andHasUserNameView:(BOOL)hasNameView;

+ (CGFloat)bindRPContentAndRPComtentImageAtCell:(ChatStockPageTVCell *)cell
                                   andIndexPath:(NSIndexPath *)indexPath
                                   andTableView:(UITableView *)tableView
                               andTopViewBottom:(CGFloat)topViewBottom
                             andHasUserNameView:(BOOL)hasUserNameView;

/** cell长按手势的设定 */
- (void)setLongPressGRAtCell:(ChatStockPageTVCell *)cell
                andTableView:(UITableView *)tableView
                andIndexPath:(NSIndexPath *)indexPath;

/** 返回聊股标题、聊股内容、聊股图片的高度 */
+ (CGFloat)getTitleAndContentAndImageHeightWithWeibo:(TweetListItem *)item
                                     andContontWidth:(CGFloat)contentWidth;

/** 返回聊股内容和聊股图片的高度 */
+ (CGFloat)getContentAndImageHeightWithWeibo:(TweetListItem *)item
                             andContontWidth:(CGFloat)contentWidth;

/** 返回聊股内容高度*/
+ (CGFloat)weiboContentHeightWithWeibo:(TweetListItem *)weibo
                      withContontWidth:(CGFloat)contentWidth;

/** 返回转发聊股内容高度*/
+ (CGFloat)weiboReplayContentHeightWithWeibo:(TweetListItem *)weibo
                            withContontWidth:(CGFloat)contentWidth;

/** 返回聊股标题高度*/
+ (CGFloat)weiboTitleHeightWithWeibo:(TweetListItem *)weibo withContontWidth:(CGFloat)contentWidth;

/** 删除某一条聊股数据（删除或者取消收藏都会触发） */
- (void)tableView:(UITableView *)tableView
       delateCell:(NSNumber *)tid
            atRow:(NSInteger)row
          andType:(ChatStockPageDeleteCellType)deleteType;

/** 设置左侧时间线 */
- (void)resetBottomLineViewInCell:(ChatStockPageTVCell *)cell
                           andRow:(NSInteger)row
                          andData:(DataArray *)dataArray;

@end

@interface ChatStockPageBaseTVC : BaseTableViewController

/** 放置分享弹出框的View */
@property(nonatomic, weak) UIView *clientView;

/** 添加分享、评论、赞的监听 */
- (void)addObservers;

@end
