//
//  GetPaymentCardViewController.m
//  Cents
//
//  Created by Sapan Bhuta on 7/30/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#define kStripeKey @"pk_test_4SpEIGtYzfx4J0NZbNBxMfr8"

#import "GetPaymentCardViewController.h"
#import "STPView.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import "RootViewController.h"

@interface GetPaymentCardViewController () <STPViewDelegate>
@property STPView *stripeView;
@property STPCard *stripeCard;
@property JSQFlatButton *save;
@property BOOL customCheckout;
@property UITextField *number;
@property UITextField *expiry;
@property UITextField *cvc;
@end

@implementation GetPaymentCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _customCheckout = NO;
    _customCheckout ? [self createStripeViewCustom] : [self createStripeViewDefault];

    self.view.backgroundColor = [UIColor wisteriaColor];

    [self createSaveButton];
}

- (void)createSaveButton
{
    _save = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,
                                                            self.view.frame.size.height-216-54,
                                                            self.view.frame.size.width,
                                                            54)
                                 backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                 foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                           title:@"save"
                                           image:nil];
    [_save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_save];
    _save.enabled = NO;
}

- (void)save:(UIButton *)sender
{
    _customCheckout ? [self saveStripeInfoCustom] : [self saveStripeInfoDefault];
    RootViewController *vc = [RootViewController new];
    [self presentViewController:vc animated:NO completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Stripe

- (void)createStripeViewDefault
{
    self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(15,127.5,290,55) andKey:kStripeKey];
    self.stripeView.delegate = self;
    [self.view addSubview:self.stripeView];
}

- (void)saveStripeInfoDefault
{
    [self.stripeView createToken:^(STPToken *token, NSError *error)
     {
         if (error)
         {
             NSLog(@"Error");
             [self handleError:error];
         }
         else
         {
             NSLog(@"Create Token");
             // Send off token to your server = save token in parse and associate with phone number or fb login
             // [self handleToken:token];
         }
     }];
}

- (void)createStripeViewCustom
{
    //number field
    //date field
    //cvc field

    _stripeCard = [STPCard new];

    _number = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-2*20, 100)];
    _number.placeholder = @"card number";
    _number.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    _number.textColor = [UIColor whiteColor];
    _number.adjustsFontSizeToFitWidth = YES;
    _number.keyboardAppearance = UIKeyboardAppearanceDark;
    _number.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_number];
    [_number becomeFirstResponder];

    _expiry = [[UITextField alloc] initWithFrame:CGRectMake(20, 120, self.view.frame.size.width-2*20, 50)];
    _expiry.placeholder = @"expiry date";
    _expiry.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    _expiry.textColor = [UIColor whiteColor];
    _expiry.adjustsFontSizeToFitWidth = YES;
    _expiry.keyboardAppearance = UIKeyboardAppearanceDark;
    _expiry.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_expiry];

    _cvc = [[UITextField alloc] initWithFrame:CGRectMake(20, 220, self.view.frame.size.width-2*20, 50)];
    _cvc.placeholder = @"CVC";
    _cvc.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    _cvc.textColor = [UIColor whiteColor];
    _cvc.adjustsFontSizeToFitWidth = YES;
    _cvc.keyboardAppearance = UIKeyboardAppearanceDark;
    _cvc.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_cvc];
}

- (void)saveStripeInfoCustom
{
    [Stripe createTokenWithCard:_stripeCard publishableKey:kStripeKey completion:^(STPToken *token, NSError *error)
    {
         if (error)
         {
             [self handleError:error];
         }
         else
         {
             NSLog(@"Create Token");
//             [self handleToken:token];
         }
    }];
}

- (void)handleError:(NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

- (void)handleToken:(STPToken *)token
{
    NSLog(@"Received token %@", token.tokenId);

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://example.com"]];
    request.HTTPMethod = @"POST";
    NSString *body     = [NSString stringWithFormat:@"stripeToken=%@", token.tokenId];
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error) {
                                   // Handle error
                               }
                           }];
}

- (void)stripeView:(STPView *)view withCard:(PKCard *)card isValid:(BOOL)valid
{
    _save.enabled = valid;
}

@end