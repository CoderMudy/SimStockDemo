//
//  AllGroupsView.m
//  SimuStock
//
//  Created by Yuemeng on 15/6/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AllGroupsView.h"
#import "AllGroupTableViewCell.h"
#import "SimuUtil.h"
#import "ModifySelfGroupViewController.h"

@implementation AllGroupsView

- (void)awakeFromNib {

  UINib *cellNib = [UINib nibWithNibName:self.nibName bundle:nil];
  [_allGroupTableView registerNib:cellNib forCellReuseIdentifier:self.nibName];
}

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([AllGroupTableViewCell class]);
  }
  return nibFileName;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return _stockNameArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 37;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  AllGroupTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:self.nibName];
  QuerySelfStockElement *element = _stockNameArray[indexPath.row];
  cell.stockNameLabel.text = element.groupName;
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  [SimuUtil performBlockOnMainThread:^{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidden = YES;

  } withDelaySeconds:0.2f];
  [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView
    didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

  if (indexPath.row == _stockNameArray.count - 1) {
    //编辑分组
    [AppDelegate pushViewControllerFromRight:
                     [[ModifySelfGroupViewController alloc] init]];
  } else {
    if (_choiceGroupBlock) {
      QuerySelfStockElement *element = _stockNameArray[indexPath.row];
      _choiceGroupBlock(element.groupName, element.groupId);
    }
  }
}

- (void)reloadTableViewWithQuerySelfStockData:(QuerySelfStockData *)data {
  _data = data;
  _stockNameArray =
      [data.dataArray mutableCopy]; //不可直接赋值！否则添加分组页面出错

  QuerySelfStockElement *elementEnd = [[QuerySelfStockElement alloc] init];
  elementEnd.groupName = @"编辑分组";
  elementEnd.groupId = @"-1";

  [_stockNameArray addObject:elementEnd];
  _tableViewHeightConst.constant = _stockNameArray.count * 37;
  [_allGroupTableView reloadData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  self.hidden = YES;
  [self.nextResponder touchesBegan:touches withEvent:event];
}

@end
