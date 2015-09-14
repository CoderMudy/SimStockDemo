//
//  FTCoreTextView.m
//  FTCoreText
//
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTCoreTextView.h"
#import <CoreText/CoreText.h>
#import "WeiboUtil.h"
#import "WeiboText.h"
#import "NSString+java.h"

#define FTCT_SYSTEM_VERSION_LESS_THAN(v)                                       \
  ([[[UIDevice currentDevice] systemVersion] compare:v                         \
                                             options:NSNumericSearch] ==       \
   NSOrderedAscending)

#pragma mark - Custom categories headers

/* Callbacks */
static void deallocCallback(void *ref) { CFRelease(ref); }
static CGFloat ascentCallback(void *ref) {
  return [(NSString *)((__bridge NSDictionary *)ref)[@"height"] floatValue];
}
static CGFloat descentCallback(void *ref) {
  return [(NSString *)((__bridge NSDictionary *)ref)[@"descent"] floatValue];
}
static CGFloat widthCallback(void *ref) {
  return [(NSString *)((__bridge NSDictionary *)ref)[@"width"] floatValue];
}

#pragma mark - FTCoreText

NSString *const FTCoreTextTagDefault = @"_default";
NSString *const FTCoreTextTagImage = @"_image";
NSString *const FTCoreTextTagBullet = @"_bullet";
NSString *const FTCoreTextTagPage = @"_page";
NSString *const FTCoreTextTagLink = @"_link";

NSString *const FTCoreTextDataURL = @"url";
NSString *const FTCoreTextDataName = @"FTCoreTextDataName";
NSString *const FTCoreTextDataFrame = @"FTCoreTextDataFrame";
NSString *const FTCoreTextDataAttributes = @"FTCoreTextDataAttributes";

@interface FTCoreTextView ()

@property(nonatomic) CTFramesetterRef framesetter;
@property(nonatomic) NSArray *textNodes;
@property(nonatomic, readwrite) NSAttributedString *attributedString;
@property(nonatomic) NSDictionary *touchedData;
@property(nonatomic) NSString *selectionRange;

CTFontRef CTFontCreateFromUIFont(UIFont *font);

- (void)updateFramesetterIfNeeded;
- (void)doInit;
- (void)didMakeChanges;
- (NSString *)defaultTagNameForKey:(NSString *)tagKey;

@end

@implementation FTCoreTextView

#pragma mark - Tools methods

CTFontRef CTFontCreateFromUIFont(UIFont *font) {
  CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName,
                                          font.pointSize, NULL);
  return ctFont;
}

#pragma mark - FTCoreTextView business
#pragma mark -

- (void)changeDefaultTag:(NSString *)coreTextTag
                   toTag:(NSString *)newDefaultTag {
  if (_defaultsTags[coreTextTag] == nil) {
    [NSException raise:NSInvalidArgumentException
                format:@"%@ is not a default tag of FTCoreTextView. Use the "
                       @"constant FTCoreTextTag constants.",
                       coreTextTag];
  } else {
    _defaultsTags[coreTextTag] = newDefaultTag;
  }
}

- (NSString *)defaultTagNameForKey:(NSString *)tagKey {
  return _defaultsTags[tagKey];
}

- (void)didMakeChanges {
  _coreTextViewFlags.updatedAttrString = NO;
  _coreTextViewFlags.updatedFramesetter = NO;
}

#pragma mark - UI related

