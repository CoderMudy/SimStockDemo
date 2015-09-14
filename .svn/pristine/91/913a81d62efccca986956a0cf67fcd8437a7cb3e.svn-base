//
//  HistoryTableViewCell.h
//  SimuStock
//
//  Created by moulin wang on 14-7-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HistoryTableViewCellDelegate <NSObject>
//可实现
@optional
- (void)bidButtonHistoryCallbackMethodRow:(NSInteger)row
                                     cell:(UITableViewCell *)cell;
@end
@interface HistoryTableViewCell : UITableViewCell
//股票代码
@property(nonatomic, strong) UILabel *codeLab;
//股票名称
@property(nonatomic, strong) UILabel *nameLab;
//已加入自选
@property(nonatomic, strong) UILabel *addOptionalLab;
//添加自选按钮
@property(nonatomic, strong) UIButton *optionalBtn;
//线
@property(nonatomic, strong) UIView *lineView;
//行
@property(nonatomic, assign) NSInteger rowInt;
@property(nonatomic, weak) id<HistoryTableViewCellDelegate> delegate;
@end
