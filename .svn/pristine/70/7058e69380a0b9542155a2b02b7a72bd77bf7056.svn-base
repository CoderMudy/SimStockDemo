//
//  MarketListViewController.h
//  SimuStock
//
//  Created by moulin wang on 14-7-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuTradeStatus.h"
#import "BaseViewcontroller.h"
#import "SimuWaitCounter.h"
#import "DataArray.h"
#import "MJRefresh.h"
#import "MarketListTableHeader.h"
#import "MarketConst.h"

typedef NS_ENUM(NSUInteger, skipPage) {
  ///本类跳转
  classSkip = 1,
  ///搜索界面跳转
  searchSkip,

};




@interface MarketListViewController : BaseViewController {
  ///股票榜单类型
  StockListType _stockListType;

  ///下拉刷新显示时间的key
  NSString *_headerViewTimeKey;

  ///请求的URL部分
  NSString *urlPart;

  ///数值显示是否使用涨红跌绿颜色
  BOOL useStockTextColor;
  
  ///是否正在加载
  BOOL isLoadMore;
  
  ///是否正在加载
  BOOL isLoadPrevious;

  //没有数据
  UIView *noDataFootView;

  MarketListTableHeader *tableHeader;

  //定时器间隔时间
  NSTimeInterval timeinterval;

  //定时期
  NSTimer *iKLTimer;

  //表格视图用于显示盈利信息
  UITableView *marketListtableView;
  MJRefreshFooterView *footerView;
  MJRefreshHeaderView *headerView;
  //数据
  DataArray *dataArray;
}

@property(nonatomic, strong) NSString *titleStr;
@property(nonatomic, strong) NSString *codeStr;
@property(nonatomic, assign) skipPage page;

/**
 * 返回行情主页的二级页面：大盘指数，热门行业，热门概念，涨幅榜，跌幅榜，换手榜，振幅榜，新股发行
 *  这些页面的共同特征是：标题固定，且不需要其他任何参数
 */
- (id)initStockListType:(StockListType)stockListType;

/** 返回指定行业、概念下、指定选股指标下的股票列表页面，该页面必须给出code和name
 */
- (id)initIndustryNotionCode:(NSString *)industryNotionCode
      withIndustryNotionName:(NSString *)industryNotionName;

/** 返回指定行业、概念下股票列表页面，该页面必须给出code和name
 */
- (id)initRecommendCode:(NSString *)recommendTypeCode
      withRecommendName:(NSString *)recommendTypeName;
@end