- (NSDictionary *)dataForPoint:(CGPoint)point {
  return [self dataForPoint:point activeRects:nil];
}
/** 通过指定的点，找到对应的点击区域 */
- (NSDictionary *)dataForPoint:(CGPoint)point
                   activeRects:(NSArray **)activeRects {
  NSMutableDictionary *returnedDict = [NSMutableDictionary dictionary];

  CGMutablePathRef mainPath;
  CTFrameRef drawFrame;
  [self initPath:&mainPath frame:&drawFrame];

  NSArray *lines = (__bridge NSArray *)CTFrameGetLines(drawFrame);
  NSInteger lineCount = [lines count];
  CGPoint origins[lineCount];

  if (lineCount != 0) {

    CTFrameGetLineOrigins(drawFrame, CFRangeMake(0, 0), origins);

    for (NSUInteger i = 0; i < lineCount; i++) {
      CGPoint baselineOrigin = origins[i];
      // the view is inverted, the y origin of the baseline is upside down
      baselineOrigin.y = CGRectGetHeight(self.frame) - baselineOrigin.y;

      CTLineRef line = (__bridge CTLineRef)lines[i];
      CGFloat ascent, descent;
      CGFloat lineWidth =
          (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, NULL);

      CGRect lineFrame = CGRectMake(baselineOrigin.x, baselineOrigin.y - ascent,
                                    lineWidth, ascent + descent);

      if (CGRectContainsPoint(lineFrame, point)) {
        // we look if the position of the touch is correct on the line

        CFIndex index = CTLineGetStringIndexForPosition(line, point);

        NSArray *urlsKeys = [_URLs allKeys];

        for (NSString *key in urlsKeys) {
          NSRange range = NSRangeFromString(key);
          if (index >= range.location &&
              index < range.location + range.length) {

            returnedDict[FTCoreTextDataURL] = key;

            if (activeRects && _highlightTouch) {
              // we looks for the rects enclosing the entire active section
              NSInteger startIndex = range.location;
              NSInteger endIndex = range.location + range.length;

              // we look for the line that contains the start index
              NSUInteger startLineIndex = i;
              for (NSInteger iLine = i; iLine >= 0; iLine--) {
                CTLineRef line = (__bridge CTLineRef)lines[iLine];
                CFRange range = CTLineGetStringRange(line);
                if (range.location <= startIndex &&
                    range.location + range.length >= startIndex) {
                  startLineIndex = iLine;
                  break;
                }
              }
              // we look for the line that contains the end index
              NSInteger endLineIndex = startLineIndex;
              for (NSUInteger iLine = i; iLine < lineCount; iLine++) {
                CTLineRef line = (__bridge CTLineRef)lines[iLine];
                CFRange range = CTLineGetStringRange(line);
                if (range.location <= endIndex &&
                    range.location + range.length >= endIndex) {
                  endLineIndex = iLine;
                  break;
                }
              }
              // we get enclosing rects
              NSMutableArray *rectsStrings = [NSMutableArray new];
              for (NSUInteger iLine = startLineIndex; iLine <= endLineIndex;
                   iLine++) {
                CTLineRef line = (__bridge CTLineRef)lines[iLine];
                CGFloat ascent, descent;
                CGFloat lineWidth =
                    CTLineGetTypographicBounds(line, &ascent, &descent, NULL);

                CGPoint baselineOrigin = origins[iLine];
                // the view is inverted, the y origin of the baseline is upside
                // down
                baselineOrigin.y =
                    CGRectGetHeight(self.frame) - baselineOrigin.y;

                CGRect lineFrame =
                    CGRectMake(baselineOrigin.x, baselineOrigin.y - ascent,
                               lineWidth, ascent + descent);
                CGRect actualRect = CGRectZero;
                actualRect.size.height = lineFrame.size.height;
                actualRect.origin.y = lineFrame.origin.y;

                CFRange range = CTLineGetStringRange(line);
                if (range.location >= startIndex) {
                  // the beginning of the line is included
                  actualRect.origin.x = lineFrame.origin.x;
                } else {
                  actualRect.origin.x =
                      CTLineGetOffsetForStringIndex(line, startIndex, NULL);
                }
                NSInteger lineRangEnd = range.length + range.location;
                if (lineRangEnd <= endIndex) {
                  // the end of the line is included
                  actualRect.size.width =
                      CGRectGetMaxX(lineFrame) - CGRectGetMinX(actualRect);
                } else {
                  CGFloat position =
                      CTLineGetOffsetForStringIndex(line, endIndex, NULL);
                  actualRect.size.width = position - CGRectGetMinX(actualRect);
                }
                actualRect = CGRectInset(actualRect, -1, 0);
                [rectsStrings addObject:NSStringFromCGRect(actualRect)];
              }

              *activeRects = rectsStrings;
            }
            break;
          }
        }

        // frame
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        for (CFIndex j = 0; j < CFArrayGetCount(runs); j++) {
          CTRunRef run = CFArrayGetValueAtIndex(runs, j);
          NSDictionary *attributes =
              (__bridge NSDictionary *)CTRunGetAttributes(run);

          NSString *name = attributes[FTCoreTextDataName];
          if (![name isEqualToString:FTCoreTextTagLink])
            continue;

          returnedDict[FTCoreTextDataName] = name;
          returnedDict[FTCoreTextDataAttributes] = attributes;

          CGRect runBounds;
          runBounds.size.width = (CGFloat)CTRunGetTypographicBounds(
              run, CFRangeMake(0, 0), &ascent, &descent, NULL); // 8
          runBounds.size.height = ascent + descent;

          CGFloat xOffset = CTLineGetOffsetForStringIndex(
              line, CTRunGetStringRange(run).location, NULL); // 9
          runBounds.origin.x = baselineOrigin.x + self.frame.origin.x + xOffset;
          runBounds.origin.y =
              baselineOrigin.y + lineFrame.size.height - ascent;

          returnedDict[FTCoreTextDataFrame] = NSStringFromCGRect(runBounds);
        }
      }
      if (returnedDict.count > 0)
        break;
    }
  }

  [self cleanPath:mainPath frame:drawFrame];

  return returnedDict;
}

- (void)updateFramesetterIfNeeded {
  if (!_coreTextViewFlags.updatedAttrString) {
    //    TICK;
    [self resetFramesetter];

    if (_numberOfLines > 0) {

      [self resetAttributeStringOnLimitLines];
    }
    _coreTextViewFlags.updatedAttrString = YES;
    _coreTextViewFlags.updatedFramesetter = YES;
    //    TOCK;
  }
}

