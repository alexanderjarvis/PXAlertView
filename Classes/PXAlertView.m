//
//  PXAlertView.m
//  PXAlertViewDemo
//
//  Created by Alex Jarvis on 25/09/2013.
//  Copyright (c) 2013 Panaxiom Ltd. All rights reserved.
//

#import "PXAlertView.h"
#import <objc/runtime.h>

void * const kCancelBGKey = (void * const) &kCancelBGKey;
void * const kOtherBGKey = (void * const) &kOtherBGKey;
void * const kAllBGKey = (void * const) &kAllBGKey;
void * const kFGKey = (void * const) &kFGKey;

@interface PXAlertViewStack : NSObject

@property (nonatomic) NSMutableArray *alertViews;

+ (PXAlertViewStack *)sharedInstance;

- (void)push:(PXAlertView *)alertView;
- (void)pop:(PXAlertView *)alertView;

@property (nonatomic) UIWindow *mainWindow;
@property (nonatomic) UIWindow *alertWindow;

@end

static const CGFloat AlertViewWidth = 270.0;
static const CGFloat AlertViewContentMargin = 9;
static const CGFloat AlertViewVerticalElementSpace = 10;
static const CGFloat AlertViewButtonHeight = 44;
static const CGFloat AlertViewLineLayerWidth = 0.5;

@interface PXAlertView ()

@property (weak, nonatomic) UIWindow *mainWindow;
@property (weak, nonatomic) UIWindow *alertWindow;

@property (nonatomic) BOOL buttonsShouldStack;
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIView *alertView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIView *contentView;
@property (nonatomic) NSMutableArray *lineViews;

@property (nonatomic) UIView *lastElement;

@property (nonatomic) UILabel *messageLabel;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *otherButton;
@property (nonatomic) NSMutableArray *buttons;
@property (nonatomic) UITapGestureRecognizer *tap;
@property (nonatomic, copy) void (^completion)(BOOL cancelled, NSInteger buttonIndex);

@property (strong, nonatomic) UIColor *cancelButtonPressedColor;
@property (strong, nonatomic) UIColor *otherButtonPressedColor;
@property (strong, nonatomic) UIColor *allButtonPressedColor;

@property (strong, nonatomic) UIColor *cachedUnpressedColor;

@property (nonatomic) NSLayoutConstraint *cancelButtonRightConstraint;

@end

@implementation PXAlertView

- (id)initWithTitle:(NSString *)title
			message:(NSString *)message
		cancelTitle:(NSString *)cancelTitle
		 otherTitle:(NSString *)otherTitle
 buttonsShouldStack:(BOOL)shouldstack
		contentView:(UIView *)contentView
		 completion:(PXAlertViewCompletionBlock)completion
{
	return [self initWithTitle:title
					   message:message
				   cancelTitle:cancelTitle
				   otherTitles:(otherTitle) ? @[ otherTitle ] : nil
			buttonsShouldStack:(BOOL)shouldstack
				   contentView:contentView
					completion:completion];
}

- (id)initWithTitle:(NSString *)title
			message:(NSString *)message
		cancelTitle:(NSString *)cancelTitle
		otherTitles:(NSArray *)otherTitles
 buttonsShouldStack:(BOOL)shouldstack
		contentView:(UIView *)contentView
		 completion:(PXAlertViewCompletionBlock)completion
{
	self = [super init];
	if (self) {
		[self setupWithTitle:title message:message cancelTitle:cancelTitle otherTitles:otherTitles buttonsShouldStack:shouldstack contentView:contentView completion:completion];
	}
	return self;
}

