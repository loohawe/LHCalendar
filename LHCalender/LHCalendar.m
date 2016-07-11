//
//  LHCalendar.m
//  LHCalender
//
//  Created by luhao on 16/5/6.
//  Copyright © 2016年 luhao. All rights reserved.
//

#import "LHCalendar.h"
#import "LHCalendarCollectionView.h"
#import "LHCalendarDateModel.h"
#import "LHCalendarCollectionCell.h"
#import "LHCollectionViewflowLayout.h"
#import "NSDate+LHExtension.h"

#define LHCalendarSlideUpThreshold 150
#define LHCalendarSlideDownThresHold -100

@interface LHCalendar () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    ///< follow property use to gesture swipe
    CGPoint _touchStartPoint;
    CGRect _calendarSnapshotFrame;
    CGFloat _offsetY;
    LHCalendarScope _calendarScopeTouchBegin;
    CGRect _calendarCollectionTouchBeginFrame;
    BOOL _touchHasBeginFlag;
    BOOL _touchHasMovedFlag;
    
    ///< offset on Y to pin week view
    CGFloat _offsetYToPin;
}

@property (nonatomic, strong) LHCalendarCollectionView *calendarCollection; ///< calendar collection view
@property (nonatomic, strong) LHCalendarDateModel *dateModel; ///< calendar date provider
@property (nonatomic, strong) LHCollectionViewflowLayout *calendarFlowLayout; ///< flow layout use specify to calendarCollection
@property (nonatomic, strong) UIView *calendarSnapshot; ///< snapshot of calendarCollection
@property (nonatomic, strong) NSDate *selectedDate; ///< setected date

@end

@implementation LHCalendar

#pragma mark - override
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self privateInitial];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark touch event
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return [super pointInside:point withEvent:event];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // NSLog(@"LHCalendar hitTest!!!");
    return [super hitTest:point withEvent:event];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // NSLog(@"began");
    [super touchesBegan:touches withEvent:event];
    
    _touchHasBeginFlag = YES;
    
    _touchStartPoint = [[touches anyObject] locationInView:self];
    _calendarScopeTouchBegin = self.calendarScope;
    _offsetY = 0;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // NSLog(@"end");
    [super touchesEnded:touches withEvent:event];
    
    [self touchEndedAndCanceled];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // NSLog(@"moving");
    [super touchesMoved:touches withEvent:event];
    
    CGPoint currentP = [[touches anyObject] locationInView:self];
    _offsetY = _touchStartPoint.y - currentP.y;
    
    if (_calendarScopeTouchBegin == LHCalendarScopeMonthly) {
        
        if (_offsetY > 0) { // swipe up
            
            [self readyToTouchMove];
            
            self.calendarCollection.scrollEnabled = NO;
            self.calendarSnapshot.hidden = NO;
            
            if (_offsetY >= _offsetYToPin) {
                [self setCalendarScope:LHCalendarScopeWeekly];
                self.calendarCollection.hidden = NO;
            } else {
                self.calendarCollection.hidden = YES;
                [self setCalendarScope:LHCalendarScopeMonthly];
            }
            
            CGRect snapshotFrame = self.calendarSnapshot.frame;
            snapshotFrame.origin.y = _calendarSnapshotFrame.origin.y - (_offsetY-0);
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.calendarSnapshot.frame = snapshotFrame;
            } completion:nil];
        }
        
    } else if (_calendarScopeTouchBegin == LHCalendarScopeWeekly) {
        
        if (_offsetY < 0) { // swipe down
            
            [self readyToTouchMove];
            
            self.calendarCollection.scrollEnabled = NO;
            
            if (_offsetY < (_offsetYToPin - ((self.bounds.size.height/6) * 5))) {
                self.calendarSnapshot.hidden = YES;
            } else {
                self.calendarSnapshot.hidden = NO;
            }
            
            CGRect snapshotFrame = _calendarCollectionTouchBeginFrame;
            snapshotFrame.origin.y = _calendarCollectionTouchBeginFrame.origin.y - (_offsetY+0);
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.calendarCollection.frame = snapshotFrame;
            } completion:nil];
        }
    }
    
    _touchHasMovedFlag = YES;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // NSLog(@"cancel");
    [super touchesCancelled:touches withEvent:event];
    
    [self touchEndedAndCanceled];
}

