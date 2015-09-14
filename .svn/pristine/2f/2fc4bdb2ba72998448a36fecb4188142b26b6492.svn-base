//
//  ApplyActulTradingDayView.h
//  SimuStock
//
//  Created by jhss_wyz on 15/4/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyActulTradingDayView : UIView

/** 顶部标题视图 */
@property(weak, nonatomic) IBOutlet UIView *topView;
/** 顶部左侧标题 */
@property(weak, nonatomic) IBOutlet UILabel *topLeftTitleLable;
/** 顶部右侧标题 */
@property(weak, nonatomic) IBOutlet UILabel *topRightTitleLable;

/**
 存储从左至右，从上至下的所有选项按钮
 @[self.btn_one, self.btn_two, self.btn_three, self.btn_four, self.btn_five,
 self.btn_six, self.btn_seven, self.btn_eight];
 */
@property(strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArrays;

/** 第一个选项按钮（从左至右，从上至下） */
@property(weak, nonatomic) IBOutlet UIButton *btnOne;
/** 第二个选项按钮（从左至右，从上至下） */
@property(weak, nonatomic) IBOutlet UIButton *btnTwo;
/** 第三个选项按钮（从左至右，从上至下） */
@property(weak, nonatomic) IBOutlet UIButton *btnThree;
/** 第四个选项按钮（从左至右，从上至下） */
@property(weak, nonatomic) IBOutlet UIButton *btnFour;
/** 第五个选项按钮（从左至右，从上至下） */
@property(weak, nonatomic) IBOutlet UIButton *btnFive;
/** 第六个选项按钮（从左至右，从上至下） */
@property(weak, nonatomic) IBOutlet UIButton *btnSix;
/** 第七个选项按钮（从左至右，从上至下） */
@property(weak, nonatomic) IBOutlet UIButton *btnSeven;
/** 第八个选项按钮（从左至右，从上至下） */
@property(weak, nonatomic) IBOutlet UIButton *btnEight;

/** 当前选中的选项按钮 */
@property(weak, nonatomic) UIButton *selectedBtn;
/** 当前选中按钮上添加的对勾图片 */
@property(strong, nonatomic) UIButton *selectedImage;

/** 按钮文字 */
@property(copy, nonatomic) NSArray *infoArray;

/** 通过ApplyActulTradingDayView.xib创建选项视图 */
+ (ApplyActulTradingDayView *)applyActulTradingDayView;

/** 选项按钮响应函数 */
- (void)refreshSelectButtons;

/** 设置选中的选项按钮上的对勾位置 */
- (void)setupCheckmarkImage;

@end
