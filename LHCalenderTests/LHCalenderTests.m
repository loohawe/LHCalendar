//
//  LHCalenderTests.m
//  LHCalenderTests
//
//  Created by luhao on 16/5/6.
//  Copyright © 2016年 luhao. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LHCalendarConstance.h"
#import "NSDate+LHExtension.h"

@interface LHCalenderTests : XCTestCase

@end

@implementation LHCalenderTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    NSDate *date = [NSDate lh_dataWithYear:2016 month:5 day:1];
    NSInteger weekdayOr = [date weekdayOrdinalInThisMonthWithFirstWeedDay:LHExtensionWeekdayMonday];
    NSLog(@"%ld", (long)weekdayOr);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
