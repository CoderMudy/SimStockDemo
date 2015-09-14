//
//  StockSearchTableVC.h
//  SimuStock
//
//  Created by Mac on 15/6/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
#import "StockUtil.h"
#import "SimuKeyBoardView.h"

typedef void (^OnSearchFieldFocus)();

@interface StockSearchTableAdapter : BaseTableAdapter

@end

@interface StockSearchTableVC
    : BaseTableViewController <SimuKeyBoardViewDelegate, UIAlertViewDelegate,
                               UITextFieldDelegate, UITableViewDelegate> {
  /**自定义键盘*/
  SimuKeyBoardView *keyboardView;

  /**相关股票搜索提示*/
  UILabel *promptLab;
}

/**搜索框*/
@property(weak, nonatomic) UITextField *searchField;

/**最近查询股票*/
@property(strong, nonatomic) UIView *tableHeader;

/** 是否过滤指数股 */
@property(assign, nonatomic) BOOL filterStockIndex;

@property(copy, nonatomic) OnStockSelected onStockSelectedCallback;
@property(copy, nonatomic) OnSearchFieldFocus onSearchFieldFocus;

- (id)initWithFrame:(CGRect)frame withSearchField:(UITextField *)searchField;

/** 字母键盘，修改编辑框数据 */
- (void)textFieldChangeWithCharButtonPress:(UIButton *)button;

/** 数字键盘，修改编辑框数据 */
- (void)textFieldChangeWithSelfButtonPress:(UIButton *)button;

/**展示历史搜索股票纪录*/
- (void)didShowHisSearchStockView:(BOOL)isFilterStockIndex;

@end
