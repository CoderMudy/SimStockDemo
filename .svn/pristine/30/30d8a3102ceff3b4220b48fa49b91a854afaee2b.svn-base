//
//  GainersTableViewCell.h
//  SimuStock
//
//  Created by moulin wang on 14-7-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GainersView.h"
@protocol GainersTableViewCellDelegate <NSObject>
//可实现
@optional
- (void)bidButtonMarketHomeCallbackMethod:(NSInteger)tag row:(NSInteger)row;
@end
@interface GainersTableViewCell : UITableViewCell
@property(nonatomic, strong) GainersView *gainersView;
@property(nonatomic, strong) NSMutableArray *gainArray;
@property(nonatomic, strong) UIButton *stocksBtn1;
@property(nonatomic, strong) UIButton *stocksBtn2;
//竖线
@property(nonatomic, strong) UIView *verticalLine;
//横线
@property(nonatomic, strong) UIView *transverseLine;
//行
@property(nonatomic, assign) NSInteger rowInt;

@property(nonatomic, weak) id<GainersTableViewCellDelegate> delegate;
@end
