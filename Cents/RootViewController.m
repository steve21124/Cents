//
//  RootViewController.m
//  Cents
//
//  Created by Sapan Bhuta on 7/27/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#define kStripeSecretKey @"sk_test_4TyIk8adGJTfvHq9YDt4raCx"

#define amountFont 100
#define buttonSize 75
#define gap 75

#import "RootViewController.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import <MessageUI/MessageUI.h>
#import <Parse/Parse.h>
#import "CleanPhoneNumber.h"
@import AddressBook;

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPopoverControllerDelegate, MFMessageComposeViewControllerDelegate, UITextFieldDelegate>
@property UILabel *dollarSign;
@property UITextField *amountField;
@property CGRect frame;
@property UICollectionView *collectionView;
@property BOOL actionIsSend;
@property int recipientIndex;
@property NSString *recipientId;
@property JSQFlatButton *request;
@property JSQFlatButton *send;
@property JSQFlatButton *cancel;
@property JSQFlatButton *confirm;
@property NSMutableArray *contacts;
@property UILabel *confirmText;
@property UIImageView *confirmPic;
@property NSTimer *buttonCheckTimer;
@property JSQFlatButton *OK;
@property UILabel *statusText;
@property BOOL hasDecimal;
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _recipientIndex = -1;
    [self fetchContacts];
    [self createAmountLabel];
    [self createSendRequestButtons];
    [self createContactsView];

    _buttonCheckTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(buttonCheck) userInfo:nil repeats:YES];
}

- (void)createAmountLabel
{
    self.view.backgroundColor = [UIColor wisteriaColor];

    _dollarSign = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 20, amountFont)];
    _dollarSign.text = @"$";
    _dollarSign.textColor = [UIColor whiteColor];
    _dollarSign.adjustsFontSizeToFitWidth = YES;
    _dollarSign.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:amountFont];
    [self.view addSubview:_dollarSign];

    _amountField = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, 280, amountFont)];
    _amountField.placeholder = @"Enter amount";
    _amountField.textColor = [UIColor whiteColor];
    _amountField.textAlignment = NSTextAlignmentLeft;
    _amountField.keyboardAppearance = UIKeyboardAppearanceDark;
    _amountField.keyboardType = UIKeyboardTypeDecimalPad;
    _amountField.adjustsFontSizeToFitWidth = YES;
    _amountField.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:amountFont];
    [self.view addSubview:_amountField];
    [_amountField becomeFirstResponder];

    _hasDecimal = NO;
}

- (void)createContactsView
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    if (self.view.frame.size.height <= 480)
    {
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _frame = CGRectMake(0, 30+amountFont, 320, 70);
    }
    else
    {
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        _frame = CGRectMake(0, 30+amountFont, 320, self.view.frame.size.height - 30 - amountFont - 216 -54);
    }

    _collectionView = [[UICollectionView alloc] initWithFrame:_frame collectionViewLayout:flow];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:_collectionView];
}

- (void)createSendRequestButtons
{
    _request = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216-54, 159.75, 54)
                                    backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                    foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                              title:@"Request"
                                              image:nil];
    [_request addTarget:self action:@selector(request:) forControlEvents:UIControlEventTouchUpInside];
    _request.enabled = NO;
    _request.transform = CGAffineTransformMakeTranslation(_request.transform.tx-320, 0);
    [self.view addSubview:_request];

    _send = [[JSQFlatButton alloc] initWithFrame:CGRectMake(160.25, self.view.frame.size.height-216-54, 159.75, 54)
                                 backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                 foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                           title:@"Send"
                                           image:nil];
    [_send addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    _send.enabled = NO;
    _send.transform = CGAffineTransformMakeTranslation(_send.transform.tx+320, 0);
    [self.view addSubview:_send];

    [self slideInButtons];
}

