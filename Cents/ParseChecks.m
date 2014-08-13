//
//  ParseChecks.m
//  Cents
//
//  Created by Sapan Bhuta on 8/12/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "ParseChecks.h"

@implementation ParseChecks

+ (BOOL)userHasPhoneNumber
{
#warning check parse if has phone number
    return NO;
}

+ (BOOL)userHasPaymentCard
{
#warning check parse if has pay card
    return NO;
}

+ (BOOL)userIsInDataBase:(NSString *)number
{
#warning check phone number is in database
    return !NO;
}

+ (void)addCardOnFileIs:(BOOL)answer for:(NSString *)custId;
{
#warning tell parse card on file is answer for custId
}

+ (void)addUserToDataBase:(NSString *)custId
{
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
#warning add customer ID to Parse tied to phone number
}

@end
