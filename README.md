# customSegmentControl
1.类似网易新闻的Segment  2.实时动态加减分类标签 3.标题，tag, 响应事件，坐标 4.HMSegmentedControl

(1)创建
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

(2)填充测试数据
self.itemArray = [NSMutableArray arrayWithObjects:@"推荐",@"要闻",@"直播",@"选股",@"视频", nil];
    self.VCArray = [NSMutableArray arrayWithObjects:@"AViewController",@"BViewController",@"CViewController",@"DViewController",@"EViewController",nil];
    self.columnArray = [NSMutableArray arrayWithObjects:@"推荐",@"要闻",@"直播",@"选股",@"视频", nil];
    
