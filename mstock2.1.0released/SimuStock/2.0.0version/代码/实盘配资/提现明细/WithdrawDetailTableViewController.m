//
//  WithdrawDetailTableViewController.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/22.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

@interface WithdrawDetailTableViewController () <UITableViewDelegate,
                                                 UITableViewDataSource>

/** 提现明细列表 */
@property(copy, nonatomic) NSArray *withdrawList;

@end

@implementation WithdrawDetailTableViewController

static NSString *cellID = @"withdrawDetailCell";

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  UINib *cellNib = [UINib nibWithNibName:@"WithdrawDetailCell" bundle:nil];
  [self.tableView registerNib:cellNib forCellReuseIdentifier:cellID];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {

  return 20;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 57;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  WithdrawDetailCell *cell =
      [tableView dequeueReusableCellWithIdentifier:cellID];
  return cell;
}

@end
