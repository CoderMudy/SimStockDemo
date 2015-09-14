//
//  Header.h
//  ifengNewsOrderDemo
//
//  Created by zer0 on 14-2-26.
//  Copyright (c) 2014年 zer0. All rights reserved.
//
#define KOrderButtonFrameOriginX 257.0
#define KOrderButtonFrameSizeX 63

#define KTableStartPointX 12

#define KTable_Distance_PointX                                                 \
  ([[UIScreen mainScreen] bounds].size.width - KTableStartPointX * 2 -         \
   KButtonWidth * 4) /                                                         \
      3

#define KButtonWidth 65

#ifndef ifengNewsOrderDemo_Header_h
#define ifengNewsOrderDemo_Header_h

#define KOrderButtonFrameOriginY 20

#define KOrderButtonFrameSizeY 45
//以上是OrderButton的frame值
#define KOrderButtonImage @"topnav_orderbutton.png"
#define KOrderButtonImageSelected @"topnav_orderbutton_selected_unselected.png"
//以上是OrderButton的背景图片
#define KDefaultCountOfUpsideList 5
//默认订阅频道数

#define KTableStartPointY 50
//已订阅的按钮起始的位置

#define KButtonHeight 30

//每一层之间的空隙的高度

#define KTable_Distance_PointY 20

//每行有几个 按钮
#define KTable_Num_btn 4
//按钮的大小

//常用控件填充色
#define customFilledColor @"f07533"
///灰色分割线
#define customGrayCuttingLine @"f2f2f2"
//通用整体背景色
#define customBGColor @"ffffff"

#define KChannelList                                                           \
  @"头条", @"娱乐", @"健康", @"星座", @"社会", @"佛教", @"时事", \
      @"时尚", @"军事", @"旅游", @"房产", @"汽车", @"港澳",        \
      @"教育", @"历史", @"文化", @"财经", @"读书", @"台湾",        \
      @"体育", @"科技", @"评论"
#define KChannelUrlStringList                                                  \
  @"http://api.3g.ifeng.com/"                                                  \
      @"iosNews?id=aid=SYLB10&imgwidth=100&type=list&pagesize=20",             \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=YL53&imgwidth=100&type=list&pagesize=20",               \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=JK36&imgwidth=100&type=list&pagesize=20",               \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=XZ09&imgwidth=100&type=list&pagesize=20",               \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=SH133&imgwidth=100&type=list&pagesize=20",              \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=FJ31&imgwidth=100&type=list&pagesize=20",               \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=XW23&imgwidth=100&type=list&pagesize=20",               \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=SS78&imgwidth=100&type=list&pagesize=20",               \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=JS83&imgwidth=100&type=list&pagesize=20",               \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=LY67&imgwidth=100&type=list&pagesize=20",               \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=FC81&imgwidth=100&type=list&pagesize=20",               \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=QC45&imgwidth=100&type=list&pagesize=20",               \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=GA18&imgwidth=100&type=list&pagesize=20",               \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=JY90&imgwidth=100&type=list&pagesize=20",               \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=LS153&imgwidth=100&type=list&pagesize=20",              \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=WH25&imgwidth=100&type=list&pagesize=20",               \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=CJ33&imgwidth=100&type=list&pagesize=20",               \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=DS57&imgwidth=100&type=list&pagesize=20",               \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=TW73&imgwidth=100&type=list&pagesize=20",               \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=TY43,FOCUSTY43&imgwidth=100&type=list&pagesize=20",     \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=KJ123&imgwidth=100&type=list&pagesize=20",              \
      @"http://api.3g.ifeng.com/"                                              \
      @"iosNews?id=aid=PL40&imgwidth=100&type=list&pagesize=20"
//频道名称和对应的请求接口
#endif
