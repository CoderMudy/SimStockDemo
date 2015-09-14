//
//  InputTextFieldView.h
//  SimuStock
//
//  Created by jhss_wyz on 15/4/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, InputTextFieldType) {
  /** 整数 */
  INPUTE_TYPE_INTEGER_NUMBER,
  /** 小数 */
  INPUTE_TYPE_DECIMAL_NUMBER,
};

typedef void (^changeTextBlock)(NSString *textStr, BOOL isChanged);
typedef void (^endEditingBlock)(NSString *textStr);

@interface InputTextFieldView : UIView

/** 输入框 */
@property(weak, nonatomic) UITextField *inputTextField;
/** 输入框的类型 */
@property(assign, nonatomic) InputTextFieldType inputType;
/** 保留小数的位数 */
@property(assign, nonatomic) int numberOfDecimalPlaces;
/** 允许输入数字的位数（整数）*/
@property(assign, nonatomic) int numberOfIntegerPlaces;

/** 当用户输入时，输入框输入的字符回调处理Block */
@property(copy, nonatomic) changeTextBlock changeTextBlock;
/** 结束编辑时调用的Block */
@property(copy, nonatomic) endEditingBlock endEditingBlock;

#pragma mark 类方法

+ (instancetype)inputTextFieldViewWithType:(InputTextFieldType)type;

/**
 changeBlock中参数：textStr：当前输入框中的字符串（包含此次输入的字符串）
 */
+ (instancetype)inputTextFieldViewWithType:(InputTextFieldType)type
                        andChangeTextBlock:(changeTextBlock)changeTextBlock;

/**
 endEditingBlock中参数：textStr：结束编辑后输入框中的字符串
 */
+ (instancetype)inputTextFieldViewWithType:(InputTextFieldType)type
                        andEndEditingBlock:(endEditingBlock)endEditingBlock;

/**
 changeBlock中参数：textStr：当前输入框中的字符串（包含此次输入的字符串）
 endEditingBlock中参数：textStr：结束编辑后输入框中的字符串
 */
+ (instancetype)inputTextFieldViewWithType:(InputTextFieldType)type
                        andChangeTextBlock:(changeTextBlock)changeTextBlock
                        andEndEditingBlock:(endEditingBlock)endEditingBlock;

@end
