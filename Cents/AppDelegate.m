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
#import "ParseChecks.h"
@import AddressBook;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"P7UUztIv5Z2hZB6gY51Mu79CIoLIzoeaXVGzj8uX"
                  clientKey:@"tJKQOiTU85yegajonqCwGuAy2JEqxL3mgsuiR6b5"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

//    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
//                                                    UIRemoteNotificationTypeAlert|
//                                                    UIRemoteNotificationTypeSound];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [self vcFromFlowOrder];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIViewController *)vcFromFlowOrder
{
    if (![ParseChecks userHasPhoneNumber])
    {
        return [GetPhoneNumberViewController new];
    }
    else if (![ParseChecks userHasPaymentCard])
    {
        return [GetPaymentCardViewController new];
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
    {
        return [GetContactsViewController new];
    }
    else
    {
        return [RootViewController new];
    }
}

//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//    // Store the deviceToken in the current installation and save it to Parse.
//    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//    [currentInstallation setDeviceTokenFromData:deviceToken];
//    [currentInstallation saveInBackground];
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    [PFPush handlePush:userInfo];
//}

@end
