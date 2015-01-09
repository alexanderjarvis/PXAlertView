//
//  PXAlertView+Customization.h
//  PXAlertViewDemo
//
//  Created by Michal Zygar on 21.10.2013.
//  Copyright (c) 2013 panaxiom. All rights reserved.
//

#import "PXAlertView.h"

@interface PXAlertView (Customization)

- (void)setWindowTintColor:(UIColor *)color;
- (void)setBackgroundColor:(UIColor *)color;

- (void)setTitleColor:(UIColor *)color;
- (void)setTitleFont:(UIFont *)font;

- (void)setMessageColor:(UIColor *)color;
- (void)setMessageFont:(UIFont *)font;

- (void)setCancelButtonBackgroundColor:(UIColor *)color;
- (void)setOtherButtonBackgroundColor:(UIColor *)color;
- (void)setAllButtonsBackgroundColor:(UIColor *)color;

- (void)setCancelButtonTextColor:(UIColor *)color;
- (void)setAllButtonsTextColor:(UIColor *)color;
- (void)setOtherButtonTextColor:(UIColor *)color;

- (void)useDefaultIOS7Style;

@end