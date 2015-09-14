//
//  ContestAwardsView.h
//  SimuStock
//
//  Created by 刘小龙 on 15/8/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomDividingLineView.h"
@class ContestAwardsView;
/** 删除按钮 的block */
typedef void (^DeleteButtonDown)(ContestAwardsView *);

@interface ContestAwardsView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet BottomDividingLineView *line;

@property(weak, nonatomic) IBOutlet UIButton *deleteButton;
@property(weak, nonatomic) IBOutlet UITextField *awardsTextField;
@property(weak, nonatomic) IBOutlet UILabel *rankingLabel;
/** 删除按钮 的block */
@property(copy, nonatomic) DeleteButtonDown deleteButtonDownBlock;
/** 对外初始化 */
+ (ContestAwardsView *)showContestAwardsView;
/** 收键盘 */
-(void)contestReceiveKeyboard;

@end
