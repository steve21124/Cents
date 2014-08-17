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

@implementation VCFlow

+ (UIViewController *)nextVC
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"verifiedPhoneNumber"])
    {
        return [GetPhoneNumberViewController new];
    }
    else
    {
        PFQuery *query = [PFQuery queryWithClassName:@"User"];
        [query whereKey:@"phoneNumber" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]];
        NSArray *objects = [query findObjects];

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
                return [GetPaymentCardViewController new];
            }
            else
            {
                return [RootViewController new];
            }
        }
        else
        {
#warning remove all users with that number and get number again
            return [GetPaymentCardViewController new];
        }
    }
}

@end