- (void)initPath:(CGMutablePathRef *)mainPath frame:(CTFrameRef *)drawFrame {
  *mainPath = CGPathCreateMutable();

  if (!_path) {
    CGPathAddRect(*mainPath, NULL, CGRectMake(0, 0, self.bounds.size.width,
                                              self.bounds.size.height));
  } else {
    CGPathAddPath(*mainPath, NULL, _path);
  }

  *drawFrame = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0),
                                        *mainPath, NULL);
}

- (void)cleanPath:(CGMutablePathRef)mainPath frame:(CTFrameRef)drawFrame {
  // cleanup
  if (drawFrame)
    CFRelease(drawFrame);
  CGPathRelease(mainPath);
}

- (void)resetAttributeStringOnLimitLines {

  static NSString *const kEllipsesCharacter = @"\u2026";

  int maxLineNum = _numberOfLines;

  if (maxLineNum <= 0)
    return;

  //使用显示完全文本的高度，以显示所有文本，在方法的最后，需要恢复原来的高度
  CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(
      _framesetter, CFRangeMake(0, 0), NULL,
      CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT), NULL);
  CGRect viewFrame = self.frame;
  CGFloat oldHeight = viewFrame.size.height;
  viewFrame.size.height = suggestedSize.height;
  self.frame = viewFrame;

  CGMutablePathRef mainPath;
  CTFrameRef drawFrame;
  [self initPath:&mainPath frame:&drawFrame];

  CFArrayRef lines = CTFrameGetLines(drawFrame);
  CFIndex lineCount = CFArrayGetCount(lines);

  if (lines != 0 && maxLineNum >= lineCount) {
    //恢复原来的高度
    viewFrame.size.height = oldHeight;
    self.frame = viewFrame;
    [self cleanPath:mainPath frame:drawFrame];
    return;
  }

  CGPoint lineOrigins[maxLineNum];
  CTFrameGetLineOrigins(drawFrame, CFRangeMake(0, maxLineNum), lineOrigins);
  NSAttributedString *attributedString = self.attributedString;

  CTLineRef lastVisibleLine = CFArrayGetValueAtIndex(lines, maxLineNum - 1);

  CFRange lastLineRange = CTLineGetStringRange(lastVisibleLine);
  //最后一行无法显示所有的内容
  if (lastLineRange.location + lastLineRange.length <
      (CFIndex)attributedString.length) {

    NSUInteger truncationAttributePosition =
        (NSUInteger)(lastLineRange.location + lastLineRange.length - 1);

    NSDictionary *tokenAttributes =
        [attributedString attributesAtIndex:truncationAttributePosition
                             effectiveRange:NULL]; //可能导致超界崩溃
    NSAttributedString *tokenString =
        [[NSAttributedString alloc] initWithString:kEllipsesCharacter
                                        attributes:tokenAttributes];
    float ellipsesCharWidth =
        [kEllipsesCharacter sizeWithFont:[UIFont systemFontOfSize:16.0f]].width;

    float lastCharWidth =
        [[[_attributedString
             attributedSubstringFromRange:
                 NSMakeRange(truncationAttributePosition, 1)] string]
            sizeWithFont:[UIFont systemFontOfSize:16.0f]]
            .width;
    if (lastCharWidth < ellipsesCharWidth - 1) {
      truncationAttributePosition--;
    }

    NSMutableAttributedString *truncationString = [[attributedString
        attributedSubstringFromRange:
            NSMakeRange(0, truncationAttributePosition)] mutableCopy];
    NSUInteger lastCharIndex = truncationAttributePosition - 1;
    while (lastCharIndex > 0) {
      // Remove any whitespace at the end of the line.
      unichar lastCharacter =
          [[truncationString string] characterAtIndex:lastCharIndex];
      if ([[NSCharacterSet whitespaceAndNewlineCharacterSet]
              characterIsMember:lastCharacter]) {
        [truncationString
            deleteCharactersInRange:NSMakeRange(lastCharIndex, 1)];
        lastCharIndex--;
      } else {
        break;
      }
    }
    [truncationString appendAttributedString:tokenString];
    _text = [truncationString string];
    _attributedString = truncationString;
    [self resetFramesetter];
  }

  //恢复原来的高度
  viewFrame.size.height = oldHeight;
  self.frame = viewFrame;
  [self cleanPath:mainPath frame:drawFrame];
  return;
}

- (void)resetFramesetter {
  if (_framesetter != NULL) {
    CFRelease(_framesetter);
    _framesetter = NULL;
  }
  _framesetter = CTFramesetterCreateWithAttributedString(
      (__bridge CFAttributedStringRef)self.attributedString);
}

/*!
 * @abstract get the supposed size of the drawn text
 *
 */

- (CGSize)suggestedSizeConstrainedToSize:(CGSize)size {
  CGSize suggestedSize;
  [self updateFramesetterIfNeeded];
  if (_framesetter == NULL) {
    return CGSizeZero;
  }
  suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(
      _framesetter, CFRangeMake(0, 0), NULL, size, NULL);
  suggestedSize =
      CGSizeMake(ceilf(suggestedSize.width), ceilf(suggestedSize.height));
  return suggestedSize;
}

