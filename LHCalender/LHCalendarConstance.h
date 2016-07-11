//
//  LHCalendarConstance.h
//  LHCalender
//
//  Created by luhao on 16/5/8.
//  Copyright © 2016年 luhao. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef CGFLOAT_IS_DOUBLE
#define LHCalendarFloor(c) floor(c)
#else
#define LHCalendarFloor(c) floorf(c)
#endif

#ifdef DEBUG
#define LHLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define LHLog(format, ...)
#endif

@interface LHCalendarConstance : NSObject

@end
