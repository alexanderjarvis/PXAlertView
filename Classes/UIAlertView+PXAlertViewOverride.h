//
//  UIAlertView+PXAlertViewOverride.h
//  PXAlertView
//
//  Created by Bryan Way on 18/09/2014.
//

// Uncomment next line to enable automatic implementation or define PXALERT_SWIZZLING globally
//#define PXALERT_SWIZZLING

#ifdef PXALERT_SWIZZLING

#import "PXAlertView.h"
#import <objc/runtime.h>

@interface UIAlertView (PXAlertViewOverride)

-(void)showWithContent:(UIView*)contentView;

@end

#endif
