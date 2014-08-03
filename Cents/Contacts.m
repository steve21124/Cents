//
//  Contacts.m
//  Cents
//
//  Created by Sapan Bhuta on 8/2/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "Contacts.h"

@implementation Contacts

- (id)init
{
    if (self = [super init])
    {
        [self fetch];
    }
    return self;
}

- (void)fetch
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

@end
