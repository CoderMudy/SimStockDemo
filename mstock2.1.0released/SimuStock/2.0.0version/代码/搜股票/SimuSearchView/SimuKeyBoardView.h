//
//  SimuKeyBoardView.h
//  SimuStock
//
//  Created by Mac on 13-9-14.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
//自定义键盘协议
@protocol SimuKeyBoardViewDelegate <NSObject>

//数字按钮点击
- (void)keyButtonDown:(UIButton *)index;
//字母按钮点击
- (void)keyButtonCharDown:(UIButton *)index;

@end
/*
 *类说明：自己定义的键盘
 */
@interface SimuKeyBoardView : UIView {
  //数字键盘承载视图
  UIView *skbv_NumberKeyBaseView;
  //字母键盘承载视图
  UIView *skbv_charKeyBaseView;
  //当前大小写键是否在大写状态
  BOOL skbv_siShiftDown;
}

@property(weak, nonatomic) id<SimuKeyBoardViewDelegate> delegate;
@property(assign, nonatomic) BOOL siShiftDown;

@end
