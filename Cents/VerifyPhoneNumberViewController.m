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
@property UITextField *phoneEntry;
@property NSTimer *buttonCheckTimer;
@property JSQFlatButton *enter;
@property int randomNum;
@end

@implementation VerifyPhoneNumberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor wisteriaColor];

    _phoneEntry = [[UITextField alloc] initWithFrame:CGRectMake(15, 100, self.view.frame.size.width-2*15, 100)];
    _phoneEntry.placeholder = @"enter code";
    _phoneEntry.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    _phoneEntry.textColor = [UIColor whiteColor];
    _phoneEntry.adjustsFontSizeToFitWidth = YES;
    _phoneEntry.keyboardAppearance = UIKeyboardAppearanceDark;
    _phoneEntry.keyboardType = UIKeyboardTypeNumberPad;
    _phoneEntry.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_phoneEntry];
    [_phoneEntry becomeFirstResponder];

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


    _enter = [[JSQFlatButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+.25,
                                                             self.view.frame.size.height-216-54,
                                                             self.view.frame.size.width/2-.25,
                                                             54)
                                  backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                  foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                            title:@"enter"
                                            image:nil];
    [_enter addTarget:self action:@selector(enter:) forControlEvents:UIControlEventTouchUpInside];
    _enter.enabled = NO;
    [self.view addSubview:_enter];

    _buttonCheckTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(buttonCheck) userInfo:nil repeats:YES];

    [self sendText];
}

- (void)sendText
{
//    _randomNum = arc4random_uniform(10000);
    _randomNum = 1234;
    NSString *message = [NSString stringWithFormat:@"Cents code: %i",_randomNum];
    NSLog(@"%@",message);

#warning send text from Twilio
}

- (void)resend
{
    [self sendText];
}

- (void)enter:(UIButton *)sender
{
    GetPaymentCardViewController *vc = [GetPaymentCardViewController new];
    [self presentViewController:vc animated:NO completion:nil];
}

- (BOOL)codeIsValid
{
    return _randomNum == [_phoneEntry.text intValue];
}

- (void)buttonCheck
{
    [self codeIsValid] ? [_phoneEntry setTextColor:[UIColor greenColor]] : [_phoneEntry setTextColor:[UIColor whiteColor]];
    _enter.enabled = [self codeIsValid];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end