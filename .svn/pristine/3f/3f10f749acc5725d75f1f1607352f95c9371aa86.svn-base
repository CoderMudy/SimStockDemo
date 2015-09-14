//
//  MarketListTableHeader.h
//  SimuStock
//
//  Created by Mac on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MarketConst.h"
#import "UIButton+Block.h"
#import "UIButton+ImageOnRight.h"

/**
 *  股票行情二级页面的表头
 */
@interface MarketListTableHeader : UIView {
  ///第一列表头
  CGRect _firstColumn;
  CGRect _firstColumnSpace;
  ///第二列表头
  CGRect _secondColumn;
  CGRect _secondColumnSpace;
  ///第三列表头
  CGRect _thirdColumn;
  CGRect _thirdColumnSpace;
  CGRect _thirdColumnLeftSpace;
  ///股票榜单类型
  StockListType _stockListType;
  ///智能选股指标类型
  RecommendStockType _recommendStockType;
}

///菊花控件
@property(nonatomic, strong) UIActivityIndicatorView *sortingIndicatorView;

///排序方向箭头
@property(nonatomic, strong) UIImageView *sortOrderImageView;

///排序触发按钮
@property(nonatomic, strong) UIButton *sortButton;

/** 点击逻辑Block存储在字典中 */
@property(nonatomic, copy) ButtonPressed action;

/** 初始化表头，可以指定大小，股票列表类型，推荐股票指标类型和重新排序方法回调
 */
- (id)initWithFrame:(CGRect)frame
    withStockListType:(StockListType)stockListType
    withRecommendType:(RecommendStockType)recommendStockType
     withSortCallBack:(ButtonPressed)callback;

@end
