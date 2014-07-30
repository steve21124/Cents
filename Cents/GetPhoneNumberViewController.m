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
#import "LTPhoneNumberField.h"

@interface GetPhoneNumberViewController ()
@property LTPhoneNumberField *phoneEntry;
@property NSTimer *buttonCheckTimer;
@property JSQFlatButton *verify;
@end

@implementation GetPhoneNumberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor wisteriaColor];

    _phoneEntry = [[LTPhoneNumberField alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width-2*20, 100)];
    _phoneEntry.placeholder = @"phone number";
    _phoneEntry.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    _phoneEntry.textColor = [UIColor whiteColor];
    _phoneEntry.adjustsFontSizeToFitWidth = YES;
    _phoneEntry.keyboardAppearance = UIKeyboardAppearanceDark;
    _phoneEntry.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:_phoneEntry];
    [_phoneEntry becomeFirstResponder];

    _verify = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,
                                                              self.view.frame.size.height-216-54,
                                                              self.view.frame.size.width,
                                                              54)
                                   backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                   foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                             title:@"verify via sms"
                                             image:nil];
    [_verify addTarget:self action:@selector(verify:) forControlEvents:UIControlEventTouchUpInside];
    _verify.enabled = NO;
    [self.view addSubview:_verify];

    _buttonCheckTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(buttonCheck) userInfo:nil repeats:YES];
}

- (void)verify:(UIButton *)sender
{
    VerifyPhoneNumberViewController *vc = [VerifyPhoneNumberViewController new];
    [self presentViewController:vc animated:NO completion:nil];
}

- (void)buttonCheck
{
    if (_phoneEntry.containsValidNumber)
    {
        _phoneEntry.textColor = [UIColor greenColor];
        _verify.enabled = YES;
    }
    else
    {
        _phoneEntry.textColor = [UIColor whiteColor];
        _verify.enabled = NO;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
