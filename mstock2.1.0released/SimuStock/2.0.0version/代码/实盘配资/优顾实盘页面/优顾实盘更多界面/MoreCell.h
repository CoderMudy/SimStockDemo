//
//  MoreCell.h
//  SimuStock
//
//  Created by moulin wang on 15/4/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UIImageView *titleImageView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;

@property(assign, nonatomic) float lineFloat;

@end
