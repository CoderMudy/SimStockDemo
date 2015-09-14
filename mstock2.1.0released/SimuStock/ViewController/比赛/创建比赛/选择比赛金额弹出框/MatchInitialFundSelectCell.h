//
//  MatchInitialFundSelectCell.h
//  SimuStock
//
//  Created by jhss_wyz on 15/8/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellBottomLinesView;

@interface MatchInitialFundSelectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *initialFundLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinNumLabel;
@property (weak, nonatomic) IBOutlet CellBottomLinesView *bottomLineView;

@end
