//
//  StockGroupToolTip.m
//  SimuStock
//
//  Created by jhss_wyz on 15/6/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockGroupToolTip.h"
#import "StockGroupToolTipCell.h"
#import "PortfolioStockModel.h"
#import "NewShowLabel.h"
#import "SimuUtil.h"

@interface StockGroupToolTip () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation StockGroupToolTip

- (void)awakeFromNib {
  UINib *cellNib =
      [UINib nibWithNibName:NSStringFromClass([StockGroupToolTipCell class])
                     bundle:nil];
  [self.stockGroupTV registerNib:cellNib
          forCellReuseIdentifier:@"StockGroupToolTipCell"];

  self.selectedIdArrayM = [NSMutableArray array];

  [_sureBtn setBackgroundImage:[SimuUtil imageFromColor:Color_Blue_butDown]
                      forState:UIControlStateHighlighted];
  [_cancleBtn setBackgroundImage:[SimuUtil imageFromColor:Color_Gray_butDown]
                        forState:UIControlStateHighlighted];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [[self superview] endEditing:YES];
}

+ (void)showWithEightStockCode:(NSString *)eightStockCode
          andSureBtnClickBlock:(sureBtnClickBlock)sureBlock
        andCancleBtnClickBlock:(cancleBtnClickBlock)cancleBlcok
                  showGroupAll:(BOOL)showGroupAll {
  if (eightStockCode.length != 8) {
    NSLog(@"⚠️股票代码不是8位：%@", eightStockCode);
    return;
  }

  StockGroupToolTip *tip =
      [[[NSBundle mainBundle] loadNibNamed:@"StockGroupToolTip"
                                     owner:nil
                                   options:nil] lastObject];
  tip.frame = WINDOW.bounds;
  tip.showGroupAll = showGroupAll;
  [WINDOW addSubview:tip];

  QuerySelfStockData *tempData =
      [PortfolioStockManager currentPortfolioStockModel].local;
  tip.groupArrayM = [tempData.dataArray mutableCopy];

  if (tip.groupArrayM.count < 2) {
    [NewShowLabel setMessageContent:@"您" @"目"
                  @"前没有分组，请添加分组后操作"];
    [tip removeFromSuperview];
    return;
  }

  //根据是否需要显示“全部”列表判断
  if (!showGroupAll) {
    tip.groupArrayM = [[tip.groupArrayM
        subarrayWithRange:NSMakeRange(1,
                                      tip.groupArrayM.count - 1)] mutableCopy];
  }

  tip.eightStockCode = eightStockCode;
  tip.sureBtnClickBlock = sureBlock;
  tip.cancleBtnClickBlock = cancleBlcok;
  tip.tipHeight.constant = tip.groupArrayM.count * 42 + 61;
  tip.stockGroupTV.delegate = tip;
  tip.stockGroupTV.dataSource = tip;
}

- (IBAction)clickOnCancleBtn:(UIButton *)sender {
  if (self.cancleBtnClickBlock) {
    self.cancleBtnClickBlock();
  }
  [self removeFromSuperview];
}

- (IBAction)clickOnSureBtn:(UIButton *)sender {
  if (self.sureBtnClickBlock) {
    self.sureBtnClickBlock([self.selectedIdArrayM copy], self.eightStockCode);
  }
  [self removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return self.groupArrayM.count;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 41;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  StockGroupToolTipCell *cell = (StockGroupToolTipCell *)[tableView cellForRowAtIndexPath:indexPath];
  QuerySelfStockElement *groupElement = self.groupArrayM[indexPath.row];
  if (![groupElement.groupId isEqualToString:GROUP_ALL_ID]) {
    [cell clickOnGroupSelectBtn:cell.groupSelectBtn];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *Cell_Id = @"StockGroupToolTipCell";
  UITableViewCell *tempCell =
      [tableView dequeueReusableCellWithIdentifier:Cell_Id];

  StockGroupToolTipCell *cell = (StockGroupToolTipCell *)tempCell;
  QuerySelfStockElement *groupElement = self.groupArrayM[indexPath.row];
  cell.groupId = groupElement.groupId;
  cell.groupNameLable.text = groupElement.groupName;

  __weak StockGroupToolTip *weakSelf = self;

  cell.selectBtnClickBlock = ^(NSString *groupId, BOOL selected) {
    if (selected) {
      [weakSelf.selectedIdArrayM addObject:groupId];
    } else {
      [weakSelf.selectedIdArrayM removeObject:groupId];
    }
  };

  //默认选中“全部”，和当前选中的分组
  if ([cell.groupId isEqualToString:GROUP_ALL_ID]) {
    cell.groupSelectBtn.enabled = NO;
    cell.groupNameLable.enabled = NO;
    if (cell.selectBtnClickBlock) {
      cell.selectBtnClickBlock(cell.groupId, YES);
    }
  } else if ([cell.groupId
                 isEqualToString:[SimuUtil currentSelectedSelfGroupID]]) {
    [cell clickOnGroupSelectBtn:cell.groupSelectBtn];
  } else if (groupElement.stockCodeArray) {
    __block BOOL isContained = NO;
    [groupElement.stockCodeArray
        enumerateObjectsUsingBlock:^(NSString *stockCode, NSUInteger idx,
                                     BOOL *stop) {
          if ([stockCode isEqualToString:weakSelf.eightStockCode]) {
            isContained = YES;
            *stop = YES;
          }
        }];
    if (isContained) {
      [cell clickOnGroupSelectBtn:cell.groupSelectBtn];
    }
  }
  return cell;
}

@end
