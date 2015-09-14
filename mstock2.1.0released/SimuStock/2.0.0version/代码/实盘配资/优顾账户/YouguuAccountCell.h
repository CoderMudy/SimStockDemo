//
//  YouguuAccountCell.h
//  SimuStock
//
//  Created by Wang Yugang on 15/3/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouguuAccountCell : UITableViewCell

/** 账户类别 */
@property(weak, nonatomic) IBOutlet UILabel *sortLabel;
/** 余额  */
@property(weak, nonatomic) IBOutlet UILabel *balanceLabel;
/** 时间 */
@property(weak, nonatomic) IBOutlet UILabel *dateLabel;
/** 金额 */
@property(weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end
