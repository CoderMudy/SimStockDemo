//
//  IndexCurStatusVC.m
//  SimuStock
//
//  Created by Mac on 15/6/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "IndexCurStatusVC.h"

static CGFloat IndexInfoViewHeight = 120.f;
@interface IndexCurStatusAdapter ()

@property(nonatomic, weak) IndexCurStatusVC *owner;

@end

@implementation IndexCurStatusAdapter

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return _owner.topStockInfoView;
  } else {
    return nil;
  }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return IndexInfoViewHeight;
  } else {
    return 0.f;
  }
}

- (UIView *)tableView:(UITableView *)tableView
    viewForFooterInSection:(NSInteger)section {
  if (section == 0) {
    return _owner.securitiesTrendVC.view;
  } else {
    return nil;
  }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForFooterInSection:(NSInteger)section {
  if (section == 0) {
    return 240.f;
  } else {
    return 0.f;
  }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 0.f;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return 0;
}

@end

@implementation IndexCurStatusVC



- (void)resetWithFrame:(CGRect)frame
    withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo {
  if ([securitiesInfo.securitiesCode()
          isEqualToString:self.securitiesInfo.securitiesCode()]) {
    return;
  }
  [super resetWithFrame:frame withSecuritiesInfo:securitiesInfo];
  [self clearView];

  [_tableView reloadData];
}

- (void)refreshSecuritesData {
  [self refreshView];
}

- (void)refreshView {
  [_securitiesTrendVC refreshView];
  [_indexStockWindVaneView refreshView];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createTableView];

  _topStockInfoView = [[TopStockInfoView alloc]
      initWithFrame:CGRectMake(5, 0, self.view.bounds.size.width - 10,
                               IndexInfoViewHeight)
             IsDapa:YES];
  [self.view addSubview:_topStockInfoView];

  _securitiesTrendVC = [[SecuritiesTrendVC alloc]
           initWithFrame:CGRectMake(0, IndexInfoViewHeight,
                                    self.view.bounds.size.width, 223.f)
      withSecuritiesInfo:self.securitiesInfo];

  __weak IndexCurStatusVC *weakSelf = self;
  _securitiesTrendVC.stockQuotationInfoReady = ^(NSObject *obj) {
    [weakSelf bindFundCurStatus:(StockQuotationInfo *)obj];
  };
  _securitiesTrendVC.beginRefreshCallBack = self.beginRefreshCallBack;
  _securitiesTrendVC.endRefreshCallBack = self.endRefreshCallBack;

  [self addChildViewController:_securitiesTrendVC];
  [self.view addSubview:_securitiesTrendVC.view];

  _indexStockWindVaneView = [[IndexStockWindVaneView alloc]
      initWithFrame:CGRectMake(0, 345, self.view.width, 700)];
  _indexStockWindVaneView.beginRefreshCallBack = self.beginRefreshCallBack;
  _indexStockWindVaneView.endRefreshCallBack = self.endRefreshCallBack;
  
  [_tableView setTableFooterView:_indexStockWindVaneView.view];
  [self addChildViewController:_indexStockWindVaneView];

  [SimuUtil performBlockOnMainThread:^{
    [weakSelf refreshSecuritesData];
  } withDelaySeconds:0.1];
}

- (void)bindFundCurStatus:(StockQuotationInfo *)data {
  self.stockQuotationInfo = data;
  [self.topStockInfoView setHeadStcokInfo:data IsDapan:YES];
  if (self.onDataReadyCallBack) {
    self.onDataReadyCallBack();
  }
}

#pragma mark
#pragma mark 创建控件

- (IndexCurStatusAdapter *)tableAdapter {
  if (_tableAdapter == nil) {
    _tableAdapter =
        [[IndexCurStatusAdapter alloc] initWithTableViewController:nil
                                                     withDataArray:nil];
  }
  _tableAdapter.owner = self;
  return _tableAdapter;
}

//创建滚动页面
- (void)createTableView {
  _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
  _tableView.delegate = [self tableAdapter];
  _tableView.dataSource = [self tableAdapter];
  _tableView.bounces = YES;
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tableView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [self.view addSubview:_tableView];
}

/**
 * 设置无网络小牛
 */
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip];
}

#pragma mark
#pragma mark 对外接口

//清理当前数据
- (void)clearSecuritesData {
  [_tableView reloadData];
  [_securitiesTrendVC clearView];
}

- (UIView *)curStatusViewForShare {
  if (_tableView) {
    return _tableView;
  }
  return nil;
}

- (NSString *)curPrice {
  if (_stockQuotationInfo == nil) {
    return @"--";
  } else {
    //个股信息
    __block NSString *curPrice = nil;

    [_stockQuotationInfo.dataArray
        enumerateObjectsUsingBlock:^(PacketTableData *packetTable,
                                     NSUInteger idx, BOOL *stop) {
          if ([packetTable.tableName isEqualToString:@"CurStatus"]) {
            NSDictionary *dic = packetTable.tableItemDataArray[0];
            CGFloat newprice = [dic[@"curPrice"] floatValue];
            curPrice = [NSString stringWithFormat:@"%.2f", newprice];
          }
        }];
    return curPrice ? curPrice : @"--";
  }
}

- (NSString *)riseRate {
  if (_stockQuotationInfo == nil) {
    return @"--";
  } else {
    //个股信息
    __block NSString *curPrice = nil;

    [_stockQuotationInfo.dataArray
        enumerateObjectsUsingBlock:^(PacketTableData *packetTable,
                                     NSUInteger idx, BOOL *stop) {
          if ([packetTable.tableName isEqualToString:@"CurStatus"]) {
            NSDictionary *dic = packetTable.tableItemDataArray[0];
            CGFloat riseRate = [dic[@"changePer"] floatValue];
            curPrice = [NSString stringWithFormat:@"%.2f%%", riseRate];
          }
        }];
    return curPrice ? curPrice : @"--";
  }
}

@end
