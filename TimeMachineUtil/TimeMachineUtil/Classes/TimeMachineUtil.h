//
//  TimeMachineUtil.h
//  Nimblest
//
//  Created by Cai Dong on 2020/6/16.
//  Copyright © 2020 Cai Dong.Nimblest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+BRAdd.h"
#import "NSCalendar+JSCCalendar.h"


@interface TimeMachineUtil : NSObject
+ (TimeMachineUtil *)shareInstance;
- (NSMutableArray *)getAllDaysWithMonth:(NSDate *)currentDate;
- (NSString *)getDateTitleString;
- (NSDate *)getNewCurrentDate:(NSInteger)offsetMonths;
@end

