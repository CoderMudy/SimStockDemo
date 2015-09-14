//
//  realTradTransCell.m
//  SimuStock
//
//  Created by Mac on 14-9-23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "realTradTransCell.h"
#import "SimuUtil.h"

@implementation realTradTransCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    rttc_cellHeight = 55;
    [self creatViews];
  }
  return self;
}

- (void)creatViews {
  float width = WIDTH_OF_SCREEN / 4;
  //时间 年
  rttc_yearTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(3, 12, width, 13)];
  rttc_yearTimeLable.backgroundColor = [UIColor clearColor];
  rttc_yearTimeLable.font = [UIFont systemFontOfSize:Font_Height_13_0];
  rttc_yearTimeLable.textAlignment = NSTextAlignmentCenter;
  rttc_yearTimeLable.textColor = [Globle colorFromHexRGB:Color_Table_Title];
  [self.contentView addSubview:rttc_yearTimeLable];
  //时间 当前时间
  rttc_CorTimeLable = [[UILabel alloc]
      initWithFrame:CGRectMake(3, rttc_yearTimeLable.frame.origin.y + rttc_yearTimeLable.frame.size.height + 5, width, 11)];
  rttc_CorTimeLable.backgroundColor = [UIColor clearColor];
  rttc_CorTimeLable.font = [UIFont systemFontOfSize:11];
  rttc_CorTimeLable.textAlignment = NSTextAlignmentCenter;
  rttc_CorTimeLable.textColor = [Globle colorFromHexRGB:@"#939393"];
  [self.contentView addSubview:rttc_CorTimeLable];
  //方向label
  rttc_TransferLable = [[UILabel alloc] initWithFrame:CGRectMake(3 * width, 12, width, 13)];
  rttc_TransferLable.backgroundColor = [UIColor clearColor];
  rttc_TransferLable.font = [UIFont systemFontOfSize:Font_Height_13_0];
  rttc_TransferLable.textAlignment = NSTextAlignmentCenter;
  rttc_TransferLable.textColor = [Globle colorFromHexRGB:Color_Table_Title];
  [self.contentView addSubview:rttc_TransferLable];
  //状态label
  rttc_StateLable = [[UILabel alloc]
      initWithFrame:CGRectMake(3 * width, rttc_yearTimeLable.frame.origin.y + rttc_yearTimeLable.frame.size.height + 2, width, 28)];
  rttc_StateLable.backgroundColor = [UIColor clearColor];
  rttc_StateLable.numberOfLines = 0;
  rttc_StateLable.font = [UIFont systemFontOfSize:11];
  rttc_StateLable.textAlignment = NSTextAlignmentCenter;
  rttc_StateLable.textColor = [Globle colorFromHexRGB:@"#939393"];
  [self.contentView addSubview:rttc_StateLable];

  //创建其他列数据
  for (int i = 0; i < 4; i++) {
    UILabel *lable =
        [[UILabel alloc] initWithFrame:CGRectMake((i + 1) * width, (rttc_cellHeight - 10) / 2, width, 13)];
    lable.backgroundColor = [UIColor clearColor];
    lable.font = [UIFont systemFontOfSize:Font_Height_13_0];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [Globle colorFromHexRGB:Color_Table_Title];
    [self.contentView addSubview:lable];
    if (i == 0) {
      rttc_bankLable = lable;
    } else if (i == 1) {
      rttc_AtoumLable = lable;
    }
  }
  //上
  UIView *_upLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 55 - 1.0, WIDTH_OF_SCREEN, 0.5)];
  _upLineView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  [self.contentView addSubview:_upLineView];
  //下
  UIView *_downLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 55 - 0.5, WIDTH_OF_SCREEN, 0.5)];
  _downLineView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [self.contentView addSubview:_downLineView];
}

- (void)resetData:(RealTradeFundTransferHistoryItem *)Item {

  if (!Item.date || [Item.date length] < 1) {
    rttc_CorTimeLable.origin =
        CGPointMake(rttc_CorTimeLable.origin.x, self.height / 2.0f - rttc_CorTimeLable.size.height / 2.0f);
  }
  rttc_yearTimeLable.text = Item.date;

  rttc_CorTimeLable.text = Item.time;
  rttc_bankLable.text = Item.bank;
  rttc_AtoumLable.text = Item.moneyAmount;
  rttc_TransferLable.text = Item.transferDirection;
  rttc_StateLable.text = Item.status;
}

@end
