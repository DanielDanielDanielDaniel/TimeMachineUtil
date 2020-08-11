//
//  TimeMachineUtil.m
//  Nimblest
//
//  Created by Cai Dong on 2020/6/16.
//  Copyright © 2020 Cai Dong.Nimblest. All rights reserved.
//

#import "TimeMachineUtil.h"

@interface TimeMachineUtil()
{
    NSDate *_currentDate;//当前展示的日期
    NSDateFormatter *_dateFormatter;
    NSArray *_daysInMonth;//三个月的日历数据数组
    NSArray *_threedateArray;//三个月的今天数据数组（例如：2018-03-18，2018-04-18，2018-05-18）
}

@property (nonatomic, strong) NSCalendar *calendar;

@end

@implementation TimeMachineUtil
+ (TimeMachineUtil *)shareInstance
{
    static TimeMachineUtil *timeUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        timeUtil = [[TimeMachineUtil alloc] init];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        timeUtil.calendar = calendar;
        timeUtil->_dateFormatter = [[NSDateFormatter alloc] init];
        [timeUtil->_dateFormatter setLocale:[NSLocale currentLocale]];
        timeUtil->_currentDate = [NSDate date];
    });
    return timeUtil;
}
- (NSString *)getDateTitleString
{
    NSInteger year = [self.calendar year:_currentDate];
    NSInteger month = [self.calendar month:_currentDate];
    return [NSString stringWithFormat:@"%ld年%ld月的记录",(long)year,(long)month];
}
- (NSMutableArray *)getAllDaysWithMonth:(NSDate *)currentDate
{
    NSMutableArray *result = [NSMutableArray array];
    _currentDate = currentDate;
    _daysInMonth = [self.calendar threedateArray:currentDate];
    NSDate *lastdate = [self.calendar lastMonth:currentDate];
    NSDate *nextdate = [self.calendar nextMonth:currentDate];
    _threedateArray = [NSArray arrayWithObjects:lastdate, currentDate, nextdate, nil];
    
    for (int i=0; i<[_threedateArray count]; i++) {
        
        NSMutableArray *oneMonths = [NSMutableArray array];
        NSInteger rowcount = [self.calendar dataCollectViewRowcount:[_threedateArray objectAtIndex:i]];
        NSInteger firstWeekday = [self.calendar firstWeekdayInThisMonth:[_threedateArray objectAtIndex:i]];
        NSInteger totaldays = [self.calendar totaldaysInMonth:[_threedateArray objectAtIndex:i]];
        //NSInteger year = [self.calendar year:currentDate];
        NSInteger month = [self.calendar month:[_threedateArray objectAtIndex:i]];
        
        for (int item =0; item<rowcount*7; item++) {
            if (item<firstWeekday||(item-firstWeekday+1)>totaldays) {
                continue;
            }
            NSDate *date = _daysInMonth[i][item-firstWeekday];
            NSInteger day = [self.calendar day:date];
            if (month<10) {
                if (day<10) {
                    [oneMonths addObject:[NSString stringWithFormat:@"0%ld.0%ld",(long)month,(long)day]];
                   
                }else{
                    [oneMonths addObject:[NSString stringWithFormat:@"0%ld.%ld",(long)month,(long)day]];
                }
            }else{
                if (day<10) {
                    [oneMonths addObject:[NSString stringWithFormat:@"%ld.0%ld",(long)month,(long)day]];
                }else{
                    [oneMonths addObject:[NSString stringWithFormat:@"%ld.%ld",(long)month,(long)day]];
                }
            }
            
        }
        [result addObject:oneMonths];
    }
    return result;
}
- (NSDate *)getNewCurrentDate:(NSInteger)offsetMonths
{
    //+n,-n
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSDate *currentDate;
    dateComponents.month = offsetMonths;
    currentDate = [self.calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    return currentDate;
}

@end
