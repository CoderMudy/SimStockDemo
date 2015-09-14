//
//  SelectMatchTypeTipView.h
//  SimuStock
//
//  Created by jhss on 15/8/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuBlockDefine.h"

@class SimuMatchUsesData;

typedef void (^SelectMatchUsesBlock)(NSString *matchUse);
@interface SelectMatchTypeTipView : UIView <UITableViewDelegate, UITableViewDataSource>
/** 选择比赛用途的回调Block */
@property(copy, nonatomic) SelectMatchPurposeBlock selectMatchUseBlock;
/** 弹框消失回调Block */
@property(copy, nonatomic) CallBackBlock cancelBlock;
/** 比赛用途数据 */
@property(strong, nonatomic) SimuMatchUsesData *matchData;
@property(weak, nonatomic) IBOutlet UITableView *selectMatchUseTableView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *matchUseTipViewHeight;

+ (void)showTipWithMatchUseData:(SimuMatchUsesData *)matchData
                 withSelectBlock:(SelectMatchPurposeBlock)selectBlock
                withCancelBlock:(CallBackBlock)cancelBlock;
@end
