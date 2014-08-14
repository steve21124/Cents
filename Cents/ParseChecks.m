//
//  ParseChecks.m
//  Cents
//
//  Created by Sapan Bhuta on 8/12/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "ParseChecks.h"

@implementation ParseChecks

+ (BOOL)userIsInDataBase:(NSString *)phoneNumber
{
#warning check parse for a user in database with phoneNumber
    return !NO;
}

+ (BOOL)userHasPhoneNumber
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"] ? YES : NO;
}

+ (BOOL)userHasPaymentCard
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"] ? YES : NO;
}

+ (void)addUserToDataBase
{
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString *customerId = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"];
    NSString *recipientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"recipientId"];

    NSDictionary *params = @{@"phoneNumber":phoneNumber, @"customerId":customerId, @"recipientId":recipientId};

    NSLog(@"%@",params);
#warning add User object to Parse with params
}

@end
