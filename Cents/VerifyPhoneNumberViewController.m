//
//  VerifyPhoneNumberViewController.m
//  Cents
//
//  Created by Sapan Bhuta on 7/30/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "VerifyPhoneNumberViewController.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import "GetPaymentCardViewController.h"

@interface VerifyPhoneNumberViewController ()

@end

@implementation VerifyPhoneNumberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor wisteriaColor];

    UITextField *phoneEntry = [[UITextField alloc] initWithFrame:CGRectMake(15, 100, self.view.frame.size.width-2*15, 100)];
    phoneEntry.placeholder = @"enter code";
    phoneEntry.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    phoneEntry.textColor = [UIColor whiteColor];
    phoneEntry.adjustsFontSizeToFitWidth = YES;
    phoneEntry.keyboardAppearance = UIKeyboardAppearanceDark;
    phoneEntry.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneEntry];
    [phoneEntry becomeFirstResponder];

    JSQFlatButton *resend = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,
                                                                           self.view.frame.size.height-216-54,
                                                                           self.view.frame.size.width/2-.25,
                                                                           54)
                                                backgroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                                foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                                          title:@"resend"
                                                          image:nil];
    [resend addTarget:self action:@selector(resend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resend];


    JSQFlatButton *enter = [[JSQFlatButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+.25,
                                                                           self.view.frame.size.height-216-54,
                                                                           self.view.frame.size.width/2-.25,
                                                                           54)
                                                 backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                                 foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                                           title:@"enter"
                                                           image:nil];
    [enter addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enter];
}

- (void)sendText
{
#warning send text from Twilio
}

- (void)resend
{
    [self sendText];
}

- (void)enter
{
    GetPaymentCardViewController *vc = [GetPaymentCardViewController new];
    [self presentViewController:vc animated:NO completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end