//
//  StockGroupToolTipCell.h
//  SimuStock
//
//  Created by jhss_wyz on 15/6/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^selectBtnClickBlock)(NSString *groupId, BOOL selected);

@interface StockGroupToolTipCell : UITableViewCell

/** 自选股分组名称Lable */
@property (weak, nonatomic) IBOutlet UILabel *groupNameLable;
/** 自选股分组选择按钮 */
@property (weak, nonatomic) IBOutlet UIButton *groupSelectBtn;
/** 自选组分组选择按钮回调Block */
@property (copy, nonatomic) selectBtnClickBlock selectBtnClickBlock;
/** 自选股分组ID */
@property (copy, nonatomic) NSString *groupId;

- (IBAction)clickOnGroupSelectBtn:(UIButton *)sender;

@end
