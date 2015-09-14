//
//  AllChatStockTableVC.h
//  SimuStock
//
//  Created by jhss_wyz on 15/7/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ChatStockPageBaseTVC.h"

typedef void (^ResetBarInfoBlock)(NSObject *obj);

@interface AllChatStockTableAdapter : ChatStockPageBaseTableAdapter

/** 置顶股聊数组 */
@property(strong, nonatomic) DataArray *barTopList;

@end

/** 聊股吧全部聊股页 */
@interface AllChatStockTableVC : ChatStockPageBaseTVC

/** 聊股吧ID */
@property(copy, nonatomic) NSNumber *barID;

/** 置顶股聊数组 */
@property(strong, nonatomic) DataArray *barTopList;

/** 重设聊股吧信息回调函数 */
@property(copy, nonatomic) ResetBarInfoBlock resetBarInfoBlock;

/** 加精按钮回调block */
@property(nonatomic, copy) EliteButtonClickBlock topEliteButtonClickBlock;

/**
 *  请求股吧信息
 */
- (void)requestShowBarInfoData;

/**
 *  请求置顶股聊信息
 */
- (void)requestBarTopListData;

@end
