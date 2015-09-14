//
//  StockEntrust.m
//  SimuStock
//
//  Created by Mac on 14-10-15.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "StockEntrust.h"

@implementation StockEntrustViewHolder

- (instancetype)initWithRootView:(UIView *)rootView {

  if (self = [super init]) {

    //加入表格控件
    CGRect frame = CGRectMake(0, 0, rootView.bounds.size.width,
                              rootView.bounds.size.height );
    self.tableView = [[SimuTableView alloc] initWithFrame:frame];
    [rootView addSubview:self.tableView];

    //初始化界面
    self.dataArray = [[DataArray alloc] init];
    
    
    _dataSource = [[SimuTableDataResouce alloc] initWithIdentifier:@"今"
                                                                   @"日委托"];
    [_dataSource resetRevokeList:self.dataArray.array];
    [_tableView setScrollVisible:NO];

    _tableView.dataResource = _dataSource;
    [_tableView resetTable];
  }

  return self;
}


//得到当前撤单的流水号
- (NSString *)getSelectedEntrustIDs {
  NSMutableString *cancellID = [[NSMutableString alloc] init];
  for (SimuChechBoxView *obj in _dataSource.checkBoxViewArray) {
    if (obj.isDown && 0 <= obj.row && obj.row < [self.dataArray.array count]) {
      id<EntrustItem> elment = self.dataArray.array[obj.row];
      if (elment) {
        if ([cancellID length] > 0) {
          [cancellID appendString:@","];
        }
        [cancellID appendString:[elment commissionId]];
      }
    }
  }
  return [NSString stringWithString:cancellID];
}

- (void)bindEntrustList:(NSMutableArray *)entrustList {

  [self.dataArray.array removeAllObjects];
  [self.dataArray.array addObjectsFromArray:entrustList];
  self.dataArray.dataBinded = YES;

  [_dataSource resetRevokeList:entrustList];
  _tableView.dataResource = _dataSource;
  [_tableView setScrollVisible:YES];
  _tableView.hidden = NO;
  [_tableView resetTable];
}


@end
