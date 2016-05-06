//
//  YZTColumnManageView.h
//  YZTColumnManageView
//
//  Created by Apple on 16/4/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YZTColumnManageView;

@protocol YZTColumnManageViewDelegate <NSObject>

- (void)columnManageView:(YZTColumnManageView *)manageView withTitleArray:(NSMutableArray *)titleArray;

@end

@interface YZTColumnManageView : UIView

@property (nonatomic, strong) NSMutableArray *upperArray;
@property (nonatomic, strong) NSMutableArray *bottomArray;
@property (nonatomic, assign) id<YZTColumnManageViewDelegate>delegate;

@end
