//
//  MoneyDetailsCell.h
//  SimuStock
//
//  Created by Wang Yugang on 15/3/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellBottomLinesView.h"

/** 资金明细页面的自定义cell */
@interface MoneyDetailsCell : UITableViewCell
/**  详细的分类标题 */
@property(weak, nonatomic) IBOutlet UILabel *hintLabel;
/**  显示时间 */
@property(weak, nonatomic) IBOutlet UILabel *dateLabel;
/** 显示金额 */
@property(weak, nonatomic) IBOutlet UILabel *moneyLabel;
/**  */
@property(weak, nonatomic) IBOutlet CellBottomLinesView *bottomSplitLine;

/** 设置子控件 */
- (void)setupSubviews;

@end
