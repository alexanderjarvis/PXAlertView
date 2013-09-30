//
//  PXAlertView.h
//  PXAlertViewDemo
//
//  Created by Alex Jarvis on 25/09/2013.
//  Copyright (c) 2013 Panaxiom Ltd. All rights reserved.
//

@import UIKit;

@interface PXAlertView : UIView

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancelTitle
                otherTitle:(NSString *)otherTitle
                completion:(void(^) (BOOL cancelled))completion;

@end