/*!
 * @abstract handy method to fit to the suggested height in one call
 *
 */

- (void)fitToSuggestedHeight {
  CGSize suggestedSize = [self
      suggestedSizeConstrainedToSize:CGSizeMake(CGRectGetWidth(self.frame),
                                                MAXFLOAT)];
  CGRect viewFrame = self.frame;
  viewFrame.size.height = suggestedSize.height;
  self.frame = viewFrame;
}

- (void)fitToSuggestedHeight:(NSLayoutConstraint*)cons
{
  CGSize suggestedSize = [self
                          suggestedSizeConstrainedToSize:CGSizeMake(CGRectGetWidth(self.frame),
                                                                    MAXFLOAT)];
  cons.constant = suggestedSize.height;
}

/*
 * @abstract 根据内容计算高度
 *
 *
 */

+ (CGFloat)heightWithText:(NSString *)text
                    width:(CGFloat)width
                     font:(float)font {
  static FTCoreTextView *ctView;
  if (!text) {
    return 0.0;
  } else {
    if (!ctView) {
      ctView = [[FTCoreTextView alloc]
          initWithFrame:CGRectMake(20, 58, width,
                                   0)]; //文字内容距离灰气泡边缘6
    }
    CGRect frame = ctView.frame;
    frame.size.width = width;
    ctView.frame = frame;
    [ctView setTextSize:font];
    //当字符串长度为1时，计算高度不正确，coretext的bug
    if ([text length] == 1) {
      text = [NSString stringWithFormat:@"%@%@ ", text, text];
    }
    ctView.text = text;

    CGSize resultSize = [ctView
        suggestedSizeConstrainedToSize:CGSizeMake(CGRectGetWidth(ctView.frame),
                                                  10000)];
    return resultSize.height;
  }
}

/*
 * 获取FTCoreTextView界面显示内容
 */
- (NSString *)getVisibleFTCoreText {
  NSMutableString *muStr = [[NSMutableString alloc] initWithCapacity:0];
  if (_textNodes && [_textNodes count] > 0) {
    for (WeiboText *wbText in _textNodes) {
      [muStr appendString:wbText.content];
    }
    return muStr;
  } else {
    return @"";
  }
}

#pragma mark Styling

- (void)addStyle:(FTCoreTextStyle *)style {
  _styles[style.name] = [style copy];
  [self didMakeChanges];
  if ([self superview])
    [self setNeedsDisplay];
}

- (void)addStyles:(NSArray *)styles {
  for (FTCoreTextStyle *style in styles) {
    _styles[style.name] = [style copy];
  }
  [self didMakeChanges];
  if ([self superview])
    [self setNeedsDisplay];
}

