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
#import <Parse/Parse.h>

@interface VerifyPhoneNumberViewController ()
@property UITextField *codeEntry;
@property NSTimer *buttonCheckTimer;
@property JSQFlatButton *enter;
@property int randomNum;
@end

@implementation VerifyPhoneNumberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor wisteriaColor];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-2*10, 50)];
    title.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    title.textColor = [UIColor whiteColor];
    title.text = @"Verify Number";
    title.adjustsFontSizeToFitWidth = YES;
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];

    _codeEntry = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width-2*20, 100)];
    _codeEntry.placeholder = @"enter code";
    _codeEntry.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:40];
    _codeEntry.textColor = [UIColor whiteColor];
    _codeEntry.adjustsFontSizeToFitWidth = YES;
    _codeEntry.keyboardAppearance = UIKeyboardAppearanceDark;
    _codeEntry.keyboardType = UIKeyboardTypeNumberPad;
    _codeEntry.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_codeEntry];
    [_codeEntry becomeFirstResponder];

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self sendSMSToNumber:[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]];
}

- (void)resend
{
    _codeEntry.text = @"";
    [self sendSMSToNumber:[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]];
}

- (void)enter:(UIButton *)sender
{
    GetPaymentCardViewController *vc = [GetPaymentCardViewController new];
    [self presentViewController:vc animated:NO completion:nil];
}

- (BOOL)codeIsValid
{
    return _randomNum == [_codeEntry.text intValue];
}

- (void)buttonCheck
{
    if ([_codeEntry.text length] > 3)
    {
        [self codeIsValid] ? [_codeEntry setTextColor:[UIColor greenColor]] : [_codeEntry setTextColor:[UIColor redColor]];
    }
    else
    {
        _codeEntry.textColor = [UIColor whiteColor];
    }

    _enter.enabled = [self codeIsValid];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)sendSMSToNumber:(NSString *)phoneNumber
{
    _randomNum = 1000 + arc4random_uniform(8999);
    NSString *message = [NSString stringWithFormat:@"Cents Code: %@",@(_randomNum).description];
    [PFCloud callFunctionInBackground:@"verifyNum"
                       withParameters:@{@"number" : phoneNumber, @"message":message}
                                block:^(id object, NSError *error)
    {
        if (error)
        {
//            NSLog(@"ERROR: %@",error.localizedDescription);
        }
    }];
}

@end