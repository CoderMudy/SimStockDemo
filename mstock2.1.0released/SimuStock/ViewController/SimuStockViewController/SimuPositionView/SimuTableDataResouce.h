//
//  SimuTableDataResouce.h
//  SimuStock
//
//  Created by Mac on 13-8-23.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimuPositionPageData.h"
#import "CustomPageData.h"
#import "SimuChechBoxView.h"
#import "RealTradeDealList.h"
#import "WFTodayTransactionData.h"
#import "WFHistoryData.h"


@class RealTradeTodayEntrust;
@class SimuTradeRevokeWrapper;

//排列顺序
typedef enum {
  //从大到小
  USLM_Mode_HighToLower,
  //从小到大
  USCC_Mode_LowerToHigh,
  //默认次序
  USCC_Mode_Default,
} UISortListMode;


//单行或者多行模式
typedef enum {
  //单行模式
  USCC_Mode_OneLine,
  //两行模式
  USCC_Mode_TwoLine,
  //两行模式
  USCC_Mode_TwoLineEqual,
  //复选框模式
  USCC_Mode_CheckBox,

} UISimuCellLineMode;

/*
 *类说明：表格的内容cell
 */
@interface SimuTableItem : NSObject

/** 行 */
@property(assign) NSInteger row;
/** 列 */
@property(assign) NSInteger col;

/** 行模式 */
@property(assign) UISimuCellLineMode lineMode;
/** 内容上一行 */
@property(copy, nonatomic) NSString *contentone;
/** 内容下一行 */
@property(copy, nonatomic) NSString *contenttwo;
/** 列颜色 */
@property(strong, nonatomic) UIColor *colorMode;
/** 下一行列颜色 */
@property(strong, nonatomic) UIColor *twocolorMode;

/** 是否可以选中 */
@property(assign) BOOL canSelected;

@end

/*
 *类说明：表格的数据源函数
 */
@interface SimuTableDataResouce : NSObject {
  //列数
  NSInteger stdr_ColNumber;
  //行数
  NSInteger stdr_LineNumber;
  //头说明行高
  CGFloat stdr_HeadHeight;
  //其他行行高
  CGFloat stdr_LineHeight;
  //第一列列宽
  CGFloat stdr_FirstColWidth;
  //列的左右空白总长度
  CGFloat stdr_TotelSpaceWidth;
  //右侧列的总长度
  CGFloat stdr_allcolWidth;
  //总高度（除头文件外）
  CGFloat stdr_allHeight;

  //字体高度
  CGFloat stdr_FontHeight;
  //其他列列宽
  NSMutableArray *stdr_CelWidthArray;
  //标题头内容(字符串)
  NSMutableArray *stdr_HeadContentArray;
  //内容
  NSMutableArray *stdr_CellArray;
  //标题头内容存储
  NSMutableArray *stdr_headBaseViewArray;

  //使用的字体
  UIFont *sit_Font;
  //复选框模式的时候，复选按钮数组
  NSMutableArray *stdr_checkBoxViewArray;
  //是否有重新排序功能
  BOOL sit_isRsetSequence;
  //是否是自选股页面重新设置计数
  NSInteger sit_isSelfStockReset;
  //有排列功能的头纪录数组
  NSMutableArray *sit_headListSequenceArray;
  //排列按钮上的箭头图片
  NSMutableArray *sit_headArrowImageViewArray;
  //当前选中列
  NSInteger sit_cor;
  //当前选中状态
  NSInteger sit_state;
  //当前动画是否正在运行
  BOOL sit_isAnimationRuning;
  //当前是否自选股
  BOOL sit_isSelfStockType;
}

@property(strong, nonatomic) SimuPageData *pagedata;
@property(assign) CGFloat HeadHeight;
@property(assign) CGFloat FirstColWidth;
@property(assign) CGFloat LineHeight;
@property(assign) CGFloat allcolWidth;
@property(assign) CGFloat allHeight;
@property(assign) NSInteger LineNumber;
@property(assign) NSInteger ColNumber;
@property(strong, nonatomic) NSMutableArray *checkBoxViewArray;

@property(strong, nonatomic) NSMutableArray *CelWidthArray;
@property(weak, nonatomic) id delegate;
@property(nonatomic, copy) onTableRowSelected onTableRowSelectedCallback;
@property(assign, nonatomic) NSInteger isSelfStockReset;

/** 表示符 */
@property(copy, nonatomic) NSString *viewIndentifier;

- (UIView *)getTableHeadCellLable:(NSInteger)row Column:(NSInteger)col;
- (UIView *)getTableCellLable:(NSInteger)row Column:(NSInteger)col;
//设定初始化的选中列和选中状态
- (void)setIniteItemCorOrState:(NSInteger)Item_col State:(NSInteger)Item_Type;
//今日成交
- (void)resetDealList:(NSObject *)list withBool:(BOOL)isCapital;

/**委托列表 */
- (void)resetRevokeList:(NSMutableArray *)dataArray;

/**初始化所有变量 */
- (void)resetParamerters;

/**重置列宽、边宽、总高度 */
- (void)resetColumnWidthAndHeightsWithMinWidth:(int)minwidth;

/** 配资实盘历史成交 */
-(void)bindHistoryData:(NSMutableArray *)historyDataArray;

/** 加个初始化方法 */
-(id)initWithIdentifier:(NSString *)indentifier;
@end
