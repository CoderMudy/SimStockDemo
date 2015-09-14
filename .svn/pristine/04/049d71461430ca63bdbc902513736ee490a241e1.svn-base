//
//  SimuShowDataView.m
//  SimuStock
//
//  Created by Mac on 13-11-20.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

@implementation SimuShowMessageDataView
@synthesize smdv_backImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        //牛头图像SST_showMsg@2x.png
        smdv_backImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"捂嘴小牛"]];
        smdv_backImageView.bounds=CGRectMake(0, 0, [UIImage imageNamed:@"捂嘴小牛"].size.width, [UIImage imageNamed:@"捂嘴小牛"].size.height);
        smdv_backImageView.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2-[UIImage imageNamed:@"捂嘴小牛"].size.height/2);
        [self addSubview:smdv_backImageView];
        
        smdv_messageLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 60)];
        smdv_messageLable.backgroundColor=[UIColor clearColor];
        smdv_messageLable.font=[UIFont systemFontOfSize:15];
        smdv_messageLable.textColor=[Globle colorFromHexRGB:Color_Gray];
        smdv_messageLable.textAlignment=NSTextAlignmentCenter;
        smdv_messageLable.numberOfLines = 0;
        smdv_messageLable.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2+20);
        [self addSubview:smdv_messageLable];
    }
    return self;
}
//比赛_我参与的（无数据）
- (void)noDataStockMatchWithImageName:(NSString *)imageName withContent:(NSString *)content
{
    smdv_backImageView.image = [UIImage imageNamed:imageName];
    smdv_backImageView.bounds=CGRectMake(0, 0, [UIImage imageNamed:imageName].size.width, [UIImage imageNamed:imageName].size.height);
    smdv_backImageView.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2-[UIImage imageNamed:imageName].size.height);
    
    smdv_messageLable.text = content;
}
- (id)initWithFrameNOImage:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        
        smdv_messageLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
        smdv_messageLable.backgroundColor=[UIColor clearColor];
        smdv_messageLable.font=[UIFont systemFontOfSize:15];
        smdv_messageLable.textColor=[Globle colorFromHexRGB:Color_Gray];
        smdv_messageLable.textAlignment=NSTextAlignmentCenter;
        smdv_messageLable.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        [self addSubview:smdv_messageLable];
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

//设定展示消息
-(void)setMessageData:(NSString *) message
{
    if(smdv_messageLable && message!=nil)
    {
        smdv_messageLable.text=message;
    }
}
- (void)showNoNetworkStatusWithMessage:(NSString *)message
{
    [self setMessageData:message];
    //牛头图像SST_showMsg@2x.png
    smdv_backImageView.image = [UIImage imageNamed:@"no_network"];
    smdv_backImageView.bounds=CGRectMake(0, 0, 93, 93);
    smdv_backImageView.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2-47-20);
}

- (void)showNoNetworkStatusWithMessage {
  [self showNoNetworkStatusWithMessage:NO_NETWORK_MESSAGE];
}

@end
