//
//  SelectMatchTypeTipView.m
//  SimuStock
//
//  Created by jhss on 15/8/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SelectMatchTypeTipView.h"
#import "SimuMatchUsesData.h"
#import "SelectMatchTypeTableViewCell.h"

@implementation SelectMatchTypeTipView

+ (void)showTipWithMatchUseData:(SimuMatchUsesData *)matchData
                withSelectBlock:(SelectMatchPurposeBlock)selectBlock
                withCancelBlock:(CallBackBlock)cancelBlock {
  SelectMatchTypeTipView *tip = [[[NSBundle mainBundle] loadNibNamed:@"SelectMatchTypeTipView"
                                                               owner:nil
                                                             options:nil] firstObject];
  [tip.selectMatchUseTableView
                 registerNib:[UINib nibWithNibName:@"SelectMatchTypeTableViewCell" bundle:nil]
      forCellReuseIdentifier:@"SelectMatchTypeTableViewCell"];
  tip.matchData = matchData;
  tip.selectMatchUseTableView.delegate = tip;
  tip.selectMatchUseTableView.dataSource = tip;
  tip.selectMatchUseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  tip.matchUseTipViewHeight.constant = 50.0f + CellHeight * tip.matchData.dataArray.count;
  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
  tip.frame = mainWindow.bounds;
  tip.selectMatchUseBlock = selectBlock;
  tip.cancelBlock = cancelBlock;
  [mainWindow addSubview:tip];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.matchData.dataArray count];
}

/// Cell高度
static const CGFloat CellHeight = 44.0f;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return CellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  SelectMatchTypeTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"SelectMatchTypeTableViewCell"];

  NSString *matchUses = self.matchData.dataArray[indexPath.row];
  cell.matchUseLabel.text = matchUses;

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.selectMatchUseBlock) {
    NSString *matchUse = self.matchData.dataArray[indexPath.row];
    self.selectMatchUseBlock(matchUse);
  }
  [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  if (self.cancelBlock) {
    self.cancelBlock();
  }
  [self removeFromSuperview];
}
@end
