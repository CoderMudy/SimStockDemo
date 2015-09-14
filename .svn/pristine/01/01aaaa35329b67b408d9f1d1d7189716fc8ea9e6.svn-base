//
//  simuCancellationViewController.h
//  SimuStock
//
//  Created by Mac on 14-7-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonFormatRequester.h"
#import "SimuTradeRevokeWrapper.h"
#import "StockEntrust.h"
#import "UIButton+Block.h"
#import "ExpertPlanConst.h"

#import "EWMultiColumnTableView.h"

/*
 *类说明：撤单页面视图控制器
 */
@interface simuCancellationViewController : BaseViewController
{
  //内容的数组
  NSMutableArray* data;
  NSMutableArray* sectionHeaderData;
  
  CGFloat colWidth;        //数据区每列的宽度
  CGFloat rightColWidth;//右侧表的列宽
  NSInteger numberOfSections; //数据有几个分区
  
  NSInteger numberOfColumns;  //数据的列数
  EWMultiColumnTableView* tbView;  //表格视图
  
}

/** 比赛ID */
@property(nonatomic, strong) NSString *matchId;

/** 撤单按钮 */
@property(nonatomic, strong) UIButton *btnCancleEntrust;

/** block  回调 */
@property(nonatomic, copy) onTableRowSelected onTableRowSelectedCallback;

@property(nonatomic, strong) StockEntrustViewHolder *tableViewHolder;

/** 区分 是 普通用户 还是 牛人用户的 枚举 */
@property(assign, nonatomic) StockBuySellType userOrExpertType;
/** 牛人ID */
@property(strong, nonatomic) NSString *accountId;

/** 标题 */
@property(strong, nonatomic) NSString *titleName;

- (id)initWithMatchId:(NSString *)matchId
        withAccountId:(NSString *)accountId
        withTitleName:(NSString *)titleName
     withUserOrExpert:(StockBuySellType)type;

//撤单列表查询
- (void)doqueryWithRequestFromUser:(BOOL)requestFromUser;
@end
