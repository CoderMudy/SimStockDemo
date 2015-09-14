//
//  ApplyForActualTradingViewController.h
//  SimuStock
//
//  Created by jhss_wyz on 15/3/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"

@class WFProductListInfo;
@class WFOneProductInfo;
@class DayAndMoneyTableViewCell;

typedef void (^applySuccess)(WFOneProductInfo *);

@interface ApplyForActualTradingViewController
    : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
  DayAndMoneyTableViewCell *amountCell;
  DayAndMoneyTableViewCell *dayCell;
}

/** 数据模型 */
@property(strong, nonatomic) WFProductListInfo *productInfo;

@property(nonatomic, strong) UITableView *tableView;

/** 申请成功后回调 */
@property(nonatomic, copy) applySuccess applySucess;

/** 顶部右侧“说明”按钮 */
@property(strong, nonatomic) UIButton *instructionBtn;

/** 所选产品的信息 */
@property(strong, nonatomic) WFOneProductInfo *selectedOneProductInfo;

/** 需要支付的总额（单位：元） */
@property(copy, nonatomic) NSString *totalAmount;

///选择的金额
@property(strong, nonatomic) NSString *selectedAmount;
///选择天数
@property(strong, nonatomic) NSString *selectedDay;
///借款日期
@property(nonatomic, copy) NSString *borrowingDate;
///冻结保证金
@property(nonatomic, copy) NSString *frozenDeposit;
///账户管理费
@property(nonatomic, copy) NSString *accountManagementFees;
///合约按钮的状态
@property(nonatomic) BOOL agreementButtonState;

@property(copy, nonatomic) NSArray *days;

@end
