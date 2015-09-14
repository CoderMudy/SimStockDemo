//
//  HaveAStockRecordViewController.m
//  SimuStock
//
//  Created by moulin wang on 15/4/16.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "HaveAStockRecordViewController.h"
#import "DataArray.h"

@interface HaveAStockRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
  //展示 已清仓股票的UITableView
  UITableView *_haveStockRecordTableView;
  
  /** 清仓数据数组，用于数据绑定和小牛判断 */
  DataArray *_closedPositionDataArray;
  
}


@end

@implementation HaveAStockRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  //创建tableview
  [self creatTabelView];
  
  //开个线程 请求数据
  [NSThread detachNewThreadSelector:@selector(requestHaveStockRecord) toTarget:self withObject:nil];
  
}
//创建tableview
-(void)creatTabelView
{
  CGRect frame = CGRectMake(0, 35.0f, CGRectGetWidth(_clientView.bounds), CGRectGetHeight(_clientView.bounds) - 35.0f);
  _haveStockRecordTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
  _haveStockRecordTableView.delegate = self;
  _haveStockRecordTableView.dataSource = self;
  _haveStockRecordTableView.backgroundColor = [UIColor clearColor];
  _haveStockRecordTableView.backgroundView = nil;
  _haveStockRecordTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  [_clientView addSubview:_haveStockRecordTableView];
}

-(void)requestHaveStockRecord
{
  
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return nil;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