- (void)createConfirmCancelButtons
{
    _cancel = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216-54, 159.75, 54)
                                   backgroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                   foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                             title:@"Cancel"
                                             image:nil];
    [_cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    _cancel.transform = CGAffineTransformMakeTranslation(_cancel.transform.tx+320, 0);
    [self.view addSubview:_cancel];

    _confirm = [[JSQFlatButton alloc] initWithFrame:CGRectMake(160.25, self.view.frame.size.height-216-54, 159.75, 54)
                                    backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                    foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                              title:@"Confirm"
                                              image:nil];
    [_confirm addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    _confirm.transform = CGAffineTransformMakeTranslation(_confirm.transform.tx+320, 0);
    [self.view addSubview:_confirm];
}

- (void)createConfirmView
{
    _confirmText = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, amountFont)];
    _confirmText.text = [NSString stringWithFormat:@"%@ $%@ %@ %@?", _actionIsSend ? @"Send" : @"Request",@([_amountField.text floatValue]).description, _actionIsSend ? @"to" : @"from", _contacts[_recipientIndex][@"name"]];
    _confirmText.textColor = [UIColor whiteColor];
    _confirmText.textAlignment = NSTextAlignmentCenter;
    _confirmText.adjustsFontSizeToFitWidth = YES;
    _confirmText.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:amountFont];
    [self.view addSubview:_confirmText];
    _confirmText.transform = CGAffineTransformMakeTranslation(_confirmText.transform.tx+320, 0);

    _confirmPic = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-_frame.size.height/2)/2,
                                                                _frame.origin.y,
                                                                _frame.size.height/2,
                                                                _frame.size.height/2)];
    _confirmPic.image = [UIImage imageWithData:_contacts[_recipientIndex][@"image"]];
    _confirmPic.layer.masksToBounds = YES;
    _confirmPic.layer.cornerRadius = _collectionView.bounds.size.height/4;
    [self.view addSubview:_confirmPic];
    _confirmPic.transform = CGAffineTransformMakeTranslation(_confirmPic.transform.tx+320, 0);
}

- (void)buttonCheck
{
    BOOL tempHasDecimal = ([_amountField.text rangeOfString:@"."].length == 1);

    if (_hasDecimal != tempHasDecimal)
    {
        if (tempHasDecimal)
        {
            _amountField.keyboardType = UIKeyboardTypeNumberPad;
        }
        else
        {
            _amountField.keyboardType = UIKeyboardTypeDecimalPad;
        }
        [_amountField reloadInputViews];
        _hasDecimal = !_hasDecimal;
    }

    if (_recipientIndex == -1 || [_amountField.text floatValue]<0.50)
    {
        _request.enabled = NO;
        _send.enabled = NO;
    }
    else
    {
        _request.enabled = YES;
        _send.enabled = YES;
    }
}

- (void)request:(JSQFlatButton *)sender
{
    _request.enabled = NO;
    _send.enabled = NO;
    _actionIsSend = NO;
    [self decideActionOnSaveOrRequest];
}

- (void)send:(JSQFlatButton *)sender
{
    _request.enabled = NO;
    _send.enabled = NO;
    _actionIsSend = YES;
    [self decideActionOnSaveOrRequest];
}

- (void)decideActionOnSaveOrRequest
{
    NSLog(@"%@",_contacts[_recipientIndex][@"phone"]);

    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"phoneNumber" equalTo:_contacts[_recipientIndex][@"phone"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error)
         {
             NSLog(@"Query failed: %@ %@", error, [error userInfo]);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error: No Network Connection" message:@"Please connect to a network and retry" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
             [alert show];
         }
         else
         {
             NSLog(@"Query successful: %lu", (unsigned long)objects.count);
             if (objects.count == 0)
             {
                 [self handleRecepientNotOnService];
             }
             else if (objects.count == 1)
             {
                 _recipientId = objects.firstObject[@"recipientId"];
                 [self ask];
             }
             else
             {
#warning handle error multiple user with same number
             }
         }
     }];
}

- (void)handleRecepientNotOnService
{
    if([MFMessageComposeViewController canSendText])
    {
        [self slideOutButtons];
        [self showSMS:_amountField.text];
    }
    else
    {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                               message:@"Your device doesn't support SMS!"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
        [warningAlert show];
    }
}

- (void)ask
{
    [self createConfirmCancelButtons];
    [self createConfirmView];
    [UIView animateWithDuration:.3 animations:^{
        _dollarSign.transform = CGAffineTransformMakeTranslation(_dollarSign.transform.tx-320, 0);
        _amountField.transform = CGAffineTransformMakeTranslation(_amountField.transform.tx-320, 0);
        _collectionView.transform = CGAffineTransformMakeTranslation(_collectionView.transform.tx-320, 0);
        _confirmText.transform = CGAffineTransformMakeTranslation(_confirmText.transform.tx-320, 0);
        _confirmPic.transform = CGAffineTransformMakeTranslation(_confirmPic.transform.tx-320, 0);
        _request.transform = CGAffineTransformMakeTranslation(_request.transform.tx-320, 0);
        _send.transform = CGAffineTransformMakeTranslation(_send.transform.tx-320, 0);
        _cancel.transform = CGAffineTransformMakeTranslation(_cancel.transform.tx-320, 0);
        _confirm.transform = CGAffineTransformMakeTranslation(_confirm.transform.tx-320, 0);
    } completion:^(BOOL finished) {
        _request.enabled = YES;
        _send.enabled = YES;
    }];
}