- (void)setupWithTitle:(NSString *)title
			   message:(NSString *)message
		   cancelTitle:(NSString *)cancelTitle
		   otherTitles:(NSArray *)otherTitles
	buttonsShouldStack:(BOOL)shouldstack
		   contentView:(UIView *)contentView
			completion:(PXAlertViewCompletionBlock)completion {

	self.backgroundView = [[UIView alloc] init];
	[_backgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view addSubview:self.backgroundView];

	NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[view]-(0)-|" options:0 metrics:nil views:@{@"view":_backgroundView}];
	NSArray *constraints = [hConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|" options:0 metrics:nil views:@{@"view":_backgroundView}]];
	[self.view addConstraints:constraints];

	self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
	self.backgroundView.alpha = 0;

	self.alertView = [[UIView alloc] init];
	[self.alertView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view addSubview:self.alertView];

	constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(alertViewWidth)]" options:0 metrics:@{@"alertViewWidth":@(AlertViewWidth)} views:@{@"view":self.alertView}];

	[self.alertView addConstraints:constraints];

	NSLayoutConstraint *centerV = [NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];

	NSLayoutConstraint *centerH = [NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];

	[self.view addConstraints:@[centerH, centerV]];

	self.alertView.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];
	self.alertView.layer.cornerRadius = 8.0;
	self.alertView.layer.opacity = .95;
	self.alertView.clipsToBounds = YES;

	//dummy view for constraints at top
	UIView *topView = [[UIView alloc] initWithFrame:CGRectZero];
	[topView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.alertView addSubview:topView];
	constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[topView(0)]" options:0 metrics:nil views:@{@"topView":topView}];
	constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[topView]-(0)-|" options:0 metrics:nil views:@{@"topView":topView}]];
	[self.alertView addConstraints:constraints];

	_lastElement = topView;

	if (title) {
		// Title
		self.titleLabel = [[UILabel alloc] init];
		[_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.alertView addSubview:self.titleLabel];

		hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[view]-(margin)-|" options:0 metrics:@{@"margin":@(AlertViewContentMargin)} views:@{@"view":_titleLabel}];
		constraints = [hConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastElement]-(spacing)-[view]" options:0 metrics:@{@"spacing":@(AlertViewVerticalElementSpace)} views:@{@"lastElement":_lastElement,@"view":_titleLabel}]];
		[self.alertView addConstraints:constraints];
		_lastElement = _titleLabel;

		self.titleLabel.text = title;
		self.titleLabel.backgroundColor = [UIColor clearColor];
		self.titleLabel.textColor = [UIColor whiteColor];
		self.titleLabel.textAlignment = NSTextAlignmentCenter;
		self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
		self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
		self.titleLabel.numberOfLines = 0;

	}

	// Content View
	if (contentView) {

		self.contentView = contentView;
		[contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.alertView addSubview:self.contentView];

		hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[view]-(0)-|" options:0 metrics:@{@"margin":@(AlertViewContentMargin)} views:@{@"view":contentView}];
		constraints = [hConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastElement]-(spacing)-[view]" options:0 metrics:@{@"spacing":@(AlertViewVerticalElementSpace)} views:@{@"lastElement":_lastElement,@"view":contentView}]];
		[self.alertView addConstraints:constraints];
		_lastElement = contentView;
	}

	if (message) {
		// Message
		self.messageLabel = [[UILabel alloc] init];
		[_messageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.alertView addSubview:self.messageLabel];

		hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[view]-(margin)-|" options:0 metrics:@{@"margin":@(AlertViewContentMargin)} views:@{@"view":_messageLabel}];
		constraints = [hConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastElement]-(spacing)-[view]" options:0 metrics:@{@"spacing":@(AlertViewVerticalElementSpace)} views:@{@"lastElement":_lastElement,@"view":_messageLabel}]];
		[self.alertView addConstraints:constraints];
		_lastElement = _messageLabel;

		self.messageLabel.text = message;
		self.messageLabel.backgroundColor = [UIColor clearColor];
		self.messageLabel.textColor = [UIColor whiteColor];
		self.messageLabel.textAlignment = NSTextAlignmentCenter;
		self.messageLabel.font = [UIFont systemFontOfSize:15];
		self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
		self.messageLabel.numberOfLines = 0;

	}

	//dummy view for constraints at bottom
	UIView *bottomView = [[UIView alloc] initWithFrame:CGRectZero];
	[bottomView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.alertView addSubview:bottomView];
	constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastElement]-(margin)-[bottomView(0)]" options:0 metrics:@{@"margin":@(AlertViewContentMargin)} views:@{@"lastElement":_lastElement,@"bottomView":bottomView}];
	constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[bottomView]-(0)-|" options:0 metrics:nil views:@{@"bottomView":bottomView}]];
	[self.alertView addConstraints:constraints];

	_lastElement = bottomView;

	// Buttons
	_buttonsShouldStack = shouldstack;

	if (cancelTitle) {
		[self addButtonWithTitle:cancelTitle];
	}

	if (otherTitles && [otherTitles count] > 0) {
		for (id otherTitle in otherTitles) {
			NSParameterAssert([otherTitle isKindOfClass:[NSString class]]);
			[self addButtonWithTitle:(NSString *)otherTitle];
		}
	}

	//line color
	[self setAlertViewLineColor:[UIColor colorWithWhite:0.90 alpha:0.3]];

	//bottom constraint
	constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastElement]-(0)-|" options:0 metrics:nil views:@{@"lastElement":_lastElement}];

	[self.alertView addConstraints:constraints];

	if (completion) {
		self.completion = completion;
	}

	[self setupGestures];
}

