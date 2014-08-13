//
//  ParseChecks.h
//  Cents
//
//  Created by Sapan Bhuta on 8/12/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseChecks : NSObject
+ (BOOL)userIsInDataBase:(NSString *)phoneNumber;
+ (BOOL)userHasPhoneNumber;
+ (BOOL)userHasPaymentCard;
+ (void)addUserToDataBase;
@end
