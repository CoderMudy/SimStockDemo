//
//  MarketListView.h
//  SimuStock
//
//  Created by Mac on 13-9-26.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuTableView.h"
#import "SimuTableDataResouce.h"
#import "SimuPositionPageData.h"
#import "SimuUtil.h"
#import "SimuConst.h"
#import "tabbuttonTollView.h"
#import "SimuShowDataView.h"
#import "ASIHTTPRequest.h"
#import "MarketViewController.h"


/*
 *类说明：重新排序
 */
@protocol MarketListViewDelegate <NSObject>
/*
 *功能：点击表格重新排序按钮
 *参数：col_num 排序项目 orderRow 排序类型：升高，降低，默认
 */
-(void)resetSeqencing:(NSInteger) col_num orderRow:(NSInteger)order_row;

@end

/*
 *行情股票列表
 */
@interface MarketListView : UIView <SimuTableViewDelegate>
{
    //表格视图
    SimuTableView * ssv_tableView;
    //表格数据
    SimuTableDataResouce * ssv_tableViewDataResouce;
    //表格区域
    CGRect ssv_tableRect;
    //表格下方区域
    CGRect ssv_bottomRect;
    //数据页面
    CustomPageDada * ssv_pagedata;
    //排序后的新数据页面
    CustomPageDada * ssv_newSortListPageData;
    //当前排序
    UISortListMode ssv_listMode;
    //无自选股说明页面
    SimuShowMessageDataView * spv_messageView;
    //初始化数据
    SimuPageData * spv_pagedata;
}
//设置网络数据(初始化创建)
-(void)setUserPageData:(CustomPageDada *) m_pagedata;
//设置网络数据 （重新排序后的数据，非初始化）
-(void)SetUserPageNotInit:(CustomPageDada *) m_pagedata;
-(void)resetSelfCount;
-(UIScrollView *)GetupdateScrollView;

@property (weak,nonatomic) MarketViewController* delegate;


@end
