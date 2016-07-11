//
//  LHCalendarDateModel.m
//  LHCalender
//
//  Created by luhao on 16/5/7.
//  Copyright © 2016年 luhao. All rights reserved.
//

#import "LHCalendarDateModel.h"
#import "NSDate+LHExtension.h"
#import <UIKit/UIKit.h>
#import"LHCalendarConstance.h"

@interface LHCalendarDateModel ()

@property (nonatomic, strong) NSCalendar *calendar; ///< instance of system calendar
@property (nonatomic, strong) NSDate *miniDate; ///< minimized date that will displayed in calendar
@property (nonatomic, strong) NSDate *maxDate; ///< maxiumum date that will displayed in calendar
@property (nonatomic, assign, readwrite) NSInteger numberOfMonth; ///< the number of month
@property (nonatomic, assign, readwrite) NSInteger numberOfWeek; ///< the number of weed
@property (nonatomic, assign, readwrite) LHCalendarScope calendarScope; ///< calendar scope

@end

@implementation LHCalendarDateModel

#pragma mark - override
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self privateInitial];
    }
    return self;
}

#pragma mark - private method

- (void)privateInitial
{
    _miniDate = [NSDate lh_dataWithYear:1970 month:1 day:1];
    _maxDate = [NSDate lh_dataWithYear:2099 month:12 day:31];
    
    _calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    _calendar.timeZone = [NSTimeZone localTimeZone];
    
    _numberOfMonth = [self monthNumberWithStart:_miniDate end:_maxDate];
    _numberOfWeek = [self weekNumberWithStart:_miniDate end:_maxDate];
    
    _calendarScope = LHCalendarScopeMonthly;
    _numberOfRow = 42;
    _numberOfSection = _numberOfMonth;
    
}

// calucate the number of month with specified startDate and endDate
-  (NSInteger)weekNumberWithStart:(NSDate *)startDate end:(NSDate *)endDate
{
    return [startDate intervalNumberOfWeekTo:endDate];
}

// calucate the number of month with specified startDate and endDate
- (NSInteger)monthNumberWithStart:(NSDate *)startDate end:(NSDate *)endDate
{
    return [startDate intervalNumberOfMonthTo:endDate];
}


- (NSInteger)numberOfHeadPlaceholderForMonth:(NSDate *)month
{
    // sunday is 1
    NSInteger weekday = [month lh_weekday];
    NSInteger placeNumber = weekday-2 >= 0 ? (weekday-2) : 7+(weekday-2);
    //NSLog(@"%@ \n%ld", month, (long)weekday);
    return placeNumber;
}

#pragma mark - public method
- (NSDate *)dataWithIndexPath:(NSIndexPath *)indexPath
{
    if (self.calendarScope == LHCalendarScopeMonthly) {
        
        NSDate *firstDayThisMonth = [self.miniDate.lh_firstDayOfMonth lh_dateByAddingMonths:indexPath.section];
        NSInteger offsetDayWithFirstMonth = [self numberOfHeadPlaceholderForMonth:firstDayThisMonth];
        
        NSInteger column = LHCalendarFloor(indexPath.row/6);
        NSInteger row = indexPath.row % 6;
        
        NSInteger offsetDay = 7*row + column;
        NSDate *date = [firstDayThisMonth lh_dateByAddingDays:offsetDay - offsetDayWithFirstMonth];
        return date;
        
    } else if (self.calendarScope == LHCalendarScopeWeekly) {
        
        NSInteger miniDateWeekday = self.miniDate.lh_weekday;
        
        // monday correspond weekday is 2
        NSInteger miniDateToSubtract = -(miniDateWeekday - 2 >= 0 ? (miniDateWeekday - 2) : 6);
        NSDate *beginningDate = [self.miniDate lh_dateByAddingDays:miniDateToSubtract];
        NSDate *resultDate = [beginningDate lh_dateByAddingDays:indexPath.section*7 + indexPath.row];
        return resultDate;
    }
    
    return nil;
}

#pragma mark - public method
- (void)setCalendarScope:(LHCalendarScope)scopeType
{
    _calendarScope = scopeType;
    if (_calendarScope == LHCalendarScopeWeekly) {
        _numberOfSection = _numberOfWeek;
        _numberOfRow = 7;
    } else if (_calendarScope == LHCalendarScopeMonthly) {
        _numberOfSection = _numberOfMonth;
        _numberOfRow = 42;
    }
}

- (NSInteger)numberOfOffsetPagesWithDate:(NSDate *)date
{
    NSInteger interval;
    if (_calendarScope == LHCalendarScopeWeekly) {
        interval = [date weekdayOrdinalFromDate:self.miniDate firstWeekday:LHExtensionWeekdayMonday];
    } else if (_calendarScope == LHCalendarScopeMonthly) {
        interval = [self.miniDate intervalNumberOfMonthTo:date];
    }
    return interval;
}

@end
