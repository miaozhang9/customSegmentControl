//
//  YZTColumnViewCell.h
//  YZTColumnManageView
//
//  Created by Apple on 16/4/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YZTColumnViewCellType){
    YZTColumnViewCellTypeUpper,
    YZTColumnViewCellTypeBottom
};

@interface YZTColumnViewCell : UICollectionViewCell

@property (nonatomic, copy)   NSString *data;
@property (nonatomic, assign) YZTColumnViewCellType cellType;

@end
