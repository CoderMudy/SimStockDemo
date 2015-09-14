//
//  FTCoreTextView.h
//  FTCoreText
//
//  Copyright 2011 Fuerte International. All rights reserved.
//

/*
 * @warning The source text has to contain every new line sequence '\n'
 *required.
 *
 * If you don't provide an attributed string when initializing the view, the
 *-text property is parsed
 * to create the attributed string that will be drawn. You can cache the
 *-attributedString property
 * (as long as you've set the -text property) for a later reuse therefore
 *avoiding to parse again
 * the source text.
 *
 * If the -text property is nil though, adding new FTCoreTextStyles styles will
 *have no effect.
 *
 */

#import <UIKit/UIKit.h>
#import "FTCoreTextStyle.h"
#import "Globle.h"

/* These constants are default tag names recognised by FTCoreTextView */
/* 文本类型 */
extern NSString *const FTCoreTextTagDefault; // It is the default applied to the
                                             // whole text. Markups is not
                                             // needed on the source text
extern NSString
    *const FTCoreTextTagImage; // Define style for images. Respond to markup
// <_image>imageNameInMainBundle.extension</_image> in the
// source text.
extern NSString *const
    FTCoreTextTagPage; // Divide the text in pages. Respond to markup <_page/>
extern NSString *const FTCoreTextTagLink; // Define style for links. Respond to
                                          // markup <_link>link URL|link
                                          // replacement name</_link>

/* These constants are used in the dictionary argument of the delegate method
 * -coreTextView:receivedTouchOnData: */

extern NSString *const FTCoreTextDataURL;
extern NSString *const FTCoreTextDataName;
extern NSString *const FTCoreTextDataFrame;
extern NSString *const FTCoreTextDataAttributes;

static const CGFloat FTCoreTextViewDefaultLineHeightMultiple = 1.3f;

@interface FTCoreTextView : UIView {
  NSMutableDictionary *_styles;
  NSMutableDictionary *_defaultsTags;
  struct {
    unsigned int textChangesMade : 1;
    unsigned int updatedAttrString : 1;
    unsigned int updatedFramesetter : 1;
  } _coreTextViewFlags;
}

@property(nonatomic) NSString *text;
@property(nonatomic) NSString *processedString;
@property(nonatomic, readonly) NSAttributedString *attributedString;
@property(nonatomic, assign) CGPathRef path;
@property(nonatomic) NSMutableDictionary *URLs;
@property(retain, nonatomic) NSMutableArray *images;

// shadow is not yet part of a style. It's applied on the whole view
@property(nonatomic) UIColor *shadowColor;
@property(nonatomic) CGSize shadowOffset;
@property(nonatomic) BOOL highlightTouch; // defaut YES;
@property(nonatomic) int numberOfLines;   // defaut 0;
@property(nonatomic) CGFloat
    lineHeightMultiple; // defaut FTCoreTextViewDefaultLineHeightMultiple;

/** touch事件完成后，通知父容器 */
@property(nonatomic, copy) CallBackAction endTouchAction;
/** touch事件开始后，通知父容器 */
@property(nonatomic, copy) CallBackAction beginTouchAction;

/* Using this method, you then have to set the -text property to get any result
 */
- (id)initWithFrame:(CGRect)frame;

- (id)initWithFrame:(CGRect)frame
andAttributedString:(NSAttributedString *)attributedString;

/* Using one of the FTCoreTextTag constants defined you can change a default tag
 * to a new one.
 * Example: you can call [coretTextView changeDefaultTag:FTCoreTextTagBullet
 * toTag:@"li"] to
 * make the view regonize <li>...</li> tags as bullet points */
- (void)changeDefaultTag:(NSString *)coreTextTag
                   toTag:(NSString *)newDefaultTag;

- (void)addStyle:(FTCoreTextStyle *)style;
- (void)addStyles:(NSArray *)styles;

- (NSArray *)styles;
- (FTCoreTextStyle *)styleForName:(NSString *)tagName;

/** 用于数据绑定时计算好内容需要的高度 */
+ (CGFloat)heightWithText:(NSString *)text
                    width:(CGFloat)width
                     font:(float)font;

- (CGSize)suggestedSizeConstrainedToSize:(CGSize)size;
- (void)fitToSuggestedHeight;
- (void)fitToSuggestedHeight:(NSLayoutConstraint*)cons;

/** 修改字体大小，调用此方法后，需要调用fitToSuggestedHeight等方法重置高度 */
- (void)setTextSize:(float)textSize;
/** 黑体专用 */
- (void)setBoldTextSize:(float)textSize;
/** 修改字体颜色 */
- (void)setTextColor:(UIColor *)color;
/** 修改行间距，单位：行距的倍数 */
- (void)setLineHeightMultiple:(CGFloat)lineHeightMultiple;
/** 修改最大显示行数，0表示显示所有行 */
- (void)setNumberOfLines:(int)numberOfLines;

/**
 * 当长按FTCoreTextView的可点击部分时，需要触发点击链接事件，返回YES，表示触发点击事件，返回NO，表示不处理该事件
 */
- (BOOL)performClickOnPoint:(CGPoint)point;

- (NSString *)getVisibleFTCoreText;

@end
