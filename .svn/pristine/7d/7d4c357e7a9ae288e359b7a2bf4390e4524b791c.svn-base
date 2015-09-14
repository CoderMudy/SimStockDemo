//
//  StockGroupToolTip.h
//  SimuStock
//
//  Created by jhss_wyz on 15/6/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^sureBtnClickBlock)(NSArray *SelectedIdArray,
                                  NSString *eightStockCode);
typedef void (^cancleBtnClickBlock)();

@interface StockGroupToolTip : UIView

//是否显示“全部”列表
@property (nonatomic) BOOL showGroupAll;

/** 取消按钮 */
@property(weak, nonatomic) IBOutlet UIButton *cancleBtn;
/** 确定按钮 */
@property(weak, nonatomic) IBOutlet UIButton *sureBtn;
/** 自选股分组选择tableView */
@property(weak, nonatomic) IBOutlet UITableView *stockGroupTV;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tipHeight;

@property(strong, nonatomic) NSMutableArray *groupArrayM;

@property(strong, nonatomic) NSString *eightStockCode;

/** 取消按钮回调Block */
@property(copy, nonatomic) cancleBtnClickBlock cancleBtnClickBlock;
/** 确定按钮回调Block */
@property(copy, nonatomic) sureBtnClickBlock sureBtnClickBlock;

@property(strong, nonatomic) __block NSMutableArray *selectedIdArrayM;

+ (void)showWithEightStockCode:(NSString *)eightStockCode
          andSureBtnClickBlock:(sureBtnClickBlock)sureBlock
        andCancleBtnClickBlock:(cancleBtnClickBlock)cancleBlcok
                  showGroupAll:(BOOL)showGroupAll;

@end