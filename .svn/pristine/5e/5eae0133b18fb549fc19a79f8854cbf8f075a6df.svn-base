//
//  CompetionKeyBoardView.h
//  SimuStock
//
//  Created by moulin wang on 14-7-15.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
//自定义键盘协议
@protocol CompetionKeyBoardViewDelegate <NSObject>

//数字按钮点击
- (void)keyButtonDown:(UIButton *)index;
//字母按钮点击
- (void)keyButtonCharDown:(UIButton *)index;

@end
/*
 *类说明：自己定义的键盘
 */
@interface CompetionKeyBoardView : UIView {
  //数字键盘承载视图
  UIView *skbv_NumberKeyBaseView;
  //字母键盘承载视图
  UIView *skbv_charKeyBaseView;
  //当前大小写键是否在大写状态
  BOOL skbv_siShiftDown;
}
@property(weak, nonatomic) id<CompetionKeyBoardViewDelegate> delegate;
@property(assign, nonatomic) BOOL siShiftDown;
@end
