//
//  SimuBlockDefine.h
//  SimuStock
//
//  Created by jhss_wyz on 15/8/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#ifndef SimuStock_SimuBlockDefine_h
#define SimuStock_SimuBlockDefine_h

@class TweetListItem;

/** 基本回调函数 */
typedef void (^CallBackBlock)();

/** 长按删除block回调 */
typedef void (^DeleteTStockClickBlock)(NSNumber *);
/** 长按删除block回调 */
typedef void (^CancleCollectTStockClickBlock)(NSNumber *);
/** （全局）置顶按钮回调block */
typedef void (^TopButtonClickBlock)(TweetListItem *);
/** 加精按钮，通知精华列表刷新 */
typedef void (^EliteButtonClickBlock)(BOOL, NSNumber *);
/** 刷新分享、评论、赞状态 */
typedef void (^UpdateStatusBlock)(TweetListItem *);
/** 通知刷新数据源所有赞状态 */
typedef void (^RefreshPraisedBlock)(void);

/** 创建比赛：选择比赛模板回调 */
typedef void (^SelectMatchInitialFundBlock)(NSString *);
/** 创建比赛：选择高校比赛用途回调 */
typedef void (^SelectMatchPurposeBlock)(NSString *);

#endif
