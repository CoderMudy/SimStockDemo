//
//  WeiBoToolTip.h
//  SimuStock
//
//  Created by Yuemeng on 15/1/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExchangeDiamondView;

typedef void (^sureButtonClickBlock)();
typedef void (^cancleButtonClickBlock)();
typedef void (^finishButtonClickBlock)(NSString *);
typedef void (^sureButtonClickBlockWithDiamond)(NSString *);

typedef NS_ENUM(NSUInteger, WeiboToolTipStyle) {
  WeiboToolTipStyleMakeSure,                 //确认框
  WeiboToolTipStyleMakeSureWithContent,      //带内容确认框
  WeiboToolTipStyleInputView,                //输入框
  WeiboToolTipStyleMakeSureWithLargeContent, //带较多内容确认框
  WeiboToolTipStyleExchangeDiamond,          //兑换钻石
  WeiboToolTipStyleWithdrawIntroduction,     //说明框
};

/** 微博提示框类 */
@interface WeiboToolTip : UIView <UITextViewDelegate> {
  ///蓝色分割线（可选）
  UIView *_blueLine;
  ///输入框（可选）
  UITextView *_textView;
  ///返回或取消（根据样式区分）
  UIButton *_cancelButton;
  ///完成或确定（根据样式区分）
  UIButton *_sureButton;
  ///输入框默认替换符
  NSString *_placeHolder;
  ///当前类型
  WeiboToolTipStyle _style;
  ///确定按钮标题
  NSString *_sureButtonTitle;
  ///确定按钮标题
  NSString *_cancelButtonTitle;
  ///⭐️主窗体 494*328
  UIView *_windowView;
  //钻石页面
  ExchangeDiamondView *_diamondView;
}

/** 输入框默认字符 */
//@property (nonatomic,copy) NSString *placeHolder;

/** 确定按钮回调 */
@property(nonatomic, copy) sureButtonClickBlock sureButtonClickBlock;
/** 取消按钮回调 */
@property(nonatomic, copy) cancleButtonClickBlock cancleButtonClickBlock;
/** 完成按钮回调 */
@property(nonatomic, copy) finishButtonClickBlock finishButtonClickBlock;
/** 确定按钮回调，且返回钻石数量 */
@property(nonatomic, copy)
    sureButtonClickBlockWithDiamond sureButtonClickBlockWithDiamond;
/** 确认框 */
+ (void)showMakeSureWithTitle:(NSString *)title
                    sureblock:(sureButtonClickBlock)sureblock;
/** 带内容确认框 */
+ (void)showMakeSureWithTitle:(NSString *)title
                      content:(NSString *)content
                    sureblock:(sureButtonClickBlock)sureblock;

/** 带较多内容，指定确定按钮内容的确认框 */
+ (void)showMakeSureWithTitle:(NSString *)title
                 largeContent:(NSString *)content
                  lineSpacing:(CGFloat)lineSpacing
            contentTopSpacing:(CGFloat)contentTopSpacing
         contentBottomSpacing:(CGFloat)contentBottomSpacing
              sureButtonTitle:(NSString *)sureButtonTitle
            cancelButtonTitle:(NSString *)cancelButtonTitle
                    sureblock:(sureButtonClickBlock)sureblock
                  cancleblock:(cancleButtonClickBlock)cancleblock;

/** 带内容，指定确定按钮内容的确认框 */
+ (void)showMakeSureWithTitle:(NSString *)title
                      content:(NSString *)content
              sureButtonTitle:(NSString *)sureButtonTitle
                    sureblock:(sureButtonClickBlock)sureblock;

/** 带内容，指定确定按钮内容的确认框 */
+ (void)showMakeSureWithTitle:(NSString *)title
                      content:(NSString *)content
              sureButtonTitle:(NSString *)sureButtonTitle
                    sureblock:(sureButtonClickBlock)sureblock
                  cancleblock:(cancleButtonClickBlock)cancleblock;

/** 输入框 */
+ (void)showInputViewWithTitle:(NSString *)title
                   placeholder:(NSString *)placeholder
                   finishblock:(finishButtonClickBlock)finishblock;

/** 指定内容View的提示框 */
//+ (void)showMakeSureWithTitle:(NSString *)title
//                  contentView:(UIView *)contentView
//                    sureblock:(sureButtonClickBlock)sureblock;

/** 兑换钻石 */
+ (void)showExchangeDiamondViewWithRatio:(NSString *)ratio
                                maxValue:(NSString *)maxValue
                               Sureblock:
                                   (sureButtonClickBlockWithDiamond)sureblock;

/** 说明框，仅有一个确定 */
+ (void)showWithdrawIntroduction;
@end