- (void)applyStyle:(FTCoreTextStyle *)style
           inRange:(NSRange)styleRange
          onString:(NSMutableAttributedString **)attributedString
       isHighlight:(BOOL)highlightColor {

  if (style.name == nil) {
    [NSException raise:@"NSConcreteMutableAttributedString "
                 @"addAttribute:value:range: style.name = nil value "
                format:@"NSConcreteMutableAttributedString "
                @"addAttribute:value:range: style.name = nil value "];
  }
  [*attributedString addAttribute:(id)FTCoreTextDataName
                            value:(id)style.name
                            range:styleRange];
  UIColor *textColor = highlightColor ? style.pressedColor : style.color;
  if (textColor.CGColor == nil) {
    [NSException
         raise:@"NSConcreteMutableAttributedString addAttribute:value:range: "
         @"textColor.CGColor = nil value "
        format:@"NSConcreteMutableAttributedString addAttribute:value:range: "
        @"textColor.CGColor = nil value "];
  }
  [*attributedString addAttribute:(id)kCTForegroundColorAttributeName
                            value:(id)textColor.CGColor
                            range:styleRange];

  if (style.isUnderLined) {
    NSNumber *underline = @(kCTUnderlineStyleSingle);
    [*attributedString addAttribute:(id)kCTUnderlineStyleAttributeName
                              value:(id)underline
                              range:styleRange];
  }

  CTFontRef ctFont = CTFontCreateFromUIFont(style.font);

  [*attributedString addAttribute:(id)kCTFontAttributeName
                            value:(__bridge id)ctFont
                            range:styleRange];
  CFRelease(ctFont);

  CTTextAlignment alignment = (CTTextAlignment)style.textAlignment;
  CGFloat maxLineHeight = style.maxLineHeight;
  CGFloat minLineHeight = style.minLineHeight;
  CGFloat paragraphLeading = style.leading;

  CGFloat paragraphSpacingBefore = style.paragraphInset.top;
  CGFloat paragraphSpacingAfter = style.paragraphInset.bottom;
  CGFloat paragraphFirstLineHeadIntent = style.paragraphInset.left;
  CGFloat paragraphHeadIntent = style.paragraphInset.left;
  CGFloat paragraphTailIntent = style.paragraphInset.right;
  CGFloat lineHeightMultiple = _lineHeightMultiple;

  // if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
  paragraphSpacingBefore = 0;
  //}

  CFIndex numberOfSettings = 9;
  CGFloat tabSpacing = 28.f;

  BOOL applyParagraphStyling = style.applyParagraphStyling;

  if ([style.name
          isEqualToString:[self defaultTagNameForKey:FTCoreTextTagBullet]]) {
    applyParagraphStyling = YES;
  } else if ([style.name isEqualToString:@"_FTBulletStyle"]) {
    applyParagraphStyling = YES;
    numberOfSettings++;
    tabSpacing = style.paragraphInset.right;
    paragraphSpacingBefore = 0;
    paragraphSpacingAfter = 0;
    paragraphFirstLineHeadIntent = 0;
    paragraphTailIntent = 0;
  } else if ([style.name hasPrefix:@"_FTTopSpacingStyle"]) {
    [*attributedString removeAttribute:(id)kCTParagraphStyleAttributeName
                                 range:styleRange];
  }

  if (applyParagraphStyling) {

    CTTextTabRef tabArray[] = {
        CTTextTabCreate(kCTTextAlignmentLeft, tabSpacing, NULL)};

    CFArrayRef tabStops =
        CFArrayCreate(kCFAllocatorDefault, (const void **)tabArray, 1,
                      &kCFTypeArrayCallBacks);
    CFRelease(tabArray[0]);

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
      CTParagraphStyleSetting settings[] = {
          {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
          {kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat),
           &maxLineHeight},
          {kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat),
           &minLineHeight},
          {kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat),
           &lineHeightMultiple},
          {kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat),
           &paragraphSpacingBefore},
          {kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat),
           &paragraphSpacingAfter},
          {kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat),
           &paragraphFirstLineHeadIntent},
          {kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat),
           &paragraphHeadIntent},
          {kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat),
           &paragraphTailIntent},
          {kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat),
           &paragraphLeading},
          {kCTParagraphStyleSpecifierTabStops, sizeof(CFArrayRef),
           &tabStops} // always at the end
      };
      numberOfSettings = 10;
      CTParagraphStyleRef paragraphStyle =
          CTParagraphStyleCreate(settings, (size_t)numberOfSettings);
      [*attributedString addAttribute:(id)kCTParagraphStyleAttributeName
                                value:(__bridge id)paragraphStyle
                                range:styleRange];
      CFRelease(tabStops);
      CFRelease(paragraphStyle);
    } else {
      CTParagraphStyleSetting settings[] = {
          {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
          {kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat),
           &maxLineHeight},
          {kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat),
           &minLineHeight},
          {kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat),
           &paragraphSpacingBefore},
          {kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat),
           &paragraphSpacingAfter},
          {kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat),
           &paragraphFirstLineHeadIntent},
          {kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat),
           &paragraphHeadIntent},
          {kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat),
           &paragraphTailIntent},
          {kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat),
           &paragraphLeading},
          {kCTParagraphStyleSpecifierTabStops, sizeof(CFArrayRef),
           &tabStops} // always at the end
      };
      numberOfSettings = 9;
      CTParagraphStyleRef paragraphStyle =
          CTParagraphStyleCreate(settings, (size_t)numberOfSettings);
      [*attributedString addAttribute:(id)kCTParagraphStyleAttributeName
                                value:(__bridge id)paragraphStyle
                                range:styleRange];
      CFRelease(tabStops);
      CFRelease(paragraphStyle);
    }
    //聊股富文本显示的行间距修改为1.3倍
  }
}

#pragma mark - Object lifecycle

- (id)initWithFrame:(CGRect)frame {
  return [self initWithFrame:frame andAttributedString:nil];
}

- (id)initWithFrame:(CGRect)frame
andAttributedString:(NSAttributedString *)attributedString {
  self = [super initWithFrame:frame];
  if (self) {
    _attributedString = attributedString;
    [self doInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self doInit];
  }
  return self;
}

- (void)doInit {
  // Initialization code
  _framesetter = NULL;
  _styles = [[NSMutableDictionary alloc] init];
  _URLs = [[NSMutableDictionary alloc] init];
  self.images = [[NSMutableArray alloc] init];
  _highlightTouch = YES;
  _numberOfLines = 0;
  _lineHeightMultiple = FTCoreTextViewDefaultLineHeightMultiple;
  self.opaque = YES;
  self.backgroundColor = [UIColor clearColor];
  self.contentMode = UIViewContentModeRedraw;
  [self setUserInteractionEnabled:YES];

  FTCoreTextStyle *defaultStyle =
      [FTCoreTextStyle styleWithName:FTCoreTextTagDefault];
  [self addStyle:defaultStyle];

  FTCoreTextStyle *linksStyle = [defaultStyle copy];
  linksStyle.color = [UIColor blueColor];
  linksStyle.name = FTCoreTextTagLink;
  _styles[linksStyle.name] = [linksStyle copy];

  _defaultsTags = [@{
    FTCoreTextTagDefault : FTCoreTextTagDefault,
    FTCoreTextTagLink : FTCoreTextTagLink,
    FTCoreTextTagImage : FTCoreTextTagImage,
    FTCoreTextTagPage : FTCoreTextTagPage,
    FTCoreTextTagBullet : FTCoreTextTagBullet
  } mutableCopy];
  [WeiboUtil addTextStylesToTextView:self];
}

