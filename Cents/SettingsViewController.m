//
//  SettingsViewController.m
//  Cents
//
//  Created by Sapan Bhuta on 8/20/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "SettingsViewController.h"
#import "JSQFlatButton.h"
#import "Constants.h"

@interface SettingsViewController ()
@property JSQFlatButton *cancel;
@property JSQFlatButton *save;
@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [Constants backgroundColor];
    [self createButtons];
}

- (void)createButtons
{
    _cancel = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,
                                                              self.view.frame.size.height-216-54,
                                                              self.view.frame.size.width/2-.25,
                                                              54)
                                   backgroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                   foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                             title:@"cancel"
                                             image:nil];
    [_cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancel];

    _save = [[JSQFlatButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+.25,
                                                            self.view.frame.size.height-216-54,
                                                            self.view.frame.size.width/2-.25,
                                                            54)
                                  backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                  foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                            title:@"save"
                                            image:nil];
    [_save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    _save.enabled = NO;
    [self.view addSubview:_save];
}

- (void)cancel:(JSQFlatButton *)sender
{
    [self dismiss];
}

- (void)save:(JSQFlatButton *)sender
{
    [self dismiss];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"spin" object:nil];
}

@end
