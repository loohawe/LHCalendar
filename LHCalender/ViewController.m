//
//  ViewController.m
//  LHCalender
//
//  Created by luhao on 16/5/6.
//  Copyright © 2016年 luhao. All rights reserved.
//

#import "ViewController.h"
#import "LHCalendar.h"

@interface ViewController () {
    BOOL _buttonFlag;
    LHCalendar *_calendar;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _calendar = [[LHCalendar alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-44-20)];
    [self.view addSubview:_calendar];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-44, [UIScreen mainScreen].bounds.size.width, 44)];
    [button setTitle:@"Toggle" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonAction:(UIButton *)button {
    if (_buttonFlag) {
        _calendar.calendarScope = LHCalendarScopeMonthly;
    } else {
        _calendar.calendarScope = LHCalendarScopeWeekly;
    }
    _buttonFlag = !_buttonFlag;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
