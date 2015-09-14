//
//  ClosedPositionViewController.h
//  SimuStock
//
//  Created by Mac on 15/4/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
#import "DataArray.h"
#import "Globle.h"

@interface ClosedPositionTableAdapter : BaseTableAdapter

@property(assign, nonatomic) BOOL showButtons;

@end

/** 清仓股票列表数据 */
@interface ClosedPositionViewController : BaseTableViewController

@property(assign, nonatomic) BOOL showTopSeperatorLine;

@property(strong, nonatomic) NSString *userID;
@property(strong, nonatomic) NSString *matchID;

/** 清仓选择表格记录 */
@property(assign, nonatomic) NSInteger selectedRowIndex;

/** 初始化*/
- (id)initWithFrame:(CGRect)frame withUserId:(NSString *)userid withMatckId:(NSString *)matchId;

/** 刷新数据，供父容器调用*/
- (void)refreshButtonPressDown;

/** 数据是否已经绑定，供父容器调用*/
- (BOOL)dataBinded;

@end
