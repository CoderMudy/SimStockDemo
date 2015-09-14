//
//  SelectMatchInitialFundTipView.h
//  SimuStock
//
//  Created by jhss_wyz on 15/8/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuBlockDefine.h"

@class SimuMatchTemplateData;

@interface SelectMatchInitialFundTipView : UIView <UITableViewDelegate, UITableViewDataSource>
/** 比赛模版（比赛初始资金） */
@property(copy, nonatomic) NSString *templateId;
/** 当前用户拥有的金币数 */
@property(assign, nonatomic) NSInteger goldCoinNum;
/** 选择比赛初始资金的回调Block */
@property(copy, nonatomic) SelectMatchInitialFundBlock selectBlock;
/** 弹框消失回调Block */
@property(copy, nonatomic) CallBackBlock cancelBlock;
/** 初始资金选择tableView */
@property(weak, nonatomic) IBOutlet UITableView *initialFundSelectTableView;
/** 提示框的宽度 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewHeight;

/** 比赛模版数据 */
@property(strong, nonatomic) SimuMatchTemplateData *matchData;

+ (void)showTipWithOwnGoldCoinNum:(NSInteger)ownNum
                        matchData:(SimuMatchTemplateData *)matchData
                  withSelectBlock:(SelectMatchInitialFundBlock)selectBlock
                  withCancelBlock:(CallBackBlock)cancelBlock;

@end
