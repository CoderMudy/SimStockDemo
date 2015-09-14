//
//  HomePageChatStockTableVC.h
//  SimuStock
//
//  Created by jhss_wyz on 15/8/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyChatStockHasSCPTableVC.h"

@protocol HomePageChatStockTVCProtocol <NSObject>
/** 动画回调，（scrollViewDidScroll:） */
- (void)homePageChatStockTableViewDidScroll:(UIScrollView *)scrollView;

@end

@interface HomePageChatStockTableAdapter : MyChatStockHasSCPTableAdapter

@property(nonatomic, weak) id<HomePageChatStockTVCProtocol> scrollViewdelegate;

@end

@interface HomePageChatStockTableVC : MyChatStockHasSCPTableVC

@property(nonatomic, weak) id<HomePageChatStockTVCProtocol> scrollViewdelegate;

/** 下拉刷新时，通知父容器 */
@property(copy, nonatomic) CallBackAction homeHeaderRefreshCallBack;

@property(nonatomic, copy) NSString *userID;

@end
