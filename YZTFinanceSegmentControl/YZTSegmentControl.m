//
//  YZTSegmentControl.m
//  XYYSegmentControl
//
//  Created by Apple on 16/5/5.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "YZTSegmentControl.h"
#import "HMSegmentedControl.h"

#define kHeightOfTopScrollView 44

@interface YZTSegmentControl()<UIScrollViewDelegate>

@property (nonatomic, strong) HMSegmentedControl *hmSegmentedControl;

@end

@implementation YZTSegmentControl

#pragma mark public
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self yzt_initValues];
    }
    return self;
}


#pragma mark private method
- (void)yzt_initValues
{
    [self yzt_createTopView];//创建分布式
    [self yzt_createRootView];

}

//创建标签页
-(void)yzt_createTopView
{
    
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    self.hmSegmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, viewWidth- 40, kHeightOfTopScrollView)];
    self.hmSegmentedControl.sectionTitles = self.channelName;
    self.hmSegmentedControl.selectedSegmentIndex = 0;
    
    //默认colors
    self.hmSegmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.hmSegmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]};
    self.hmSegmentedControl.backgroundColor = [UIColor colorWithRed:46.0f/255.0f green:70.0f/255.0f blue:132.0f/255.0f alpha:1.0f];
    self.hmSegmentedControl.selectionIndicatorColor = [UIColor whiteColor];
    
    //默认style
    self.hmSegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.hmSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
    self.hmSegmentedControl.selectionIndicatorHeight = 1.5;
    self.hmSegmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -1.5, 0);
    self.hmSegmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 18, 0, 18);
    
    [self addSubview:self.hmSegmentedControl];
    
    __weak typeof(self) weakSelf = self;
    [self.hmSegmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf yzt_segmentClicked:index];
    }];
}

//创建根视图
-(void)yzt_createRootView
{
    //创建主滚动视图
    _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeightOfTopScrollView , self.bounds.size.width, self.bounds.size.height - kHeightOfTopScrollView)];
    _rootScrollView.delegate = self;
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.userInteractionEnabled = YES;
    _rootScrollView.bounces = NO;
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.showsVerticalScrollIndicator = NO;
    _rootScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_rootScrollView];
}

//顶部滚动视图逻辑方法
- (void)yzt_segmentClicked:(NSInteger)index
{
    [self.rootScrollView setContentOffset:CGPointMake(index * self.bounds.size.width, 0) animated:NO];
    self.userSelectedChannelID = index;
}


#pragma mark --UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView) {
        _userContentOffsetX = scrollView.contentOffset.x;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
}

//滚动视图释放滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView) {
        //调整顶部滑条按钮状态
        int index = (int)scrollView.contentOffset.x/self.bounds.size.width ;
        [self yzt_segmentClicked:index];
        [self.hmSegmentedControl setSelectedSegmentIndex:index animated:YES];
    }
}

#pragma mark -- 更新视图
-(void)yzt_reloadTopViewData
{
    self.hmSegmentedControl.sectionTitles = self.channelName;
    if (self.userSelectedChannelID >= self.channelName.count) {
        self.userSelectedChannelID = self.channelName.count-1;
    }
    self.hmSegmentedControl.selectedSegmentIndex = self.userSelectedChannelID;
    
    __weak typeof(self) weakSelf = self;
    [self.hmSegmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf yzt_segmentClicked:index];
    }];
}

- (void)updateRootScrollView
{
    
    for (int i = 0; i < self.viewControllers.count; i ++) {
        UIViewController *vc = [self.viewControllers objectAtIndex:i];
        [_rootScrollView addSubview:vc.view];
    }
    
    [self setNeedsLayout];
}

//当横竖屏切换时可通过此方法调整布局
- (void)layoutSubviews
{
    //更新主视图的总宽度
    _rootScrollView.contentSize = CGSizeMake(self.bounds.size.width * [self.viewControllers count], 0);
    //更新主视图各个子视图的宽度
    for (int i = 0; i < [self.viewControllers count]; i++) {
        UIViewController *listVC = self.viewControllers[i];
        listVC.view.frame = CGRectMake(0+_rootScrollView.bounds.size.width*i, 0,
                                       _rootScrollView.bounds.size.width, _rootScrollView.bounds.size.height);
    }
    //滚动到选中的视图
    [_rootScrollView setContentOffset:CGPointMake((_userSelectedChannelID )*self.bounds.size.width, 0) animated:NO];
    
}


#pragma mark setter method
- (void)setDelegate:(id<YZTSegmentControlDelegate>)delegate
{
    _delegate = delegate;
   
}

- (void)setChannelName:(NSMutableArray *)channelName
{
    _channelName = channelName;
    [self yzt_reloadTopViewData];
    
}
- (void)setViewControllers:(NSMutableArray *)viewControllers {
    _viewControllers = viewControllers;
    [self updateRootScrollView];

}
- (void)setPageViewDic:(NSMutableDictionary *)pageViewDic {
    _pageViewDic = pageViewDic;
    
}

- (void)setSegmentController:(UIViewController *)segmentController
{
    _segmentController = segmentController;
}

- (void)setTabItemNormalBackgroundColor:(UIColor *)tabItemNormalBackgroundColor
{
    self.hmSegmentedControl.backgroundColor = tabItemNormalBackgroundColor;
}

- (void)setTabItemNormalColor:(UIColor *)tabItemNormalColor
{
    self.hmSegmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : tabItemNormalColor};
}

- (void)setTabItemSelectedColor:(UIColor *)tabItemSelectedColor
{
    self.hmSegmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : tabItemSelectedColor};
}

- (void)setTabItemSelectionIndicatorColor:(UIColor *)tabItemSelectionIndicatorColor
{
    self.hmSegmentedControl.selectionIndicatorColor = tabItemSelectionIndicatorColor;
}

- (void)setTabSelectionStyle:(YZTSegmentControlSelectionStyle)tabSelectionStyle
{
    HMSegmentedControlSelectionStyle HMSelectionStyle;
    if (tabSelectionStyle == HMSegmentedControlSelectionStyleTextWidthStripe)
    {
        HMSelectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        
    }else if (tabSelectionStyle == HMSegmentedControlSelectionStyleFullWidthStripe)
    {
        HMSelectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        
    }else if (tabSelectionStyle == HMSegmentedControlSelectionStyleBox)
    {
        HMSelectionStyle = HMSegmentedControlSelectionStyleBox;
        
    }else if (tabSelectionStyle == HMSegmentedControlSelectionStyleArrow)
    {
        HMSelectionStyle = HMSegmentedControlSelectionStyleArrow;
        
    }
    self.hmSegmentedControl.selectionStyle = HMSelectionStyle;
}

- (void)setTabSelectionIndicatorLocation:(YZTSegmentControlSelectionIndicatorLocation)tabSelectionIndicatorLocation
{
    HMSegmentedControlSelectionIndicatorLocation selectionIndicatorLocation;
    if (tabSelectionIndicatorLocation == HMSegmentedControlSelectionIndicatorLocationUp)
    {
        selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
        
    }else if (tabSelectionIndicatorLocation == HMSegmentedControlSelectionIndicatorLocationDown)
    {
        selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        
    }else if (tabSelectionIndicatorLocation == HMSegmentedControlSelectionIndicatorLocationNone)
    {
        selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        
    }
    self.hmSegmentedControl.selectionIndicatorLocation = selectionIndicatorLocation;

}



@end
