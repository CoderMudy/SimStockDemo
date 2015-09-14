//
//  BanksListView.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NSString+PinYin.h"

typedef void (^selectedBankBlock)(NSString *);

/*
 *  银行列表选择View
 */
@interface BanksListView : UIView <UITableViewDataSource, UITableViewDelegate> {
  UITableView *_tableView;
  NSInteger _index;
  NSString *_firstLetter;
  /** 索引字母 */
  UILabel *_charLabel;
}

@property(nonatomic, copy) selectedBankBlock selectedBankBlock;
@property(nonatomic, strong) NSArray *contentArray;
@property(nonatomic, strong) NSArray *letterArray;

///传入由NSString组成的内容和字母数组来生成自定义视图
+ (void)showMJNIndexView:(selectedBankBlock)selectedBankBlock
            contentArray:(NSArray *)contentArray;

@end
