//
//  SingleCapitaldetailsCell.h
//  SimuStock
//
//  Created by Mac on 15/4/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
///分割线
#import "CellBottomLinesView.h"
#import "UIButton+Block.h"

@class WFContractInfo;
@protocol SingleCapitaldetailsCellDelegate <NSObject>
///续约按钮变点击
- (void)reneWalbtnClick:(NSInteger)index;
@end
@interface SingleCapitaldetailsCell : UITableViewCell

@property(weak, nonatomic) IBOutlet CellBottomLinesView *VerticallineView1;
@property(weak, nonatomic) IBOutlet CellBottomLinesView *VerticallineView2;
@property(weak, nonatomic) IBOutlet CellBottomLinesView *VerticallineView3;

@property(weak, nonatomic) IBOutlet UILabel *Labelsign2;
@property(weak, nonatomic) IBOutlet UILabel *Labelsign1;
@property(weak, nonatomic) IBOutlet UILabel *Labelsign4;
@property(weak, nonatomic) IBOutlet UILabel *Labalsign3;

@property(weak, nonatomic) IBOutlet UILabel *ProfitLabel;
@property(weak, nonatomic) IBOutlet UILabel *MaturityDateLabel;
@property(weak, nonatomic) IBOutlet UILabel *CurrentAssetsLabel;
@property(weak, nonatomic) IBOutlet UILabel *AvailableFundsLabel;

@property(weak, nonatomic) id<SingleCapitaldetailsCellDelegate> delegate;
/**  续约按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *RenewalBtn;
///借钱数
@property(weak, nonatomic) IBOutlet UILabel *NumberLabel;
///单位
//@property (weak, nonatomic) IBOutlet UILabel *UnitLabel;

//@property (nonatomic,)
/**  续约按钮 触发的操作*/
- (IBAction)popUpRenewalView:(id)sender;

///基本数据初始化赋值
- (void)giveWithCellUIData:(WFContractInfo *)wfcontract;

@end
