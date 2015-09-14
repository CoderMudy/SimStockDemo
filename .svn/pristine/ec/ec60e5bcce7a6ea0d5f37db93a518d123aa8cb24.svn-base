//
//  S5B5View.h
//  SimuStock
//
//  Created by Mac on 13-10-9.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuStockInfoData.h"
#import "CustomPageData.h"
#import "TrendKLineModel.h"
/*
 *类说明：卖五买五控件
 */
@interface S5B5View : UIView {
  //卖区域
  CGRect _sellRect;
  //买区域
  CGRect _buyRect;
  //价格lable数组
  NSMutableArray *_priceArray;
  //量lable数组
  NSMutableArray *_handsArray;
  //当前是否大盘
  BOOL _isIndexStock;
}

- (void)setPageDate:(StockQuotationInfo *)Item priceFormat:(NSString*)priceFormat;
- (void)setDapaPageDate:(NSMutableArray *)pagedata;
- (id)initWithFrame:(CGRect)frame isIndexStock:(BOOL)isIndexStock;

//清除所有数据
- (void)clearAllData;

@end
