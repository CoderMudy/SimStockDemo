//
//  CustomizeNumberKeyBoard.h
//  SimuStock
//
//  Created by jhss on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define keyboard_width (self.frame.size.width - 26) / 4
#define keyboard_height (self.frame.size.height - 60 - 5) / 3

//自定义键盘协议
@protocol customizeNumKeyBoardDelegate <NSObject>

//数字按钮点击
//- (void)keyButtonDown:(UIButton *)index;
@required

- (void)selectRandomMethod:(NSString *)theValue;

@end
/*
 *类说明：自定义的键盘
 */
@interface CustomizeNumberKeyBoard : UIView {
  //数字键盘承载视图
  UIView *numberKeyBaseView;
}
@property(weak, nonatomic) id<customizeNumKeyBoardDelegate> delegate;

@end
