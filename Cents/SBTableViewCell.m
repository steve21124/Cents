//
//  SBTableViewCell.m
//  Cents
//
//  Created by Sapan Bhuta on 8/21/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "SBTableViewCell.h"

@implementation SBTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 22;
        self.imageView.tag = 0;

        self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x+self.bounds.size.width/2,
                                                                    self.bounds.origin.y,
                                                                    self.bounds.size.width/2-80,
                                                                    44)];
        self.rightLabel.textColor = [UIColor whiteColor];
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.rightLabel];

        self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x+self.bounds.size.width-63, self.bounds.origin.y, 44, 44)];
        self.rightImageView.layer.masksToBounds = YES;
        self.rightImageView.layer.cornerRadius = 22;
        self.rightImageView.tag = 1;
        [self.contentView addSubview:self.rightImageView];
    }
    return self;
}

@end
