//
//  LHCalendar.h
//  LHCalender
//
//  Created by luhao on 16/5/6.
//  Copyright © 2016年 luhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHCalendarConstance.h"

typedef enum {
    LHCalendarScopeWeekly,
    LHCalendarScopeMonthly,
} LHCalendarScope;

@interface LHCalendar : UIView

@property (nonatomic, assign) LHCalendarScope calendarScope;

- (void)setSelectedDate:(NSDate *)date animated:(BOOL)animated;

@end