- (void)dealloc {
  if (_framesetter != NULL) {
    CFRelease(_framesetter);
    _framesetter = NULL;
  }
  if (_path)
    CGPathRelease(_path);
}

#pragma mark - Custom Setters

- (void)setText:(NSString *)text {
  _text = text;
  _coreTextViewFlags.textChangesMade = YES;
  [self didMakeChanges];
  if ([self superview])
    [self setNeedsDisplay];
}

- (void)setPath:(CGPathRef)path {
  _path = CGPathRetain(path);
  [self didMakeChanges];
  if ([self superview])
    [self setNeedsDisplay];
}

- (void)setShadowColor:(UIColor *)shadowColor {
  _shadowColor = shadowColor;
  if ([self superview])
    [self setNeedsDisplay];
}

- (void)setShadowOffset:(CGSize)shadowOffset {
  _shadowOffset = shadowOffset;
  if ([self superview])
    [self setNeedsDisplay];
}

#pragma mark - Custom Getters

- (NSArray *)styles {
  return [_styles allValues];
}

- (FTCoreTextStyle *)styleForName:(NSString *)tagName {
  return _styles[tagName];
}

static const NSString *IMG_LOCATION = @"location";
static const NSString *IMG_WIDTH = @"width";
static const NSString *IMG_HEIGHT = @"height";
static const NSString *IMG_FILENAME = @"fileName";
static const NSString *IMG_DATA = @"imgData";
static const NSString *IMG_BOUND = @"imgBounds";
static const NSString *IMG_LINK = @"链接小图标.png";

- (void)setTextSize:(float)textSize {
  NSArray *array = [_styles allValues];
  for (FTCoreTextStyle *style in array) {
    style.font = [UIFont systemFontOfSize:textSize];
  }
}

- (void)setBoldTextSize:(float)textSize {
  NSArray *array = [_styles allValues];
  for (FTCoreTextStyle *style in array) {
    style.font = [UIFont boldSystemFontOfSize:textSize];
  }
}

- (void)setTextColor:(UIColor *)color {
  FTCoreTextStyle *defaultStyle = [self defaultStyle];
  defaultStyle.color = color;
  [self setNeedsDisplay];
}

- (void)setLineHeightMultiple:(CGFloat)lineHeightMultiple {
  _lineHeightMultiple = lineHeightMultiple;
}

- (void)setNumberOfLines:(int)numberOfLines {
  _numberOfLines = numberOfLines;
  _coreTextViewFlags.updatedAttrString = YES;
}

- (FTCoreTextStyle *)defaultStyle {
  FTCoreTextStyle *defaultStyle = [self styleForName:FTCoreTextTagDefault];
  if (defaultStyle == nil) {
    defaultStyle = [[FTCoreTextStyle alloc] init];
    defaultStyle.name = FTCoreTextTagDefault;
    defaultStyle.textAlignment = FTCoreTextAlignementLeft;
    _styles[FTCoreTextTagDefault] = defaultStyle;
  }
  return defaultStyle;
}