- (UIButton *)genericButton
{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.backgroundColor = [UIColor clearColor];
	button.titleLabel.font = [UIFont systemFontOfSize:17];
	button.titleLabel.adjustsFontSizeToFitWidth = YES;
	button.titleEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setTitleColor:[UIColor colorWithWhite:0.25 alpha:1] forState:UIControlStateHighlighted];
	[button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
	[button addTarget:self action:@selector(setCustomBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
	[button addTarget:self action:@selector(setCustomBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragEnter];
	[button addTarget:self action:@selector(clearBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragExit];
	[button setTranslatesAutoresizingMaskIntoConstraints:NO];
	return button;
}

- (CGFloat)statusBarOffset
{
	CGFloat statusBarOffset = 0;
	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
		statusBarOffset = 20;
	}
	return statusBarOffset;
}

- (void)setupGestures
{
	self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
	[self.tap setNumberOfTapsRequired:1];
	[self.backgroundView setUserInteractionEnabled:YES];
	[self.backgroundView setMultipleTouchEnabled:NO];
	[self.backgroundView addGestureRecognizer:self.tap];
}

- (void)setBackgroundColorForButton:(id)sender
{
	[sender setBackgroundColor:[UIColor colorWithRed:94/255.0 green:196/255.0 blue:221/255.0 alpha:1.0]];
}

- (void)clearBackgroundColorForButton:(id)sender
{
	[sender setBackgroundColor:_cachedUnpressedColor];
}

- (void)show
{
	[[PXAlertViewStack sharedInstance] push:self];
}

- (void)showInternal
{
	_alertWindow = [[PXAlertViewStack sharedInstance] alertWindow];
	_mainWindow = [[PXAlertViewStack sharedInstance] mainWindow];

	[self.view setTranslatesAutoresizingMaskIntoConstraints:NO];

	[self.alertWindow addSubview:self.view];

	NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[view]-(0)-|" options:0 metrics:nil views:@{@"view":self.view}];
	NSArray *constraints = [hConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|" options:0 metrics:nil views:@{@"view":self.view}]];
	[self.alertWindow addConstraints:constraints];

	[self.view layoutIfNeeded];

	[self.alertWindow makeKeyAndVisible];
	self.visible = YES;
	[self showBackgroundView];
	[self showAlertAnimation];
}

- (void)showBackgroundView
{
	if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
		self.mainWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
		[self.mainWindow tintColorDidChange];
	}
	[UIView animateWithDuration:0.3 animations:^{
		self.backgroundView.alpha = 1;
	}];
}

- (void)hide
{
	[self.view removeFromSuperview];
}

- (void)dismiss:(id)sender
{
	[self dismiss:sender animated:YES];
}

- (void)dismiss:(id)sender animated:(BOOL)animated
{
	self.visible = NO;

	if ([[[PXAlertViewStack sharedInstance] alertViews] count] == 1) {
		if (animated) {
			[self dismissAlertAnimation];
		}
		if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
			self.mainWindow.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
			[self.mainWindow tintColorDidChange];
		}
		[UIView animateWithDuration:(animated ? 0.2 : 0) animations:^{
			self.backgroundView.alpha = 0;
		} completion:nil];
	}

	[UIView animateWithDuration:(animated ? 0.2 : 0) animations:^{
		self.alertView.alpha = 0;
	} completion:^(BOOL finished) {
		[[PXAlertViewStack sharedInstance] pop:self];
		[self.view removeFromSuperview];
	}];

	if (self.completion) {
		BOOL cancelled = NO;
		if (sender == self.cancelButton || sender == self.tap) {
			cancelled = YES;
		}
		NSInteger buttonIndex = -1;
		if (self.buttons) {
			NSUInteger index = [self.buttons indexOfObject:sender];
			if (buttonIndex != NSNotFound) {
				buttonIndex = index;
			}
		}
		self.completion(cancelled, buttonIndex);
	}
}

- (void)showAlertAnimation
{
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];

	animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
						 [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
						 [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
	animation.keyTimes = @[ @0, @0.5, @1 ];
	animation.fillMode = kCAFillModeForwards;
	animation.removedOnCompletion = NO;
	animation.duration = .3;

	[self.alertView.layer addAnimation:animation forKey:@"showAlert"];
}

- (void)dismissAlertAnimation
{
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];

	animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
						 [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
						 [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)]];
	animation.keyTimes = @[ @0, @0.5, @1 ];
	animation.fillMode = kCAFillModeRemoved;
	animation.duration = .2;

	[self.alertView.layer addAnimation:animation forKey:@"dismissAlert"];
}

#pragma mark -
#pragma mark UIViewController

- (BOOL)prefersStatusBarHidden
{
	return [UIApplication sharedApplication].statusBarHidden;
}

- (BOOL)shouldAutorotate
{
	return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark -
#pragma mark Public

+ (instancetype)showAlertWithTitle:(NSString *)title
{
	return [[self class] showAlertWithTitle:title message:nil cancelTitle:NSLocalizedString(@"Ok", nil) completion:nil];
}

+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message
{
	return [[self class] showAlertWithTitle:title message:message cancelTitle:NSLocalizedString(@"Ok", nil) completion:nil];
}

+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message
						completion:(PXAlertViewCompletionBlock)completion
{
	return [[self class] showAlertWithTitle:title message:message cancelTitle:NSLocalizedString(@"Ok", nil) completion:completion];
}

+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message
					   cancelTitle:(NSString *)cancelTitle
						completion:(PXAlertViewCompletionBlock)completion
{
	return [[self class] showAlertWithTitle:title
									message:message
								cancelTitle:cancelTitle
								 otherTitle:nil
						 buttonsShouldStack:NO
								contentView:nil
								 completion:completion];
}

+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message
					   cancelTitle:(NSString *)cancelTitle
						otherTitle:(NSString *)otherTitle
						completion:(PXAlertViewCompletionBlock)completion
{
	return [[self class] showAlertWithTitle:title
									message:message
								cancelTitle:cancelTitle
								 otherTitle:otherTitle
						 buttonsShouldStack:NO
								contentView:nil
								 completion:completion];
}

+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message
					   cancelTitle:(NSString *)cancelTitle
						otherTitle:(NSString *)otherTitle
				buttonsShouldStack:(BOOL)shouldStack
						completion:(PXAlertViewCompletionBlock)completion
{
	return [[self class] showAlertWithTitle:title
									message:message
								cancelTitle:cancelTitle
								otherTitles:(otherTitle? @[otherTitle] : nil)
						 buttonsShouldStack:shouldStack
								contentView:nil
								 completion:completion];
}

+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message
					   cancelTitle:(NSString *)cancelTitle
					   otherTitles:(NSArray *)otherTitles
						completion:(PXAlertViewCompletionBlock)completion
{
	return [[self class] showAlertWithTitle:title
									message:message
								cancelTitle:cancelTitle
								otherTitles:otherTitles
						 buttonsShouldStack:NO
								contentView:nil
								 completion:completion];}

+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message
					   cancelTitle:(NSString *)cancelTitle
						otherTitle:(NSString *)otherTitle
					   contentView:(UIView *)view
						completion:(PXAlertViewCompletionBlock)completion
{
	return [[self class] showAlertWithTitle:title
									message:message
								cancelTitle:cancelTitle
								otherTitles:(otherTitle? @[otherTitle] : nil)
						 buttonsShouldStack:NO
								contentView:view
								 completion:completion];
}

+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message
					   cancelTitle:(NSString *)cancelTitle
						otherTitle:(NSString *)otherTitle
				buttonsShouldStack:(BOOL)shouldStack
					   contentView:(UIView *)view
						completion:(PXAlertViewCompletionBlock)completion
{
	return [[self class] showAlertWithTitle:title
									message:message
								cancelTitle:cancelTitle
								otherTitles:(otherTitle? @[otherTitle] : nil)
						 buttonsShouldStack:shouldStack
								contentView:view
								 completion:completion];
}


+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message
					   cancelTitle:(NSString *)cancelTitle
					   otherTitles:(NSArray *)otherTitles
					   contentView:(UIView *)view
						completion:(PXAlertViewCompletionBlock)completion
{
	return [[self class] showAlertWithTitle:title
									message:message
								cancelTitle:cancelTitle
								otherTitles:otherTitles
						 buttonsShouldStack:NO
								contentView:view
								 completion:completion];
}

+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message
					   cancelTitle:(NSString *)cancelTitle
					   otherTitles:(NSArray *)otherTitles
				buttonsShouldStack:(BOOL)shouldStack
					   contentView:(UIView *)view
						completion:(PXAlertViewCompletionBlock)completion
{
	PXAlertView *alertView = [[self alloc] initWithTitle:title
												 message:message
											 cancelTitle:cancelTitle
											 otherTitles:otherTitles
									  buttonsShouldStack:shouldStack
											 contentView:view
											  completion:completion];
	[alertView show];
	return alertView;
}



-(void)addHorizontalLine {
	if (!_lineViews) {
		_lineViews = [NSMutableArray array];
	}

	[_lineViews addObject:[[UIView alloc] init]];
	[_lineViews.lastObject setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.alertView addSubview:_lineViews.lastObject];

	NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[view]-(0)-|" options:0 metrics:nil views:@{@"view":_lineViews.lastObject}];
	NSArray *constraints = [hConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastElement]-(0)-[view(lineViewHeight)]" options:0 metrics:@{@"lineViewHeight":@(AlertViewLineLayerWidth)} views:@{@"lastElement":_lastElement,@"view":_lineViews.lastObject}]];
	[self.view addConstraints:constraints];

	_lastElement = [_lineViews lastObject];
}

- (void)addButtonWithTitle:(NSString *)title
{
	UIButton *button = [self genericButton];
	[button setTitle:title forState:UIControlStateNormal];
	[self.alertView addSubview:button];


	if (!self.cancelButton) {

		[self addHorizontalLine];

		button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
		_cancelButton = button;

		NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastElement]-(0)-[button(buttonHeight)]" options:0 metrics:@{@"buttonHeight":@(AlertViewButtonHeight)} views:@{@"lastElement":_lastElement,@"button":button}];
		NSArray *buttonConstraints = [vConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[button]" options:0 metrics:nil views:@{@"button":button}]];

		_cancelButtonRightConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:button.superview attribute:NSLayoutAttributeRight multiplier:1 constant:0];
		buttonConstraints = [buttonConstraints arrayByAddingObject:_cancelButtonRightConstraint];

		[_alertView addConstraints:buttonConstraints];

		_lastElement = button;

	}
	else if (_buttonsShouldStack || _buttons.count > 1) {
		if (_buttons.count <= 1) {
			_otherButton = button;
		}

		[self addHorizontalLine];

		NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastElement]-(0)-[button(buttonHeight)]" options:0 metrics:@{@"buttonHeight":@(AlertViewButtonHeight)} views:@{@"lastElement":_lastElement,@"button":button}];
		NSArray *buttonConstraints = [vConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[button]-(0)-|" options:0 metrics:nil views:@{@"button":button}]];
		[_alertView addConstraints:buttonConstraints];

		button.titleLabel.font = [UIFont systemFontOfSize:17];

		_lastElement = button;
	}
	else {

		_otherButton = button;

		[_lineViews addObject:[[UIView alloc] init]];
		[_lineViews.lastObject setTranslatesAutoresizingMaskIntoConstraints:NO];
		[_alertView addSubview:_lineViews.lastObject];

		[_alertView removeConstraint:_cancelButtonRightConstraint];
		_cancelButtonRightConstraint = nil;

		NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[cancelButton(==otherButton)]-(0)-[view(lineViewHeight)]-(0)-[otherButton]-(0)-|" options:0 metrics:@{@"lineViewHeight":@(AlertViewLineLayerWidth)} views:@{@"view":_lineViews.lastObject,@"cancelButton":_cancelButton,@"otherButton":button}];
		NSArray *constraints = [hConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[firstLine]-(0)-[view(==cancelButton)]" options:0 metrics:nil views:@{@"firstLine":_lineViews[0],@"view":_lineViews.lastObject,@"cancelButton":_cancelButton}]];
		constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[firstLine]-(0)-[button(buttonHeight)]" options:0 metrics:@{@"buttonHeight":@(AlertViewButtonHeight)} views:@{@"firstLine":_lineViews[0],@"button":button}]];
		[_alertView addConstraints:constraints];

		button.titleLabel.font = [UIFont systemFontOfSize:17];
	}

	if(_buttons) {
		[_buttons addObject:button];
	}
	else {
		_buttons = [@[button] mutableCopy];
	}
}


- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
	if (buttonIndex >= 0 && buttonIndex < [self.buttons count]) {
		[self dismiss:self.buttons[buttonIndex] animated:animated];
	}
}

- (void)setTapToDismissEnabled:(BOOL)enabled
{
	self.tap.enabled = enabled;
}

#pragma mark - customization

- (void)useDefaultIOS7Style {
	[self setTapToDismissEnabled:NO];
	UIColor *ios7BlueColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
	[self setAllButtonsTextColor:ios7BlueColor];
	[self setTitleColor:[UIColor blackColor]];
	[self setMessageColor:[UIColor blackColor]];
	UIColor *defaultBackgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0];
	[self setAllButtonsBackgroundColor:defaultBackgroundColor];
	[self setBackgroundColor:[UIColor whiteColor]];
}

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
	_cachedUnpressedColor = [sender backgroundColor];

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
	_cancelButtonPressedColor = color;
}

