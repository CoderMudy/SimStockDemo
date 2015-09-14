//
//  FMMoveTableCellView.h
//  SimuStock
//
//  Created by jhss_wyz on 15/6/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SimuChechBoxView;

@interface FMMoveTableCellView : UIView

//选中标志区域
@property(weak, nonatomic) IBOutlet SimuChechBoxView *ftvc_checkBoxView;

///股票代码
@property(weak, nonatomic) IBOutlet UILabel *stockCodeLable;
///股票名称
@property(weak, nonatomic) IBOutlet UILabel *stockNameLable;
///股票提醒设置按钮
@property(weak, nonatomic) IBOutlet UIButton *stockAlarmButton;

///股票分组按钮
@property(weak, nonatomic) IBOutlet UIButton *stockGroupButton;

@end
