//
//  Globle.h
//  SlideSwitchDemo
//
//  Created by liulian on 13-4-23.
//  Copyright (c) 2013年 liulian. All rights reserved.
//

#import <Foundation/Foundation.h>

//涨红跌绿
#define color_positive_rate @"ca332a"
#define color_negative_rate @"5a8a02"
#define color_zero_rate @"939393"

//定义字符串转换颜色，失败后的返回默认颜色
#define DEFAULT_VOID_COLOR [UIColor blackColor]

@protocol ScrollToTopVC <NSObject>

/**
 *  是否支持点击状态栏，返回顶部
 *
 *  @param scrollsToTop BOOL 支持=YES
 */
- (void)enableScrollsToTop:(BOOL)scrollsToTop;

@end

///传递的回调函数
typedef void (^CallBackAction)();

/**
 点击返回按钮的回调函数
 */
typedef void (^onBackButtonPressed)();

typedef struct SelectedItem {
  NSInteger row;
  NSInteger section;
} SelectedRow;

/** 排序的顺序*/
typedef NS_ENUM(NSUInteger, ListOrder) {
  /** 原本顺序*/
  ListOrderNatural = 0,
  /** 从大到小*/
  ListOrderDescending,
  /** 从小到大*/
  ListOrderAscending,
};

@interface Globle : NSObject

/** 从NSString转化成UIColor (#开头，16进制数转换) */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

/** 从NSString转化成UIColor，并指定透明度 (#开头，16进制数转换) */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString alpha:(CGFloat)alpha;

/** rgb 数值转化成颜色, red, green, blue在0--255之间 */
+ (UIColor *)colorWithRGB:(NSInteger)red ForGreen:(NSInteger)green ForBlue:(NSInteger)blue;
@end