- (UIColor *)cancelButtonBackgroundColor
{
	return _cancelButtonPressedColor;
}

- (void)setAllButtonsBackgroundColor:(UIColor *)color
{
	_otherButtonPressedColor = color;
	_cancelButtonPressedColor = color;
	_allButtonPressedColor = color;
}

- (UIColor *)allButtonsBackgroundColor
{
	return _allButtonPressedColor;
}

- (void)setOtherButtonBackgroundColor:(UIColor *)color
{
	_otherButtonPressedColor = color;
}

- (UIColor *)otherButtonBackgroundColor
{
	return _otherButtonPressedColor;
}

-(void)setCancelButtonColor:(UIColor *)color {
	[self.cancelButton setBackgroundColor:color];
}

-(void)setOtherButtonColor:(UIColor *)color {
	[self.otherButton setBackgroundColor:color];
}

-(void)setAllButtonsColor:(UIColor *)color {
	for (UIButton *b in self.buttons) {
		[b setBackgroundColor:color];
	}
}

#pragma mark Buttons Text Colors
- (void)setCancelButtonTextColor:(UIColor *)color
{
	[self.cancelButton setTitleColor:color forState:UIControlStateNormal];
	[self.cancelButton setTitleColor:color forState:UIControlStateHighlighted];
}

