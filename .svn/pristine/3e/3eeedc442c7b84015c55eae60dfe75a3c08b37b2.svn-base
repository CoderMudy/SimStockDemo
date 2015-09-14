//
//  SameStockHeroMainViewController.h
//  SimuStock
//
//  Created by Mac on 15/4/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseNoTitleViewController.h"
#import "SameStockHeroListViewController.h"
#import "StockUtil.h"

@interface SameStockHeroHeaderView : UIView

/** 总人数 */
@property(weak, nonatomic) IBOutlet UILabel *lblHoldUserNum;

/** 获利占比 */
@property(weak, nonatomic) IBOutlet UILabel *lblProfitRate;

/** 平均成本 */
@property(weak, nonatomic) IBOutlet UILabel *lblAvgCostPrice;

/** 平均盈利 */
@property(weak, nonatomic) IBOutlet UILabel *lblAvgProfitRate;

/** 返回价格格式化字符串 */
@property(nonatomic, copy) PriceFormatAction priceFormat;

/** 重置 */
- (void)reset;

/** 数据绑定 */
- (void)bindData:(SameStockHeroList *)heroList;

@end

@interface SameStockHeroMainViewController : BaseNoTitleViewController

@property(nonatomic, strong) SameStockHeroHeaderView *headView;

/** 股票代码 */
@property(nonatomic, strong) NSString *stockCode;
@property(nonatomic, strong) NSString *firstType;

/** 同股牛人页面数据 */
@property(nonatomic, strong) SameStockHeroList *heroList;

/** 同股牛人列表 */
@property(nonatomic, strong) SameStockHeroListViewController *heroListVC;

/** 开始加载，通知父容器*/
@property(copy, nonatomic) CallBackAction beginRefreshCallBack;

/** 结束加载，通知父容器*/
@property(copy, nonatomic) CallBackAction endRefreshCallBack;

/** 初始化 */
- (id)initWithFrame:(CGRect)frame
      withStockCode:(NSString *)stockCode
          firstType:(NSString *)firstType;

/** 重置股票代码 */
- (void)resetStockCode:(NSString *)stockCode firstType:(NSString *)firstType;

/** 刷新页面 */
- (void)refresh;

@end