- (void)confirm:(JSQFlatButton *)sender
{
    _actionIsSend ? [self createCharge] : [self createRequest];
}

- (void)cancel:(JSQFlatButton *)sender
{
    [UIView animateWithDuration:.3 animations:^{
        _dollarSign.transform = CGAffineTransformMakeTranslation(_dollarSign.transform.tx+320, 0);
        _amountField.transform = CGAffineTransformMakeTranslation(_amountField.transform.tx+320, 0);
        _collectionView.transform = CGAffineTransformMakeTranslation(_collectionView.transform.tx+320, 0);
        _confirmText.transform = CGAffineTransformMakeTranslation(_confirmText.transform.tx+320, 0);
        _confirmPic.transform = CGAffineTransformMakeTranslation(_confirmPic.transform.tx+320, 0);
        _request.transform = CGAffineTransformMakeTranslation(_request.transform.tx+320, 0);
        _send.transform = CGAffineTransformMakeTranslation(_send.transform.tx+320, 0);
        _cancel.transform = CGAffineTransformMakeTranslation(_cancel.transform.tx+320, 0);
        _confirm.transform = CGAffineTransformMakeTranslation(_confirm.transform.tx+320, 0);
    } completion:^(BOOL finished) {
        [_OK removeFromSuperview];
    }];
}

- (void)createRequest
{
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    NSString *phoneNumber = _contacts[_recipientIndex][@"phone"];
    NSString *amount = @([_amountField.text floatValue]).description;
    NSString *message = [NSString stringWithFormat:@"%@ has requested $%@", name, amount];

    [self sendPushNotificationTo:phoneNumber With:message Of:@"request" With:amount With:name];
    [self showFaliure:NO];
}

- (void)sendPushNotificationTo:(NSString *)phoneNumber
                          With:(NSString *)message
                            Of:(NSString *)type
                          With:(NSString *)amount
                          With:(NSString *)name
{
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"deviceType" equalTo:@"ios"];
    [pushQuery whereKey:@"phoneNumber" equalTo:phoneNumber];

    NSDictionary *data = @{@"alert":message,
                           @"badge":@"Increment",
                           @"phoneNumber":phoneNumber,
                           @"type":type,
                           @"amount":amount,
                           @"name":name};

    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery];
    [push setData:data];
    [push sendPushInBackground];
}

- (void)handleIncomingPush:(NSNotification *)notification
{
#warning bubble head animation that creates table view with buttons
#warning if request then set action to send and take to confirm screen, else dismiss notification after 5secs
#warning remove annoying default alert view from app
    
    NSDictionary *data = notification.object;
    NSString *alert = data[@"alert"];
    NSString *badge = data[@"badge"];
    NSString *phoneNumber = data[@"phoneNumber"];
    NSString *type = data[@"type"];
    NSString *amount = data[@"amount"];
    NSString *name = data[@"name"];

    NSLog(@"%@ %@ %@ %@ %@ %@",alert,badge,phoneNumber,type,amount,name);
}

- (void)createCharge
{
    _cancel.enabled = NO;
    _confirm.enabled = NO;
    NSString *amount = @([_amountField.text floatValue]*100).description;
    NSString *customerId = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"];

    [PFCloud callFunctionInBackground:@"createCharge"
                       withParameters:@{@"amount":amount, @"customer":customerId}
                                block:^(id chargeId, NSError *error)
     {
         if (error)
         {
             NSLog(@"Card charge failed with error: %@", error.localizedDescription);
             [self showFaliure:YES];
         }
         else
         {
             NSLog(@"Card charged successfully with id: %@", chargeId);
             [self createTransferWithAmount:amount Customer:customerId Recipient:_recipientId Charge:chargeId];
         }
     }];
}

