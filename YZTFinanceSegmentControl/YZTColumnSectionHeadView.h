//
//  YZTSectionHeadView.h
//  YZTColumnManageView
//
//  Created by Apple on 16/5/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YZTSectionHeadViewType){
    YZTSectionHeadViewTypeAdded,
    YZTSectionHeadViewTypeNotAdded
};


@interface YZTColumnSectionHeadView : UICollectionReusableView

@property (nonatomic, assign) YZTSectionHeadViewType sectionType;

@end
