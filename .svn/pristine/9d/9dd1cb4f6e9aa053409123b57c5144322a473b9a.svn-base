//
//  KLineENUM.h
//  SimuStock
//
//  Created by Yuemeng on 15/4/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#ifndef SimuStock_KLineENUM_h
#define SimuStock_KLineENUM_h

/*
 *K线相关公用宏
 */

// k线起始位置重新计算类型
typedef NS_ENUM(NSUInteger, KLineCalMode) {
    // k线放缩计算
    KL_Zoom_Mode,
    // 初始化时候的计算
    KL_Common_Mode,
    // k线移动时候计算
    KL_Move_Mode,
};

// k线变化类型
typedef NS_ENUM(NSUInteger, KLineShapChangeMode) {
    // k线放大
    KLSC_Larger,
    // k线缩小
    KLSC_Smaller,
    // k线左移
    KLSC_MoveLeft,
    // k线右移
    KLSC_MoveRight,
};

//当前长按的按钮
typedef NS_ENUM(NSUInteger, KLineNowPressButtonMode) {
    //左移按钮按中
    KLNPB_Mode_LeftButton,
    //右移按钮按中
    KLNPB_Mode_RightButton,
    //当前无按钮被按中
    KLNPB_Mode_NoneButton,
};

// k线当前横屏移动模式显示
typedef NS_ENUM(NSUInteger, KLineHoriModeMove) {
    //移动图像模式
    KLHMM_PICMOVE,
    //移动指标模式
    KLHMM_INDEXMOVE,
};

// 指标线类型
typedef NS_ENUM(NSUInteger, IndicatorLineType) {
    indicatorVOL,
    indicatorMACD,
    indicatorKDJ,
    indicatorRSI,
    indicatorBOLL,
    indicatorBRAR,
    indicatorOBV,
    indicatorDMI,
    indicatorBIAS,
    indicatorWR,
};

#endif
