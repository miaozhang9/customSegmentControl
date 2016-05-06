//
//  ViewController.m
//  YZTFinanceSegmentControl
//
//  Created by Apple on 16/5/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"

#import "YZTSegmentControl.h"

#import "AViewController.h"
#import "BViewController.h"
#import "CViewController.h"
#import "DViewController.h"
#import "EViewController.h"

#import "YZTColumnManageView.h"
#import "Masonry.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


@interface ViewController ()<YZTSegmentControlDelegate,YZTColumnManageViewDelegate>

@property (nonatomic, strong) YZTSegmentControl   *slideSwitchView;
@property (nonatomic, strong) YZTColumnManageView *columnView;

@property (nonatomic, copy)   NSMutableArray    *itemArray;
@property (nonatomic, copy)   NSMutableArray    *VCArray;
@property (nonatomic, copy)   NSMutableArray    *columnArray;
@property (nonatomic, strong) UIButton          *rightBtn;

@end

@implementation ViewController
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemArray = [NSMutableArray arrayWithObjects:@"推荐",@"要闻",@"直播",@"选股",@"视频", nil];
    self.VCArray = [NSMutableArray arrayWithObjects:@"AViewController",@"BViewController",@"CViewController",@"DViewController",@"EViewController",nil];
    self.columnArray = [NSMutableArray arrayWithObjects:@"推荐",@"要闻",@"直播",@"选股",@"视频", nil];
    
    [self yzt_buildSegment];
}

#pragma mark - 配置segment
-(void)yzt_buildSegment
{
   
    
    NSMutableDictionary *tmppageViewDic = [NSMutableDictionary new];
    for (int i = 0; i < self.itemArray.count ; i ++ ) {
        [tmppageViewDic setObject:self.VCArray[i] forKey:self.itemArray[i]];
    }
    self.slideSwitchView.pageViewDic = tmppageViewDic;
    
    [self yzt_reloadSegment];
    
    [self.view addSubview:self.rightBtn];
    [self yzt_reloadColumn];

}

- (void)yzt_reloadSegment
{
    self.slideSwitchView.channelName = self.itemArray;
    NSMutableArray *pageVCs = [NSMutableArray new];
    for (NSString *title in self.itemArray) {
        
        Class VCClass = NSClassFromString([self.slideSwitchView.pageViewDic objectForKey:title]);
        UIViewController *vc = [[VCClass alloc] init];
        [pageVCs addObject:vc];
    }
    self.slideSwitchView.viewControllers = pageVCs;

    
}

- (void)yzt_reloadColumn
{
    self.columnView.upperArray = [NSMutableArray arrayWithArray:self.columnArray];
    self.columnView.bottomArray = [NSMutableArray array];
}

#pragma mark YZTColumnManageViewDelegate
- (void)columnManageView:(YZTColumnManageView *)manageView withTitleArray:(NSMutableArray *)titleArray
{
    
    self.itemArray = titleArray;
    
    [self yzt_reloadSegment];
    
    WS(weakSelf);
    [UIView animateWithDuration:0.5 animations:^{
        [self.columnView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_top).offset(0);
        }];
        [weakSelf loadViewIfNeeded];
    }];
    
}


#pragma mark setter method
- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat viewWidth = CGRectGetWidth(self.view.frame);
        [_rightBtn setImage:[UIImage imageNamed:@"nav_more@2x"] forState:UIControlStateNormal];
        [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
        _rightBtn.frame = CGRectMake(viewWidth - 40, 20, 40, 44);
        _rightBtn.backgroundColor = [UIColor colorWithRed:46.0f/255.0f green:70.0f/255.0f blue:132.0f/255.0f alpha:1.0f];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (YZTColumnManageView *)columnView
{
    if (!_columnView) {
        _columnView = [[YZTColumnManageView alloc] init];
        _columnView.delegate = self;
        [self.view addSubview:_columnView];
        [_columnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.bottom.equalTo(self.view.mas_top).offset(0);
            make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.view.frame), 280));
        }];
    }
    return _columnView;
}

- (YZTSegmentControl *)slideSwitchView
{
    if (!_slideSwitchView) {
        _slideSwitchView = [[YZTSegmentControl alloc] initWithFrame:CGRectMake(0 , 20 , self.view.frame.size.width, self.view.frame.size.height - 20)];
        _slideSwitchView.segmentController = self;
        _slideSwitchView.delegate = self;
        [_slideSwitchView setUserInteractionEnabled:YES];
        [self.view addSubview:_slideSwitchView];
    }
    return _slideSwitchView;
}


#pragma mark event response
- (void)rightBtnClick
{
    WS(weakSelf);
    [UIView animateWithDuration:0.5 animations:^{
        [self.columnView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_top).offset(20 + 280);
        }];
        [self.view bringSubviewToFront:self.columnView];
        [weakSelf loadViewIfNeeded];
    }];
}

@end
