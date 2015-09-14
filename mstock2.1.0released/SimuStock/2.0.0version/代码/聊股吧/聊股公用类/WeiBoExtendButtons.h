//
//  WeiBoExtendButtons.h
//  SimuStock
//
//  Created by Yuemeng on 15/1/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Block.h"
#import "StockTradeList.h"
#import "TweetListItem.h"

@class BarTopTweetData; //置顶聊股cell
@class TweetListItem;   //普通聊股cell
@class BlueViewAndArrow;

//@class TweetListItem;
typedef void (^extendTopButtonClickBlock)(TweetListItem *, NSObject *);
typedef void (^extendUnTopButtonClickBlock)(NSNumber *, NSObject *);
typedef void (^extendEliteButtonClickBlock)(BOOL, NSNumber *, NSObject *);
typedef void (^extendDeleteButtonClickBlock)(NSNumber *, NSObject *);
typedef void (^extendCancleCollectButtonClickBlock)(NSNumber *, NSObject *);
typedef void (^extendCopyTScontentButtonClick)();

/** 微博长按拓展按钮类（全局置顶，置顶，加精，删除，收藏）*/
@interface WeiBoExtendButtons : UIImageView {

  /** 蓝色背景框总宽度 */
  CGFloat _blueWidth;

  /** 当前用户是否为吧主 */
  BOOL _isBarHost;

  /** 当前用户是否为超级管理员 */
  BOOL _isAdmin;

  /** 数据请求是否来自topCell */
  BOOL _isTopCell;

  //有时间进行属性重构，以支持所有数据类型
  //⭐️重点判断该obj是否有相关的属性就行了
}

/** tweet数据指针 */
@property(nonatomic, strong) TweetListItem *item;

/** top数据指针 */
@property(nonatomic, strong) BarTopTweetData *data;
/** cell指针 */
@property(nonatomic, strong) NSObject *cell;
/** 蓝色提示框三角图 */
@property(nonatomic, strong) BlueViewAndArrow *blueViewAndArrow;
;

/*********************对外block*********************/

/** （全局）置顶按钮回调block */
@property(nonatomic, copy) extendTopButtonClickBlock extendTopButtonClickBlock;
/** 取消置顶按钮回调block */
@property(nonatomic, copy)
    extendUnTopButtonClickBlock extendUnTopButtonClickBlock;
/** 加精按钮，通知精华列表刷新 */
@property(nonatomic, copy)
    extendEliteButtonClickBlock extendEliteButtonClickBlock;
/** 删除按钮，刷新表格 */
@property(nonatomic, copy)
    extendDeleteButtonClickBlock extendDeleteButtonClickBlock;
/** 取消收藏按钮，刷新表格 */
@property(nonatomic, copy)
    extendCancleCollectButtonClickBlock extendCancleCollectButtonClickBlock;
/** 复制聊股内容按钮 */
@property(nonatomic, copy)
    extendCopyTScontentButtonClick extendCopyButtonclickBlock;

/** 缩小消失动画 */
- (void)hideAndScaleSmall;

/** 添加按钮和事件 */
- (void)buttonMaker:(NSString *)title action:(ButtonPressed)action;

/** 重设蓝框和箭头位置 */
- (void)resetBlueViewAndArrowsFrameWithOffsetY:(CGFloat)offsetY;

- (void)showAndScaleLarge;

/** 获取拓展按钮单例，在windows中调用一次 */
+ (WeiBoExtendButtons *)sharedExtendButtons;

/** 长按置顶聊股出现 */
+ (void)showWithBarTopTweetData:(BarTopTweetData *)data
                        offsetY:(CGFloat)offsetY
                           cell:(NSObject *)cell;
/** 长按普通聊股出现 */
+ (void)showWithTweetListItem:(TweetListItem *)item
                      offsetY:(CGFloat)offsetY
                         cell:(NSObject *)cell;
/** 聊股内容页长按生成按钮 */
+ (void)showButtonWithTweetListItem:(TweetListItem *)item
                            offsetY:(CGFloat)offsetY
                               cell:(NSObject *)cell;
/** 聊股内容页表头复制 */
+ (void)showButtonWithCopyContent:(NSString *)content
                          offsetY:(CGFloat)offsetY
                           bgView:(NSObject *)bgView;

@end
