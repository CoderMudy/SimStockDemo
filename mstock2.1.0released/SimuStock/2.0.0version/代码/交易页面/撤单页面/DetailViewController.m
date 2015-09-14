//
//  ViewController.m
//  NewTableViewDemo
//
//  Created by 杜甲 on 14-1-11.
//  Copyright (c) 2014年 杜甲. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController {

  NSArray *array;
  NSString *sttr;
}
- (id)initWithIdentifier:(NSString *)indentifier {
  self = [self init];
  if (self) {
    self.viewIndentifier = indentifier;
    [self establishNavigationBarWithIndentifier:indentifier];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [Globle colorFromHexRGB:@"f9f9f9"];

  //  [_topToolBar resetContentAndFlage:@"查委托/撤单" Mode:TTBM_Mode_Leveltwo];

  //  array = @[
  //            @"状态",
  //            @"股票名称",
  //            @"操作类型",
  //            @"委托价格",
  //            @"委托数量",
  //            @"委托时间"
  //            ];
  array = @[ @"操作", @"股票名称", @"成交价格", @"成交数量", @"成交时间" ];

  NSString *str1 = @"武钢股份";
  NSString *str2 = @"600005";
  sttr = [NSString stringWithFormat:@"%@%@", str1, str2];
  numberOfColumns = 5;
  numberOfSections = 1;

  numberOfColumns = array.count;

  colWidth = 50.0f;      //左侧表的宽度
  rightColWidth = 80.0f; //右侧表的列宽
  data = [[NSMutableArray alloc] init];
  sectionHeaderData = [[NSMutableArray alloc] init];

  for (int i = 0; i < numberOfSections; i++) {

    NSMutableArray *sectionArray = [NSMutableArray array];

    for (int k = 0; k < 5; k++) { //行数
      NSMutableArray *rowArray = [NSMutableArray array];
      for (int j = 0; j < numberOfColumns; j++) {
        NSMutableString *text = [NSMutableString stringWithFormat:@"( %d , %d)", k, j];
        [rowArray addObject:text];
      }
      [sectionArray addObject:rowArray];
    }
    [data addObject:sectionArray];
  }
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {

    tbView = [[EWMultiColumnTableView alloc]
        initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height)];
  } else {

    tbView = [[EWMultiColumnTableView alloc]
        initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height)];
  }

  tbView.sectionHeaderEnabled = YES;
  tbView.dataSource = self;
  tbView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  [self.view addSubview:tbView];
  self.view.clipsToBounds = NO;
}
/**
 *  创建导航栏  今日成交 今日委托  历史数据
 */
- (void)establishNavigationBarWithIndentifier:(NSString *)indentifier {

  // clang-format off
  if ([indentifier isEqualToString:@"今日委托"]) {
    array =
        @[ @"撤单",
           @"状态",
           @"股票名称",
           @"操作类型",
           @"委托价格",
           @"委托数量",
           @"委托时间" ];
  } else if ([indentifier isEqualToString:@"今日成交"] ||
             [indentifier isEqualToString:@"历史成交"]) {
    array = @[ @"操作", @"股票名称", @"成交价格", @"成交数量", @"成交时间" ];
  }
  // clang-format on
  //列数赋值
  //  stdr_ColNumber = [array count];
  //
  //  //字体高度
  //  CGSize size = [@"大" sizeWithFont:sit_Font];
  //  stdr_FontHeight = size.height;
  //  [stdr_HeadContentArray removeAllObjects];
  //  [stdr_HeadContentArray addObjectsFromArray:array];
  //  [self resetColumnWidthAndHeightsWithMinWidth:0];
  //[self reCalculationWidth];
}

//设置表格视图有多少个分区
- (NSInteger)numberOfSectionsInTableView:(EWMultiColumnTableView *)tableView {
  return 1;
}

//设置每个分组的个数
- (NSInteger)tableView:(EWMultiColumnTableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  //    return [[data objectAtIndex:section] count];
  return 5;
}
/**
 *
 *
 *******组头
 *
 *
 */
//为数据区分区的头部添加一个Label
- (UIView *)tableView:(EWMultiColumnTableView *)tableView
    sectionHeaderCellForSection:(NSInteger)section
                         column:(NSInteger)col {
  UILabel *l = [[UILabel alloc]
      initWithFrame:CGRectMake(0.0f, 0.0f, [self tableView:tableView widthForColumn:col], 0.0f)];
  //    l.backgroundColor = [UIColor yellowColor];
  return l;
}

//设置数据区分区的头部Label赋值
- (void)tableView:(EWMultiColumnTableView *)tableView
    setContentForSectionHeaderCell:(UIView *)cell
                           section:(NSInteger)section
                            column:(NSInteger)col {
}

//为表格视图创建一个Label标签     右侧表里面的内容
- (UIView *)tableView:(EWMultiColumnTableView *)tableView
     cellForIndexPath:(NSIndexPath *)indexPath
               column:(NSInteger)col {
  UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 44.0f)];
  l.numberOfLines = 0;
  l.textAlignment = NSTextAlignmentCenter;
  l.lineBreakMode = NSLineBreakByWordWrapping;
  //  l.backgroundColor = [UIColor grayColor];
  return l;
}

