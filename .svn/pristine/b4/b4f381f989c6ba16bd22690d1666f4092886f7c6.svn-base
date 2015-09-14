//
//  SelectMatchInitialFundTipView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/8/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SelectMatchInitialFundTipView.h"
#import "MatchInitialFundSelectCell.h"
#import "SimuMatchTemplateData.h"
#import "Globle.h"

#define CellWidth 44.0f

@implementation SelectMatchInitialFundTipView

+ (void)showTipWithOwnGoldCoinNum:(NSInteger)ownNum
                        matchData:(SimuMatchTemplateData *)matchData
                  withSelectBlock:(SelectMatchInitialFundBlock)selectBlock
                  withCancelBlock:(CallBackBlock)cancelBlock {
  SelectMatchInitialFundTipView *tip =
      [[[NSBundle mainBundle] loadNibNamed:@"SelectMatchInitialFundTipView"
                                     owner:nil
                                   options:nil] firstObject];
  [tip.initialFundSelectTableView
                 registerNib:[UINib nibWithNibName:@"MatchInitialFundSelectCell" bundle:nil]
      forCellReuseIdentifier:@"MatchInitialFundSelectCell"];
  tip.matchData = matchData;
  tip.goldCoinNum = ownNum;
  tip.initialFundSelectTableView.delegate = tip;
  tip.initialFundSelectTableView.dataSource = tip;
  tip.initialFundSelectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  tip.initialFundSelectTableView.backgroundColor = [Globle colorFromHexRGB:@"#F7F7F7"];
  tip.tipViewHeight.constant = 50.0f + CellWidth * tip.matchData.dataArray.count;
  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
  tip.frame = mainWindow.bounds;
  tip.selectBlock = selectBlock;
  tip.cancelBlock = cancelBlock;
  [mainWindow addSubview:tip];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.matchData.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return CellWidth;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MatchInitialFundSelectCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"MatchInitialFundSelectCell"];
  SimuMatchTemplateData *item = self.matchData.dataArray[indexPath.row];
  cell.initialFundLabel.text = item.mTemplateName;
  if (item.mCreateFee) {
    cell.coinNumLabel.text = [item.mCreateFee stringByAppendingString:@"金币"];
    if ([item.mCreateFee integerValue] > self.goldCoinNum) {
      cell.initialFundLabel.textColor = [Globle colorFromHexRGB:@"#939393"];
      cell.coinNumLabel.textColor = [Globle colorFromHexRGB:@"#939393"];
      cell.userInteractionEnabled = NO;
    } else {
      cell.initialFundLabel.textColor = [Globle colorFromHexRGB:@"#454545"];
      cell.coinNumLabel.textColor = [Globle colorFromHexRGB:@"#454545"];
      cell.userInteractionEnabled = YES;
    }
  } else {
    cell.coinNumLabel.text = @"免费";
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.selectBlock) {
    SimuMatchTemplateData *item = self.matchData.dataArray[indexPath.row];
    self.selectBlock(item.mTemplateID);
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
