//
//  SettingsButton.m
//  Cents
//
//  Created by Sapan Bhuta on 8/21/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "SettingsButton.h"

@implementation SettingsButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 1)];
        topLine.backgroundColor = [UIColor whiteColor];
        [self addSubview:topLine];

        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 39, 40, 1)];
        bottomLine.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomLine];

        UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 40)];
        leftLine.backgroundColor = [UIColor whiteColor];
        [self addSubview:leftLine];

        UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(39, 0, 1, 40)];
        rightLine.backgroundColor = [UIColor whiteColor];
        [self addSubview:rightLine];
    }
    return self;
}

@end
