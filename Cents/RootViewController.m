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

#define kContactsCollectionView 0
#define kScenesCollectionView 1
#define kNotificationsTableView 2
#define kHistoryTableView 3

#define includeBlankContacts NO
#define enableNotifications !NO
#define enableSettings NO

#define greenColor [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0]
#define redColor [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];

#import "RootViewController.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import <MessageUI/MessageUI.h>
#import <Parse/Parse.h>
#import "CleanPhoneNumber.h"
@import AddressBook;
#import "FXBlurView.h"
#import "SWTableViewCell.h"
#import "NSMutableArray+SWUtilityButtons.h"
#import "MenuView.h"
#import "SettingsViewController.h"
#import "SettingsButton.h"
#import "SBCollectionViewCell.h"

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPopoverControllerDelegate, MFMessageComposeViewControllerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>
@property UILabel *dollarSign;
@property UITextField *amountField;
@property CGRect frame;
@property UICollectionView *contactsCollectionView;
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
@property NSMutableArray *notifications;
@property UITableView *notificationsTableView;
@property BOOL showingNotifications;
@property FXBlurView *blurView;
@property BOOL takingAction;
@property UICollectionView *scenesCollectionView;
@property NSMutableArray *scenes;
@property NSArray *transactions;
@property UITableView *historyTableView;
@property (nonatomic) UIView *topLineView;
@property (nonatomic) UIView *centerLineView;
@property (nonatomic) UIView *bottomLineView;
@property (nonatomic) UIView *containerView;
@property (nonatomic) BOOL displayingMenu;
@property MenuView *menuView;
@property UIButton *settingsButton;
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _recipientIndex = -1;
    [self fetchContacts];
    [self createAmountLabel];
    [self createSendRequestButtons];
    _scenes = [NSMutableArray new];
    [self createScenesView];
    [self createContactsView];
    [self createHistoryView];
    [self createSettingsButton];
    [self createBlurView];
    [self createNotificationsView];
    [self createMenuView];
    _showingNotifications = false;
    _notifications = [NSMutableArray new];
    _buttonCheckTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(buttonCheck) userInfo:nil repeats:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNotifications) name:@"morph" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideNotifications) name:@"unmorph" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pingParseForNotifications) name:@"push" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideSettings) name:@"spin" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_amountField becomeFirstResponder];
    [self pingParseForNotifications];
}

- (void)pingParseForNotifications
{
    PFQuery *query = [PFQuery queryWithClassName:@"Notification"];
    [query whereKey:@"recipientPhoneNumber" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error)
         {
#warning handle error
         }
         else if (objects.count == 0)
         {
             //do nothing
         }
         else if (!_showingNotifications)
         {
//             NSLog(@"notifications %@",objects);
             _notifications = [objects mutableCopy];
             [_notificationsTableView reloadData];
             [[UIApplication sharedApplication] setApplicationIconBadgeNumber:_notifications.count];
//             if (enableNotifications)
//             {
//                 [self showNotifications];
//                 [_menuView morphToX];
//             }
         }
     }];
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

    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery];
    [push setMessage:message];
    [push sendPushInBackground];

    PFObject *notification = [PFObject objectWithClassName:@"Notification"];
    notification[@"recipientPhoneNumber"] = phoneNumber;
    notification[@"senderPhoneNumber"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    notification[@"message"] = message;
    notification[@"type"] = type;
    notification[@"amount"] = amount;
    notification[@"name"] = name;
    [notification saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (error)
        {
#warning handle error
        }
    }];
}

- (void)showNotifications
{
    if (!_showingNotifications)
    {
        _showingNotifications = true;
        _blurView.dynamic = YES;
        [UIView animateWithDuration:.3 animations:^{
            _blurView.transform = CGAffineTransformMakeTranslation(0, 0);
            _notificationsTableView.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            _blurView.dynamic = NO;
        }];
    }
}

- (void)hideNotifications
{
    if (_showingNotifications)
    {
        _showingNotifications = false;
        _blurView.dynamic = YES;
        [UIView animateWithDuration:.3 animations:^{
            _blurView.transform = CGAffineTransformMakeTranslation(0, -(self.view.frame.size.height-216));
            _notificationsTableView.transform = CGAffineTransformMakeTranslation(0,-(self.view.frame.size.height-216));
        } completion:^(BOOL finished) {
            _blurView.dynamic = NO;
        }];
    }
}

