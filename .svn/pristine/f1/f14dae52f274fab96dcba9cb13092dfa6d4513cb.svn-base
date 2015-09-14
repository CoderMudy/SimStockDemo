//
//  MarketHomeViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-7-7.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MarketHomeViewController.h"


=======
      if (indexPath.section == 3 || indexPath.section == 4) {
        cell.curPriceLab.textColor = [StockUtil getColorByFloat:value];
        cell.dataPerLab.textColor = [StockUtil getColorByFloat:value];
      } else {
        cell.curPriceLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
        cell.dataPerLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
      }

      cell.dataPerLab.text = dataPer;
      NSString *stockcode = [NSString
          stringWithFormat:@"%lld", [[dic objectForKey:@"code"] longLongValue]];
      if (stockcode.length == 8) {
        stockcode = [stockcode substringFromIndex:2];
      }
      cell.codeLab.text = stockcode;
    }

  } break;
  case 7: {
    cell.upLineView.hidden = NO;
    cell.downLineView.hidden = NO;
    if (indexPath.row == 0) {
      cell.latestStockView.hidden = NO;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.upLineView.frame =
          CGRectMake(0.0, 30.0 - 1.0, tableView.bounds.size.width, 0.5);
      cell.downLineView.frame =
          CGRectMake(0.0, 30.0 - 0.5, tableView.bounds.size.width, 0.5);
      break;
    } else {
      //取消选中效果
      UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
      cell.selectedBackgroundView = backView;

      cell.selectedBackgroundView.backgroundColor =
          [Globle colorFromHexRGB:@"#e8e8e8"];
      cell.selectionStyle = UITableViewCellSelectionStyleGray;
      cell.nameLab.hidden = NO;
      cell.curPriceLab.hidden = NO;
      cell.dataPerLab.hidden = NO;
      cell.codeLab.hidden = NO;
      cell.upLineView.frame =
          CGRectMake(0.0, 45.0 - 1.0, cell.bounds.size.width, 0.5);
      cell.downLineView.frame =
          CGRectMake(0.0, 45.0 - 0.5, cell.bounds.size.width, 0.5);
    }
    PaketTableData *m_paketTableData = nil;
    if (7 == indexPath.section) {
      m_paketTableData = [dataDic objectForKey:@"newstock"];
    }
    if (!m_paketTableData) {
      break;
    }
    if ((indexPath.row - 1) <= [m_paketTableData.tableItemDataArray count]) {
      NSMutableDictionary *dic =
          [m_paketTableData.tableItemDataArray objectAtIndex:indexPath.row - 1];
      cell.nameLab.text = [SimuUtil changeIDtoStr:[dic objectForKey:@"name"]];

      int64_t curlong = [[dic objectForKey:@"issueShare"] longLongValue];
      NSInteger curlFloat = curlong / 10000;
      NSString *curPrice = [NSString stringWithFormat:@"%ld", (long)curlFloat];
      cell.curPriceLab.text = curPrice;
      cell.dataPerLab.text =
          [SimuUtil changeIDtoStr:[dic objectForKey:@"applyDate"]];
      NSString *stockcode = [NSString
          stringWithFormat:@"%lld", [[dic objectForKey:@"code"] longLongValue]];
      if (stockcode.length == 8) {
        stockcode = [stockcode substringFromIndex:2];
      }
      cell.codeLab.text = stockcode;

      cell.curPriceLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
      cell.dataPerLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    }

  } break;

  default:
    break;
  }
  cell.delegate = self;
  return cell;
}
// uitable的选择方法
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  PaketTableData *m_paketTableData = nil;
  if (3 == indexPath.section) {
    m_paketTableData = [dataDic objectForKey:@"zdup"];
  } else if (4 == indexPath.section) {
    m_paketTableData = [dataDic objectForKey:@"zddown"];
  } else if (5 == indexPath.section) {
    m_paketTableData = [dataDic objectForKey:@"hs"];
  } else if (6 == indexPath.section) {
    m_paketTableData = [dataDic objectForKey:@"zf"];
  } else if (7 == indexPath.section) {
    if (indexPath.row == 0) {
      return;
    }
    m_paketTableData = [dataDic objectForKey:@"newstock"];
  }
  if (!m_paketTableData) {
    return;
  }
