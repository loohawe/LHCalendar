//
//  LHCollectionViewflowLayout.m
//  LHCalender
//
//  Created by luhao on 16/5/8.
//  Copyright © 2016年 luhao. All rights reserved.
//

#import "LHCollectionViewflowLayout.h"

@implementation LHCollectionViewflowLayout

#pragma mark - override
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        self.itemSize = CGSizeMake(1, 1);
        //self.estimatedItemSize = CGSizeMake(20, 20);
        //self.headerReferenceSize = CGSizeMake(50, 0);
        //self.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
        //self.sectionHeadersPinToVisibleBounds = YES;
        
        self.calendarScope = LHCalendarScopeMonthly;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    if (self.calendarScope == LHCalendarScopeMonthly) {
        CGFloat itemWidth = self.collectionView.bounds.size.width / 7;
        CGFloat itemHeight = self.collectionView.bounds.size.height / 6;
        CGSize itemSize = CGSizeMake(itemWidth, itemHeight);
        self.itemSize = itemSize;
    } else if (self.calendarScope == LHCalendarScopeWeekly) {
        CGFloat itemWidth = self.collectionView.bounds.size.width / 7;
        CGFloat itemHeight = self.collectionView.bounds.size.height;
        CGSize itemSize = CGSizeMake(itemWidth, itemHeight);
        self.itemSize = itemSize;
    }

}

@end