//为Cell中的Label标签赋值
- (void)tableView:(EWMultiColumnTableView *)tableView
setContentForCell:(UIView *)cell
        indexPath:(NSIndexPath *)indexPath
           column:(NSInteger)col {
  UILabel *l = (UILabel *)cell;
  l.text = sttr;
  CGRect f = l.frame;
  f.size.width = [self tableView:tableView widthForColumn:col];
  l.font = [UIFont systemFontOfSize:15];
  l.frame = f;
}

//数据区的高度
- (CGFloat)tableView:(EWMultiColumnTableView *)tableView
    heightForCellAtIndexPath:(NSIndexPath *)indexPath
                      column:(NSInteger)column {
  return 44.0f;
}

//设置数据区Cell的宽度
- (CGFloat)tableView:(EWMultiColumnTableView *)tableView widthForColumn:(NSInteger)column {
  return 80;
}

//设置数据区分区的列数
- (NSInteger)numberOfColumnsInTableView:(EWMultiColumnTableView *)tableView {
  return numberOfColumns;
}

#pragma mark Header Cell

//为数据区左侧的Cell添加一个Label
- (UIView *)tableView:(EWMultiColumnTableView *)tableView
    headerCellForIndexPath:(NSIndexPath *)indexPath {
  return [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 40.0f)];
}
//为数据区左侧的Cell的Label赋值
- (void)tableView:(EWMultiColumnTableView *)tableView
    setContentForHeaderCell:(UIView *)cell
                atIndexPath:(NSIndexPath *)indexPath {
}

//设置左侧Cell的高度 为了保证左右的高度一致，所以在左侧与右侧相比较时，取最大值
- (CGFloat)tableView:(EWMultiColumnTableView *)tableView
    heightForHeaderCellAtIndexPath:(NSIndexPath *)indexPath {
  return 40.0f;
}

//设置数据分区标题Cell的高度
- (CGFloat)tableView:(EWMultiColumnTableView *)tableView
    heightForSectionHeaderCellAtSection:(NSInteger)section
                                 column:(NSInteger)col {
  return 0.0f;
}

//为数据分区标题添加一个Label
- (UIView *)tableView:(EWMultiColumnTableView *)tableView
    headerCellInSectionHeaderForSection:(NSInteger)section {
  UILabel *l =
      [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [self widthForHeaderCellOfTableView:tableView], 0.0f)];
  //    l.backgroundColor = [UIColor orangeColor];
  return l;
}

//为Label的标题赋值
- (void)tableView:(EWMultiColumnTableView *)tableView
    setContentForHeaderCellInSectionHeader:(UIView *)cell
                                 AtSection:(NSInteger)section {
  //    UILabel *l = (UILabel *)cell;
  //    l.text = [NSString stringWithFormat:@"Section %ld", (long)section];
}

/*左侧头部标题的宽度*/
- (CGFloat)widthForHeaderCellOfTableView:(EWMultiColumnTableView *)tableView {
  return 50.0f;
}

/*为右侧头部标题赋值*/
- (UIView *)tableView:(EWMultiColumnTableView *)tableView headerCellForColumn:(NSInteger)col {
  UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80, 36.0f)];
  //    l.text = [NSString stringWithFormat:@"999Column: %d", col];
  l.text = array[col];
  l.backgroundColor = [Globle colorFromHexRGB:@"e1e3e8"];
  l.font = [UIFont systemFontOfSize:15];
  l.textAlignment = NSTextAlignmentCenter;
  l.userInteractionEnabled = YES;

  l.tag = col;
  UITapGestureRecognizer *recognizer =
      [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
  recognizer.numberOfTapsRequired = 2;
  [l addGestureRecognizer:recognizer];

  return l;
}

/*为左侧头部标签赋值*/
- (UIView *)topleftHeaderCellOfTableView:(EWMultiColumnTableView *)tableView {
  //    UILabel *l =  [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 250.0f, [self
  //    heightForHeaderCellOfTableView:tableView])] ;
  UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, colWidth, 36)];
  l.backgroundColor = [Globle colorFromHexRGB:@"e1e3e8"];
  l.text = @"撤单";
  l.font = [UIFont systemFontOfSize:15];
  l.textAlignment = NSTextAlignmentCenter;
  return l;
}

/*总头部的高度*/
- (CGFloat)heightForHeaderCellOfTableView:(EWMultiColumnTableView *)tableView {
  return 36.0f;
}

- (void)tableView:(EWMultiColumnTableView *)tableView
 swapDataOfColumn:(NSInteger)col1
        andColumn:(NSInteger)col2 {
  for (int i = 0; i < [self numberOfSectionsInTableView:tableView]; i++) {
    NSMutableArray *section = [data objectAtIndex:i];
    for (int j = 0; j < [self tableView:tableView numberOfRowsInSection:i]; j++) {
      NSMutableArray *a = [section objectAtIndex:j];
      id tmp = [a objectAtIndex:col2];

      [a replaceObjectAtIndex:col2 withObject:[a objectAtIndex:col1]];
      [a replaceObjectAtIndex:col1 withObject:tmp];
    }
  }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
  NSInteger col = [recognizer.view tag];
  for (NSMutableArray *arrayItem in sectionHeaderData) {
    [arrayItem removeObjectAtIndex:col];
  }

  for (NSMutableArray *section in data) {
    for (NSMutableArray *row in section) {
      [row removeObjectAtIndex:col];
    }
  }

  numberOfColumns--;

  [tbView reloadData];
}

@end
