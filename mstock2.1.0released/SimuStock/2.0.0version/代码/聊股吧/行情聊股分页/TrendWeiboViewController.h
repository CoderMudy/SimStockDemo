//
//  TrendWeiboViewController.h
//  SimuStock
//
//  Created by Yuemeng on 14/12/25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"

@class TrendViewController;
@class TrendChatStockPageTableVC;
@class TweetListItem;

/** 行情聊股分页 */
@interface TrendWeiboViewController : BaseViewController {
  TrendChatStockPageTableVC *tableVC;
}

/** 股票代码 */
@property(nonatomic, copy) NSString *stockCode;
/** 股票名称 */
@property(nonatomic, strong) NSString *stockName;
/** 父视图（行情） */
@property(nonatomic, weak) TrendViewController *trendVC;

/** 初始化方法 */
- (id)initCode:(NSString *)stockCode
          name:(NSString *)stockName
    controller:(TrendViewController *)trendVC;

/**界面切换触发加载指示器*/
- (void)interfaceSwitchingTriggerLoadIndicator;

/** 行情切换股票时刷新数据 */
- (void)refreshDataWithStockCode:(NSString *)stockCode;

/** 添加发布聊股后的，第一条假数据 */
- (void)disVC_data:(TweetListItem *)tweetObject;

@end