- (void)createTransferWithAmount:(NSString *)amount
                        Customer:(NSString *)customerId
                       Recipient:(NSString *)recipientId
                          Charge:(NSString *)chargeId
{
    NSString *urlString = [NSString stringWithFormat:@"https://%@:@api.stripe.com/v1/transfers",kStripeSecretKey];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    NSString *params = [NSString stringWithFormat:@"amount=%@&currency=usd&recipient=%@",amount,recipientId];
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
             [self showFaliure:YES];
         }
         else
         {
             NSDictionary *output = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
             NSLog(@"SUCCESS: %@", output);

             if (!output[@"id"])
             {
                 NSLog(@"Transfer failed with error: %@", error.localizedDescription);
                 [self showFaliure:YES];
             }
             else
             {
                 NSString *transferId = output[@"id"];
                 NSLog(@"Transfer successful with id: %@", transferId);
                 [self recordTransactionWithAmount:amount Customer:customerId Recipient:recipientId Charge:chargeId Transfer:transferId];
                 [self showFaliure:NO];

                 NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
                 NSString *phoneNumber = _contacts[_recipientIndex][@"phone"];
                 NSString *message = [NSString stringWithFormat:@"%@ sent you $%@", name, amount];
                 [self sendPushNotificationTo:phoneNumber With:message Of:@"send" With:amount With:name];
             }
         }
         _cancel.enabled = YES;
         _confirm.enabled = YES;
     }];
}

- (void)recordTransactionWithAmount:(NSString *)amount
                           Customer:(NSString *)customerId
                          Recipient:(NSString *)recipientId
                             Charge:(NSString *)chargeId
                           Transfer:(NSString *)transferId
{
    PFObject *transaction = [PFObject objectWithClassName:@"Transaction"];
    transaction[@"date"] = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    transaction[@"amount"] = @([_amountField.text floatValue]).description;
    transaction[@"customerId"] = customerId;
    transaction[@"recipientId"] = recipientId;
    transaction[@"chargeId"] = chargeId;
    transaction[@"transferId"] = transferId;
    [transaction saveInBackground];
}

- (void)createStatusText
{
    _statusText = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, amountFont)];
    _statusText.text = @"";
    _statusText.textColor = [UIColor whiteColor];
    _statusText.textAlignment = NSTextAlignmentCenter;
    _statusText.adjustsFontSizeToFitWidth = YES;
    _statusText.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:amountFont];
    [self.view addSubview:_statusText];
    _statusText.transform = CGAffineTransformMakeTranslation(_statusText.transform.tx+320, 0);
}

- (void)createOKButton
{
    _OK = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216-54, self.view.frame.size.width, 54)
                               backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                               foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                         title:@"OK"
                                         image:nil];
    [_OK addTarget:self action:@selector(OK:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_OK];
    _OK.transform = CGAffineTransformMakeTranslation(_OK.transform.tx+320, 0);
}

- (void)showFaliure:(BOOL)answer
{
    [self createStatusText];
    [self createOKButton];
    if (answer)
    {
        _statusText.text = [NSString stringWithFormat:@"Sorry, but failed to %@", _actionIsSend ? @"send" : @"request"];
    }
    else
    {
        _statusText.text = [NSString stringWithFormat:@"Success! %@ $%@", _actionIsSend ? @"Sent" : @"Requested", @([_amountField.text floatValue]).description];
    }

    [UIView animateWithDuration:.3 animations:^{
        _dollarSign.transform = CGAffineTransformMakeTranslation(_dollarSign.transform.tx-320, 0);
        _amountField.transform = CGAffineTransformMakeTranslation(_amountField.transform.tx-320, 0);
        _collectionView.transform = CGAffineTransformMakeTranslation(_collectionView.transform.tx-320, 0);
        _confirmText.transform = CGAffineTransformMakeTranslation(_confirmText.transform.tx-320, 0);
//        _confirmPic.transform = CGAffineTransformMakeTranslation(_confirmPic.transform.tx-320, 0);
        _request.transform = CGAffineTransformMakeTranslation(_request.transform.tx-320, 0);
        _send.transform = CGAffineTransformMakeTranslation(_send.transform.tx-320, 0);
        _cancel.transform = CGAffineTransformMakeTranslation(_cancel.transform.tx-320, 0);
        _confirm.transform = CGAffineTransformMakeTranslation(_confirm.transform.tx-320, 0);
        _statusText.transform = CGAffineTransformMakeTranslation(_statusText.transform.tx-320, 0);
        _OK.transform = CGAffineTransformMakeTranslation(_OK.transform.tx-320, 0);
    }];
}

