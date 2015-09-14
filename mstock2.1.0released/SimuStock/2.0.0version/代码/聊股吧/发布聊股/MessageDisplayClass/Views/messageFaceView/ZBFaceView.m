//
//  ZBFaceView.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-13.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "ZBFaceView.h"
#import "YLColorToimage.h"
#import "Globle.h"
#import "SREmojiConvertor.h"

#define NumPerLine 7
#define Lines 4
#define FaceSize 40
/*
** 两边边缘间隔
 */
#define EdgeDistance 0
/*
 ** 上下边缘间隔
 */
#define EdgeInterVal 5

@implementation ZBFaceView

- (id)initWithFrame:(CGRect)frame forIndexPath:(NSInteger)index {
  self = [super initWithFrame:frame];
  if (self) {
    // 水平间隔
    CGFloat horizontalInterval = (CGRectGetWidth(self.bounds) -
                                  NumPerLine * FaceSize - 2 * EdgeDistance) /
                                 (NumPerLine - 1);
    // 上下垂直间隔
    CGFloat verticalInterval =
        (CGRectGetHeight(self.bounds) - 2 * EdgeInterVal - Lines * FaceSize) /
        (Lines - 1);
    
    SREmojiConvertor *emojis = [[SREmojiConvertor alloc] init];

    _emoji_arrays = [[NSMutableArray alloc] initWithArray:[emojis emojis5]];
    
    UIImage * defaultImage=[UIImage imageWithColor:[Globle colorFromHexRGB:@"d9ecf2"]];
    UIFont * fonttext=[UIFont systemFontOfSize:30];
    for (int i = 0; i < Lines; i++) {
      for (int x = 0; x < NumPerLine; x++) {
        UIButton *expressionButton =
            [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:expressionButton];
        [expressionButton
            setFrame:CGRectMake(
                         x * FaceSize + EdgeDistance + x * horizontalInterval,
                         i * FaceSize + i * verticalInterval + EdgeInterVal,
                         FaceSize, FaceSize)];
        NSInteger length = 28 * index + i * 7 + x;
        if ([_emoji_arrays count] - 1 < 28 * index + i * 7 + x) {
          length = [_emoji_arrays count] - 1;
        }
        expressionButton.titleEdgeInsets=UIEdgeInsetsMake(-2, 5, 2, 5);
        NSString *emoji_str = _emoji_arrays[length];
        expressionButton.titleLabel.font=fonttext;
        expressionButton.titleLabel.backgroundColor=[UIColor clearColor];
        [expressionButton setBackgroundImage:defaultImage forState:UIControlStateHighlighted];
        [expressionButton setTitle:emoji_str forState:UIControlStateNormal];
        expressionButton.tag = 28 * index + i * 7 + x;
        [expressionButton addTarget:self
                             action:@selector(faceClick:)
                   forControlEvents:UIControlEventTouchUpInside];
      }
    }
  }
  return self;
}

- (void)faceClick:(UIButton *)button {
  NSInteger length = button.tag;
  if ([_emoji_arrays count] - 1 < button.tag) {
    length = [_emoji_arrays count] - 1;
  }
  NSString *faceName = _emoji_arrays[length];

  if (self.delegate &&
      [self.delegate
          respondsToSelector:@selector(didSelecteFace:andIsSelecteDelete:)]) {
    [self.delegate didSelecteFace:faceName andIsSelecteDelete:NO];
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
