//
//  MoreSelectedView.m
//  SimuStock
//
//  Created by jhss on 15/6/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MoreSelectedView.h"
#import "MoreSelectedTableViewCell.h"
#import "SimuUtil.h"

@implementation MoreSelectedView
- (void)awakeFromNib {
  UINib *cellNib = [UINib nibWithNibName:self.nibName bundle:nil];
  [_moreSelectedTableView registerNib:cellNib
               forCellReuseIdentifier:self.nibName];
}

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([MoreSelectedTableViewCell class]);
  }
  return nibFileName;
}

- (void)reloadTableViewWithQuerySelfStockData:(BOOL)isMasterPlan {
  if (isMasterPlan) {
    _moreselectedArr = [@[ @"牛人计划", @"分享" ] mutableCopy];
  } else {
    _moreselectedArr = [@[ @"分享" ] mutableCopy];
  }
  _isBuyMasterPlan = isMasterPlan;
  _cellHeight.constant = _moreselectedArr.count * 37;
  _moreSelectedTableView.layer.masksToBounds = YES;
  [_moreSelectedTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return _moreselectedArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 37;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MoreSelectedTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:self.nibName];
  cell.selectedNameLabel.text = _moreselectedArr[indexPath.row];
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
  [_moreselectedArr[indexPath.row] isEqualToString:@"牛人计划"]
      ? (_pushToSuperPlanVCCallBack())
      : (_sharePressCallBack());
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  self.hidden = YES;
  [super.nextResponder touchesBegan:touches withEvent:event];
}
@end
