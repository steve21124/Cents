//
//  RootViewController.m
//  Cents
//
//  Created by Sapan Bhuta on 7/27/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#define buttonSize 50
#define gap 50

#import "RootViewController.h"
#import "JSQFlatButton.h"

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property UILabel *amountLabel;
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor purpleColor];

    _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, 50)];
    _amountLabel.textColor = [UIColor whiteColor];
    _amountLabel.text = @"0";
    _amountLabel.textAlignment = NSTextAlignmentCenter;
    _amountLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
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
    zero.tag = 11;
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
    [self.view addSubview:request];

    JSQFlatButton *send = [[JSQFlatButton alloc] initWithFrame:CGRectMake(160.5, self.view.frame.size.height-54, 159.5, 54)
                                              backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                              foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                                        title:@"Send"
                                                        image:nil];//[UIImage imageNamed:@"up"]];
    [self.view addSubview:send];
}

- (void)keyPress:(UIButton *)sender
{
    _amountLabel.text = @(sender.tag).description;

    switch (sender.tag) {
        case 1:
            NSLog(@"1");
            break;

        default:
            break;
    }
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
