//
//  FooterInfoView.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-13.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#define WIDTH_OF_VIEWCONTROLLER [UIScreen mainScreen].bounds.size.width
#define FRAME CGRectMake(0, 0, WIDTH_OF_VIEWCONTROLLER, HEIGHT_OF_SELL_CELL)

@interface FooterInfoView ()
{
    //正在加载更多提示
    TopAndBottomAlignmentLabel *_loadingMoreLabel;
    //暂无更多数据
    TopAndBottomAlignmentLabel *_noMoreDataLabel;
}
@end

@implementation FooterInfoView

- (id)init
{
    self = [super initWithFrame:FRAME];//320 45
    if (self) {
        //
        self.hidden = NO;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _loadingMoreLabel = [[TopAndBottomAlignmentLabel alloc] initWithFrame:FRAME];
    _loadingMoreLabel.text = @"正在加载更多...";
    _loadingMoreLabel.textColor = [Globle colorFromHexRGB:Color_Gray];
    _loadingMoreLabel.textAlignment = NSTextAlignmentCenter;
    _loadingMoreLabel.verticalAlignment = VerticalAlignmentMiddle;
    _loadingMoreLabel.backgroundColor = [UIColor clearColor];//adjust to iOS6
    [self addSubview:_loadingMoreLabel];
    
    _noMoreDataLabel = [[TopAndBottomAlignmentLabel alloc] initWithFrame:FRAME];
    _noMoreDataLabel.text = @"暂无更多数据";
    _noMoreDataLabel.textColor = [Globle colorFromHexRGB:Color_Gray];
    _noMoreDataLabel.textAlignment = NSTextAlignmentCenter;
    _noMoreDataLabel.verticalAlignment = VerticalAlignmentMiddle;
    _noMoreDataLabel.backgroundColor = [UIColor clearColor];//adjust to iOS6
    [self addSubview:_noMoreDataLabel];
    
    _noMoreDataLabel.hidden = YES;//默认显示 @"正在加载更多..."
}

//切换视图方法
- (void)isDataCompleted:(BOOL)isCompleted
{
    if (isCompleted) {
        //数据加载完成，显示@"暂无更多数据"
        _noMoreDataLabel.hidden = NO;
        _loadingMoreLabel.hidden = YES;
    } else {
        //数据正在加载，显示@"正在加载更多..."
        _noMoreDataLabel.hidden = YES;
        _loadingMoreLabel.hidden = NO;
    }
    
    self.hidden = NO;
    [self.superview bringSubviewToFront:self];
}



@end