- (void)createBlurView
{
    _blurView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-216)];
    _blurView.alpha = .9;
    [self.view addSubview:_blurView];
    _blurView.transform = CGAffineTransformMakeTranslation(0, -(self.view.frame.size.height-216));
}

- (void)createNotificationsView
{
    _notificationsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width-50, self.view.frame.size.height-216-30)
                                                           style:UITableViewStylePlain];
    _notificationsTableView.delegate = self;
    _notificationsTableView.dataSource = self;
    _notificationsTableView.backgroundColor = [UIColor clearColor];
    _notificationsTableView.separatorColor = [UIColor clearColor];
    _notificationsTableView.tag = kNotificationsTableView;
    _notificationsTableView.allowsSelection = NO;
//    _notificationsTableView.alwaysBounceVertical = NO;
    [self.view addSubview:_notificationsTableView];
    _notificationsTableView.transform = CGAffineTransformMakeTranslation(0, -(self.view.frame.size.height-216));
}

- (void)createSettingsButton
{
    _settingsButton = [SettingsButton buttonWithType:UIButtonTypeSystem];
    _settingsButton.frame = CGRectMake(270, 80, 40, 40);
    _settingsButton.tintColor = [UIColor whiteColor];
    [_settingsButton setImage:[UIImage imageNamed:@"gear"] forState:UIControlStateNormal];
    [_settingsButton addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_settingsButton];
    _settingsButton.hidden = !enableSettings;
}

- (void)showSettings
{
//    [self slideOutButtons];
    [self animateSettingsButton];
}

- (void)hideSettings
{
//    [self slideInButtons];
    [self animateSettingsButton];
}

- (void)animateSettingsButton
{
    if (CGAffineTransformIsIdentity(_settingsButton.transform))
    {
        [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _settingsButton.transform = CGAffineTransformMakeRotation(M_PI);
            [self presentViewController:[SettingsViewController new] animated:YES completion:nil];
        } completion:^(BOOL finished) {
        }];
    }
    else
    {
        [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _settingsButton.transform = CGAffineTransformIdentity;
            [self presentViewController:[SettingsViewController new] animated:YES completion:nil];
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)createHistoryView
{
    _historyTableView = [[UITableView alloc] initWithFrame:_scenesCollectionView.bounds style:UITableViewStylePlain];
    _historyTableView.delegate = self;
    _historyTableView.dataSource = self;
    _historyTableView.backgroundColor = [UIColor clearColor];
    _historyTableView.tag = kHistoryTableView;
    _historyTableView.separatorColor = [UIColor clearColor];
    _historyTableView.allowsSelection = NO;
    [_scenes addObject:_historyTableView];
    [_scenesCollectionView reloadData];

    [self updateHistoryView];
}

- (void)updateHistoryView
{
    PFQuery *customerId = [PFQuery queryWithClassName:@"Transaction"];
    [customerId whereKey:@"customerId" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"]];
    PFQuery *recipientId = [PFQuery queryWithClassName:@"Transaction"];
    [recipientId whereKey:@"recipientId" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"recipientId"]];
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[customerId,recipientId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error)
         {
#warning handle error
         }
         else
         {
             _transactions = objects;
             [_historyTableView reloadData];

             if (_transactions.count > 0)
             {
                 [_historyTableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:_transactions.count-1 inSection:0]
                                          atScrollPosition: UITableViewScrollPositionTop
                                                  animated: YES];
             }
         }
     }];
}

- (void)createContactsView
{
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    CGRect frame;
    if (self.view.frame.size.height <= 480)
    {
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        frame = _scenesCollectionView.bounds;
    }
    else
    {
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        frame = _scenesCollectionView.bounds;
    }

    _contactsCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flow];
    _contactsCollectionView.backgroundColor = [UIColor clearColor];
    _contactsCollectionView.delegate = self;
    _contactsCollectionView.dataSource = self;
    [_contactsCollectionView registerClass:[SBCollectionViewCell class] forCellWithReuseIdentifier:@"ContactsCell"];
    _contactsCollectionView.tag = kContactsCollectionView;
    [_scenes addObject:_contactsCollectionView];
    [_scenesCollectionView reloadData];
}

