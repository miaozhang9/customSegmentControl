//
//  YZTColumnManageView.m
//  YZTColumnManageView
//
//  Created by Apple on 16/4/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YZTColumnManageView.h"
#import "YZTColumnViewCell.h"
#import "YZTColumnSectionHeadView.h"
#import "Masonry.h"

static NSString *cellId = @"cellId";
static NSString *headId = @"headId";

#define cellWidth ([[UIScreen mainScreen] bounds].size.width - 10*5)/4
#define cellHeight 50

@interface YZTColumnManageView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *collectionHeadView;
@property (nonatomic, strong) UIView *tempMoveCell;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, strong) NSIndexPath *originalIndexPath;
@property (nonatomic, strong) NSIndexPath *moveIndexPath;

@end

@implementation YZTColumnManageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.collectionView.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
        
    }
    return self;
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.upperArray.count;
    }else{
        return self.bottomArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YZTColumnViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.data = [self.upperArray objectAtIndex:indexPath.row];
        cell.cellType = YZTColumnViewCellTypeUpper;
        
        
    }else{
        cell.data = [self.bottomArray objectAtIndex:indexPath.row];
        cell.cellType = YZTColumnViewCellTypeBottom;
    }
     return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    YZTColumnSectionHeadView *headView = (YZTColumnSectionHeadView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headId forIndexPath:indexPath];
    if (indexPath.section == 0)
    {
        headView.sectionType = YZTSectionHeadViewTypeAdded;
    }else{
        
        headView.sectionType = YZTSectionHeadViewTypeNotAdded;
    }
    return headView;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *text = [self.upperArray objectAtIndex:indexPath.row];
        if (![text isEqualToString:@"推荐"] && self.upperArray.count > 4) {
            [self.upperArray removeObject:text];
            [self.bottomArray addObject:text];
            [self.collectionView reloadData];
        }
    }else{
        NSString *text = [self.bottomArray objectAtIndex:indexPath.row];
        [self.bottomArray removeObject:text];
        [self.upperArray addObject:text];
        [self.collectionView reloadData];
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(cellWidth, cellHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.frame.size.width, 44);
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5,5,5,5);
}

#pragma mark event response
- (void)longPressMethod:(UILongPressGestureRecognizer *)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self yzt_gestureBegan:longPress];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self yzt_gestureChange:longPress];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [self yzt_gestureEndOrCancle:longPress];
        }
            break;
        default:
            break;
    }
}

- (void)buttonClick
{
    if ([self.delegate respondsToSelector:@selector(columnManageView:withTitleArray:)]) {
        [self.delegate columnManageView:self withTitleArray:self.upperArray];
    }
}

#pragma mark private method
- (void)yzt_addGesture
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
    longPress.delegate = self;
    [_collectionView addGestureRecognizer:longPress];
}

- (void)yzt_gestureBegan:(UILongPressGestureRecognizer *)longPress
{
    _originalIndexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
    NSString *text = [self.upperArray objectAtIndex:_originalIndexPath.row];

    if (_originalIndexPath != nil && _originalIndexPath.section == 0 && ![text isEqualToString:@"推荐"]) {
        YZTColumnViewCell *cell = (YZTColumnViewCell *)[self.collectionView cellForItemAtIndexPath:_originalIndexPath];
        cell.hidden = YES;
        _tempMoveCell = [cell snapshotViewAfterScreenUpdates:NO];
        _tempMoveCell.frame = cell.frame;
        [self.collectionView addSubview:_tempMoveCell];
         _lastPoint = [longPress locationOfTouch:0 inView:longPress.view];
    }
}

- (void)yzt_gestureChange:(UILongPressGestureRecognizer *)longPress
{
    CGFloat tranX = [longPress locationOfTouch:0 inView:longPress.view].x - _lastPoint.x;
    CGFloat tranY = [longPress locationOfTouch:0 inView:longPress.view].y - _lastPoint.y;
    _tempMoveCell.center = CGPointApplyAffineTransform(_tempMoveCell.center, CGAffineTransformMakeTranslation(tranX, tranY));
    _lastPoint = [longPress locationOfTouch:0 inView:longPress.view];
    
    NSIndexPath *index = [self.collectionView indexPathForItemAtPoint:_lastPoint];
    if (index.row != 0) {
        [self yzt_moveCell];
    }
}

- (void)yzt_gestureEndOrCancle:(UILongPressGestureRecognizer *)longPress
{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:_originalIndexPath];
    [UIView animateWithDuration:0.25 animations:^{
        _tempMoveCell.center = cell.center;
    } completion:^(BOOL finished) {
        [_tempMoveCell removeFromSuperview];
        cell.hidden = NO;
    }];
}

- (void)yzt_moveCell
{
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]){

        if ([self.collectionView indexPathForCell:cell].section == 0) {
            //计算中心距
            CGFloat spacingX = fabs(_tempMoveCell.center.x - cell.center.x);
            CGFloat spacingY = fabs(_tempMoveCell.center.y - cell.center.y);
            if (spacingX <= _tempMoveCell.bounds.size.width / 2.0f && spacingY <= _tempMoveCell.bounds.size.height / 2.0f) {
                _moveIndexPath = [self.collectionView indexPathForCell:cell];
                //更新数据源
                [self yzt_updateSourseData];
                
                //移动
                [self.collectionView moveItemAtIndexPath:_originalIndexPath toIndexPath:_moveIndexPath];
                
                //设置移动后的起始indexPath
                _originalIndexPath = _moveIndexPath;
                break;
            }
        }
    }
}

- (void)yzt_updateSourseData
{
    id objc = [self.upperArray objectAtIndex:_originalIndexPath.row];
    [self.upperArray removeObject:objc];
    [self.upperArray insertObject:objc atIndex:_moveIndexPath.row];
}

#pragma mark setter && getter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layOut];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[YZTColumnViewCell class] forCellWithReuseIdentifier:cellId];
        [_collectionView registerClass:[YZTColumnSectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headId];
        [self yzt_addGesture];
        
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.top.equalTo(self.collectionHeadView.mas_bottom);
        }];
    }
    return _collectionView;
}

- (UIView *)collectionHeadView
{
    if (!_collectionHeadView) {
        _collectionHeadView = [[UIView alloc] init];
        _collectionHeadView.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
        [self addSubview:_collectionHeadView];
        [_collectionHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(44);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"栏目管理";
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16];
        [_collectionHeadView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_collectionHeadView);
            make.width.mas_equalTo(80);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [_collectionHeadView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(_collectionHeadView);
            make.width.mas_equalTo(60);
        }];
        
    }
    return _collectionHeadView;
}

@end
