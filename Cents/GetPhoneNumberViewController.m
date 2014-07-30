//
//  GetPhoneNumberViewController.m
//  Cents
//
//  Created by Sapan Bhuta on 7/30/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "GetPhoneNumberViewController.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import "VerifyPhoneNumberViewController.h"

@interface GetPhoneNumberViewController ()

@end

@implementation GetPhoneNumberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor wisteriaColor];

    UITextField *phoneEntry = [[UITextField alloc] initWithFrame:CGRectMake(15, 100, self.view.frame.size.width-2*15, 100)];
    phoneEntry.placeholder = @"enter phone number";
    phoneEntry.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    phoneEntry.textColor = [UIColor whiteColor];
    phoneEntry.adjustsFontSizeToFitWidth = YES;
    phoneEntry.keyboardAppearance = UIKeyboardAppearanceDark;
    phoneEntry.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneEntry];
    [phoneEntry becomeFirstResponder];

    JSQFlatButton *verify = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,
                                                                           self.view.frame.size.height-216-54,
                                                                           self.view.frame.size.width,
                                                                           54)
                                                 backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                                 foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                                           title:@"verify via sms"
                                                           image:nil];
    [verify addTarget:self action:@selector(verify) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verify];
}

- (void)verify
{
    VerifyPhoneNumberViewController *vc = [VerifyPhoneNumberViewController new];
    [self presentViewController:vc animated:NO completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
