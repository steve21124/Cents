//
//  RootViewController.m
//  Cents
//
//  Created by Sapan Bhuta on 7/27/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#define amountFont 100
#define buttonSize 75
#define gap 75

#import "RootViewController.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import <MessageUI/MessageUI.h>
#import <Parse/Parse.h>
#import "TSCurrencyTextField.h"
#import "JDFCurrencyTextField.h"
#import "Contacts.h"

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPopoverControllerDelegate, MFMessageComposeViewControllerDelegate, UITextFieldDelegate>
@property TSCurrencyTextField *amountLabel;
@property UICollectionView *collectionView;
@property CGFloat amount;
@property BOOL actionIsSend;
@property int recipientIndex;
@property JSQFlatButton *request;
@property JSQFlatButton *send;
@property JSQFlatButton *cancel;
@property JSQFlatButton *confirm;
@property NSArray *contacts;
@property NSTimer *buttonCheckTimer;
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

- (void)fetchContacts
{
    Contacts *contacts = [Contacts new];
    _contacts = contacts.contacts;
}

- (void)createAmountLabel
{
    self.view.backgroundColor = [UIColor wisteriaColor];

    _amountLabel = [[TSCurrencyTextField alloc] initWithFrame:CGRectMake(0, 30, 320, amountFont)];
    _amountLabel.textColor = [UIColor whiteColor];
    _amountLabel.textAlignment = NSTextAlignmentCenter;
    _amountLabel.keyboardAppearance = UIKeyboardAppearanceDark;
    _amountLabel.keyboardType = UIKeyboardTypeDecimalPad;
    _amountLabel.adjustsFontSizeToFitWidth = YES;
    _amountLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:amountFont];
    [self.view addSubview:_amountLabel];
    [_amountLabel becomeFirstResponder];
}

- (void)createContactsView
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30+amountFont, 320, 70) collectionViewLayout:flow];
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
                                              image:nil];//[UIImage imageNamed:@"down"]];
    [_request addTarget:self action:@selector(request:) forControlEvents:UIControlEventTouchUpInside];
    _request.enabled = NO;
    _request.transform = CGAffineTransformMakeTranslation(_request.transform.tx-320, 0);
    [self.view addSubview:_request];

    _send = [[JSQFlatButton alloc] initWithFrame:CGRectMake(160.25, self.view.frame.size.height-216-54, 159.75, 54)
                                 backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                 foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                           title:@"Send"
                                           image:nil];//[UIImage imageNamed:@"up"]];
    [_send addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    _send.enabled = NO;
    _send.transform = CGAffineTransformMakeTranslation(_send.transform.tx+320, 0);
    [self.view addSubview:_send];

    [self slideInButtons];
}

- (void)buttonCheck
{
    if (_recipientIndex == -1)
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
    _actionIsSend = NO;

    if ([self userIsInDataBase:_contacts[_recipientIndex][@"phone"]])
    {
#warning send push notification and chat head bubble to recipient asking for money
#warning create unique rootView screen with pre selected amount and person
    }
    else
    {
        [self slideOutButtons];
        [self showSMS:_amountLabel.text];
    }
}

- (void)send:(JSQFlatButton *)sender
{
    _actionIsSend = YES;

    if ([self userIsInDataBase:_contacts[_recipientIndex][@"phone"]])
    {
#warning make a new charge using stripe
#warning show a confirmation
    }
    else
    {
        [self slideOutButtons];
        [self showSMS:_amountLabel.text];
    }
}

- (void)slideOutButtons
{
    [UIView animateWithDuration:.3 animations:^{
        _send.transform = CGAffineTransformMakeTranslation(_send.transform.tx+320, 0);
        _request.transform = CGAffineTransformMakeTranslation(_request.transform.tx-320, 0);
    }];
}

- (void)slideInButtons
{
    [UIView animateWithDuration:.3 animations:^{
        _send.transform = CGAffineTransformMakeTranslation(0, 0);
        _request.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

- (BOOL)userIsInDataBase:(NSString *)number
{
#warning check phone number is in database
    return NO;
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
    return 10;
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
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Profile"]];;
        //        [imageView setImageWithURL:[NSURL URLWithString:@"Profile"] placeholderImage:[UIImage imageNamed:@"Profile"]];
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
    [_amountLabel becomeFirstResponder];
}

- (void)showSMS:(NSString*)file
{

    if(![MFMessageComposeViewController canSendText])
    {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }

//    NSArray *recipients = @[@"12345678", @"72345524"];
    NSArray *recipients = @[_contacts[_recipientIndex][@"phone"]];
    NSString *message;
    if (_actionIsSend)
    {
        message = [NSString stringWithFormat:@"Here's %@. Download this app to get it: appstore.com/cents", file];
    }
    else
    {
        message = [NSString stringWithFormat:@"Please send me %@ on this app: appstore.com/cents", file];
    }

    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipients];
    [messageController setBody:message];
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)chargeStripe
{
#warning chargeStripe
}

@end