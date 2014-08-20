//
//  MenuViewController.m
//  Cents
//
//  Created by Sapan Bhuta on 8/19/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()
@property (nonatomic) UIView *topLineView;
@property (nonatomic) UIView *centerLineView;
@property (nonatomic) UIView *bottomLineView;
@property (nonatomic) UIView *containerView;
@property (nonatomic) BOOL displayingMenu;
@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self viewSetUp];
}

-(void)viewSetUp
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(morph:)];
    [self.containerView addGestureRecognizer:tapRecognizer];

    [self.containerView addSubview:self.topLineView];
    [self.containerView addSubview:self.centerLineView];
    [self.containerView addSubview:self.bottomLineView];
    [self.view addSubview:self.containerView];
}

#pragma mark - Where The Magic Happens
-(void)morph:(UITapGestureRecognizer *)tapRecognizer
{
    if (self.displayingMenu)
    {
        [self morphToLine];
    }
    else
    {
        [self morphToX];
    }
    self.displayingMenu = !self.displayingMenu;
}

-(void)morphToX
{
    CGFloat angle = M_PI_4;
    CGPoint center = CGPointMake(120., 120.);

    __weak MenuViewController *weakSelf = self;
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        MenuViewController *strongSelf = weakSelf;

        strongSelf.topLineView.transform = CGAffineTransformMakeRotation(-angle*5);
        strongSelf.topLineView.center = center;

        strongSelf.bottomLineView.transform = CGAffineTransformMakeRotation(angle*5);
        strongSelf.bottomLineView.center = center;

        strongSelf.centerLineView.transform = CGAffineTransformMakeScale(0., 1.0);

    } completion:^(BOOL finished) {

    }];
}

-(void)morphToLine
{

    __weak MenuViewController *weakSelf = self;
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        MenuViewController *strongSelf = weakSelf;

        strongSelf.topLineView.transform = CGAffineTransformIdentity;
        strongSelf.topLineView.center = CGPointMake(120., 2.);

        strongSelf.bottomLineView.transform = CGAffineTransformIdentity;
        strongSelf.bottomLineView.center = CGPointMake(120., 60);

        strongSelf.centerLineView.transform = CGAffineTransformIdentity;

    } completion:^(BOOL finished) {

    }];
}

#pragma mark - Acessors

-(UIView *)topLineView
{
    if (!_topLineView)
    {
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0., 0., 240/4, 4./4)];
        _topLineView.backgroundColor = [UIColor whiteColor];
    }

    return _topLineView;
}

-(UIView *)centerLineView
{
    if (!_centerLineView)
    {
        _centerLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 120./4, 240/4, 4./4)];
        _centerLineView.backgroundColor = [UIColor whiteColor];
    }

    return _centerLineView;
}

-(UIView *)bottomLineView
{
    if (!_bottomLineView)
    {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 240./4, 240./4, 4./4)];
        _bottomLineView.backgroundColor = [UIColor whiteColor];
    }

    return _bottomLineView;
}

-(UIView *)containerView
{
    if (!_containerView)
    {
        _containerView = [UIView new];
        _containerView.bounds = CGRectMake(0.0, 0.0, 240./4, 240./4);
        _containerView.center = self.view.center;
    }

    return _containerView;
}

@end