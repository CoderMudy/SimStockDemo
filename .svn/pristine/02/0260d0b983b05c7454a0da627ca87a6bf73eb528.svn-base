//
//  AwardsRankingView.h
//  SimuStock
//
//  Created by 刘小龙 on 15/8/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomDividingLineView.h"

@interface AwardsRankingView : UIView <UITextFieldDelegate>
/** 第几名 */
@property(weak, nonatomic) IBOutlet UILabel *rankingLabel;
/** 奖品输入框 */
@property(weak, nonatomic) IBOutlet UITextField *awardsTextField;

@property (weak, nonatomic) IBOutlet BottomDividingLineView *line;

/** 对外提供的 初始化 */
+ (AwardsRankingView *)showAwardsRankingView;

/** 收键盘 */
-(void)rankingReceiveKeyboard;
@end