- (NSAttributedString *)attributedString {
  if (!_coreTextViewFlags.updatedAttrString) {
    _coreTextViewFlags.updatedAttrString = YES;

    if (self.textNodes == nil || _coreTextViewFlags.textChangesMade) {
      _coreTextViewFlags.textChangesMade = NO;
      self.textNodes = [WeiboUtil parseWeiboRichContext:_text];
    }

    //测试数据居然有空股聊😓，为例避免崩溃，直接返回nil
    NSMutableAttributedString *string =
        [[NSMutableAttributedString alloc] initWithString:@""];
    if (!self.textNodes) {
      _attributedString = string;
      return string;
    }

    [_URLs removeAllObjects];
    [self.images removeAllObjects];

    NSUInteger start = 0;
    for (WeiboText *weiboText in self.textNodes) {
      NSRange styleRange = NSMakeRange(start, [weiboText.content length]);
      FTCoreTextStyle *style = _styles[weiboText.tag];

      if (weiboText.type == WeiboTextType_HtmlLink) {
        UrlWeiboText *urlWeiboText = (UrlWeiboText *)weiboText;
        if ([urlWeiboText.url startsWith:@"youguu://"]) {
          [string
              appendAttributedString:[[NSAttributedString alloc]
                                         initWithString:urlWeiboText.content]];
        } else {
          //网页链接图标使用字体同样大小的图片，要求图片符合英文排版的ascender,
          // descender规则，例如：
          //对于19号字体，则图片的要求：内部图片12*12，图片左侧留白7px,
          //右侧留白7px，上侧留白7px
          NSNumber *width = @(style.font.pointSize);
          NSNumber *height = @(style.font.pointSize);
          NSLog(@"%f,%f", style.font.ascender, style.font.descender);
          NSLog(@"%f,%f", style.font.capHeight, style.font.xHeight);

          NSMutableDictionary *dic =
              [[NSMutableDictionary alloc] initWithDictionary:@{
                IMG_LOCATION : @(start),
                IMG_WIDTH : width,
                IMG_HEIGHT : height,
                IMG_FILENAME : IMG_LINK
              }];
          [self.images addObject:dic];

          // render empty space for drawing the image in the text //1
          CTRunDelegateCallbacks callbacks;
          callbacks.version = kCTRunDelegateVersion1;
          callbacks.getAscent = ascentCallback;
          callbacks.getDescent = descentCallback;
          callbacks.getWidth = widthCallback;
          callbacks.dealloc = deallocCallback;

          CTRunDelegateRef delegate =
              CTRunDelegateCreate(&callbacks, (__bridge void *)(dic)); // 3
          NSDictionary *attrDictionaryDelegate = @{
            // set the delegate
            (NSString *)kCTRunDelegateAttributeName : (__bridge id)delegate
          };

          // add a space to the text so that it can call the delegate
          [string appendAttributedString:
                      [[NSAttributedString alloc]
                          initWithString:[URL_SHOW_CONTEXT substringToIndex:1]
                              attributes:attrDictionaryDelegate]];

          [string
              appendAttributedString:
                  [[NSAttributedString alloc]
                      initWithString:[URL_SHOW_CONTEXT substringFromIndex:1]]];
        }
      } else {
        //此处存在内存访问错误bug
        [string appendAttributedString:[[NSAttributedString alloc]
                                           initWithString:weiboText.content]];
      }

      if (weiboText.type == WeiboTextType_Font) {
        FontWeiboText *fontWeiboText = (FontWeiboText *)weiboText;
        style = [[FTCoreTextStyle alloc] init];
        CGFloat textSize = fontWeiboText.textSize > 0
                               ? fontWeiboText.textSize
                               : self.defaultStyle.font.pointSize;
        style.font = fontWeiboText.isBold
                         ? [UIFont boldSystemFontOfSize:textSize]
                         : [UIFont systemFontOfSize:textSize];
        style.color = fontWeiboText.textColor;
      }
      NSString *rangeString = NSStringFromRange(styleRange);
      [self applyStyle:style
               inRange:styleRange
              onString:&string
           isHighlight:[rangeString isEqualToString:self.selectionRange]];
      start += [weiboText.content length];
      if (weiboText.isClickable) {
        _URLs[rangeString] = weiboText;
      }
    }

    _attributedString = string;
  }

  return _attributedString;
}

#pragma mark - View lifecycle

/*!
 * @abstract draw the actual coretext on the context
 *
 */

- (void)drawRect:(CGRect)rect {
  [self updateFramesetterIfNeeded];

  CGContextRef context = UIGraphicsGetCurrentContext();

  [self.backgroundColor setFill];
  CGContextFillRect(context, rect);

  CGMutablePathRef mainPath;
  CTFrameRef drawFrame;
  [self initPath:&mainPath frame:&drawFrame];

  if (drawFrame == NULL) {
    //    if (_verbose)
    //      NSLog(@"f: %@", self.processedString);
  } else {
    // draw images
    if ([self.images count] > 0) {
      [self calculateImageBounds:drawFrame];
      [self drawImages];
    }

    if (_shadowColor) {
      CGContextSetShadowWithColor(context, _shadowOffset, 0.f,
                                  _shadowColor.CGColor);
    }

    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    // draw text
    CTFrameDraw(drawFrame, context);
  }
  [self cleanPath:mainPath frame:drawFrame];
}