- (void)createScenesView
{
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    flow.minimumLineSpacing = 0;

    if (self.view.frame.size.height <= 480)
    {
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _frame = CGRectMake(0, 30+amountFont, 320, 70);
    }
    else
    {
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _frame = CGRectMake(0, 30+amountFont, 320, self.view.frame.size.height - 30 - amountFont - 216 -54);
    }
    _scenesCollectionView = [[UICollectionView alloc] initWithFrame:_frame collectionViewLayout:flow];
    _scenesCollectionView.backgroundColor = [UIColor clearColor];
    _scenesCollectionView.delegate = self;
    _scenesCollectionView.dataSource = self;
    _scenesCollectionView.pagingEnabled = YES;
    [_scenesCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ScenesCell"];
    _scenesCollectionView.tag = kScenesCollectionView;
    [self.view addSubview:_scenesCollectionView];
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

- (void)createAmountLabel
{
    self.view.backgroundColor = [UIColor wisteriaColor];

    _dollarSign = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 20, amountFont)];
    _dollarSign.text = @"$";
    _dollarSign.textColor = [UIColor whiteColor];
    _dollarSign.adjustsFontSizeToFitWidth = YES;
    _dollarSign.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:amountFont];
    [self.view addSubview:_dollarSign];

    _amountField = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, 280-50, amountFont)];
    _amountField.placeholder = @"enter amount";
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

- (void)createMenuView
{
    _menuView = [[MenuView alloc] initWithFrame:CGRectMake(270, 30, 40, 40)];
    [self.view addSubview:_menuView];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMenu)];
    [_menuView addGestureRecognizer:tapRecognizer];
}

- (void)toggleMenu
{
    [self pingParseForNotifications];
    if (_showingNotifications)
    {
        [self hideNotifications];
        [_menuView morphToLine];
    }
    else
    {
        [self showNotifications];
        [_menuView morphToX];
    }
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
    _confirmPic.image = _contacts[_recipientIndex][@"image"];
    _confirmPic.layer.masksToBounds = YES;
    _confirmPic.layer.cornerRadius = _contactsCollectionView.bounds.size.height/4;
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

    if (_recipientIndex == -1 || [_amountField.text floatValue]<0.50 || _takingAction)
    {
        _request.enabled = NO;
        _send.enabled = NO;
    }
    else
    {
        _request.enabled = YES;
        _send.enabled = YES;
    }

    _menuView.label.text = @(_notifications.count).description;
    if (_notifications.count > 0 && !_showingNotifications)
    {
        _menuView.backgroundColor = [UIColor tangerineColor];
    }
    else
    {
        _menuView.backgroundColor = [UIColor clearColor];
    }

    [self.view bringSubviewToFront:_blurView];
    [self.view bringSubviewToFront:_notificationsTableView];
    [self.view bringSubviewToFront:_menuView];
}

- (void)request:(JSQFlatButton *)sender
{
    _actionIsSend = NO;
    [self decideActionOnSaveOrRequest];
}

- (void)send:(JSQFlatButton *)sender
{
    _actionIsSend = YES;
    [self decideActionOnSaveOrRequest];
}

- (void)decideActionOnSaveOrRequest
{
    _takingAction = YES;

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
                 for (PFObject *user in objects)
                 {
                     [user deleteInBackground];
                 }
                 [self handleRecepientNotOnService];
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
        _menuView.transform = CGAffineTransformMakeTranslation(_menuView.transform.tx-320, 0);
        _settingsButton.transform = CGAffineTransformMakeTranslation(_settingsButton.transform.tx-320, 0);
        _amountField.transform = CGAffineTransformMakeTranslation(_amountField.transform.tx-320, 0);
        _scenesCollectionView.transform = CGAffineTransformMakeTranslation(_scenesCollectionView.transform.tx-320, 0);
        _confirmText.transform = CGAffineTransformMakeTranslation(_confirmText.transform.tx-320, 0);
        _confirmPic.transform = CGAffineTransformMakeTranslation(_confirmPic.transform.tx-320, 0);
        _request.transform = CGAffineTransformMakeTranslation(_request.transform.tx-320, 0);
        _send.transform = CGAffineTransformMakeTranslation(_send.transform.tx-320, 0);
        _cancel.transform = CGAffineTransformMakeTranslation(_cancel.transform.tx-320, 0);
        _confirm.transform = CGAffineTransformMakeTranslation(_confirm.transform.tx-320, 0);
    } completion:^(BOOL finished) {
        _takingAction = NO;
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
        _menuView.transform = CGAffineTransformMakeTranslation(_menuView.transform.tx+320, 0);
        _settingsButton.transform = CGAffineTransformMakeTranslation(_settingsButton.transform.tx+320, 0);
        _amountField.transform = CGAffineTransformMakeTranslation(_amountField.transform.tx+320, 0);
        _scenesCollectionView.transform = CGAffineTransformMakeTranslation(_scenesCollectionView.transform.tx+320, 0);
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
             NSLog(@"Card charge successful with id: %@", chargeId);
             [self createTransferWithAmount:amount Customer:customerId Recipient:_recipientId Charge:chargeId];
         }
     }];
}