- (void)setAllButtonsTextColor:(UIColor *)color
{
	for (UIButton *button in self.buttons) {
		[button setTitleColor:color forState:UIControlStateNormal];
		[button setTitleColor:color forState:UIControlStateHighlighted];
	}
}

- (void)setOtherButtonTextColor:(UIColor *)color
{
	[self.otherButton setTitleColor:color forState:UIControlStateNormal];
	[self.otherButton setTitleColor:color forState:UIControlStateHighlighted];
}

#pragma mark - Button Font

- (void)setCancelButtonFont:(UIFont *)font
{
	[self.cancelButton.titleLabel setFont:font];
}

- (void)setAllButtonsFont:(UIFont *)font
{
	for (UIButton *button in self.buttons) {
		[button.titleLabel setFont:font];
	}
}

- (void)setOtherButtonFont:(UIFont *)font
{
	[self.otherButton.titleLabel setFont:font];
}

#pragma mark - other configuration

-(void)setAlertViewBackgroundColor:(UIColor *)color {
	[self.alertView setBackgroundColor:color];
}

-(void)setAlertViewLineVisible {
	for (UIView *lineView in _lineViews) {
		lineView.hidden = NO;
	}
}

-(void)setAlertViewLineHidden {
	for (UIView *lineView in _lineViews) {
		lineView.hidden = YES;
	}
}

