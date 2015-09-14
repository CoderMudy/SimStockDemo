//
//  ExpertCell.h
//  SimuStock
//
//  Created by 刘小龙 on 15/9/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTCoreTextView.h"
#import "UIButton+Block.h"
#import "MasterTradeListWrapper.h"
#import "RoundHeadImage.h"
#import "UserGradeView.h"
#import "BottomDividingLineView.h"

/** tableviewCell */
@interface ExpertCell : UITableViewCell

/** 头像图片  */
@property(weak, nonatomic) IBOutlet RoundHeadImage *headImageView;

/** 昵称 */
@property(weak, nonatomic) IBOutlet UserGradeView *nickNameView;

/** 总盈利率值 */
@property(weak, nonatomic) IBOutlet UILabel *grossProfitRateLabel;

/** 总盈利率label的宽度 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *grossProfitRateWidth;

/** 股票信息view */
@property(weak, nonatomic) IBOutlet FTCoreTextView *coreTextView;

/** 跟买按钮  */
@property(weak, nonatomic) IBOutlet BGColorUIButton *buyButton;

@property(strong, nonatomic) ConcludesListItem *listItem;
@property(weak, nonatomic) IBOutlet UIImageView *notWorkHeadImage;

/** 股票信息 文本展示空间高度 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *coreHeight;

/** 股票信息 下面的隐藏Button  */
@property(weak, nonatomic) IBOutlet BGColorUIButton *quotationButton;

/**
 *  绑定数据的方法
 *
 *  @param item 数据模型类
 */
- (void)bindData:(ConcludesListItem *)item withCoreTextFont:(CGFloat)font;

/** 无网络的时候 设定数据显示 */
- (void)notWorkBindData;

@end
