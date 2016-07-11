//
//  LHCalendarCollectionCell.h
//  LHCalender
//
//  Created by luhao on 16/5/7.
//  Copyright © 2016年 luhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHCalendarCollectionCell : UICollectionViewCell

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) NSDate *date;
@property (nonatomic, getter=isSelected) BOOL selected;

@end
