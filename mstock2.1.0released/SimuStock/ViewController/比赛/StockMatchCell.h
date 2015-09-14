//
//  StockMatchCell.h
//  SimuStock
//
//  Created by jhss on 14-5-6.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopAndBottomAlignmentLabel.h"

@interface StockMatchCell : UITableViewCell
@property(strong, nonatomic) UIView *whiteBackgroundView;
@property(strong, nonatomic) UIButton *rowBackButton;
@property(strong, nonatomic) UIImageView *matchIconImageView;
@property(strong, nonatomic) UILabel *createMarkLabel;
@property(strong, nonatomic) UIImageView *diamondImageView;
@property(strong, nonatomic) UILabel *matchNameLabel;
@property(strong, nonatomic) UILabel *matchDeadLineLabel;
@property(strong, nonatomic) TopAndBottomAlignmentLabel *matchDetailLabel;
@property(strong, nonatomic) UILabel *joinNumberLabel;
@property(strong, nonatomic) UILabel *personNameLabel;
@property(strong, nonatomic) UILabel *creatorLabel;

@end
