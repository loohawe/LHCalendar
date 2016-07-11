//
//  LHCalendarDateModel.h
//  LHCalender
//
//  Created by luhao on 16/5/7.
//  Copyright © 2016年 luhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHCalendar.h"

@interface LHCalendarDateModel : NSObject

@property (nonatomic, assign, readonly) LHCalendarScope calendarScope; //calendar scope, have two style - weekly and monthly, default is monthly
@property (nonatomic, assign, readonly) NSInteger numberOfSection; ///< the number of section in collection
@property (nonatomic, assign, readonly) NSInteger numberOfRow; ///< the number of section in collection

/*!
 *  @author luhao, 16-05-17 16:05:58
 *
 *  @brief set calendar scope
 *
 *  @param scopeType scope type
 */
- (void)setCalendarScope:(LHCalendarScope)scopeType;

/*!
 *  @author luhao, 16-05-08 21:05:21
 *
 *  @brief get date to specified cell depending indexPath
 *
 *  @param indexPath position of cell
 *
 *  @return date
 */
- (NSDate *)dataWithIndexPath:(NSIndexPath *)indexPath;

/*!
 *  @author luhao, 16-05-25 20:05:20
 *
 *  @brief caculate collection offset
 *
 *  @param date date
 *
 *  @return to set collection offset, example collection * return value
 */
- (NSInteger)numberOfOffsetPagesWithDate:(NSDate *)date;

@end
