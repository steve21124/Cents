//
//  FailViewController.m
//  Cents
//
//  Created by Sapan Bhuta on 8/21/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "FailViewController.h"
#import "JSQFlatButton.h"
#import "Constants.h"
#import "Reachability.h"
#import "VCFlow.h"

@interface FailViewController ()
@property JSQFlatButton *retry;
@end

@implementation FailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupScene];
    [self showError];
}

- (void)showError
{
    [[[UIAlertView alloc] initWithTitle:@"Error Connecting To Internet" message:@"Please connect to internet and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

- (void)setupScene
{
    self.view.backgroundColor = [Constants backgroundColor];
    _retry = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,
                                                              self.view.frame.size.height-54,
                                                              self.view.frame.size.width,
                                                              54)
                                   backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                   foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                             title:@"retry"
                                             image:nil];
    [_retry addTarget:self action:@selector(retry:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_retry];
}

- (void)retry:(JSQFlatButton *)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showError];
    }
    else
    {
        [self presentViewController:[VCFlow nextVC] animated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
