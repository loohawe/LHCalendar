//
//  NSDate+LHExtension.h
//  LHCalender
//
//  Created by luhao on 16/5/7.
//  Copyright © 2016年 luhao. All rights reserved.
//

typedef enum {
    LHExtensionWeekdaySunday = 1,
    LHExtensionWeekdayMonday,
    LHExtensionWeekdayTuesday,
    LHExtensionWeekdayWednesday,
    LHExtensionWeekdayThursday,
    LHExtensionWeekdayFriday,
    LHExtensionWeekdaySaturday,
}LHExtensionWeekday;

#import <Foundation/Foundation.h>

@interface NSDate (LHExtension)

@property (readonly, nonatomic) NSInteger lh_day;
@property (readonly, nonatomic) NSInteger lh_weekday; //sunday is 1, monday is 2
@property (readonly, nonatomic) NSInteger lh_weekdayOfYear;

@property (readonly, nonatomic) NSDate *lh_firstDayOfMonth;

/**
 *  +--------------------------------+
 *  | 一 | 二 | 三 | 四 | 五 | 六 | 日 |
 *  +--------------------------------+
 *  | 29 | 30 | 31 | 1 | 2  | 3 | 4  |
 *  |--------------------------------+
 *  example : if the day is 1,
 *  first weekday is monday
 *  follow method return the day 29.
 *
 *  else example : if the day is 2
 *  first weekday is Saturday
 *  follow method return the day 27
 **/
- (NSDate *)lh_firstDayOfWeekWithFirstWeekday:(LHExtensionWeekday)firstDay;

- (NSDate *)lh_dateByAddingDays:(NSInteger)days;
- (NSDate *)lh_dateByAddingWeeks:(NSInteger)weeks;
- (NSDate *)lh_dateByAddingMonths:(NSInteger)months;

+ (NSDate *)lh_dataWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

/*!
 *  @author luhao, 16-05-25 20:05:26
 *
 *  @brief caculate interval number of month/week which from this day to specified date
 *
 *  @param date date
 *
 *
 *  @return interval number
 */
- (NSInteger)intervalNumberOfMonthTo:(NSDate *)date;
- (NSInteger)intervalNumberOfWeekTo:(NSDate *)date;

/*!
 *  @author luhao, 16-05-26 21:05:39
 *
 *  @brief caculate weekday ordinal number in this month
 *
 *  @param firstWeekDay specifice which week day as first day of week
 *
 *  @return example 1th 5 2016 return 1, 2od 5 2016 return 2
 */
- (NSInteger)weekdayOrdinalInThisMonthWithFirstWeedDay:(LHExtensionWeekday)firstWeekDay;

/*!
 *  @author luhao, 16-05-31 19:05:37
 *
 *  @brief caculate weekday ordinal number from specitify fromdate to self date
 *
 *  @param fromdate     : from date
 *  @param firstweekday : the first day of week you want to specitify
 *
 *  @return weekday ordinal number
 */
- (NSInteger)weekdayOrdinalFromDate:(NSDate *)fromdate firstWeekday:(LHExtensionWeekday)firstweekday;

@end

@interface NSCalendar (LHExtension)

+ (instancetype)lh_sharedCalendar;

@end

@interface NSDateComponents (LHExtension)

+ (instancetype)lh_sharedDateComponents;

@end
