//
//  NSDate+LHExtension.m
//  LHCalender
//
//  Created by luhao on 16/5/7.
//  Copyright © 2016年 luhao. All rights reserved.
//

#import "NSDate+LHExtension.h"

@implementation NSDate (LHExtension)

+ (NSDate *)lh_dataWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSCalendar *calendar = [NSCalendar lh_sharedCalendar];
    NSDateComponents *components = [NSDateComponents lh_sharedDateComponents];
    components.year = year;
    components.month = month;
    components.day = day;
    NSDate *date = [calendar dateFromComponents:components];
    
    //earse components
    components.year = NSIntegerMax;
    components.month = NSIntegerMax;
    components.day = NSIntegerMax;
    
    return date;
}

#pragma mark - get and set
- (NSInteger)lh_day
{
    NSCalendar *calendar = [NSCalendar lh_sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay fromDate:self];
    return component.day;
}

- (NSInteger)lh_weekday
{
    NSCalendar *calendar = [NSCalendar lh_sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitWeekday fromDate:self];
    return component.weekday;
}

- (NSInteger)lh_weekdayOfYear
{
    NSCalendar *calendar = [NSCalendar lh_sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitWeekOfYear fromDate:self];
    return component.weekOfYear;
}

- (NSDate *)lh_firstDayOfMonth
{
    NSCalendar *calendar = [NSCalendar lh_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth| NSCalendarUnitDay fromDate:self];
    components.day = 1;
    return [calendar dateFromComponents:components];
}

//sunday is 1, monday is 2

- (NSDate *)lh_firstDayOfWeekWithFirstWeekday:(LHExtensionWeekday)firstDay
{
    NSCalendar *calendar = [NSCalendar lh_sharedCalendar];
    calendar.firstWeekday = firstDay;
    NSDateComponents *weekdayComponent = [calendar components:NSCalendarUnitWeekday fromDate:self];
    NSDateComponents *componentsToSubtract = [NSDateComponents lh_sharedDateComponents];
    NSInteger toSubtractNum = weekdayComponent.weekday - calendar.firstWeekday;
    if (toSubtractNum < 0) {
        toSubtractNum = 7 + toSubtractNum;
    }
    componentsToSubtract.day = -(toSubtractNum);
    NSDate *beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:beginningOfWeek];
    beginningOfWeek = [calendar dateFromComponents:components];
    componentsToSubtract.day = NSIntegerMax;
    calendar.firstWeekday = LHExtensionWeekdaySunday;
    return beginningOfWeek;
}

#pragma mark - public method

- (NSDate *)lh_dateByAddingDays:(NSInteger)days
{
    NSCalendar *calendar = [NSCalendar lh_sharedCalendar];
    NSDateComponents *component = [NSDateComponents lh_sharedDateComponents];
    component.day = days;
    NSDate *date = [calendar dateByAddingComponents:component toDate:self options:0];
    component.day = NSIntegerMax;
    return date;
}

- (NSDate *)lh_dateByAddingWeeks:(NSInteger)weeks
{
    NSCalendar *calendar = [NSCalendar lh_sharedCalendar];
    NSDateComponents *components = [NSDateComponents lh_sharedDateComponents];
    components.weekOfYear = weeks;
    NSDate *date = [calendar dateByAddingComponents:components toDate:self options:0];
    components.weekOfYear = NSIntegerMax;
    return date;
}

- (NSDate *)lh_dateByAddingMonths:(NSInteger)months
{
    NSCalendar *calendar = [NSCalendar lh_sharedCalendar];
    NSDateComponents *component = [NSDateComponents lh_sharedDateComponents];
    component.month = months;
    NSDate *date = [calendar dateByAddingComponents:component toDate:self options:0];
    component.month = NSIntegerMax;
    return date;
}

- (NSInteger)intervalNumberOfMonthTo:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar lh_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self toDate:date options:0];
    return components.month;
}

- (NSInteger)intervalNumberOfWeekTo:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar lh_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekdayOrdinal fromDate:self toDate:date options:0];
    return components.weekdayOrdinal;
}

- (NSInteger)weekdayOrdinalInThisMonthWithFirstWeedDay:(LHExtensionWeekday)firstWeekDay
{
    NSDate *firstDay = self.lh_firstDayOfMonth;
    NSDate *caculateFirstDay = [firstDay lh_firstDayOfWeekWithFirstWeekday:firstWeekDay];
    return [caculateFirstDay intervalNumberOfWeekTo:self];
}

- (NSInteger)weekdayOrdinalFromDate:(NSDate *)fromdate firstWeekday:(LHExtensionWeekday)firstweekday
{
    NSDate *caculateFirstDay = [fromdate lh_firstDayOfWeekWithFirstWeekday:firstweekday];
    return [caculateFirstDay intervalNumberOfWeekTo:self];
}

@end

@implementation NSCalendar (LHExtension)

+ (instancetype)lh_sharedCalendar
{
    static id instance;
    static dispatch_once_t lh_sharedCalendar_onceTocken;
    dispatch_once(&lh_sharedCalendar_onceTocken, ^{
        instance = [NSCalendar currentCalendar];
    });
    return instance;
}

@end

@implementation NSDateComponents (LHExtension)

+ (instancetype)lh_sharedDateComponents
{
    static id instance;
    static dispatch_once_t lh_sharedDateComponents_onceTocken;
    dispatch_once(&lh_sharedDateComponents_onceTocken, ^{
        instance = [[NSDateComponents alloc] init];
    });
    return instance;
}

@end

