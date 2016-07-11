//
//  LHCalendarCollectionCell.m
//  LHCalender
//
//  Created by luhao on 16/5/7.
//  Copyright © 2016年 luhao. All rights reserved.
//

#import "LHCalendarCollectionCell.h"
#import "UIView+LHExtension.h"
#import "NSDate+LHExtension.h"

@implementation LHCalendarCollectionCell

#pragma mark - override

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.lh_width = self.lh_width-2;
        label.lh_height = self.lh_height-2;
        label.lh_centralX = self.lh_width/2;
        label.lh_centralY = self.lh_height/2;
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"15";
        label.textAlignment = NSTextAlignmentCenter;
        self.titleLabel = label;
        [self.contentView addSubview:label];
    }
    return self;
}

#pragma mark - get and set
- (void)setDate:(NSDate *)date
{
    if (date == nil) return;
    _date = date;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%ld", (long)date.lh_day];
}

- (BOOL)isSelected
{
    return [super isSelected];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        self.titleLabel.backgroundColor = [UIColor cyanColor];
    } else {
        self.titleLabel.backgroundColor = [UIColor whiteColor];
    }
}

@end
