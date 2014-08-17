//
//  GetContactsViewController.m
//  Cents
//
//  Created by Sapan Bhuta on 8/2/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "GetContactsViewController.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import "RootViewController.h"
@import AddressBook;
#import "RootViewController.h"

@interface GetContactsViewController ()

@end

@implementation GetContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor wisteriaColor];
    [self createTitle];
    [self createButton];
}

- (void)createTitle
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-2*10, 50)];
    title.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    title.textColor = [UIColor whiteColor];
    title.text = @"Find Friends";
    title.adjustsFontSizeToFitWidth = YES;
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
}

- (void)createButton
{
    JSQFlatButton *verify = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,
                                                                            self.view.frame.size.height-54,
                                                                            self.view.frame.size.width,
                                                                            54)
                                                 backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                                 foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                                           title:@"ok"
                                                           image:nil];
    [verify addTarget:self action:@selector(verify) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verify];
}

- (void)verify
{
    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error)
    {
        if (granted)
        {
            RootViewController *vc = [RootViewController new];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:vc animated:NO completion:nil];
            });
        }
        else
        {
            
        }
    });
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
