//
//  PXAlertView+Customization.m
//  PXAlertViewDemo
//
//  Created by Michal Zygar on 21.10.2013.
//  Copyright (c) 2013 panaxiom. All rights reserved.
//

#import "PXAlertView+Customization.h"
#import <objc/runtime.h>

void * const kCancelBGKey = (void * const) &kCancelBGKey;
void * const kOtherBGKey = (void * const) &kOtherBGKey;
void * const kAllBGKey = (void * const) &kAllBGKey;

@interface PXAlertView ()

@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIView *alertView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *messageLabel;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *otherButton;
@property (nonatomic) NSArray *buttons;

@end

@implementation PXAlertView (Customization)

- (void)setWindowTintColor:(UIColor *)color
{
    self.backgroundView.backgroundColor = color;
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.alertView.backgroundColor = color;
}

- (void)setTitleColor:(UIColor *)color
{
    self.titleLabel.textColor = color;
}

- (void)setTitleFont:(UIFont *)font
{
    self.titleLabel.font = font;
}

- (void)setMessageColor:(UIColor *)color
{
    self.messageLabel.textColor = color;
}

- (void)setMessageFont:(UIFont *)font
{
    self.messageLabel.font = font;
}

#pragma mark -
#pragma mark Buttons Customization
#pragma mark Buttons Background Colors
- (void)setCustomBackgroundColorForButton:(id)sender
{
    if (sender == self.cancelButton && [self cancelButtonBackgroundColor]) {
        self.cancelButton.backgroundColor = [self cancelButtonBackgroundColor];
    } else if (sender == self.otherButton && [self otherButtonBackgroundColor]) {
        self.otherButton.backgroundColor = [self otherButtonBackgroundColor];
    } else if ([self allButtonsBackgroundColor]) {
        [sender setBackgroundColor:[self allButtonsBackgroundColor]];
    } else {
        [sender setBackgroundColor:[UIColor colorWithRed:94/255.0 green:196/255.0 blue:221/255.0 alpha:1]];
    }
}

- (void)setCancelButtonBackgroundColor:(UIColor *)color
{
    objc_setAssociatedObject(self, kCancelBGKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.cancelButton addTarget:self action:@selector(setCustomBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
    [self.cancelButton addTarget:self action:@selector(setCustomBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragEnter];
}

- (UIColor *)cancelButtonBackgroundColor
{
    return objc_getAssociatedObject(self, kCancelBGKey);
}

- (void)setAllButtonsBackgroundColor:(UIColor *)color
{
    objc_setAssociatedObject(self, kOtherBGKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kCancelBGKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kAllBGKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    for (UIButton *button in self.buttons) {
        [button addTarget:self action:@selector(setCustomBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(setCustomBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragEnter];
    }
}

- (UIColor *)allButtonsBackgroundColor
{
    return objc_getAssociatedObject(self, kAllBGKey);
}

- (void)setOtherButtonBackgroundColor:(UIColor *)color
{
    objc_setAssociatedObject(self, kOtherBGKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.otherButton addTarget:self action:@selector(setCustomBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
    [self.otherButton addTarget:self action:@selector(setCustomBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragEnter];
}

- (UIColor *)otherButtonBackgroundColor
{
    return objc_getAssociatedObject(self, kOtherBGKey);
}

#pragma mark Buttons Text Colors
- (void)setCancelButtonTextColor:(UIColor *)color
{
    self.cancelButton.titleLabel.textColor = color;
}

- (void)setAllButtonsTextColor:(UIColor *)color
{
    for (UIButton *button in self.buttons) {
        button.titleLabel.textColor = color;
    }
}

- (void)setOtherButtonTextColor:(UIColor *)color
{
    self.otherButton.titleLabel.textColor = color;
}
@end
