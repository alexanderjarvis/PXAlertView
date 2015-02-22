//
//  UIAlertView+PXAlertViewOverride.m
//  PXAlertView
//
//  Created by Bryan Way on 18/09/2014
//

#import "UIAlertView+PXAlertViewOverride.h"

#ifdef PXALERT_SWIZZLING

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
@implementation UIAlertView (PXAlertViewOverride)

+ (void)load {
    static dispatch_once_t dispatchOnceToken;
    dispatch_once(&dispatchOnceToken, ^{
        Class class = [self class];
		
        SEL originalInitWithTitleSelector = @selector(initWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:);
        SEL swizzledInitWithTitleSelector = @selector(swizzled_initWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:);
		SEL originalShowSelector = @selector(show);
        SEL swizzledShowSelector = @selector(swizzled_show);
		SEL originalAddButtonWithTitleSelector = @selector(addButtonWithTitle:);
        SEL swizzledAddButtonWithTitleSelector = @selector(swizzled_addButtonWithTitle:);
		SEL originalGetVisibleSelector = @selector(getVisible);
        SEL swizzledGetVisibleSelector = @selector(swizzled_getVisible);
		SEL originalGetFirstOtherButtonIndexSelector = @selector(getFirstOtherButtonIndex);
        SEL swizzledGetFirstOtherButtonIndexSelector = @selector(swizzled_getFirstOtherButtonIndex);
		SEL originalGetNumberOfButtonsSelector = @selector(getNumberOfButtons);
        SEL swizzledGetNumberOfButtonsSelector = @selector(swizzled_getNumberOfButtons);
		SEL originalButtonTitleAtIndexSelector = @selector(getNumberOfButtons);
        SEL swizzledButtonTitleAtIndexSelector = @selector(swizzled_getNumberOfButtons);
		SEL originalDismissWithClickedButtonIndexSelector = @selector(dismissWithClickedButtonIndex:animated:);
        SEL swizzledDismissWithClickedButtonIndexSelector = @selector(swizzled_dismissWithClickedButtonIndex:animated:);
		SEL originalTextFieldAtIndexSelector = @selector(textFieldAtIndex:);
        SEL swizzledTextFieldAtIndexSelector = @selector(swizzled_textFieldAtIndex:);
		
        Method originalInitWithTitleMethod = class_getInstanceMethod(class, originalInitWithTitleSelector);
        Method swizzledInitWithTitleMethod = class_getInstanceMethod(class, swizzledInitWithTitleSelector);
		Method originalShowMethod = class_getInstanceMethod(class, originalShowSelector);
        Method swizzledShowMethod = class_getInstanceMethod(class, swizzledShowSelector);
		Method originalAddButtonWithTitleMethod = class_getInstanceMethod(class, originalAddButtonWithTitleSelector);
        Method swizzledAddBUttonWithTitleMethod = class_getInstanceMethod(class, swizzledAddButtonWithTitleSelector);
		Method originalGetVisibleMethod = class_getInstanceMethod(class, originalGetVisibleSelector);
        Method swizzledGetVisibleMethod = class_getInstanceMethod(class, swizzledGetVisibleSelector);
		Method originalGetFirstOtherButtonIndexMethod = class_getInstanceMethod(class, originalGetFirstOtherButtonIndexSelector);
        Method swizzledGetFirstOtherButtonIndexMethod = class_getInstanceMethod(class, swizzledGetFirstOtherButtonIndexSelector);
		Method originalGetNumberOfButtonsMethod = class_getInstanceMethod(class, originalGetNumberOfButtonsSelector);
        Method swizzledGetNumberOfButtonsMethod = class_getInstanceMethod(class, swizzledGetNumberOfButtonsSelector);
		Method originalButtonTitleAtIndexMethod = class_getInstanceMethod(class, originalButtonTitleAtIndexSelector);
        Method swizzledButtonTitleAtIndexMethod = class_getInstanceMethod(class, swizzledButtonTitleAtIndexSelector);
		Method originalDismissWithClickedButtonIndexMethod = class_getInstanceMethod(class, originalDismissWithClickedButtonIndexSelector);
        Method swizzledDismissWithClickedButtonIndexMethod = class_getInstanceMethod(class, swizzledDismissWithClickedButtonIndexSelector);
		Method originalTextFieldAtIndexMethod = class_getInstanceMethod(class, originalTextFieldAtIndexSelector);
        Method swizzledTextFieldAtIndexMethod = class_getInstanceMethod(class, swizzledTextFieldAtIndexSelector);
		
        if(class_addMethod(class, originalInitWithTitleSelector, method_getImplementation(swizzledInitWithTitleMethod), method_getTypeEncoding(swizzledInitWithTitleMethod)))
		{
            class_replaceMethod(class, swizzledInitWithTitleSelector, method_getImplementation(originalInitWithTitleMethod), method_getTypeEncoding(originalInitWithTitleMethod));
        }
		else
		{
            method_exchangeImplementations(originalInitWithTitleMethod, swizzledInitWithTitleMethod);
        }
		
		if(class_addMethod(class, originalShowSelector, method_getImplementation(swizzledShowMethod), method_getTypeEncoding(swizzledShowMethod)))
		{
            class_replaceMethod(class, swizzledShowSelector, method_getImplementation(originalShowMethod), method_getTypeEncoding(originalShowMethod));
        }
		else
		{
            method_exchangeImplementations(originalShowMethod, swizzledShowMethod);
        }
		
		if(class_addMethod(class, originalAddButtonWithTitleSelector, method_getImplementation(swizzledAddBUttonWithTitleMethod), method_getTypeEncoding(swizzledAddBUttonWithTitleMethod)))
		{
            class_replaceMethod(class, swizzledAddButtonWithTitleSelector, method_getImplementation(originalAddButtonWithTitleMethod), method_getTypeEncoding(originalAddButtonWithTitleMethod));
        }
		else
		{
            method_exchangeImplementations(originalAddButtonWithTitleMethod, swizzledAddBUttonWithTitleMethod);
        }
		
		if(class_addMethod(class, originalGetVisibleSelector, method_getImplementation(swizzledGetVisibleMethod), method_getTypeEncoding(swizzledGetVisibleMethod)))
		{
            class_replaceMethod(class, swizzledGetVisibleSelector, method_getImplementation(originalGetVisibleMethod), method_getTypeEncoding(originalGetVisibleMethod));
        }
		else
		{
            method_exchangeImplementations(originalGetVisibleMethod, swizzledGetVisibleMethod);
        }
		
		if(class_addMethod(class, originalGetFirstOtherButtonIndexSelector, method_getImplementation(swizzledGetFirstOtherButtonIndexMethod), method_getTypeEncoding(swizzledGetFirstOtherButtonIndexMethod)))
		{
            class_replaceMethod(class, swizzledGetFirstOtherButtonIndexSelector, method_getImplementation(originalGetNumberOfButtonsMethod), method_getTypeEncoding(originalGetNumberOfButtonsMethod));
        }
		else
		{
            method_exchangeImplementations(originalGetFirstOtherButtonIndexMethod, swizzledGetFirstOtherButtonIndexMethod);
        }
		
		if(class_addMethod(class, originalGetNumberOfButtonsSelector, method_getImplementation(swizzledGetNumberOfButtonsMethod), method_getTypeEncoding(swizzledGetNumberOfButtonsMethod)))
		{
            class_replaceMethod(class, swizzledGetNumberOfButtonsSelector, method_getImplementation(originalGetFirstOtherButtonIndexMethod), method_getTypeEncoding(originalGetFirstOtherButtonIndexMethod));
        }
		else
		{
            method_exchangeImplementations(originalGetNumberOfButtonsMethod, swizzledGetNumberOfButtonsMethod);
        }
		
		if(class_addMethod(class, originalButtonTitleAtIndexSelector, method_getImplementation(swizzledButtonTitleAtIndexMethod), method_getTypeEncoding(swizzledButtonTitleAtIndexMethod)))
		{
            class_replaceMethod(class, swizzledButtonTitleAtIndexSelector, method_getImplementation(originalButtonTitleAtIndexMethod), method_getTypeEncoding(originalButtonTitleAtIndexMethod));
        }
		else
		{
            method_exchangeImplementations(originalButtonTitleAtIndexMethod, swizzledButtonTitleAtIndexMethod);
        }
		
		if(class_addMethod(class, originalDismissWithClickedButtonIndexSelector, method_getImplementation(swizzledDismissWithClickedButtonIndexMethod), method_getTypeEncoding(swizzledDismissWithClickedButtonIndexMethod)))
		{
            class_replaceMethod(class, swizzledDismissWithClickedButtonIndexSelector, method_getImplementation(originalDismissWithClickedButtonIndexMethod), method_getTypeEncoding(originalDismissWithClickedButtonIndexMethod));
        }
		else
		{
            method_exchangeImplementations(originalDismissWithClickedButtonIndexMethod, swizzledDismissWithClickedButtonIndexMethod);
        }
		
		if(class_addMethod(class, originalTextFieldAtIndexSelector, method_getImplementation(swizzledTextFieldAtIndexMethod), method_getTypeEncoding(swizzledTextFieldAtIndexMethod)))
		{
            class_replaceMethod(class, swizzledTextFieldAtIndexSelector, method_getImplementation(originalTextFieldAtIndexMethod), method_getTypeEncoding(originalTextFieldAtIndexMethod));
        }
		else
		{
            method_exchangeImplementations(originalTextFieldAtIndexMethod, swizzledTextFieldAtIndexMethod);
        }
    });
}

