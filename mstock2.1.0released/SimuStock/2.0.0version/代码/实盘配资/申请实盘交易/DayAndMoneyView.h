//
//  DayAndMoneyView.h
//  SimuStock
//
//  Created by Mac on 15/5/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DayAndMoneyViewButtonClickBlock)(
    NSInteger SelectedIndex, NSInteger Section); //当按钮被点击时，block返回

@interface DayAndMoneyView : UIView
/// cell
@property(nonatomic) NSInteger section;
///当前选择的位置
@property(nonatomic) NSInteger SelectedIndex;
/** 当前选中按钮上添加的对勾图片 */
@property(strong, nonatomic) UIButton *selectedImage;
/// block
@property(copy, nonatomic) DayAndMoneyViewButtonClickBlock block;

@property(copy, nonatomic) NSArray *btnArray;

- (void)addButton:(NSArray *)array;

- (void)setupCheckmarkImage:(UIButton *)selectedBtn;

///仅仅修改本View的选中态
- (void)setupCheckmarkImage2:(UIButton *)selectedBtn;

- (void)clearAllChecked;

@end
