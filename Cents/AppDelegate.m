//
//  AppDelegate.m
//  Cents
//
//  Created by Sapan Bhuta on 7/27/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import <Parse/Parse.h>
#import "GetPhoneNumberViewController.h"
#import "GetPaymentCardViewController.h"
#import "GetContactsViewController.h"
@import AddressBook;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"P7UUztIv5Z2hZB6gY51Mu79CIoLIzoeaXVGzj8uX"
                  clientKey:@"tJKQOiTU85yegajonqCwGuAy2JEqxL3mgsuiR6b5"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *vc;

    if (![self userHasPhoneNumber])
    {
        vc = [GetPhoneNumberViewController new];
    }
    else if (![self userHasPaymentCard])
    {
        vc = [GetPaymentCardViewController new];
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
    {
        vc = [GetContactsViewController new];
    }
    else
    {
        vc = [RootViewController new];
    }

    self.window.rootViewController = vc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)userHasPhoneNumber
{
#warning check parse for phone num
    return !NO;
}

- (BOOL)userHasPaymentCard
{
#warning check parse for pay card
    return !NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
