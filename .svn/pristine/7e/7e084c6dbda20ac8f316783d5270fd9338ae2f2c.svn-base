//
//  ShoppingMallListCell.h
//  SimuStock
//
//  Created by jhss on 13-9-18.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProductListItem.h"

@interface ShoppingMallListCell : UITableViewCell
@property(strong, nonatomic) IBOutlet UIImageView *cardSortImageView;
@property(strong, nonatomic) IBOutlet UIImageView *cardImageView;
@property(strong, nonatomic) IBOutlet UILabel *cardPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property(strong, nonatomic) IBOutlet UILabel *cardTitleLabel;
@property(strong, nonatomic) IBOutlet UILabel *cardDetailLabel;
@property(strong, nonatomic) IBOutlet UIButton *cardDetailButton;
@property(strong, nonatomic) IBOutlet UIButton *cardBuyingButton;
//上面钻石图案
@property(strong, nonatomic) IBOutlet UIImageView *diamondImageView1;

///重置视图
- (void)resetView;

///绑定数据
- (void)bindProduct:(ProductListItem *)item;

- (void)bindTrackCardInfo:(TrackCardInfo *)item;

@end
