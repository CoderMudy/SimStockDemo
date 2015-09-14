//
//  MarketMaskView.m
//  SimuStock
//
//  Created by Mac on 13-12-9.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

@implementation MarketMaskView

@synthesize delegete=_delegete;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark
#pragma mark touch
// touch
- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
{
    self.hidden=YES;
    if(_delegete)
    {
        [_delegete HideMenuView];
    }
}


@end
