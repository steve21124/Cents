//
//  AppDelegate.m
//  Cents
//
//  Created by Sapan Bhuta on 7/27/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "VCFlow.h"

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
    self.window.rootViewController = [VCFlow nextVC];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [self handlePushNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];

    return YES;
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
    NSLog(@"userinfo: %@",userInfo);
    [PFPush handlePush:userInfo];
    [self handlePushNotification:userInfo];
}

- (void)handlePushNotification:(NSDictionary *)data
{
#warning save notification to be checked in rootVC
#warning send NSNotification to handle saved notifications, if rootVC is up it will handle, else ignore

//    NSString *alert = data[@"alert"];
//    NSString *badge = data[@"badge"];
//    NSString *phoneNumber = data[@"phoneNumber"];
//    NSString *type = data[@"type"];
//    NSString *amount = data[@"amount"];
//    NSString *name = data[@"name"];

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:userInfo];
}

@end
