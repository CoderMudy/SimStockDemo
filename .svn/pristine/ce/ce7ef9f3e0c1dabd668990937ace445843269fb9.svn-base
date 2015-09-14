//
//  FMMoveTableViewCell.h
//  FMFramework
//
//  Created by Florian Mielke.
//  Copyright 2012 Florian Mielke. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SimuChechBoxView.h"
#import "TrendViewController.h"
#import "SimuUtil.h"
#import "CustomPageData.h"

@interface FMMoveTableViewCell : UITableViewCell <NSObject> {

  //移动区域图片
  UIImageView *ftvc_MoveImageView;
  //该行是否选中
  BOOL ftvc_isSelected;

  ///绑定的股票信息
  StockInfo *_stock;
}

//选中标志区域
@property(weak, nonatomic) IBOutlet SimuChechBoxView *checkBoxView;

///股票代码
@property(weak, nonatomic) IBOutlet UILabel *stockCodeLable;
///股票名称
@property(weak, nonatomic) IBOutlet UILabel *stockNameLable;
///股票提醒设置按钮
@property(weak, nonatomic) IBOutlet UIButton *stockAlarmButton;

///股票分组按钮
@property(weak, nonatomic) IBOutlet UIButton *stockGroupButton;

@property(weak, nonatomic) IBOutlet UIButton *stockBtn;

@property(assign, nonatomic) BOOL isSelected;
/** 行数 */
@property(nonatomic, assign) NSInteger row;

- (IBAction)clickOnstockBtn:(UIButton *)sender;

/**
 选中或取消选中的回调函数
 */
- (void)setOnSelectedCallback:(onSelected)onSelectedCallback;

- (void)prepareForMove;
- (void)setCheckBoxSelected:(BOOL)isSelected;

///绑定股票数据
- (void)bindStockItemInfo:(StockInfo *)stock;
@end
