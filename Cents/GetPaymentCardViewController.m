//
//  GetPaymentCardViewController.m
//  Cents
//
//  Created by Sapan Bhuta on 7/30/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "GetPaymentCardViewController.h"
#import "STPView.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import "RootViewController.h"

@interface GetPaymentCardViewController () <STPViewDelegate>
@property STPView *stripeView;
@property JSQFlatButton *save;
@end

@implementation GetPaymentCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createStripeView];

    self.view.backgroundColor = [UIColor wisteriaColor];

    _save = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,
                                                            self.view.frame.size.height-216-54,
                                                            self.view.frame.size.width,
                                                            54)
                                 backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                 foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                           title:@"save"
                                           image:nil];
    [_save addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_save];
    _save.enabled = NO;
}

- (void)save
{
    [self saveStripeInfo];
    RootViewController *vc = [RootViewController new];
    [self presentViewController:vc animated:NO completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Stripe

- (void)createStripeView
{
    self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(15,127.5,290,55) andKey:@"pk_test_4SpEIGtYzfx4J0NZbNBxMfr8"];
    self.stripeView.delegate = self;
    [self.view addSubview:self.stripeView];
}

- (void)saveStripeInfo
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