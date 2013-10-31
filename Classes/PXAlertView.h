//
//  PXAlertView.h
//  PXAlertViewDemo
//
//  Created by Alex Jarvis on 25/09/2013.
//  Copyright (c) 2013 Panaxiom Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PXAlertViewCompletionBlock)(BOOL cancelled);

@interface PXAlertView : UIViewController

@property (nonatomic, getter = isVisible) BOOL visible;

+ (instancetype)showAlertWithTitle:(NSString *)title;

+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message;

+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message
						completion:(PXAlertViewCompletionBlock)completion;

+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message
					   cancelTitle:(NSString *)cancelTitle
						completion:(PXAlertViewCompletionBlock)completion;

+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message
					   cancelTitle:(NSString *)cancelTitle
						otherTitle:(NSString *)otherTitle
						completion:(PXAlertViewCompletionBlock)completion;

+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message
					   cancelTitle:(NSString *)cancelTitle
						otherTitle:(NSString *)otherTitle
					   contentView:(UIView *)view
						completion:(PXAlertViewCompletionBlock)completion;

@end
