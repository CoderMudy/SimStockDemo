//
//  CommentsTableViewController.h
//  SimuStock
//
//  Created by Jhss on 15/6/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
#import "TweetListItem.h"
#import "LittleCattleView.h"

typedef void (^DeleteButtonClickBlock)(NSNumber *);

@interface CommentsTableAdapter : BaseTableAdapter {
  /** 存放tweet信息 */
  NSMutableArray *tweetListsArray;
  TweetListItem *talkStockItem;
}
@property(strong, nonatomic) NSString *hostUserId;
//初始化方法
- (id)initWithTableViewController:
          (BaseTableViewController *)baseTableViewController
                    withDataArray:(DataArray *)dataList
                         withHuid:(NSString *)hostUserId
                withTalkStockItem:(TweetListItem *)talkStockItems;
/** 删除按钮，刷新表格 */
@property(copy, nonatomic) DeleteButtonClickBlock deleteBtnBlock;
@end

@interface CommentsTableViewController : BaseTableViewController

/** 判断是否是楼主 */
@property(nonatomic) BOOL isHost;
/** 最早最新的状态判断 */
@property(strong, nonatomic) NSString *earliestOrNewest;
/** 下拉刷新时，通知父容器 */
@property(copy, nonatomic) CallBackAction headerRefreshCallBack;

/** 来自热门推荐中的聊股，tweetlistData  */
@property(strong, nonatomic) NSNumber *talkId;
- (id)initWithFrame:(CGRect)frame
              withIsHost:(BOOL)isHost
    withEarliestOrNewest:(NSString *)earliestOrNewest
             withtTalkId:(NSNumber *)talkId;

///楼主的Id
@property(strong, nonatomic) NSString *hostUid;
///存放楼主的信息
@property(strong, nonatomic) TweetListItem *talkStockItem;

@end
