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

    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
                                                    UIRemoteNotificationTypeAlert|
                                                    UIRemoteNotificationTypeSound];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [self vcFromFlowOrder];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [self handlePushNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];

    return YES;
}

- (UIViewController *)vcFromFlowOrder
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"])
    {
        return [GetPhoneNumberViewController new];
    }
    else if (![[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"])
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
//    currentInstallation[@"user"] = [PFUser currentUser];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
#warning handle UI of push: if received money then show bouncing head
    NSLog(@"userinfo: %@",userInfo);
    [PFPush handlePush:userInfo];
    [self handlePushNotification:userInfo];
}

- (void)handlePushNotification:(NSDictionary *)data
{
    NSString *alert = data[@"alert"];
    NSString *badge = data[@"badge"];
    NSString *phoneNumber = data[@"phoneNumber"];
    NSString *type = data[@"type"];
    NSString *amount = data[@"amount"];
    NSString *name = data[@"name"];

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:userInfo];
}

@end