//	Swizzle methods

- (id)swizzled_initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	if([super init])
	{
		self.delegate = delegate;
		self.title = title;
		self.message = message;
		
		self.cancelButtonIndex = 0;
		objc_setAssociatedObject(self, "cancelButtonTitle", cancelButtonTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		
		NSMutableArray *otherButtonTitleList = [[NSMutableArray alloc] init];
		
		if(otherButtonTitles)
		{
			[otherButtonTitleList addObject:otherButtonTitles];

			va_list args;
			va_start(args, otherButtonTitles);
			
			NSString *otherButtonTitleEntry = nil;
			while((otherButtonTitleEntry = va_arg(args, NSString*)))
			{
				[otherButtonTitleList addObject:otherButtonTitleEntry];
			}
			va_end(args);
		}

		objc_setAssociatedObject(self, "otherButtonTitles", otherButtonTitleList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return self;
}

-(void)swizzled_show
{
	[self showWithContent:nil];
}

-(void)showWithContent:(UIView*)contentView
{
	if(self.alertViewStyle != UIAlertViewStyleDefault)
	{
		if(contentView)
		{
			NSLog(@"Warning: Unable to display contentView when alertViewStyle != UIAlertViewStyleDefault. contentView will not be displayed.");
		}
		contentView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 270.0, (UIAlertViewStyleLoginAndPasswordInput ? 77.0 : 36.0)}];
		
		UITextField *textField = nil;
		
		NSMutableArray *alertBoxTextFields = [[NSMutableArray alloc] init];
		if(self.alertViewStyle == UIAlertViewStylePlainTextInput || self.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput)
		{
			textField = [[UITextField alloc] initWithFrame:(CGRect){20.0, 0, 230.0, 26.0}];
			textField.backgroundColor = [UIColor whiteColor];
			[alertBoxTextFields addObject:textField];
			[contentView addSubview:textField];
		}
		
		if(self.alertViewStyle == UIAlertViewStyleSecureTextInput || self.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput)
		{
			textField = [[UITextField alloc] initWithFrame:(CGRect){20.0, (UIAlertViewStyleLoginAndPasswordInput ? 36.0 : 0), 230.0, 31.0}];
			textField.backgroundColor = [UIColor whiteColor];
			if(UIAlertViewStyleSecureTextInput)
			{
				textField.secureTextEntry = YES;
			}
			[alertBoxTextFields addObject:textField];
			[contentView addSubview:textField];
		}
		objc_setAssociatedObject(self, "alertBoxTextFields", alertBoxTextFields, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	if(self.delegate)
	{
		if([self.delegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)])
		{
			[self.delegate alertViewShouldEnableFirstOtherButton:self]; // This has no correspondence with PXAlertView. Calling incase any code must be executed in this delegated method.
		}
		
		if([self.delegate respondsToSelector:@selector(willPresentAlertView:)])
		{
			[self.delegate willPresentAlertView:self];
		}
	}
	
	PXAlertView* alertView = [PXAlertView showAlertWithTitle:self.title message:self.message cancelTitle:(NSString*)objc_getAssociatedObject(self, "cancelButtonTitle") otherTitles:(NSMutableArray*)objc_getAssociatedObject(self, "otherButtonTitles") contentView:contentView completion:^(BOOL cancelled, NSInteger buttonIndex) {
		if(self.delegate)
		{
			if(cancelled && [self.delegate respondsToSelector:@selector(alertViewCancel:)])
			{
				[self.delegate alertViewCancel:self];
			}
			if([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
			{
				[self.delegate alertView:self clickedButtonAtIndex:buttonIndex];
			}
			if([self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)])
			{
				[self.delegate alertView:self willDismissWithButtonIndex:buttonIndex];
			}
			if([self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)])
			{
				[self.delegate alertView:self didDismissWithButtonIndex:buttonIndex];
			}
		}
		
		objc_setAssociatedObject(self, "PXAlertViewInstance", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}];
	[alertView setTapToDismissEnabled:NO]; // Default behavior like iOS. Best compatibility.
	
	objc_setAssociatedObject(self, "PXAlertViewInstance", alertView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(didPresentAlertView::)])
	{
		[self.delegate didPresentAlertView:self];
	}
}

- (NSInteger)swizzled_addButtonWithTitle:(NSString *)title
{
	PXAlertView* alertView = objc_getAssociatedObject(self, "PXAlertViewInstance");
	if(alertView)
	{
		return [alertView addButtonWithTitle:title];
	}
	else
	{
		if(!self.message)
		{
			self.message = title;
			return 0;
		}
		else
		{
			NSMutableArray* otherButtonTitles = objc_getAssociatedObject(self, "otherButtonTitles");
			if(!otherButtonTitles)
			{
				otherButtonTitles = [[NSMutableArray alloc] init];
				objc_setAssociatedObject(self, "otherButtonTitles", otherButtonTitles, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
			}
			
			[otherButtonTitles addObject:title];
			return [otherButtonTitles count];
		}
	}
	return -1;
}

- (NSString*)swizzled_buttonTitleAtIndex:(NSInteger)buttonIndex
{
	id tmpObj = objc_getAssociatedObject(self, "cancelButtonTitle");
	if(buttonIndex == 0 && tmpObj)
	{
		return (NSString*)tmpObj;
	}
	else if(buttonIndex > 0)
	{
		buttonIndex--;
		NSMutableArray* otherButtonTitles = objc_getAssociatedObject(self, "otherButtonTitles");
		if(buttonIndex < [otherButtonTitles count])
		{
			return [otherButtonTitles objectAtIndex:buttonIndex];
		}
	}
	return nil;
}

- (void)swizzled_dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
	PXAlertView* alertView = objc_getAssociatedObject(self, "PXAlertViewInstance");
	if(alertView)
	{
		[alertView dismissWithClickedButtonIndex:buttonIndex animated:animated];
	}
}

-(BOOL)swizzled_getVisible
{
	if(objc_getAssociatedObject(self, "PXAlertViewInstance"))
	{
		return YES;
	}
	return NO;
}

-(NSInteger)swizzled_getFirstOtherButtonIndex
{
	NSMutableArray *array = objc_getAssociatedObject(self, "otherButtonTitles");
	if(array && [array count] > 0)
	{
		return 0;
	}
	return -1;
}

-(NSInteger)swizzled_getNumberOfButtons
{
	NSMutableArray *array = objc_getAssociatedObject(self, "otherButtonTitles");
	if(array)
	{
		return 1 + [array count];
	}
	return 1;
}

- (UITextField *)swizzled_textFieldAtIndex:(NSInteger)textFieldIndex
{
	NSMutableArray *alertBoxTextFields = objc_getAssociatedObject(self, "alertBoxTextFields");
	if(alertBoxTextFields && [alertBoxTextFields count] > textFieldIndex)
	{
		return [alertBoxTextFields objectAtIndex:textFieldIndex];
	}
	return nil;
}

@end

#pragma clang diagnostic pop

#endif
