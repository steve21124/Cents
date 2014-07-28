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
#import "PaymentViewController.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import "UIPopoverController+FlatUI.h"

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPopoverControllerDelegate>
@property UILabel *amountLabel;
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor purpleColor];

    _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, amountFont)];
    _amountLabel.textColor = [UIColor whiteColor];
    _amountLabel.text = @"$0";
    _amountLabel.textAlignment = NSTextAlignmentCenter;
    _amountLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:amountFont];
    [self.view addSubview:_amountLabel];

    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *colletionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 90, 320, 70) collectionViewLayout:flow];
    colletionView.backgroundColor = [UIColor clearColor];
    colletionView.delegate = self;
    colletionView.dataSource = self;
    [self.view addSubview:colletionView];


    UIView *keyboard = [[UIView alloc] initWithFrame:CGRectMake(0, 160, 320, 5*gap)];
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

    JSQFlatButton *request = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-54, 159.5, 54)
                                                  backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                                  foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                                            title:@"Request"
                                                            image:nil];//[UIImage imageNamed:@"down"]];
    [request addTarget:self action:@selector(request:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:request];

    JSQFlatButton *send = [[JSQFlatButton alloc] initWithFrame:CGRectMake(160.5, self.view.frame.size.height-54, 159.5, 54)
                                              backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                              foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                                        title:@"Send"
                                                        image:nil];//[UIImage imageNamed:@"up"]];
    [send addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:send];
}

- (void)request:(JSQFlatButton *)sender
{
    NSLog(@"%f",[_amountLabel.text floatValue]);
}

- (void)send:(JSQFlatButton *)sender
{
    NSLog(@"%f",[_amountLabel.text floatValue]);

//    PaymentViewController *paymentViewController = [[PaymentViewController alloc] init];
//    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:paymentViewController];
//    [popover configureFlatPopoverWithBackgroundColor: [UIColor midnightBlueColor] cornerRadius:3];
//    popover.delegate = self;
//    [popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
@end
