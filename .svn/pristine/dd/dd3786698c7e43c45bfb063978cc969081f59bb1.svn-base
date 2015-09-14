//
//  MyStockBarsCell.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-27.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellBottomLinesView;
@class HotStockBarData;

/** 我的聊股吧 和 热门聊股吧cell */
@interface MyStockBarsCell : UITableViewCell
{
  /** 底线 */
  CellBottomLinesView *_cellBottomLinesView;
}
/** 白色底边 */
@property(strong, nonatomic) IBOutlet UIView *whiteView;
/** 股吧logo */
@property(nonatomic, strong) IBOutlet UIImageView *logoImageView;
/** 股吧名称 */
@property(strong, nonatomic) IBOutlet UILabel *nameLabel;
/** 股吧简介 */
@property(strong, nonatomic) IBOutlet UILabel *desLabel;
/** 股聊数 */
@property(strong, nonatomic) IBOutlet UILabel *postNumLabel;

/** 复用Id */
@property(copy, nonatomic) NSString *reuseId;
/** 隐藏底线方法 */
- (void)hideCellBottomLinesView:(BOOL)hide;

/** 对外刷新显示数据方法数据方法 */
- (void)refreshCellInfoWithData:(HotStockBarData *)barData;
@end