#pragma mark - private method

//property initial
- (void)privateInitial
{
    _selectedDate = [NSDate date];
    
    _calendarScope = LHCalendarScopeMonthly;
    _dateModel = [[LHCalendarDateModel alloc] init];
    _dateModel.calendarScope = _calendarScope;
    
    _calendarFlowLayout = [[LHCollectionViewflowLayout alloc] init];
    _calendarFlowLayout.calendarScope = _calendarScope;
    
    _calendarCollection = [[LHCalendarCollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) collectionViewLayout:_calendarFlowLayout];
    _calendarCollection.showsHorizontalScrollIndicator = YES;
    _calendarCollection.showsVerticalScrollIndicator = NO;
    _calendarCollection.pagingEnabled = YES;
    _calendarCollection.dataSource = self;
    _calendarCollection.delegate = self;
    [_calendarCollection registerClass:[LHCalendarCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([LHCalendarCollectionCell class])];
    [_calendarCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    [self setSelectedDate:_selectedDate animated:NO];
    [self addSubview:self.calendarCollection];
}

//reload cell use dataSource
- (void)reloadDataForCell:(LHCalendarCollectionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.date = [self.dateModel dataWithIndexPath:indexPath];
}

//when calendar slide up or down, must do something ready work
- (void)readyToTouchMove
{
    if (_touchHasBeginFlag) {
        
        self.calendarSnapshot = [self.calendarCollection snapshotViewAfterScreenUpdates:YES];
        self.calendarSnapshot.frame = CGRectMake(0, 0, self.calendarCollection.bounds.size.width, self.calendarCollection.bounds.size.height);
        self.calendarSnapshot.hidden = YES;
        _calendarSnapshotFrame = self.calendarSnapshot.frame;
        if (_calendarScopeTouchBegin == LHCalendarScopeMonthly) {
            
            [self insertSubview:self.calendarSnapshot belowSubview:self.calendarCollection];
            
        } else if (_calendarScopeTouchBegin == LHCalendarScopeWeekly) {
            
            [self insertSubview:self.calendarSnapshot aboveSubview:self.calendarCollection];
            
            self.calendarSnapshot.hidden = NO;
            [self setCalendarScope:LHCalendarScopeMonthly];
            self.calendarCollection.frame = CGRectMake(0, -((self.bounds.size.height/6) * 5), self.bounds.size.width, self.bounds.size.height);
            self.calendarCollection.hidden = NO;
            _calendarCollectionTouchBeginFrame = self.calendarCollection.frame;
        }
        
        _touchHasBeginFlag = NO;
    }
}

- (void)touchEndedAndCanceled
{
    if (_touchHasMovedFlag) { //the touch event is moved
        if (_calendarScopeTouchBegin == LHCalendarScopeMonthly) {
            
            if (_offsetY > LHCalendarSlideUpThreshold) {
                
                [self setCalendarScope:LHCalendarScopeWeekly];
                self.calendarCollection.hidden = NO;
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.calendarSnapshot.frame = CGRectMake(0, -736, _calendarSnapshot.frame.size.width, _calendarSnapshot.frame.size.height);
                } completion:^(BOOL finished) {
                    [self.calendarSnapshot removeFromSuperview];
                    self.calendarCollection.scrollEnabled = YES;
                }];
                
            } else if (0 <= _offsetY && _offsetY <= LHCalendarSlideUpThreshold) {
                
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.calendarSnapshot.frame =  _calendarSnapshotFrame;
                } completion:^(BOOL finished) {
                    [self.calendarSnapshot removeFromSuperview];
                    self.calendarCollection.hidden = NO;
                    self.calendarCollection.scrollEnabled = YES;
                }];
                
            } else {
                
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.calendarSnapshot.frame =  _calendarSnapshotFrame;
                } completion:^(BOOL finished) {
                    [self.calendarSnapshot removeFromSuperview];
                    self.calendarCollection.hidden = NO;
                    self.calendarCollection.scrollEnabled = YES;
                }];
                
            }
            
        } else if (_calendarScopeTouchBegin == LHCalendarScopeWeekly) {
            
            if (_offsetY < LHCalendarSlideDownThresHold) {
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.calendarCollection.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                } completion:^(BOOL finished) {
                    [self.calendarSnapshot removeFromSuperview];
                    self.calendarCollection.scrollEnabled = YES;
                }];
            } else if (LHCalendarSlideDownThresHold <= _offsetY && _offsetY <= 0) {
                
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.calendarCollection.frame = _calendarCollectionTouchBeginFrame;
                } completion:^(BOOL finished) {
                    [self setCalendarScope:LHCalendarScopeWeekly];
                    self.calendarCollection.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/6);
                    self.calendarCollection.hidden = NO;
                    [self.calendarSnapshot removeFromSuperview];
                    self.calendarCollection.scrollEnabled = YES;
                }];
                
            } else {
                
                [self setCalendarScope:LHCalendarScopeWeekly];
                self.calendarCollection.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/6);
                self.calendarCollection.hidden = NO;
                [self.calendarSnapshot removeFromSuperview];
                self.calendarCollection.scrollEnabled = YES;
                
            }
        }
        
        _touchHasMovedFlag = NO;
    }
}

