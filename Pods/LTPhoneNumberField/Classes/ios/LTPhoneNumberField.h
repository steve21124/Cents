//
//  LTPhoneNumberField.h
//  PhoneNumberFieldDemo
//
//  Created by Colin Regan on 5/8/14.
//  Copyright (c) 2014 Lua Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LTPhoneNumberFormat) {
    LTPhoneNumberFormatE164,
    LTPhoneNumberFormatINTERNATIONAL,
    LTPhoneNumberFormatNATIONAL,
    LTPhoneNumberFormatRFC3966
};

@interface LTPhoneNumberField : UITextField

/**
 *  Returns a Boolean value indicating whether the entered phone number matches a valid pattern.
 */
@property (nonatomic, readonly) BOOL containsValidNumber;

/**
 *  Initializes and returns a newly allocated view object with the specified frame rectangle and region code.
 *
 *  @param frame    The frame rectangle for the view, measured in points.
 *  @param region   The ISO 3166-1 two-letter region code that denotes the region where the phone number is being entered. If nil, the current locale is used.
 *
 *  @return         An initialized LTPhoneNumberField object or nil if the object couldn't be created.
 */
- (instancetype)initWithFrame:(CGRect)frame regionCode:(NSString *)region;

/**
 *  Returns a NSString of the current phone number formatted according to the given format parameter.
 *
 *  @param format   The LTPhoneNumberFormat option to format the phone number.
 *  
 *  @return         A NSString of the current phone number, or nil if there was a parsing error.
 */
- (NSString *)phoneNumberWithFormat:(LTPhoneNumberFormat)format;

@end