>>>>>>> .merge-right.r23851


@implementation MarketHomeViewController


<<<<<<< .working
=======
#pragma mark--------MarketHomeTableViewCellDelegate--------
- (void)bidButtonMarketHomeCallbackMethod:(NSInteger)tag
                                  section:(NSInteger)section
                                      row:(NSInteger)row {
  if (0 == section) {
    PaketTableData *m_paketTableData = [dataDic objectForKey:@"exponent"];
>>>>>>> .merge-right.r23851

<<<<<<< .working
=======
    if (!m_paketTableData) {
      return;
    }
    [self showStockArray:m_paketTableData.tableItemDataArray withIndex:tag - 6400];
  } else {
    PaketTableData *m_paketTableData = nil;
    if (1 == section) {
      m_paketTableData = [dataDic objectForKey:@"industry"];
    } else if (2 == section) {
      m_paketTableData = [dataDic objectForKey:@"notion"];
    }
    if (!m_paketTableData) {
      return;
    }
    NSMutableDictionary *dic =
        [m_paketTableData.tableItemDataArray objectAtIndex:(tag - 6400)];
    NSString *stockname = [SimuUtil changeIDtoStr:[dic objectForKey:@"name"]];
    NSString *stockcode =
        [NSString stringWithFormat:@"%@", [dic objectForKey:@"code"]];
    MarketListViewController *marketListVC =
        [[MarketListViewController alloc] initIndustryNotionCode:stockcode
                                          withIndustryNotionName:stockname];
    //切换
    [AppDelegate pushViewControllerFromRight:marketListVC];
  }
}
>>>>>>> .merge-right.r23851











<<<<<<< .working
=======
  if ([dataDic count] > 0) {
    [dataDic removeAllObjects];
    [markrtTableView reloadData];
  }
  for (PaketTableData *m_paketTableData in obj.dataArray) {
    [dataDic setObject:m_paketTableData forKey:m_paketTableData.tableName];
  }
  if ([dataDic count] > 0) {
    markrtTableView.hidden = NO;
  }
  [markrtTableView reloadData];
  markrtTableView.contentOffset=CGPointMake(0, contentOffsetY);
//  [markrtTableView scrollRectToVisible:CGRectMake(0, contentOffsetY,
//                                                  self.view.bounds.size.width,
//                                                  self.view.bounds.size.height)
//                              animated:NO];
  if (manualRefresh) {
    [NewShowLabel setMessageContent:@"行情更新成功"];
  }
}
>>>>>>> .merge-right.r23851





#pragma mark


#pragma mark
<<<<<<< .working
=======
#pragma mark 定时器相关函数
//创建定时器
- (void)initTrendTimer {
  //得到刷新数据
  self.refreshTime = [SimuUtil getCorRefreshTime];
  if (self.refreshTime == 0) {
    [self stopMyTimer];
    return;
  }
  timeinterval = self.refreshTime;
  if (iKLTimer != nil) {
    if ([iKLTimer isValid]) {
      [iKLTimer invalidate];
    }
  }
  iKLTimer =
      [NSTimer scheduledTimerWithTimeInterval:timeinterval
                                       target:self
                                     selector:@selector(KLineHandleTimer:)
                                     userInfo:nil
                                      repeats:YES];
}
//定时器回调函数
- (void)KLineHandleTimer:(NSTimer *)theTimer {
  if (self.refreshTime != [SimuUtil getCorRefreshTime]) {
    [self initTrendTimer];
  }
  if (iKLTimer == theTimer) {
    //如果无网络，则什么也不做；
    if (![SimuUtil isExistNetwork]) {
      return;
    }
    //如果当前交易所状态为闭市，则什么也不做
    if ([[SimuTradeStatus instance] getExchangeStatus] == TradeClosed) {
      return;
    }
>>>>>>> .merge-right.r23851





@end
