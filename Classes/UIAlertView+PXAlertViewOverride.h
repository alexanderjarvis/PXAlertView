//
//  UIAlertView+PXAlertViewOverride.h
//  PXAlertView
//
//  Created by Bryan Way on 18/09/2014.
//

#import "PXAlertView.h"
#import <objc/runtime.h>

@interface UIAlertView (PXAlertViewOverride)

-(void)showWithContent:(UIView*)contentView;

@end
