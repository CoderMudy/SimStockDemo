//
//  MyChatStockTableVC.h
//  SimuStock
//
//  Created by jhss_wyz on 15/7/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MyChatStockTVCell.h"

typedef NS_ENUM(NSUInteger, MyChatStockDeleteCellType) {
  MyChatStockDelete = 1,       /// 删除一条聊股
  MyChatStockCancleCollect = 2 /// 取消收藏
};

@interface MyChatStockTableAdapter
    : BaseTableAdapter <MyChatStockTVCellDelegate>

/** 删除聊股后的回调 */
@property(copy, nonatomic) DeleteTStockClickBlock deleteOneCellCallBack;
/** 取消收藏后的回调 */
@property(copy, nonatomic) CancleCollectTStockClickBlock cancleCollectCallBack;

/** 放置分享弹出框的View */
@property(nonatomic, weak) UIView *clientView;

/** 设置左侧时间线 */
+ (void)setTimeLineInCell:(MyChatStockTVCell *)cell
                   andRow:(NSInteger)row
                  andData:(DataArray *)dataArray;

/** 绑定聊股标题、聊股内容、聊股图片数据 */
+ (CGFloat)bindTittleAndContentAndContentImageAtCell:(MyChatStockTVCell *)cell
                                        andIndexPath:(NSIndexPath *)indexPath
                                    andTopViewBottom:(CGFloat)bottom
                                        andTableView:(UITableView *)tableView
                                  andHasUserNameView:(BOOL)hasNameView;

/** 绑定聊股内容及聊股图片数据 */
+ (CGFloat)bindContentAndContentImageAtCell:(MyChatStockTVCell *)cell
                               andIndexPath:(NSIndexPath *)indexPath
                           andTopViewBottom:(CGFloat)bottom
                               andTableView:(UITableView *)tableView
                         andHasUserNameView:(BOOL)hasNameView;

/** cell长按手势的设定 */
- (void)setLongPressGRAtCell:(MyChatStockTVCell *)cell
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
+ (CGFloat)weiboTitleHeightWithWeibo:(TweetListItem *)weibo
                    withContontWidth:(CGFloat)contentWidth;

@end

@interface MyChatStockTableVC : BaseTableViewController

@end
