//
//  MyTranceXIBCell.h
//  SimuStock
//
//  Created by Yuemeng on 15/7/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserGradeView;
@class TraceItem;

/*
 *  追踪页面 Cell
 */
@interface TrancingXIBCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UIButton *userButton;
@property(weak, nonatomic) IBOutlet UIImageView *headImageView;
@property(weak, nonatomic) IBOutlet UserGradeView *userGradeView;
@property(weak, nonatomic) IBOutlet UILabel *rateLabel;
@property(weak, nonatomic) IBOutlet UIButton *cancelTranceBtn;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *grayLineHeight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *whiteLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *traceBtnWidth;

- (void)bindInfo:(TraceItem *)item;

@end
