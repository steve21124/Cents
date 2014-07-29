//
//  PaymentViewController.m
//  Cents
//
//  Created by Sapan Bhuta on 7/27/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "PaymentViewController.h"
#import "STPView.h"

@interface PaymentViewController () <STPViewDelegate>
@property STPView* stripeView;
@end

@implementation PaymentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(15,20,290,55) andKey:@"pk_test_4SpEIGtYzfx4J0NZbNBxMfr8"];
    self.stripeView.delegate = self;
    [self.view addSubview:self.stripeView];
}

- (void)save
{
    [self.stripeView createToken:^(STPToken *token, NSError *error)
     {
         if (error)
         {
             // Handle error
             [self handleError:error];
         }
         else
         {
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

@end
