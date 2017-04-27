//
//  SRdate.m
//  SpeechRecognition
//
//  Created by 丁诗瑶 on 2017/4/13.
//  Copyright © 2017年 Sankuai. All rights reserved.
//

#import "SRdate.h"
@implementation NSDate(Conversion)

+ (BOOL)isSameDay:(NSDate *)firstDate andDate:(NSDate *)secondDate
{
    return [NSDate daysBetweenDate:firstDate andDate:secondDate] == 0 ? YES : NO;
}

+ (NSInteger)daysBetweenDate:(NSDate *)firstDate andDate:(NSDate *)secondDate
{
    if (firstDate == nil || secondDate == nil) {
        return NSIntegerMax;
    }
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components:NSCalendarUnitDay
                                                      fromDate:firstDate
                                                        toDate:secondDate
                                                       options:0];
    NSInteger days = [components day];
    return days;
}

@end

