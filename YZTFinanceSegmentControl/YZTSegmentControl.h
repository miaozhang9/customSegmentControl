//
//  YZTSegmentControl.h
//  XYYSegmentControl
//
//  Created by Apple on 16/5/5.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YZTSegmentControl;

typedef NS_ENUM(NSInteger, YZTSegmentControlSelectionStyle) {
    YZTSegmentControlSelectionStyleTextWidthStripe,
    YZTSegmentControlSelectionStyleFullWidthStripe,
    YZTSegmentControlSelectionStyleBox,
    YZTSegmentControlSelectionStyleArrow
};

typedef NS_ENUM(NSInteger,YZTSegmentControlSelectionIndicatorLocation) {
    YZTSegmentControlSelectionIndicatorLocationUp,
    YZTSegmentControlSelectionIndicatorLocationDown,
    YZTSegmentControlSelectionIndicatorLocationNone
};

@protocol YZTSegmentControlDelegate <NSObject>;

@optional

- (void)slideSwitchView:(YZTSegmentControl *)view didselectTab:(NSUInteger)number;

@end

@interface YZTSegmentControl : UIView
@property (nonatomic, strong) UIScrollView *rootScrollView;
@property (nonatomic, assign) CGFloat      userContentOffsetX;
@property (nonatomic, assign) NSInteger    userSelectedChannelID;

@property (nonatomic, strong) UIColor      *tabItemNormalColor;
@property (nonatomic, strong) UIColor      *tabItemSelectedColor;
@property (nonatomic, strong) UIColor      *tabItemNormalBackgroundColor;
@property (nonatomic, strong) UIColor      *tabItemSelectionIndicatorColor;


@property (nonatomic ,assign) YZTSegmentControlSelectionStyle  tabSelectionStyle;
@property (nonatomic ,assign) YZTSegmentControlSelectionIndicatorLocation tabSelectionIndicatorLocation;
@property (nonatomic, weak)   id<YZTSegmentControlDelegate>delegate;

@property (nonatomic, strong) NSMutableArray    *viewControllers;
@property (nonatomic, strong) NSMutableArray    *channelName;
@property (nonatomic, strong) UIViewController  *segmentController;
@property (nonatomic, strong) NSMutableDictionary *pageViewDic;

@end

