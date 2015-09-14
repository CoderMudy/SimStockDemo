//
//  MyIncomingTableViewCell.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWalletFlowData.h"
#import "CellBottomLinesView.h"

@interface MyIncomingTableViewCell : UITableViewCell

///交易类型
@property (strong, nonatomic) IBOutlet UILabel *tradeTypeLabel;
///交易时间
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
///交易金额
@property (strong, nonatomic) IBOutlet UILabel *tradeFeeLabel;
//钻石数量
@property (strong, nonatomic) IBOutlet UIButton *diamondButton;
//交易状态
@property (strong, nonatomic) IBOutlet UILabel *tradeStatusLabel;
/** cell复用字符串设定 */
@property(nonatomic, copy) NSString *reuseId;
//底线
@property (weak, nonatomic) IBOutlet CellBottomLinesView *cellBottomLinesView;

- (void)bindDataWith:(MyWalletFlowElement *)element;

@end
