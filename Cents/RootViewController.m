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

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPopoverControllerDelegate, MFMessageComposeViewControllerDelegate>
@property UILabel *amountLabel;
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
    [self createKeyboard];
    [self createSendRequestButtons];
    [self createContactsView];

    self.buttonCheckTimer = [NSTimer scheduledTimerWithTimeInterval:1/10 target:self selector:@selector(buttonCheck) userInfo:nil repeats:YES];
}

- (void)fetchContacts
{
#warning fetch contacts from address book

    _contacts = @[
                  @{@"first_name":@"Sapan",@"lastname":@"Bhuta",@"phone":@"6149377494"},
                  @{@"first_name":@"Sapan",@"lastname":@"Bhuta",@"phone":@"6149377494"},
                  @{@"first_name":@"Sapan",@"lastname":@"Bhuta",@"phone":@"6149377494"},
                  @{@"first_name":@"Sapan",@"lastname":@"Bhuta",@"phone":@"6149377494"},
                  @{@"first_name":@"Sapan",@"lastname":@"Bhuta",@"phone":@"6149377494"},
                  @{@"first_name":@"Sapan",@"lastname":@"Bhuta",@"phone":@"6149377494"},
                  @{@"first_name":@"Sapan",@"lastname":@"Bhuta",@"phone":@"6149377494"},
                  @{@"first_name":@"Sapan",@"lastname":@"Bhuta",@"phone":@"6149377494"},
                  @{@"first_name":@"Sapan",@"lastname":@"Bhuta",@"phone":@"6149377494"},
                  @{@"first_name":@"Sapan",@"lastname":@"Bhuta",@"phone":@"6149377494"},
                  ];
}

- (void)createAmountLabel
{
    self.view.backgroundColor = [UIColor wisteriaColor];

    _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, amountFont)];
    _amountLabel.textColor = [UIColor whiteColor];
    _amountLabel.text = @"$0";
    _amountLabel.textAlignment = NSTextAlignmentCenter;
    _amountLabel.adjustsFontSizeToFitWidth = YES;
    _amountLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:amountFont];
    [self.view addSubview:_amountLabel];
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

