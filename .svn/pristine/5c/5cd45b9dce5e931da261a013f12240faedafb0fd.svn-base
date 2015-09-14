//
//  BanksListView.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BanksListView.h"
#import "Globle.h"
#import "SimuUtil.h"

@implementation BanksListView

+ (void)showMJNIndexView:(selectedBankBlock)selectedBankBlock
            contentArray:(NSArray *)contentArray {
  BanksListView *backsListView =
      [[BanksListView alloc] initWithContentArray:contentArray];
  backsListView.selectedBankBlock = selectedBankBlock;
  [[[[UIApplication sharedApplication] delegate] window]
      addSubview:backsListView];
}

- (instancetype)initWithContentArray:(NSArray *)contentArray {
  self = [super
      initWithFrame:[[UIApplication sharedApplication].delegate.window bounds]];
  if (self) {
    self.contentArray = contentArray;
    //根据contentArray生成letterArray;
    [self calculateLetterArray];
    [self createUI];
    [self createBigChar];
  }
  return self;
}

- (void)calculateLetterArray {
  NSMutableArray *tempMArray = [[NSMutableArray alloc] init];
  [_contentArray enumerateObjectsUsingBlock:^(NSString *bankName,
                                              NSUInteger idx, BOOL *stop) {
    NSString *firstLetter = bankName.getFirstLetter;
    if (![_firstLetter isEqualToString:firstLetter]) {
      _firstLetter = firstLetter;
      [tempMArray addObject:firstLetter];
    }
  }];

  _letterArray = [tempMArray copy];
}

- (void)createUI {

  self.backgroundColor = [Globle colorFromHexRGB:Color_Black alpha:0.5];

  // tableView
  _tableView = [[UITableView alloc]
      initWithFrame:CGRectMake(20, 100, WIDTH_OF_VIEW - 20 * 2,
                               HEIGHT_OF_VIEW - 100 * 2)
              style:UITableViewStylePlain];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  _tableView.bounces = NO;
  _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 30);
  _tableView.layer.borderColor =
      [[Globle colorFromHexRGB:Color_Black alpha:.75f] CGColor];
  _tableView.layer.borderWidth = 2;
  _tableView.layer.cornerRadius = 5;
  _tableView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  _tableView.sectionIndexColor = [Globle colorFromHexRGB:Color_Blue_but];
  _tableView.sectionIndexBackgroundColor =
      [Globle colorFromHexRGB:Color_BG_Common];
    [self addSubview:_tableView];
}

/** 中间字母显示 */
- (void)createBigChar {
  _charLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55.0f, 55.0f)];
  _charLabel.center =
      CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
  _charLabel.backgroundColor = [Globle colorFromHexRGB:@"#0a78bf"];
  _charLabel.textAlignment = NSTextAlignmentCenter;
  _charLabel.font = [UIFont systemFontOfSize:25.0f];
  _charLabel.textColor = [UIColor whiteColor];
  [_charLabel.layer setMasksToBounds:YES];
  [_charLabel.layer setCornerRadius:5.0f];
  _charLabel.hidden = YES;
  [self addSubview:_charLabel];
}

#pragma mark - TableView datasource methods
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return _tableView.height / 8; //保证tableView恰好显示8个cell
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return _contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *cellID = @"cellID";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellID];
  }
  cell.textLabel.font = [UIFont systemFontOfSize:Font_Height_15_0];
  cell.textLabel.text = _contentArray[indexPath.row];
  cell.textLabel.textAlignment = NSTextAlignmentCenter;
  cell.textLabel.backgroundColor = [UIColor clearColor];
  cell.textLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  cell.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  cell.contentView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  cell.selectionStyle = UITableViewCellSelectionStyleBlue;
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  if (_selectedBankBlock) {
    _selectedBankBlock(_contentArray[indexPath.row]);
  }
  //渐隐并消失
  [UIView animateWithDuration:0.25f
      animations:^{
        self.alpha = 0;
      }
      completion:^(BOOL finished) {
        [self removeFromSuperview];
      }];
}

//创建索引列
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  return _letterArray;
}

//索引列滑动回调
- (NSInteger)tableView:(UITableView *)tableView
    sectionForSectionIndexTitle:(NSString *)title
                        atIndex:(NSInteger)index {
  _charLabel.hidden = NO;
  _charLabel.text = title;
  [SimuUtil performBlockOnMainThread:^{
    _charLabel.hidden = YES;
  } withDelaySeconds:2];

  [tableView
      scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
            atScrollPosition:UITableViewScrollPositionTop
                    animated:YES];
  return index;
}

@end
