//
//  realTradTransCell.h
//  SimuStock
//
//  Created by Mac on 14-9-23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealTradeFundTransferHistory.h"
/*
 *类说明：转账流水表格的cell
 */
@interface realTradTransCell : UITableViewCell {
  //时间（年）
  UILabel *rttc_yearTimeLable;
  //时间（当前时间）
  UILabel *rttc_CorTimeLable;
  //银行
  UILabel *rttc_bankLable;
  //金额
  UILabel *rttc_AtoumLable;
  //转账方向
  UILabel *rttc_TransferLable;
  //状态
  UILabel *rttc_StateLable;
  // cell 高度
  float rttc_cellHeight;
}
//重新设置数据
- (void)resetData:(RealTradeFundTransferHistoryItem *)Item;

@end