- (void)createKeyboard
{
    UIView *keyboard = [[UIView alloc] initWithFrame:CGRectMake(0, 160, 320, 5*gap)];
    //    keyboard.backgroundColor = [UIColor blackColor];
    [self.view addSubview:keyboard];

    UIButton *one = [UIButton buttonWithType:UIButtonTypeSystem];
    one.tag = 1;
    [one addTarget:self action:@selector(keyPress:) forControlEvents:UIControlEventTouchUpInside];
    [one setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    one.frame = CGRectMake(0, 0, buttonSize, buttonSize);
    one.center = CGPointMake(160-gap, gap);
    [keyboard addSubview:one];

    UIButton *two = [UIButton buttonWithType:UIButtonTypeSystem];
    two.tag = 2;
    [two addTarget:self action:@selector(keyPress:) forControlEvents:UIControlEventTouchUpInside];
    [two setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    two.frame = CGRectMake(0, 0, buttonSize, buttonSize);
    two.center = CGPointMake(160, gap);
    [keyboard addSubview:two];

    UIButton *three = [UIButton buttonWithType:UIButtonTypeSystem];
    three.tag = 3;
    [three addTarget:self action:@selector(keyPress:) forControlEvents:UIControlEventTouchUpInside];
    [three setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    three.frame = CGRectMake(0, 0, buttonSize, buttonSize);
    three.center = CGPointMake(160+gap, gap);
    [keyboard addSubview:three];

    UIButton *four = [UIButton buttonWithType:UIButtonTypeSystem];
    four.tag = 4;
    [four addTarget:self action:@selector(keyPress:) forControlEvents:UIControlEventTouchUpInside];
    [four setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    four.frame = CGRectMake(0, 0, buttonSize, buttonSize);
    four.center = CGPointMake(160-gap, gap*2);
    [keyboard addSubview:four];

    UIButton *five = [UIButton buttonWithType:UIButtonTypeSystem];
    five.tag = 5;
    [five addTarget:self action:@selector(keyPress:) forControlEvents:UIControlEventTouchUpInside];
    [five setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    five.frame = CGRectMake(0, 0, buttonSize, buttonSize);
    five.center = CGPointMake(160, gap*2);
    [keyboard addSubview:five];

    UIButton *six = [UIButton buttonWithType:UIButtonTypeSystem];
    six.tag = 6;
    [six addTarget:self action:@selector(keyPress:) forControlEvents:UIControlEventTouchUpInside];
    [six setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    six.frame = CGRectMake(0, 0, buttonSize, buttonSize);
    six.center = CGPointMake(160+gap, gap*2);
    [keyboard addSubview:six];

    UIButton *seven = [UIButton buttonWithType:UIButtonTypeSystem];
    seven.tag = 7;
    [seven addTarget:self action:@selector(keyPress:) forControlEvents:UIControlEventTouchUpInside];
    [seven setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    seven.frame = CGRectMake(0, 0, buttonSize, buttonSize);
    seven.center = CGPointMake(160-gap, gap*3);
    [keyboard addSubview:seven];

    UIButton *eight = [UIButton buttonWithType:UIButtonTypeSystem];
    eight.tag = 8;
    [eight addTarget:self action:@selector(keyPress:) forControlEvents:UIControlEventTouchUpInside];
    [eight setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    eight.frame = CGRectMake(0, 0, buttonSize, buttonSize);
    eight.center = CGPointMake(160, gap*3);
    [keyboard addSubview:eight];

    UIButton *nine = [UIButton buttonWithType:UIButtonTypeSystem];
    nine.tag = 9;
    [nine addTarget:self action:@selector(keyPress:) forControlEvents:UIControlEventTouchUpInside];
    [nine setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    nine.frame = CGRectMake(0, 0, buttonSize, buttonSize);
    nine.center = CGPointMake(160+gap, gap*3);
    [keyboard addSubview:nine];

    UIButton *dot = [UIButton buttonWithType:UIButtonTypeSystem];
    dot.tag = 10;
    [dot addTarget:self action:@selector(keyPress:) forControlEvents:UIControlEventTouchUpInside];
    [dot setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    dot.frame = CGRectMake(0, 0, buttonSize, buttonSize);
    dot.center = CGPointMake(160-gap, gap*4);
    [keyboard addSubview:dot];

    UIButton *zero = [UIButton buttonWithType:UIButtonTypeSystem];
    zero.tag = 0;
    [zero addTarget:self action:@selector(keyPress:) forControlEvents:UIControlEventTouchUpInside];
    [zero setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    zero.frame = CGRectMake(0, 0, buttonSize, buttonSize);
    zero.center = CGPointMake(160, gap*4);
    [keyboard addSubview:zero];

    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.tag = 12;
    [back addTarget:self action:@selector(keyPress:) forControlEvents:UIControlEventTouchUpInside];
    [back setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    back.frame = CGRectMake(0, 0, buttonSize, buttonSize);
    back.center = CGPointMake(160+gap, gap*4);
    [keyboard addSubview:back];
}

- (void)createSendRequestButtons
{
    _request = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-54, 159.75, 54)
                                    backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                    foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                              title:@"Request"
                                              image:nil];//[UIImage imageNamed:@"down"]];
    [_request addTarget:self action:@selector(request:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_request];

    _send = [[JSQFlatButton alloc] initWithFrame:CGRectMake(160.25, self.view.frame.size.height-54, 159.75, 54)
                                 backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                 foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                           title:@"Send"
                                           image:nil];//[UIImage imageNamed:@"up"]];
    [_send addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_send];
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
        [self showSMS:_amountLabel.text];
    }
}

- (BOOL)userIsInDataBase:(NSString *)number
{
    return NO;
}

- (void)keyPress:(UIButton *)sender
{
    if (sender.tag == 10)
    {
        if ([self containsDecimal])
        {
            [self shakeAmountLabel];
        }
        else
        {
            _amountLabel.text = [_amountLabel.text stringByAppendingString:@"."];
        }
    }
    else if (sender.tag == 12)
    {
        if ([_amountLabel.text length] > 2)
        {
            _amountLabel.text = [_amountLabel.text substringToIndex:[_amountLabel.text length]-1];
        }
        else if (![_amountLabel.text isEqualToString:@"$0"])
        {
            _amountLabel.text = @"$0";
        }
        else
        {
            [self shakeAmountLabel];
        }
    }
    else
    {
        if ([self hasTwoDecimalPlaces])
        {
            [self shakeAmountLabel];
        }
        else
        {
            if ([_amountLabel.text isEqualToString:@"$0"])
            {
                _amountLabel.text = [@"$" stringByAppendingString:@(sender.tag).description];
            }
            else
            {
                _amountLabel.text = [_amountLabel.text stringByAppendingString:@(sender.tag).description];
            }
        }
    }

    _amount = [_amountLabel.text floatValue];
}

- (BOOL)containsDecimal
{
    NSArray *arr = [_amountLabel.text componentsSeparatedByString:@"."];
    if (arr.count > 1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)hasTwoDecimalPlaces
{
    NSRange range = [_amountLabel.text rangeOfString:@"."];
    if (range.location != NSNotFound && ([_amountLabel.text length]-1-range.location) == 2)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)shakeAmountLabel
{
    [UIView animateWithDuration:0.1 animations:^{
        _amountLabel.transform = CGAffineTransformMakeTranslation(10, 0);
    } completion:^(BOOL finished) {
        // Step 2
        [UIView animateWithDuration:0.1 animations:^{
            _amountLabel.transform = CGAffineTransformMakeTranslation(-10, 0);
        } completion:^(BOOL finished) {
            // Step 3
            [UIView animateWithDuration:0.1 animations:^{
                _amountLabel.transform = CGAffineTransformMakeTranslation(0, 0);
            }];
        }];
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
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }

        case MessageComposeResultSent:
            break;

        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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

}

@end