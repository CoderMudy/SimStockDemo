//
//  YouguuAccountViewController.h
//  SimuStock
//
//  Created by Jhss on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "WFAccountInterface.h"

#import "BaseTableViewController.h"

@interface YouguuAccountTableAdapter : BaseTableAdapter

@end

@interface YouguuAccountTableViewController : BaseTableViewController

@end

/** 优顾账户界面 */
@interface YouguuAccountViewController : BaseViewController {
  YouguuAccountTableViewController *accountVC;
}

/** 资金明细流水 数据 */
@property(nonatomic, strong) WFCapitalSubsidiary *capitalSubsidiaryInfo;

/** 账户的总额 */
@property(nonatomic, copy) NSString *Youguu_Money_Amount;
/** 创建一个表格视图 */
@property(strong, nonatomic) UITableView *accountTabelView;

@end
