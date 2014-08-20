//
//  MenuView.m
//  Cents
//
//  Created by Sapan Bhuta on 8/20/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "MenuView.h"

@interface MenuView ()
@property UIView *topLineView;
//@property UIView *centerLineView;
@property UIView *bottomLineView;
@property UIView *leftLineView;
@property UIView *rightLineView;
@property CGFloat edgeLength;
@end

@implementation MenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _edgeLength = self.frame.size.width;

        self.topLineView = [[UIView alloc] initWithFrame:CGRectMake(0,0,_edgeLength,1)];
        self.topLineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.topLineView];

//        self.centerLineView = [[UIView alloc] initWithFrame:CGRectMake(0,_edgeLength/2,_edgeLength,1)];
//        self.centerLineView.backgroundColor = [UIColor whiteColor];
//        [self addSubview:self.centerLineView];

        self.bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0,_edgeLength,_edgeLength,1)];
        self.bottomLineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bottomLineView];

        _leftLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, _edgeLength)];
        _leftLineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_leftLineView];

        _rightLineView = [[UIView alloc] initWithFrame:CGRectMake(_edgeLength-1, 0, 1, _edgeLength)];
        _rightLineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_rightLineView];

        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _edgeLength, _edgeLength)];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"0";
        [self addSubview:_label];
    }
    return self;
}

#pragma mark - Where The Magic Happens
-(void)morphToX
{
    CGFloat angle = M_PI_4;
    CGPoint center = CGPointMake(_edgeLength/2, _edgeLength/2);

    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{

        self.topLineView.transform = CGAffineTransformMakeRotation(-angle*5);
        self.topLineView.center = center;

        self.bottomLineView.transform = CGAffineTransformMakeRotation(angle*5);
        self.bottomLineView.center = center;

//        self.centerLineView.transform = CGAffineTransformMakeScale(0., 1.0);

        self.leftLineView.transform = CGAffineTransformMakeRotation(-angle*2);
        self.leftLineView.center = CGPointMake(_edgeLength/2, 0);

//        self.label.hidden = YES;
        self.label.alpha = 0;

    } completion:^(BOOL finished) {

    }];
}

-(void)morphToLine
{
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{

        self.topLineView.transform = CGAffineTransformIdentity;
        self.topLineView.center = CGPointMake(_edgeLength/2, .5);

        self.bottomLineView.transform = CGAffineTransformIdentity;
        self.bottomLineView.center = CGPointMake(_edgeLength/2, _edgeLength-.5);

//        self.centerLineView.transform = CGAffineTransformIdentity;
//        self.centerLineView.center = CGPointMake(_edgeLength/2, _edgeLength/2-.5);

        self.leftLineView.transform = CGAffineTransformIdentity;
        self.leftLineView.center = CGPointMake(0, _edgeLength/2);

//        self.label.hidden = NO;
        self.label.alpha = 1;

    } completion:^(BOOL finished) {

    }];
}

@end