- (void)calculateImageBounds:(CTFrameRef)drawFrame {
  //已经计算过了
  NSMutableDictionary *image = self.images[0];
  if (image[IMG_BOUND]) {
    return;
  }

  // drawing images
  NSArray *lines = (NSArray *)CTFrameGetLines(drawFrame); // 1

  CGPoint origins[[lines count]];
  CTFrameGetLineOrigins(drawFrame, CFRangeMake(0, 0), origins); // 2

  // find images for the current column
  CFRange frameRange = CTFrameGetVisibleStringRange(drawFrame); // 4

  for (NSMutableDictionary *nextImage in self.images) {
    int imgLocation = [nextImage[IMG_LOCATION] intValue];
    if (imgLocation < frameRange.location ||
        frameRange.location + frameRange.length <= imgLocation) {
      // not this frame, goto next image
      continue;
    }
    int lineIndex = 0;
    for (id lineObj in lines) { // 5
      CTLineRef line = (__bridge CTLineRef)lineObj;
      CFRange lineRange = CTLineGetStringRange(line);
      if (imgLocation < lineRange.location ||
          lineRange.location + lineRange.length <= imgLocation) {
        // not this line, goto next line
        lineIndex++;
        continue;
      }

      for (id runObj in(NSArray *)CTLineGetGlyphRuns(line)) { // 6
        CTRunRef run = (__bridge CTRunRef)runObj;
        CFRange runRange = CTRunGetStringRange(run);

        if (runRange.location <= imgLocation &&
            runRange.location + runRange.length > imgLocation) { // 7
          CGRect runBounds;
          CGFloat ascent;  // height above the baseline
          CGFloat descent; // height below the baseline
          runBounds.size.width = (CGFloat)CTRunGetTypographicBounds(
              run, CFRangeMake(0L, 0L), &ascent, &descent, NULL); // 8
          runBounds.size.height = ascent + descent;

          CGFloat xOffset = CTLineGetOffsetForStringIndex(
              line, CTRunGetStringRange(run).location, NULL); // 9
          runBounds.origin.x = origins[lineIndex].x + xOffset;
          NSLog(@"line: self.frame.origin.x=%f, xOffset=%f",
                self.frame.origin.x, xOffset);
          runBounds.origin.y =
              CGRectGetHeight(self.frame) - origins[lineIndex].y;
          runBounds.origin.y -= ascent;
          NSLog(@"line: x=%f, y=%f", origins[lineIndex].x,
                origins[lineIndex].y);
          NSLog(@"ascent=%f, descent=%f", ascent, descent);

          CGPathRef pathRef = CTFrameGetPath(drawFrame); // 10
          CGRect colRect = CGPathGetBoundingBox(pathRef);

          CGRect imgBounds =
              CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
          nextImage[IMG_BOUND] = NSStringFromCGRect(imgBounds);

          UIImage *img = [UIImage imageNamed:nextImage[IMG_FILENAME]];
          nextImage[IMG_DATA] = img;
        }
      }
      lineIndex++;
    }
  }
}

- (void)drawImages {

  for (NSDictionary *imageData in self.images) {
    UIImage *img = imageData[IMG_DATA];
    CGRect rect = CGRectFromString(imageData[IMG_BOUND]);
    [img drawInRect:rect];
  }
}

#pragma mark User Interaction

- (BOOL)performClickOnPoint:(CGPoint)pointInWindow {
  CGPoint pointInSelf = [self.window convertPoint:pointInWindow toView:self];
  if (![self pointInside:pointInSelf withEvent:nil]) {
    return NO;
  }

  NSMutableArray *activeRects;
  NSDictionary *data = [self dataForPoint:pointInSelf activeRects:&activeRects];
  if (data && [data count] > 0) {
    NSString *key = data[FTCoreTextDataURL];
    WeiboText *weiboText = _URLs[key];
    [weiboText onClick];
    return YES;
  } else {
    return NO;
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"FTCoreTextView: touchesBegan");
  CGPoint point = [(UITouch *)[touches anyObject] locationInView:self];
  NSLog(@"press location x=%f, y=%f", point.x, point.y);
  NSMutableArray *activeRects;
  NSDictionary *data = [self dataForPoint:point activeRects:&activeRects];
  if (data.count > 0) {
    NSLog(@"FTCoreTextView: set pressed status");
    NSString *key = data[FTCoreTextDataURL];

    self.selectionRange = key;
    self.touchedData = data;
    _coreTextViewFlags.updatedAttrString = NO;
    [self setNeedsDisplay];
  } else {
    NSLog(@"FTCoreTextView: pass to next responder");
    [self.nextResponder touchesBegan:touches withEvent:event];
    if (_beginTouchAction) {
      _beginTouchAction();
    }
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"FTCoreTextView: touchesMoved");
  if (_touchedData) {
    [self canclePressedStatusWithDelaySeconds:0.2];
  } else {
    [self.nextResponder touchesMoved:touches withEvent:event];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"FTCoreTextView: touchesEnded");
  if (_touchedData) {
    NSString *key = _touchedData[FTCoreTextDataURL];
    WeiboText *weiboText = _URLs[key];
    [weiboText onClick];
    [self canclePressedStatusWithDelaySeconds:0.2];
  } else {
    self.selectionRange = nil;
    [self.nextResponder touchesEnded:touches withEvent:event];
  }
  if (_endTouchAction) {
    _endTouchAction();
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"FTCoreTextView: touchesCancelled");
  if (_touchedData) {
    [self canclePressedStatusWithDelaySeconds:0.5];
  } else {
    self.selectionRange = nil;
    [self.nextResponder touchesCancelled:touches withEvent:event];
  }
  if (_endTouchAction) {
    _endTouchAction();
  }
}

///取消按下态
- (void)canclePressedStatusWithDelaySeconds:(CGFloat)delaySeconds {
  dispatch_time_t time =
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC));
  dispatch_after(time, dispatch_get_main_queue(), ^{
    _touchedData = nil;
    self.selectionRange = nil;
    _coreTextViewFlags.updatedAttrString = NO;
    [self setNeedsDisplay];
  });
}

@end
