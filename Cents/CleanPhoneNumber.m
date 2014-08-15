//
//  CleanPhoneNumber.m
//  Cents
//
//  Created by Sapan Bhuta on 8/14/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "CleanPhoneNumber.h"

@implementation CleanPhoneNumber
+ (NSString *)clean:(NSString *)phoneNumber
{
    NSArray *symbols = @[@"+", @"(",@")", @" ", @"-", @"*", @"#", @",", @";"];
    for (NSString *symbol in symbols)
    {
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:symbol withString:@""];
    }
    if (phoneNumber.length == 9)
    {
        phoneNumber = [@"1" stringByAppendingString:phoneNumber];
    }
    return phoneNumber;
}
@end
