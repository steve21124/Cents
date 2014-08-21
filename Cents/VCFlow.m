//
//  VCFlow.m
//  Cents
//
//  Created by Sapan Bhuta on 8/17/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "VCFlow.h"
#import <Parse/Parse.h>
#import "RootViewController.h"
#import "GetPhoneNumberViewController.h"
#import "GetPaymentCardViewController.h"
#import "GetContactsViewController.h"
@import AddressBook;
#import "FailViewController.h"
#import "Reachability.h"

@implementation VCFlow

+ (UIViewController *)nextVC
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(@"There IS NO internet connection");

        return [FailViewController new];
    }
    else
    {
        NSLog(@"There IS internet connection");

        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"verifiedPhoneNumber"])
        {
            return [GetPhoneNumberViewController new];
        }
        else
        {
            PFQuery *query = [PFQuery queryWithClassName:@"User"];
            [query whereKey:@"phoneNumber" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]];
            NSArray *objects = [query findObjects];

            NSLog(@"Count of users with this phone number: %lu",(unsigned long)objects.count);

            if (objects.count == 0)
            {
                return [GetPaymentCardViewController new];
            }
            else if (objects.count == 1)
            {
                [[NSUserDefaults standardUserDefaults] setObject:objects.firstObject[@"phoneNumber"] forKey:@"phoneNumber"];
                [[NSUserDefaults standardUserDefaults] setObject:objects.firstObject[@"customerId"] forKey:@"customerId"];
                [[NSUserDefaults standardUserDefaults] setObject:objects.firstObject[@"recipientId"] forKey:@"recipientId"];
                [[NSUserDefaults standardUserDefaults] setObject:objects.firstObject[@"name"] forKey:@"name"];

                if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
                {
                    return [GetContactsViewController new];
                }
                else
                {
                    return [RootViewController new];
                }
            }
            else
            {
                for (PFObject *user in objects)
                {
                    [user deleteInBackground];
                }
                return [GetPaymentCardViewController new];
            }
        }
    }
}

@end
