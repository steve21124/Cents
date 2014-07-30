//
//  LTPhoneNumberField.m
//  PhoneNumberFieldDemo
//
//  Created by Colin Regan on 5/8/14.
//  Copyright (c) 2014 Lua Technologies, Inc. All rights reserved.
//

#import "LTPhoneNumberField.h"
#import <NBAsYouTypeFormatter.h>
#import <NBPhoneNumberUtil.h>

@interface LTPhoneNumberField () <UITextFieldDelegate>

@property (nonatomic, strong) NBAsYouTypeFormatter *formatter;
@property (nonatomic, weak) id<UITextFieldDelegate> externalDelegate;
@property (nonatomic, strong) NSString *regionCode;
@property (nonatomic, readwrite) BOOL containsValidNumber;

- (void)setupWithRegionCode:(NSString *)region;
- (void)checkValidity:(NSString *)number;
- (void)assignText:(NSString *)text;

@end

@implementation LTPhoneNumberField

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame regionCode:(NSString *)region
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWithRegionCode:region];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame regionCode:nil];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupWithRegionCode:nil];
    }
    return self;
}

- (void)setupWithRegionCode:(NSString *)region
{
    self.regionCode = region ?: [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    self.formatter = [[NBAsYouTypeFormatter alloc] initWithRegionCode:self.regionCode];
    super.delegate = self;
}

#pragma mark - Delegate overrides

- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    self.externalDelegate = delegate;
}

- (id<UITextFieldDelegate>)delegate
{
    return self.externalDelegate;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.externalDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.externalDelegate textFieldShouldBeginEditing:textField];
    } else {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.externalDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.externalDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.externalDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.externalDelegate textFieldShouldEndEditing:textField];
    } else {
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.externalDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.externalDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self) {
        BOOL singleInsertAtEnd = (string.length == 1) && (range.location == textField.text.length);
        BOOL singleDeleteFromEnd = (string.length == 0) && (range.length == 1) && (range.location == textField.text.length - 1);
        
        BOOL shouldChange = NO;
        NSString *formattedNumber;
        NSString *prefix;
        NSRange formattedRange;
        NSString *removedCharacter;
        if (singleInsertAtEnd) {
            formattedNumber = [self.formatter inputDigit:string];
            if ([formattedNumber hasSuffix:string]) {
                formattedRange = [formattedNumber rangeOfString:string options:(NSBackwardsSearch | NSAnchoredSearch)];
                prefix = [formattedNumber stringByReplacingCharactersInRange:formattedRange withString:@""];
                shouldChange = YES;
            }
        } else if (singleDeleteFromEnd) {
            formattedNumber = [self.formatter removeLastDigit];
            removedCharacter = [textField.text substringWithRange:range];
            prefix = [formattedNumber stringByAppendingString:removedCharacter];
            formattedRange = [prefix rangeOfString:removedCharacter options:(NSBackwardsSearch | NSAnchoredSearch)];
            shouldChange = YES;
        }
        
        if (shouldChange) {
            if ([self.externalDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
                [self assignText:prefix];
                if (![self.externalDelegate textField:textField shouldChangeCharactersInRange:formattedRange replacementString:string]) {
                    // Revert changes
                    if (singleInsertAtEnd) {
                        [self.formatter removeLastDigit];
                    } else if (singleDeleteFromEnd) {
                        [self.formatter inputDigit:removedCharacter];
                    }
                } else {
                    [self assignText:formattedNumber];
                }
            } else {
                [self assignText:formattedNumber];
            }
        }
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([self.externalDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.externalDelegate textFieldShouldClear:textField];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.externalDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.externalDelegate textFieldShouldReturn:textField];
    } else {
        return YES;
    }
}

#pragma mark - Custom logic

- (void)checkValidity:(NSString *)number
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NBPhoneNumberUtil *util = [NBPhoneNumberUtil sharedInstance];
        NBPhoneNumber *phoneNumber = [util parse:number defaultRegion:self.regionCode error:nil];
        BOOL isValid = [util isValidNumber:phoneNumber];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.containsValidNumber = isValid;
        });
    });
}

- (void)setText:(NSString *)text
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *formattedNumber;
        for (NSInteger index; index < text.length; index++) {
            unichar character = [text characterAtIndex:index];
            if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:character]) {
                unichar array[1] = {character};
                NSString *character = [NSString stringWithCharacters:array length:1];
                formattedNumber = [self.formatter inputDigit:character];
            }
        }
        [self assignText:formattedNumber];
    });
}

- (void)assignText:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        super.text = text;
        [self checkValidity:text];
    });
}

- (NSString *)phoneNumberWithFormat:(LTPhoneNumberFormat)format
{
    NBPhoneNumberUtil *util = [NBPhoneNumberUtil sharedInstance];
    
    NSError *error;
    NBPhoneNumber *phoneNumber = [util parse:self.text defaultRegion:self.regionCode error:&error];
    
    if (!error) {
        return [util format:phoneNumber numberFormat:(NBEPhoneNumberFormat)format error:&error];
    }
    
    NSLog(@"Error parsing phone number: %@", error);
    return nil;
}

@end