- (void)OK:(JSQFlatButton *)sender
{
    [UIView animateWithDuration:.6 animations:^{
        _dollarSign.transform = CGAffineTransformMakeTranslation(_dollarSign.transform.tx+320*2, 0);
        _amountField.transform = CGAffineTransformMakeTranslation(_amountField.transform.tx+320*2, 0);
        _collectionView.transform = CGAffineTransformMakeTranslation(_collectionView.transform.tx+320*2, 0);
        _confirmText.transform = CGAffineTransformMakeTranslation(_confirmText.transform.tx+320*2, 0);
        _confirmPic.transform = CGAffineTransformMakeTranslation(_confirmPic.transform.tx+320, 0);
        _request.transform = CGAffineTransformMakeTranslation(_request.transform.tx+320*2, 0);
        _send.transform = CGAffineTransformMakeTranslation(_send.transform.tx+320*2, 0);
        _cancel.transform = CGAffineTransformMakeTranslation(_cancel.transform.tx+320*2, 0);
        _confirm.transform = CGAffineTransformMakeTranslation(_confirm.transform.tx+320*2, 0);
        _statusText.transform = CGAffineTransformMakeTranslation(_statusText.transform.tx+320*2, 0);
        _OK.transform = CGAffineTransformMakeTranslation(_OK.transform.tx+320*2, 0);
    }];
}

- (void)slideOutButtons
{
    [UIView animateWithDuration:.3 animations:^{
        _send.transform = CGAffineTransformMakeTranslation(_send.transform.tx+320, 0);
        _request.transform = CGAffineTransformMakeTranslation(_request.transform.tx-320, 0);
    } completion:^(BOOL finished) {
        _request.enabled = YES;
        _send.enabled = YES;
    }];
}

- (void)slideInButtons
{
    [UIView animateWithDuration:.3 animations:^{
        _send.transform = CGAffineTransformMakeTranslation(0, 0);
        _request.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UICollectionView DataSource/Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_recipientIndex == (int)indexPath.item)
    {
        _recipientIndex = -1;
    }
    else
    {
        _recipientIndex = (int)indexPath.item;
    }
    [collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _contacts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    if (_recipientIndex == (int)indexPath.item)
    {
        UIImageView *check = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
        check.layer.masksToBounds = YES;
        check.layer.cornerRadius = 48/2;
        cell.backgroundView = check;
    }
    else
    {
        NSData *imageData = _contacts[indexPath.item][@"image"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 48/2;
        cell.backgroundView = imageView;
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(48,48);
}

#pragma mark - SMS Messaging

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            break;

        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                   message:@"Failed to send SMS!"
                                                                  delegate:nil cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
            [warningAlert show];
            break;
        }

        case MessageComposeResultSent:
            break;

        default:
            break;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    [self slideInButtons];
    [_amountField becomeFirstResponder];
}

- (void)showSMS:(NSString*)file
{
//    NSArray *recipients = @[@"12345678", @"72345524"];
    NSArray *recipients = @[_contacts[_recipientIndex][@"phone"]];
    NSString *message;
    if (_actionIsSend)
    {
        message = [NSString stringWithFormat:@"Here's $%@. Download this app to get it: appstore.com/cents", file];
    }
    else
    {
        message = [NSString stringWithFormat:@"Please send me $%@ on this app: appstore.com/cents", file];
    }

    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipients];
    [messageController setBody:message];
    [self presentViewController:messageController animated:YES completion:nil];
}

#pragma mark - Contacts

- (void)fetchContacts
{
    ABAddressBookRef addressBook = ABAddressBookCreate();

    if (ABAddressBookRequestAccessWithCompletion != NULL)
    {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     if (granted)
                                                     {
                                                         [self getContactsWithAddressBook:addressBook];
                                                     }
                                                 });
    }
}

- (void)getContactsWithAddressBook:(ABAddressBookRef)addressBook
{
    _contacts = [NSMutableArray new];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
	CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);

    for (int i=0;i < nPeople;i++)
    {
		NSMutableDictionary *dOfPerson = [NSMutableDictionary new];

		ABRecordRef person = CFArrayGetValueAtIndex(allPeople,i);

		ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(person, kABPersonPhoneProperty));
        CFStringRef firstName, lastName;
		firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
		lastName  = ABRecordCopyValue(person, kABPersonLastNameProperty);
		[dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];

		NSString *mobileLabel;
		for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++)
        {
			mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
			if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
			{
				[dOfPerson setObject:[CleanPhoneNumber clean:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i)] forKey:@"phone"];
			}
			else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
			{
				[dOfPerson setObject:[CleanPhoneNumber clean:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i)] forKey:@"phone"];
				break;
			}
        }

        if (ABPersonHasImageData(person))
        {
            NSData *contactImageData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
            [dOfPerson setObject:contactImageData forKey:@"image"];
        }
        
        if (dOfPerson[@"phone"] && dOfPerson[@"image"])
        {
            [_contacts addObject:dOfPerson];
        }
	}

//    for (NSDictionary *contact in _contacts)
//    {
//        NSLog(@"Name: %@, Number: %@",contact[@"name"],contact[@"phone"]);
//    }
    [_collectionView reloadData];
}

@end