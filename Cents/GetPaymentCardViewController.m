//
//  GetPaymentCardViewController.m
//  Cents
//
//  Created by Sapan Bhuta on 7/30/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#define kStripePublishableKey @"pk_test_4TyI2woMDc4DSBu1r1bYQ6l9"
#define kStripeSecretKey @"sk_test_4TyIk8adGJTfvHq9YDt4raCx"
#define kCardioToken @"6f029e310ea241408c0f67514801d637"

#import "GetPaymentCardViewController.h"
#import "STPView.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import "GetContactsViewController.h"
#import "RootViewController.h"
#import "CardIO.h"
@import AddressBook;
#import <Parse/Parse.h>

@interface GetPaymentCardViewController () <STPViewDelegate, CardIOPaymentViewControllerDelegate>
@property STPView *stripeView;
@property STPCard *stripeCard;
@property JSQFlatButton *save;
@property JSQFlatButton *camera;
@property UIButton *cameraIcon;
@property UITextField *nameField;
@end

@implementation GetPaymentCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor wisteriaColor];
    [self createTitle];
    [self createName];
    [self createStripeViewDefault];
    [self createSaveButton];
    [self createCameraButton];
}

- (void)createTitle
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-2*10, 50)];
    title.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    title.textColor = [UIColor whiteColor];
    title.text = @"Debit Card";
    title.adjustsFontSizeToFitWidth = YES;
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
}

- (void)createName
{
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(68, 100, self.view.frame.size.width-100, 30)];
    _nameField.font = [UIFont systemFontOfSize:20];
    _nameField.textColor = [UIColor blackColor];
    _nameField.placeholder = @"name on card";
    _nameField.textAlignment = NSTextAlignmentLeft;
    _nameField.keyboardAppearance = UIKeyboardAppearanceDark;
    _nameField.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:_nameField];
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
    [[NSUserDefaults standardUserDefaults] setObject:_nameField.text forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _save.enabled = NO;

    if (_stripeCard && [_stripeCard validateCardReturningError:nil])
    {
        [Stripe createTokenWithCard:_stripeCard publishableKey:kStripePublishableKey completion:^(STPToken *token, NSError *error)
         {
             if (error)
             {
                 _save.enabled = YES;
#warning handle error
                 _stripeView.hidden = NO;
                 _cameraIcon.hidden = NO;
                 [_stripeView.paymentView becomeFirstResponder];
                 [UIView animateWithDuration:.3 animations:^{
                     _save.transform = CGAffineTransformMakeTranslation(0, _save.transform.ty-216);
                 }];
             }
             else
             {
                 [self createCustomer:token];
             }
         }];
    }
    else
    {
        [self.stripeView createToken:^(STPToken *token, NSError *error)
         {
             if (error)
             {
                 _save.enabled = YES;
#warning handle error
             }
             else
             {
                 [self createCustomer:token];
             }
         }];
        [_stripeView.paymentView becomeFirstResponder];
    }
}

- (void)createCameraButton
{
    _cameraIcon = [UIButton buttonWithType:UIButtonTypeSystem];
    [_cameraIcon addTarget:self action:@selector(camera:) forControlEvents:UIControlEventTouchUpInside];
    [_cameraIcon setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    _cameraIcon.frame = CGRectMake(self.view.frame.size.width - 53, 121.5, 48, 48);
    _cameraIcon.hidden = ![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
    [self.view addSubview:_cameraIcon];
}

- (void)camera:(UIButton *)sender
{
    _stripeView.hidden = YES;
    _cameraIcon.hidden = YES;
    [UIView animateWithDuration:.3 animations:^{
        _save.transform = CGAffineTransformMakeTranslation(0, _save.transform.ty+216);
    }];
    [self scanCard];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Card.io

- (void)scanCard
{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.appToken = kCardioToken;
    [self presentViewController:scanViewController animated:YES completion:nil];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController
{
    NSLog(@"User canceled payment info");
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
    _stripeView.hidden = NO;
    _cameraIcon.hidden = NO;
    [_stripeView.paymentView becomeFirstResponder];
    [UIView animateWithDuration:.3 animations:^{
        _save.transform = CGAffineTransformMakeTranslation(0, _save.transform.ty-216);
    }];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info
             inPaymentViewController:(CardIOPaymentViewController *)scanViewController
{
    [scanViewController dismissViewControllerAnimated:YES completion:nil];

    _stripeCard = [[STPCard alloc] init];
    _stripeCard.number = info.cardNumber;
    _stripeCard.expMonth = info.expiryMonth;
    _stripeCard.expYear = info.expiryYear;
    _stripeCard.cvc = info.cvv;

    if ([_stripeCard validateCardReturningError:nil])
    {
        _save.enabled = YES;
    }
}

#pragma mark - Stripe

- (void)createStripeViewDefault
{
    self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(15,127.5,290,55) andKey:kStripePublishableKey];
    self.stripeView.delegate = self;
    [self.view addSubview:self.stripeView];
}

- (void)stripeView:(STPView *)view withCard:(PKCard *)card isValid:(BOOL)valid
{
    _save.enabled = valid;
}

- (void)createCustomer:(STPToken *)token
{
    [PFCloud callFunctionInBackground:@"createCustomer"
                       withParameters:@{@"token":token.tokenId,
                                        @"phoneNumber":[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]}
                                block:^(id customer, NSError *error)
    {
        if (error)
        {
            NSLog(@"Error in creating customer: %@",error);
#warning restart this VC
        }
        else
        {
#warning check that card is debit or restart VC
            if (YES)
            {
                NSLog(@"Customer created successfully with id: %@", customer);
                [[NSUserDefaults standardUserDefaults] setObject:customer[@"id"] forKey:@"customerId"];
                [[NSUserDefaults standardUserDefaults] synchronize];


                [self.stripeView createToken:^(STPToken *token, NSError *error)
                 {
                     if (error)
                     {
#warning handle error
                     }
                     else
                     {
                         [self createRecipient:token];
                     }
                 }];
            }
            else
            {
#warning handle non debit card error
            }
        }
    }];
}

- (void)createRecipient:(STPToken *)token
{
    NSString *name = @"Sapan Bhuta";
    NSString *urlString = [NSString stringWithFormat:@"https://%@:@api.stripe.com/v1/recipients",kStripeSecretKey];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    NSString *params = [NSString stringWithFormat:@"name=%@&type=individual&card=%@",name,token.tokenId];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if (error)
        {
            NSLog(@"ERROR: %@",error);
#warning handle error
        }
        else
        {
            NSDictionary *output = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"SUCCESS: %@", output);

            if (output[@"id"])
            {
                [[NSUserDefaults standardUserDefaults] setObject:output[@"id"] forKey:@"recipientId"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self addUserToDataBase];
            }
            else
            {
#warning handle error
            }
        }
    }];
}

- (void)addUserToDataBase
{
    PFObject *user = [PFObject objectWithClassName:@"User"];
    user[@"phoneNumber"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    user[@"customerId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"];
    user[@"recipientId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"recipientId"];
    user[@"name"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            [self showNextVC];
        }
        else
        {
#warning handle error
        }
    }];
}

- (void)showNextVC
{
    UIViewController *vc;
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusNotDetermined)
    {
        vc = [RootViewController new];
    }
    else
    {
        vc = [GetContactsViewController new];
    }
    [self presentViewController:vc animated:NO completion:nil];
}

@end

