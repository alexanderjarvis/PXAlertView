//
//  PXAlertView.h
//  PXAlertViewDemo
//
//  Created by Bryan Way on 18/09/2014.
//  Copyright (c) 2013 Panaxiom Ltd. All rights reserved.
//

#import "PXAlertView.h"
#import <objc/runtime.h>

@interface UIAlertView (PXAlertViewOverride)

-(void)showWithContent:(UIView*)contentView;

@end
