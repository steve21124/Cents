//
//  ParseChecks.h
//  Cents
//
//  Created by Sapan Bhuta on 8/12/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseChecks : NSObject
+ (BOOL)userHasPhoneNumber;
+ (BOOL)userHasPaymentCard;
+ (BOOL)userIsInDataBase:(NSString *)number;
+ (void)cardOnFileIs:(BOOL)answer;
@end