-(void)setAlertViewLineColor:(UIColor *)color {
	for (UIView *lineView in _lineViews) {
		lineView.backgroundColor = color;
	}
}

-(void)setCornerRadius:(CGFloat)cornerRadius {
	[self.alertView.layer setCornerRadius:cornerRadius];
}

@end

@implementation PXAlertViewStack

- (UIWindow *)windowWithLevel:(UIWindowLevel)windowLevel
{
	NSArray *windows = [[UIApplication sharedApplication] windows];
	for (UIWindow *window in windows) {
		if (window.windowLevel == windowLevel) {
			return window;
		}
	}
	return nil;
}


+ (instancetype)sharedInstance
{
	static PXAlertViewStack *_sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedInstance = [[PXAlertViewStack alloc] init];
		_sharedInstance.alertViews = [NSMutableArray array];
	});

	return _sharedInstance;
}

- (void)push:(PXAlertView *)alertView
{
	if (!_alertWindow) {
		self.mainWindow = [self windowWithLevel:UIWindowLevelNormal];

		//make alert window
		self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
		self.alertWindow.windowLevel = UIWindowLevelAlert;
		self.alertWindow.backgroundColor = [UIColor clearColor];
		self.alertWindow.rootViewController = alertView;
	}

	[alertView showInternal];

	[_alertViews.lastObject hide];

	[self.alertViews addObject:alertView];
}

- (void)pop:(PXAlertView *)alertView
{
	[self.alertViews removeObject:alertView];

	PXAlertView *last = [self.alertViews lastObject];

	if (last) {
		[last showInternal];
	}
	else {
		[self.alertWindow setHidden:YES];
		[self.alertWindow removeFromSuperview];
		self.alertWindow.rootViewController = nil;
		self.alertWindow = nil;
		[self.mainWindow makeKeyAndVisible];
	}
}

@end
