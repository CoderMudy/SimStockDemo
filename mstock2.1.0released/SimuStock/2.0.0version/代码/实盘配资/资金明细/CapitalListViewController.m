//
//  CapitalListViewController.m
//  SimuStock
//
//  Created by Jhss on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CapitalListViewController.h"

@interface CapitalListViewController ()

@end

@implementation CapitalListViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  /** 显示 “资金明细” 并且隐藏刷新按钮 */
  [_topToolBar resetContentAndFlage:@"资金明细" Mode:TTBM_Mode_Leveltwo];
  _indicatorView.hidden = YES;
  
  /** 初始化每行左侧资金类别标题数组 */
  capitalHintArray = [[NSMutableArray alloc]
      initWithObjects:@"实盘续约：管理费", @"实盘充值：保证金",
                      @"实盘冻结：保证金", @"实盘申请：管理费",
                      nil];

   /** 创建表格 */
  [self createCapitalTableView];

  // Do any additional setup after loading the view.
}
 /** 初始化并设置表格 */
- (void)createCapitalTableView {
  self.capitalTableView = [[UITableView alloc]
      initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN,
                               HEIGHT_OF_SCREEN - topToolBarHeight)];
  self.capitalTableView.delegate = self;
  self.capitalTableView.dataSource = self;
  self.capitalTableView.scrollEnabled = NO;
  self.capitalTableView.backgroundColor =
      [Globle colorFromHexRGB:Color_BG_Common];
  self.capitalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [_clientView addSubview:self.capitalTableView];
}
#pragma mark ————————————————————UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [capitalHintArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellId = @"cell";
  MoneyDetailsCell *cell =
      (MoneyDetailsCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"MoneyDetailsCell"
                                          owner:self
                                        options:nil] lastObject];
  }

  [cell.hintLabel setupLableWithText:[capitalHintArray objectAtIndex:indexPath.row] andTextColor:[Globle colorFromHexRGB:Color_Text_Common] andTextFont:[UIFont systemFontOfSize:Font_Height_15_0] andAlignment:NSTextAlignmentLeft];
  [cell.dateLabel setupLableWithText:@"2015-2-4  13:21" andTextColor:[Globle colorFromHexRGB:Color_Gray] andTextFont:[UIFont systemFontOfSize:Font_Height_11_0] andAlignment:NSTextAlignmentRight];
  [cell.moneyLabel setupLableWithText:@"-100.00" andTextColor:[Globle colorFromHexRGB:@"#008000"] andTextFont:[UIFont systemFontOfSize:Font_Height_14_0] andAlignment:NSTextAlignmentRight];

  /** 设置cell选中后是白色 */
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.backgroundColor = [UIColor whiteColor];

  return cell;
}
  /** 返回每一个cellde高度 */
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}

/** 为tableview设置headerview  */
- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
  UIView *hearView = [[UIView alloc] init];
  hearView.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, 27);
  hearView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Table_Title];
  // 设置标题 ————“编号”
  UILabel *serialLabel = [[UILabel alloc] init];
  [serialLabel setupLableWithText:@"编号" andTextColor:[Globle colorFromHexRGB:@"#222222"] andTextFont:[UIFont systemFontOfSize:Font_Height_13_0] andAlignment:NSTextAlignmentLeft];
  
  serialLabel.frame = CGRectMake(16, 0, 100, 25);
  [hearView addSubview:serialLabel];
  //设置编号号码
  UILabel *numberLabel = [[UILabel alloc] init];
  [numberLabel setupLableWithText:@"12345678912345654" andTextColor:[Globle colorFromHexRGB:Color_Text_Details] andTextFont:[UIFont systemFontOfSize:Font_Height_13_0] andAlignment:NSTextAlignmentRight];
  numberLabel.frame = CGRectMake(160, 0, 145, 25);
  [hearView addSubview:numberLabel];

  return hearView;
}
    /** 返回headerview的高度 */
- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 27;
}



- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
