//
//  MoreShareExplainRefreshView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MoreShareExplainRefreshView.h"
#import "MoreSelectedTableViewCell.h"

@implementation MoreShareExplainRefreshView

- (void)awakeFromNib {
  UINib *cellNib = [UINib nibWithNibName:self.nibName bundle:nil];
  [_moreShareTableView registerNib:cellNib forCellReuseIdentifier:self.nibName];
}

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([MoreSelectedTableViewCell class]);
  }
  return nibFileName;
}

//根据 牛人视角 还是 用户视角 计划运行 或者 未运行
- (void)expertOrUser:(NSDictionary *)dic {
  if (dic == nil) {
    return;
  }
  RolePerspectiveState rolePerspetive = [dic[@"state"] integerValue];
  PlanState planState = [dic[@"planState"] integerValue];

  if (rolePerspetive == ExpertPerspectiveState) {
    if (planState == PlanStateRunning) {
      _moreLableTitleArray =
          [@[ @"提前终止", @"操作协议", @"分享" ] mutableCopy];
    } else {
      _moreLableTitleArray = [@[ @"操作协议", @"分享" ] mutableCopy];
    }
  } else {
    _moreLableTitleArray = [@[ @"说明", @"分享" ] mutableCopy];
  }
  _tableViewHeight.constant = _moreLableTitleArray.count * 37;
  _moreShareTableView.layer.masksToBounds = YES;
  [_moreShareTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return _moreLableTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 37;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MoreSelectedTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:self.nibName];
  cell.selectedNameLabel.text = _moreLableTitleArray[indexPath.row];
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
  //待写
  if ([_moreLableTitleArray[indexPath.row] isEqualToString:@"提" @"前"
                                                                  @"终止"]) {
    _earlyTerminationCallBack();
  } else if ([_moreLableTitleArray[indexPath.row]
                 isEqualToString:@"操作协议"]) {
    _operatingAgreementCallBack();

  } else if ([_moreLableTitleArray[indexPath.row] isEqualToString:@"分享"]) {
    _sharePressCallBack();
  } else if ([_moreLableTitleArray[indexPath.row] isEqualToString:@"说明"]) {
    _explanationCallBack();
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  self.hidden = YES;
  [super.nextResponder touchesBegan:touches withEvent:event];
}

@end
