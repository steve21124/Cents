//
//  ParseChecks.m
//  Cents
//
//  Created by Sapan Bhuta on 8/12/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "ParseChecks.h"
#import <Parse/Parse.h>

@implementation ParseChecks

+ (BOOL)userIsInDataBase:(NSString *)phoneNumber
{
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"phoneNumber" equalTo:phoneNumber];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (error)
        {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else
        {
            NSLog(@"Successfully retrieved %d scores.", objects.count);
        }
    }];
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
    PFObject *user = [PFObject objectWithClassName:@"User"];
    user[@"phoneNumber"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    user[@"customerId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"];
    user[@"recipientId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"recipientId"];
    [user saveInBackground];
}

@end
