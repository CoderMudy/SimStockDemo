//
//  WFHistoryListTableViewController.m
//  SimuStock
//
//  Created by moulin wang on 15/4/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFHistoryListTableViewController.h"
//实盘信息Cell
#import "WFHistoryFirmOfferInforCell.h"
//结算信息Cell
#import "WFSettlementInfoCell.h"
//股票信息展示Cell
#import "WFFirmPositionsCell.h"

#import "Globle.h"
//股票成交的头View
#import "HeadStockTransactionView.h"

@interface WFHistoryListTableViewController ()
/** 实盘信息Cell */
@property(strong, nonatomic)
    IBOutlet WFHistoryFirmOfferInforCell *historyFirmCell;
/** 结算信息Cell */
@property(strong, nonatomic) IBOutlet WFSettlementInfoCell *settlementInfoCell;

@end

@implementation WFHistoryListTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  switch (section) {
  case 0:
    return 1;
    break;
  case 1:
    return 1;
    break;
  case 2:
    return 5;
    break;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"cell";
  if (indexPath.section == 0 && indexPath.row == 0) {
    return self.historyFirmCell;
  } else if (indexPath.section == 1 && indexPath.row == 0) {
    return self.settlementInfoCell;
  } else {
    WFFirmPositionsCell *cell =
        [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
      cell = [[[NSBundle mainBundle] loadNibNamed:@"WFFirmPositionsCell"
                                            owner:nil
                                          options:nil] firstObject];
    }
    return cell;
  }
  return nil;
}

// UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0 || indexPath.section == 1) {
    return 187;
  } else {
    return 45;
  }
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    UIView *fistView =
        [self titleLableForHeaderInSectionWithTiltle:@"实盘信息"];
    return fistView;
  } else if (section == 1) {
    UIView *secondView =
        [self titleLableForHeaderInSectionWithTiltle:@"结算信息"];
    return secondView;
  } else if (section == 2) {
    HeadStockTransactionView *headView =
        [[[NSBundle mainBundle] loadNibNamed:@"HeadStockTransactionView"
                                       owner:nil
                                     options:nil] lastObject];
    return headView;
  }
  return nil;
}

- (UIView *)titleLableForHeaderInSectionWithTiltle:(NSString *)title {
  UIView *viewLabel = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 28)];
  viewLabel.backgroundColor = [Globle colorFromHexRGB:@"e1e3e8"];
  UILabel *label = [[UILabel alloc]
      initWithFrame:CGRectMake(18, 0, 80, CGRectGetHeight(viewLabel.bounds))];
  label.text = title;
  label.textColor = [Globle colorFromHexRGB:@"5a5a5a"];
  label.font = [UIFont systemFontOfSize:Font_Height_12_0];
  label.textAlignment = NSTextAlignmentLeft;
  label.backgroundColor = [UIColor clearColor];
  [viewLabel addSubview:label];
  return viewLabel;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  if (section == 0 || section == 1) {
    return 28;
  } else {
    return 60;
  }
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForFooterInSection:(NSInteger)section {
  return 0;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0 || indexPath.section == 1) {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath]
withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the
array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath
*)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in
-tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#>
alloc] initWithNibName:<#@"Nib name"#> bundle:nil];

    // Pass the selected object to the new view controller.

    // Push the view controller.
    [self.navigationController pushViewController:detailViewController
animated:YES];
}
*/

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
