//
//  CapitalScrollView.m
//  SimuStock
//
//  Created by Mac on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CapitalScrollView.h"
#import "SuccessApplicantsInformationView.h"
#import "Globle.h"
#import "SingleUserApplyDetail.h"
#import "UIImageView+WebCache.h"
@implementation CapitalScrollView

-(id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.scrollview =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 36)];
    [self addSubview:self.scrollview];
    self.scrollview.scrollEnabled = NO;
    self.userInteractionEnabled = NO;
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  self.userInteractionEnabled = NO;
}

- (void)StartAnimation:(NSMutableArray *)array {
  if (array && [array count] > 0) {
    self.notPeiZiView.hidden=YES;
    self.notnetworkView.hidden=YES;
    [self.scrollview removeAllSubviews];
    [self stopTime];

    SingleUserApplyDetail *lastobject = [array objectAtIndex:0];
    [array addObject:lastobject];

    self.clipsToBounds = YES;
    for (int i = 0; i < [array count]; i++) {
      SingleUserApplyDetail *singleDetail =
          (SingleUserApplyDetail *)[array objectAtIndex:i];
      SuccessApplicantsInformationView *successView = [[[NSBundle mainBundle]
          loadNibNamed:@"SuccessApplicantsInformationView"
                 owner:self
               options:nil] lastObject];
      successView.frame =
          CGRectMake(0, self.height * i,WIDTH_OF_SCREEN, self.height);
      successView.imageView.backgroundColor =
          [Globle colorFromHexRGB:@"87c8e1"];
      [successView.imageView
           setImageWithURL:[NSURL
                               URLWithString:singleDetail.userListItem.headPic]
          placeholderImage:[UIImage imageNamed:@"用户默认头像@2x.png"]];
      //      successView.imageView.image =[UIImage imageNamed:@"icon"];
      successView.UserName.text =
          [self getUserWithnickName:singleDetail.userListItem.nickName];
      successView.ApplicantsLabel.attributedText =
          [self getApplicantsLabel:singleDetail.userMarqueeItem.amout
                           andtaye:singleDetail.userMarqueeItem.status];
      
      [self.scrollview addSubview:successView];
    }

    self.scrollview.contentSize = CGSizeMake(self.width, [array count] * self.height);
    mtimer = [NSTimer scheduledTimerWithTimeInterval:4.0
                                              target:self
                                            selector:@selector(successViewClick)
                                            userInfo:nil
                                             repeats:YES];
  } else {
    ///没有配资数据
    [self NotPeiZidata];
  }
}

- (NSString *)getUserWithnickName:(NSString *)nickname {
  if ([nickname length] >= 6) {
    return [NSString stringWithFormat:@"%@*", [nickname substringToIndex:5]];
  } else if ([nickname length] >= 3) {
    return [NSString
        stringWithFormat:@"%@*",
                         [nickname substringToIndex:[nickname length] - 1]];
  } else if ([nickname length] < 3) {
    return [NSString stringWithFormat:@"%@*", nickname];
  }
  return nickname;
}

- (NSAttributedString *)getApplicantsLabel:(double)amount andtaye:(int)type {
  NSString *text = [NSString stringWithFormat:@"%.0f", amount];
  if (type == 0) {
    text = [NSString stringWithFormat:@"申请 %@元", text];
  } else if (type == 1) {
    text = [NSString stringWithFormat:@"盈利 %@元", text];
  }
  NSMutableAttributedString *result =
      [[NSMutableAttributedString alloc] initWithString:text];

  [result addAttribute:NSFontAttributeName
                 value:[UIFont systemFontOfSize:12]
                 range:NSMakeRange(3, [text length] - 4)];
  [result addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(3, [text length] - 4)];

  return result;
}

- (void)NotnetWork {
  self.scrollview.hidden=YES;
  self.notPeiZiView.hidden=YES;
  [self stopTime];

  if (!self.notnetworkView)
  {
    self.notnetworkView =
    [[UIView alloc] initWithFrame:CGRectMake(WIDTH_OF_SCREEN / 4, 0, WIDTH_OF_SCREEN / 2, self.height)];
    [self addSubview:self.notnetworkView];
    
    //默认头像
    UIImageView *imageview =
    [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 30, 30)];
    [imageview.layer setBorderWidth:1.0f];
    [imageview.layer setBorderColor:[Globle colorFromHexRGB:@"ffffff"].CGColor];
    imageview.layer.cornerRadius = 15;
    imageview.backgroundColor = [Globle colorFromHexRGB:@"87c8e1"];
    imageview.image = [UIImage imageNamed:@"用户默认头像@2x.png"];
    [self.notnetworkView addSubview:imageview];
    
    ///文本
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 8, 120, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"当前网络不给力";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
    [self.notnetworkView addSubview:label];
  }
  self.notnetworkView.hidden = NO;
}

///没有配资数据的时候
- (void)NotPeiZidata {
  self.notnetworkView.hidden=YES;
  self.scrollview.hidden=YES;
  [self stopTime];
  
  if (!self.notPeiZiView)
  {
    self.notPeiZiView =
    [[UIView alloc] initWithFrame:CGRectMake(WIDTH_OF_SCREEN / 4, 0, WIDTH_OF_SCREEN / 2, self.height)];
    [self addSubview:self.notPeiZiView];
    
    //默认头像
    UIImageView *imageview =
    [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 30, 30)];
    [imageview.layer setBorderWidth:1.0f];
    [imageview.layer setBorderColor:[Globle colorFromHexRGB:@"ffffff"].CGColor];
    imageview.layer.cornerRadius = 15;
    imageview.backgroundColor = [Globle colorFromHexRGB:@"87c8e1"];
    imageview.image = [UIImage imageNamed:@"用户默认头像@2x.png"];
    [self.notPeiZiView addSubview:imageview];
    
    ///文本
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 8, 120, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"正在加载数据...";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
    [self.notPeiZiView addSubview:label];
  }
  self.notPeiZiView.hidden = NO;
}

//定时器关闭与开启
- (void)stopTime {
  if (mtimer) {
    if ([mtimer isValid]) {
      [mtimer invalidate];
      mtimer = nil;
    }
  }
}

- (void)successViewClick {
  CGFloat height = self.scrollview.contentOffset.y + self.scrollview.height;
  [UIView animateWithDuration:3.0
      delay:0
      options:0
      animations:^{
        self.scrollview.contentOffset = CGPointMake(0, height);
      }
      completion:^(BOOL finished) {
        if (finished) {
          if (height >= self.scrollview.contentSize.height - self.scrollview.height) {
            self.scrollview.contentOffset = CGPointMake(0, 0);
          }
        }
      }];
}

@end
