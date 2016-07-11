//
//  UIView+LHExtension.m
//  LHCalender
//
//  Created by luhao on 16/5/8.
//  Copyright © 2016年 luhao. All rights reserved.
//

#import "UIView+LHExtension.h"

@implementation UIView (LHExtension)

- (CGFloat)lh_width
{
    return CGRectGetWidth(self.frame);
}

- (void)setLh_width:(CGFloat)lh_width
{
    self.frame = CGRectMake(self.lh_left, self.lh_top, lh_width, self.lh_height);
}

- (CGFloat)lh_height
{
    return CGRectGetHeight(self.frame);
}

- (void)setLh_height:(CGFloat)lh_height
{
    self.frame = CGRectMake(self.lh_left, self.lh_top, self.lh_width, lh_height);
}

- (CGFloat)lh_top
{
    return CGRectGetMidY(self.frame);
}

- (void)setLh_top:(CGFloat)lh_top
{
    self.frame = CGRectMake(self.lh_left, lh_top, self.lh_width, self.lh_height);
}

- (CGFloat)lh_left
{
    return CGRectGetMinX(self.frame);
}

- (void)setLh_left:(CGFloat)lh_left
{
    self.frame = CGRectMake(lh_left, self.lh_top, self.lh_width, self.lh_height);
}

- (CGFloat)lh_bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setLh_bottom:(CGFloat)lh_bottom
{
    self.lh_top = lh_bottom - self.lh_height;
}

- (CGFloat)lh_right
{
    return CGRectGetMaxX(self.frame);
}

- (void)setLh_right:(CGFloat)lh_right
{
    self.lh_left = lh_right - self.lh_width;
}

- (CGFloat)lh_centralX
{
    return self.lh_left + self.lh_width/2;
}

- (void)setLh_centralX:(CGFloat)lh_centralX
{
    self.lh_left = lh_centralX - self.lh_width/2;
}

- (CGFloat)lh_centralY
{
    return self.lh_top + self.lh_height/2;
}

- (void)setLh_centralY:(CGFloat)lh_centralY
{
    self.lh_top = lh_centralY - self.lh_height/2;
}

@end
