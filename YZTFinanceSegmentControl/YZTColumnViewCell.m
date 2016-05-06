//
//  YZTColumnViewCell.m
//  YZTColumnManageView
//
//  Created by Apple on 16/4/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YZTColumnViewCell.h"
#import "Masonry.h"

@interface YZTColumnViewCell()

@property (nonatomic, strong) UILabel *textLab;

@end

@implementation YZTColumnViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _textLab = [[UILabel alloc] init];
        _textLab.textAlignment = NSTextAlignmentCenter;
        _textLab.layer.cornerRadius = (CGRectGetHeight(self.frame) - 20)/2.0;
        _textLab.layer.masksToBounds = YES;
        [self.contentView addSubview:self.textLab];
        [_textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
    }
    return self;
}

- (void)setData:(NSString *)data
{
    _textLab.text = data;
}

- (void)setCellType:(YZTColumnViewCellType)cellType
{
    _cellType = cellType;
    switch (cellType) {
        case YZTColumnViewCellTypeUpper:{
            _textLab.backgroundColor = [UIColor colorWithRed:46/255.0f green:70/255.0f blue:132/255.0f alpha:1];
            _textLab.textColor = [UIColor whiteColor];
            
        }
            break;
        case YZTColumnViewCellTypeBottom:{
            _textLab.backgroundColor = [UIColor clearColor];
            _textLab.textColor = [UIColor colorWithRed:127/255.0f green:127/255.0f blue:127/255.0f alpha:1];
            _textLab.layer.borderWidth = 1.0;
            _textLab.layer.borderColor = [UIColor colorWithRed:46/255.0f green:70/255.0f blue:132/255.0f alpha:1].CGColor;
        }
            break;
        default:
            break;
    }
}

@end