- (void)createTransferWithAmount:(NSString *)amount
                        Customer:(NSString *)customerId
                       Recipient:(NSString *)recipientId
                          Charge:(NSString *)chargeId
{
    [PFCloud callFunctionInBackground:@"createTransfer"
                       withParameters:@{@"amount":amount,@"recipient":recipientId}
                                block:^(id object, NSError *error)
    {
         if (error)
         {
             NSLog(@"ERROR: %@",error);
#warning handle error
             [self showFaliure:YES];
         }
         else
         {
             NSLog(@"%@",object);

             if (!object[@"id"])
             {
                 NSLog(@"Transfer failed with error: %@", error.localizedDescription);
                 [self showFaliure:YES];
             }
             else
             {
                 NSString *transferId = object[@"id"];
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
    transaction[@"recipientPhoneNumber"] = _contacts[_recipientIndex][@"phone"];
    transaction[@"senderPhoneNumber"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
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
        _menuView.transform = CGAffineTransformMakeTranslation(_menuView.transform.tx-320, 0);
        _settingsButton.transform = CGAffineTransformMakeTranslation(_settingsButton.transform.tx-320, 0);
        _amountField.transform = CGAffineTransformMakeTranslation(_amountField.transform.tx-320, 0);
        _scenesCollectionView.transform = CGAffineTransformMakeTranslation(_scenesCollectionView.transform.tx-320, 0);
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
        _menuView.transform = CGAffineTransformMakeTranslation(_menuView.transform.tx+320*2, 0);
        _settingsButton.transform = CGAffineTransformMakeTranslation(_settingsButton.transform.tx+320*2, 0);
        _amountField.transform = CGAffineTransformMakeTranslation(_amountField.transform.tx+320*2, 0);
        _scenesCollectionView.transform = CGAffineTransformMakeTranslation(_scenesCollectionView.transform.tx+320*2, 0);
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
        _takingAction = NO;
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

#pragma mark - UITableView DataSource/Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == kHistoryTableView)
    {
        return _transactions.count;
    }
    else
    {
        return _notifications.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kHistoryTableView)
    {
        return 44;
    }
    else
    {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kHistoryTableView)
    {
        //do nothing
    }
    else
    {
        SWTableViewCell *cell = (SWTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if ([cell isUtilityButtonsHidden])
        {
            [cell showLeftUtilityButtonsAnimated:YES];
        }
        else
        {
            [cell hideUtilityButtonsAnimated:YES];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kHistoryTableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"historyCell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.imageView.layer.masksToBounds = YES;
            cell.imageView.layer.cornerRadius = 22;
            cell.textLabel.textColor = [UIColor whiteColor];
        }

        NSDictionary *transaction = _transactions[indexPath.row];
        cell.detailTextLabel.text = transaction[@"amount"];

        if ([transaction[@"senderPhoneNumber"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]])
        {
            for (NSDictionary *contact in _contacts)
            {
                if ([contact[@"phone"] isEqualToString:transaction[@"recipientPhoneNumber"]])
                {
                    cell.imageView.image = contact[@"image"];
                    cell.textLabel.text = contact[@"name"];
                    cell.detailTextLabel.textColor = redColor;
                }
            }
        }
        else
        {
            for (NSDictionary *contact in _contacts)
            {
                if ([contact[@"phone"] isEqualToString:transaction[@"senderPhoneNumber"]])
                {
                    cell.imageView.image = contact[@"image"];
                    cell.textLabel.text = contact[@"name"];
                    cell.detailTextLabel.textColor = greenColor;
                }
            }
        }
        return cell;
    }
    else
    {
        SWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell"];
        if (!cell)
        {
            cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"notificationCell"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.imageView.layer.masksToBounds = YES;
            cell.imageView.layer.cornerRadius = 30;
            cell.leftUtilityButtons = [self leftButtons];
            cell.delegate = self;
        }
        NSDictionary *notification = _notifications[indexPath.item];
        cell.textLabel.text = notification[@"message"];
        cell.textLabel.font = [UIFont systemFontOfSize:10];

        for (NSDictionary *contact in _contacts)
        {
            if ([contact[@"phone"] isEqualToString:notification[@"senderPhoneNumber"]])
            {
                cell.imageView.image = contact[@"image"];
            }
        }

        return cell;
    }
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];

    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                icon:[UIImage imageNamed:@"check.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
                                                icon:[UIImage imageNamed:@"cross.png"]];
    return leftUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
{
    NSString *type = _notifications[index][@"type"];
    NSString *recipient = _notifications[index][@"recipientPhoneNumber"];
    NSString *sender = _notifications[index][@"senderPhoneNumber"];
    NSString *myPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];

    switch (index)
    {
        case 0:
            NSLog(@"check button was pressed");

            if ([type isEqualToString:@"send"] && [myPhone isEqualToString:recipient]) // if send to you
            {
                //finish transfer & notify sender
            }
            else if ([type isEqualToString:@"request"] && [myPhone isEqualToString:recipient]) // if request from you
            {
                //initiate charge to you & notify sender
            }
            [self delete:cell];
            break;
        case 1:
            NSLog(@"clock button was pressed");

            if ([type isEqualToString:@"send"] && [myPhone isEqualToString:recipient]) //if send to you
            {
                //cancel charge & transfer
                //notify sender
            }
            else if ([type isEqualToString:@"request"] && [myPhone isEqualToString:recipient]) // if request from you
            {
                //notify requester
            }

            [self delete:cell];
            break;
        default:
            break;
    }
}

- (void)delete:(SWTableViewCell *)cell
{
    NSIndexPath *indexPath = [_notificationsTableView indexPathForCell:cell];
    [_notifications removeObjectAtIndex:indexPath.row];
    [_notificationsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    PFQuery *query = [PFQuery queryWithClassName:@"Notification"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            PFObject *notification = objects[indexPath.row];
            [notification deleteInBackground];
    }];
}

#pragma mark - UICollectionView DataSource/Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == kContactsCollectionView)
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
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == kContactsCollectionView)
    {
        return _contacts.count;
    }
    else if (collectionView.tag == kScenesCollectionView)
    {
        return _scenes.count;
    }
    else
    {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == kContactsCollectionView)
    {
        SBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ContactsCell" forIndexPath:indexPath];

        if (_recipientIndex == (int)indexPath.item)
        {
            UIImageView *check = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check-black"]];
            check.layer.masksToBounds = YES;
            check.layer.cornerRadius = 48/2;
            cell.backgroundView = check;
        }
        else
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:_contacts[indexPath.item][@"image"]];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 48/2;
            cell.backgroundView = imageView;
        }

        cell.nameLabel.text = _contacts[indexPath.item][@"firstName"];

        return cell;
    }
    else if (collectionView.tag == kScenesCollectionView)
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ScenesCell" forIndexPath:indexPath];

        for (UIView *view in cell.subviews)
        {
            [view removeFromSuperview];
        }
        [cell addSubview:_scenes[indexPath.item]];

        if (indexPath.item == 1)
        {
            [self updateHistoryView];
        }

        return cell;
    }
    else
    {
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == kContactsCollectionView)
    {
        return CGSizeMake(48,48);
    }
    else if (collectionView.tag == kScenesCollectionView)
    {
        return CGSizeMake(self.view.frame.size.width, _scenesCollectionView.frame.size.height);
    }
    else
    {
        return CGSizeMake(self.view.frame.size.width, 44);
    }
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
    NSData *facebookImageData = UIImagePNGRepresentation([UIImage imageNamed:@"bond"]);

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
        [dOfPerson setObject:[NSString stringWithFormat:@"%@",firstName] forKey:@"firstName"];
        [dOfPerson setObject:[NSString stringWithFormat:@"%@",lastName] forKey:@"lastName"];
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
            [dOfPerson setObject:[UIImage imageWithData:contactImageData] forKey:@"image"];
        }
        else if (includeBlankContacts)
        {
            [dOfPerson setObject:facebookImageData forKey:@"image"];
        }
        
        if (dOfPerson[@"phone"] && dOfPerson[@"image"])
        {
            [_contacts addObject:dOfPerson];
        }
	}
    [_contacts sortUsingDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil]];
    [_contactsCollectionView reloadData];
}

@end