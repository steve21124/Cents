# LTPhoneNumberField

<p align="center"><img src="http://i.imgur.com/JUScCnk.gif"/></p>

LTPhoneNumberField is a subclass of UITextField that dynamically formats a phone number as it is typed. It relies on an obj-c port of Google's libphonenumber library to handle phone number parsing.

## Usage

To run the example project; clone the repo, and run `pod install` from the Example directory first.

* Use `initWithFrame:regionCode:` to initialize. Uses current locale if no region code is specified
* Readonly BOOL property `containsValidNumber` fires KVO notifications if its value changes
* Instance method `phoneNumberWithFormat:` returns the current phone number in the specified format

## Requirements

* Tested on iOS 6.1 and above, including iOS 7

## Installation

LTPhoneNumberField is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "LTPhoneNumberField"

## Author

Colin Regan, colin@getlua.com

## License

LTPhoneNumberField is available under the MIT license. See the LICENSE file for more info.

