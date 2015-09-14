//
//  STSegmentedControl.h
//  SimuStock
//
//  Created by Mac on 15-3-2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
  URBSegmentedControlOrientationHorizontal = 0,
  URBSegmentedControlOrientationVertical
};
typedef NSInteger URBSegmentedControlOrientation;

enum { URBSegmentViewLayoutDefault = 0, URBSegmentViewLayoutVertical };
typedef NSInteger URBSegmentViewLayout;

@interface STSegmentedControl : UISegmentedControl

typedef void (^URBSegmentedControlBlock)(NSInteger index,
                                         STSegmentedControl *segmentedControl);

@property(nonatomic) URBSegmentedControlOrientation layoutOrientation;
@property(nonatomic) URBSegmentViewLayout segmentViewLayout;

@property(nonatomic, copy) URBSegmentedControlBlock controlEventBlock;

@property(nonatomic, strong) UIColor *baseColor;
@property(nonatomic, strong) UIColor *strokeColor;
@property(nonatomic, assign) CGFloat strokeWidth;
@property(nonatomic) CGFloat cornerRadius;

///----------------------------
/// @name Segment Customization
///----------------------------

@property(nonatomic, strong)
    UIColor *segmentBackgroundColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *imageColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *selectedImageColor UI_APPEARANCE_SELECTOR;

- (id)initWithTitles:(NSArray *)titles;
- (id)initWithIcons:(NSArray *)icons;
- (id)initWithTitles:(NSArray *)titles icons:(NSArray *)icons;
- (void)insertSegmentWithTitle:(NSString *)title
                         image:(UIImage *)image
                       atIndex:(NSUInteger)segment
                      animated:(BOOL)animated;
- (void)setTextAttributes:(NSDictionary *)textAttributes
                 forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (void)setImageColor:(UIColor *)imageColor
             forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (void)setSegmentBackgroundColor:(UIColor *)segmentBackgroundColor
    UI_APPEARANCE_SELECTOR;

- (void)setControlEventBlock:(URBSegmentedControlBlock)controlEventBlock;

@end

@interface UIImage (URBSegmentedControl)

- (UIImage *)imageTintedWithColor:(UIColor *)color;

@end