- (void)setSelectedDate:(NSDate *)date animated:(BOOL)animated
{
    _selectedDate = date;
    CGFloat offsetX = self.calendarCollection.frame.size.width * [self.dateModel numberOfOffsetPagesWithDate:date];
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.calendarCollection setContentOffset:offset animated:animated];
    
    NSInteger offsetYToPinUnit = [_selectedDate weekdayOrdinalInThisMonthWithFirstWeedDay:LHExtensionWeekdayMonday];
    _offsetYToPin = (self.bounds.size.height / 6) * (offsetYToPinUnit);
}

#pragma mark - get and set

//over setFrame
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.calendarCollection.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)setCalendarScope:(LHCalendarScope)calendarScope
{
    if (_calendarScope == calendarScope) return;
    
    _calendarScope = calendarScope;
    self.calendarFlowLayout.calendarScope = _calendarScope;
    self.dateModel.calendarScope = _calendarScope;
    [self.calendarCollection setCollectionViewLayout:self.calendarFlowLayout];
    [self.calendarCollection reloadData];
    
    if (_calendarScope == LHCalendarScopeWeekly) {
        self.calendarCollection.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/6);
        [self setSelectedDate:self.selectedDate animated:NO];
    } else if (_calendarScope == LHCalendarScopeMonthly) {
        self.calendarCollection.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self setSelectedDate:self.selectedDate animated:NO];
    }
}

#pragma mark - delegete
#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //LHLog(@"get number of section");
    return self.dateModel.numberOfSection;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //LHLog(@"get number of row in section %ld", (long)section);
    return self.dateModel.numberOfRow;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //LHLog(@"dequeue cell at index %ld-%ld", indexPath.section, indexPath.row);
    LHCalendarCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LHCalendarCollectionCell class]) forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor grayColor];
    [self reloadDataForCell:cell atIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
    view.backgroundColor = [UIColor lightGrayColor];
    //LHLog(@"dequeue header at index %ld-%ld", indexPath.section, indexPath.row);
    return view;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", indexPath);
    NSDate *clickedDate = [self.dateModel dataWithIndexPath:indexPath];
    [self setSelectedDate:clickedDate animated:NO];
}

#pragma mark <UICollectionViewDelegateFlowLayout>

#pragma mark <UICollectionViewDelegate>
- (BOOL)collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath
{
    LHLog(@"call canFocusItems at %ld-%ld", indexPath.section, indexPath.row);
    if (indexPath.section == 0 && indexPath.row == 5) {
        return YES;
    }
    return NO;
}

@end
