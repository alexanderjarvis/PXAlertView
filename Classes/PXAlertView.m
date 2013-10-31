//
//  PXAlertView.m
//  PXAlertViewDemo
//
//  Created by Alex Jarvis on 25/09/2013.
//  Copyright (c) 2013 Panaxiom Ltd. All rights reserved.
//

#import "PXAlertView.h"

@interface PXAlertViewQueue : NSObject

@property (nonatomic) NSMutableArray *alertViews;

+ (PXAlertViewQueue *)sharedInstance;

- (void)add:(PXAlertView *)alertView;
- (void)remove:(PXAlertView *)alertView;

@end

static const CGFloat AlertViewWidth = 270.0;
static const CGFloat AlertViewContentMargin = 9;
static const CGFloat AlertViewVerticalElementSpace = 10;
static const CGFloat AlertViewButtonHeight = 44;

@interface PXAlertView ()

@property (nonatomic) UIWindow *mainWindow;
@property (nonatomic) UIWindow *alertWindow;
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIView *alertView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIView *contentView;
@property (nonatomic) UILabel *messageLabel;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *otherButton;
@property (nonatomic) UITapGestureRecognizer *tap;
@property (nonatomic, copy) void (^completion)(BOOL cancelled);

@end

@implementation PXAlertView

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

- (id)initWithTitle:(NSString *)title
			message:(NSString *)message
		cancelTitle:(NSString *)cancelTitle
		 otherTitle:(NSString *)otherTitle
		contentView:(UIView *)contentView
		 completion:(PXAlertViewCompletionBlock)completion
{
    self = [super init];
    if (self) {
        _mainWindow = [self windowWithLevel:UIWindowLevelNormal];
        _alertWindow = [self windowWithLevel:UIWindowLevelAlert];
        
        if (!_alertWindow) {
            _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _alertWindow.windowLevel = UIWindowLevelAlert;
        }
        _alertWindow.rootViewController = self;
        
        CGRect frame = [self frameForOrientation:self.interfaceOrientation];
        self.view.frame = frame;
        
        _backgroundView = [[self class] backgroundViewWithFrame:frame];
        [self.view addSubview:_backgroundView];
        
        _alertView = [[self class] alertView];
        [self.view addSubview:_alertView];
        
        // Title
        _titleLabel = [[self class] titleLabelWithTitle:title];
        [_alertView addSubview:_titleLabel];
        
        CGFloat messageLabelY = _titleLabel.frame.origin.y + _titleLabel.frame.size.height + AlertViewVerticalElementSpace;
        
        // Optional Content View
        if (contentView) {
            _contentView = contentView;
            _contentView.frame = CGRectMake(0,
                                            messageLabelY,
                                            _contentView.frame.size.width,
                                            _contentView.frame.size.height);
            _contentView.center = CGPointMake(AlertViewWidth / 2, _contentView.center.y);
            [_alertView addSubview:_contentView];
            messageLabelY += contentView.frame.size.height + AlertViewVerticalElementSpace;
        }
        
        // Message
        _messageLabel = [[self class] messageLabelWithMessage:message];
		_messageLabel.frame = CGRectMake(AlertViewContentMargin,
										 messageLabelY,
										 AlertViewWidth - AlertViewContentMargin * 2,
										 44);
        [_alertView addSubview:_messageLabel];
        
        // Line
        CALayer *lineLayer = [[self class] lineLayer];
        lineLayer.frame = CGRectMake(0, _messageLabel.frame.origin.y + _messageLabel.frame.size.height + AlertViewVerticalElementSpace, AlertViewWidth, 0.5);
        [_alertView.layer addSublayer:lineLayer];
        
        // Buttons
        _cancelButton = [[self class] cancelButtonWithTitle:cancelTitle target:self];

        CGFloat buttonsY = lineLayer.frame.origin.y + lineLayer.frame.size.height;
        if (otherTitle) {
            _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
            _cancelButton.frame = CGRectMake(0, buttonsY, AlertViewWidth/2, AlertViewButtonHeight);
            
            _otherButton = [[self class] otherButtonWithTitle:otherTitle target:self];
            _otherButton.frame = CGRectMake(_cancelButton.frame.size.width, buttonsY, AlertViewWidth/2, 44);
            [self.alertView addSubview:_otherButton];
            
            CALayer *lineLayer = [[self class] lineLayer];
            lineLayer.frame = CGRectMake(_otherButton.frame.origin.x, _otherButton.frame.origin.y, 0.5, AlertViewButtonHeight);
            [_alertView.layer addSublayer:lineLayer];
            
        } else {
            _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
            _cancelButton.frame = CGRectMake(0, buttonsY, AlertViewWidth, AlertViewButtonHeight);
        }
        
        [_alertView addSubview:_cancelButton];
        
        _alertView.bounds = CGRectMake(0, 0, AlertViewWidth, 150);
        
        if (completion) {
            _completion = completion;
        }
        
        [self resizeViews];
        
        _alertView.center = [self centerWithFrame:frame];
        
        [self setupGestures];
    }
    return self;
}

+ (UIView *)alertView {
	UIView *alertView = [[UIView alloc] init];
	alertView.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];
	alertView.layer.cornerRadius = 8.0;
	alertView.layer.opacity = .95;
	alertView.clipsToBounds = YES;
	return alertView;
}

+ (UIView *)backgroundViewWithFrame:(CGRect)frame  {
	UIView *backgroundView = [[UIView alloc] initWithFrame:frame];
	backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
	backgroundView.alpha = 0;
	return backgroundView;
}

+ (UILabel *)titleLabelWithTitle:(NSString *)title {
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(AlertViewContentMargin,
																	AlertViewVerticalElementSpace,
																	AlertViewWidth - AlertViewContentMargin*2,
																	44)];
	titleLabel.text = title;
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.font = [UIFont boldSystemFontOfSize:17];
	titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
	titleLabel.numberOfLines = 0;
	titleLabel.frame = [self adjustLabelFrameHeight:titleLabel];
	return titleLabel;
}

+ (UILabel *)messageLabelWithMessage:(NSString *)message {
	UILabel *messageLabel = [[UILabel alloc] init];
	messageLabel.text = message;
	messageLabel.backgroundColor = [UIColor clearColor];
	messageLabel.textColor = [UIColor whiteColor];
	messageLabel.textAlignment = NSTextAlignmentCenter;
	messageLabel.font = [UIFont systemFontOfSize:15];
	messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
	messageLabel.numberOfLines = 0;
	messageLabel.frame = [self adjustLabelFrameHeight:messageLabel];
	return messageLabel;
}

+ (UIButton *)cancelButtonWithTitle:(NSString *)title target:(id)target {
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	if (title) {
		[cancelButton setTitle:title forState:UIControlStateNormal];
	} else {
		[cancelButton setTitle:NSLocalizedString(@"Ok", nil) forState:UIControlStateNormal];
	}
	cancelButton.backgroundColor = [UIColor clearColor];
	
	[cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[cancelButton setTitleColor:[UIColor colorWithWhite:0.25 alpha:1] forState:UIControlStateHighlighted];
	[cancelButton addTarget:target action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
	[cancelButton addTarget:target action:@selector(setBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
	[cancelButton addTarget:target action:@selector(clearBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragExit];
	return cancelButton;
}

+ (UIButton *)otherButtonWithTitle:(NSString *)title target:(id)target {
	UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[otherButton setTitle:title forState:UIControlStateNormal];
	otherButton.backgroundColor = [UIColor clearColor];
	otherButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
	[otherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[otherButton setTitleColor:[UIColor colorWithWhite:0.25 alpha:1] forState:UIControlStateHighlighted];
	[otherButton addTarget:target action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
	[otherButton addTarget:target action:@selector(setBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
	[otherButton addTarget:target action:@selector(clearBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragExit];
	return otherButton;
}

+ (CALayer *)lineLayer {
	CALayer *lineLayer = [CALayer layer];
	lineLayer.backgroundColor = [[UIColor colorWithWhite:0.90 alpha:0.3] CGColor];
	return lineLayer;
}

- (CGRect)frameForOrientation:(UIInterfaceOrientation)orientation
{
    CGRect frame;
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        CGRect bounds = [UIScreen mainScreen].bounds;
        frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.height, bounds.size.width);
    } else {
        frame = [UIScreen mainScreen].bounds;
    }
    return frame;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    CGRect frame = [self frameForOrientation:toInterfaceOrientation];
    self.view.frame = frame;
    self.backgroundView.frame = frame;
    self.alertView.center = [self centerWithFrame:frame];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (CGPoint)centerWithFrame:(CGRect)frame
{
    return CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) - [self statusBarOffset]);
}

- (CGFloat)statusBarOffset
{
    CGFloat statusBarOffset = 0;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        statusBarOffset = 20;
    }
    return statusBarOffset;
}

- (void)show
{
    [[PXAlertViewQueue sharedInstance] add:self];
}

- (void)showInternal
{
    self.alertWindow.hidden = NO;
    [self.alertWindow addSubview:self.view];
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
    self.visible = NO;
    
    if ([[[PXAlertViewQueue sharedInstance] alertViews] count] == 1) {
        [self dismissAlertAnimation];
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            self.mainWindow.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            [self.mainWindow tintColorDidChange];
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            self.alertWindow.hidden = YES;
            [self.mainWindow makeKeyAndVisible];
        }];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [[PXAlertViewQueue sharedInstance] remove:self];
        [self.view removeFromSuperview];
    }];
    
    BOOL cancelled;
    if (sender == self.cancelButton || sender == self.tap) {
        cancelled = YES;
    } else {
        cancelled = NO;
    }
    if (self.completion) {
        self.completion(cancelled);
    }
}

- (void)setBackgroundColorForButton:(id)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:94/255.0 green:196/255.0 blue:221/255.0 alpha:1.0]];
}

- (void)clearBackgroundColorForButton:(id)sender
{
    [sender setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - public

+ (instancetype)showAlertWithTitle:(NSString *)title
{
    return [PXAlertView showAlertWithTitle:title message:nil cancelTitle:NSLocalizedString(@"Ok", nil) completion:nil];
}

+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message
{
    return [PXAlertView showAlertWithTitle:title message:message cancelTitle:NSLocalizedString(@"Ok", nil) completion:nil];
}

+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message
						completion:(PXAlertViewCompletionBlock)completion
{
    return [PXAlertView showAlertWithTitle:title message:message cancelTitle:NSLocalizedString(@"Ok", nil) completion:completion];
}

+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message
					   cancelTitle:(NSString *)cancelTitle
						completion:(PXAlertViewCompletionBlock)completion
{
    PXAlertView *alertView = [[self alloc] initWithTitle:title
														message:message
													cancelTitle:cancelTitle
													 otherTitle:nil
													contentView:nil
													 completion:completion];
    [alertView show];
    return alertView;
}

+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message
					   cancelTitle:(NSString *)cancelTitle
						otherTitle:(NSString *)otherTitle
						completion:(PXAlertViewCompletionBlock)completion
{
    PXAlertView *alertView = [[self alloc] initWithTitle:title
														message:message
													cancelTitle:cancelTitle
													 otherTitle:otherTitle
													contentView:nil
													 completion:completion];
    [alertView show];
    return alertView;
}

+ (instancetype)showAlertWithTitle:(NSString *)title
						   message:(NSString *)message
					   cancelTitle:(NSString *)cancelTitle
						otherTitle:(NSString *)otherTitle
					   contentView:(UIView *)view
						completion:(PXAlertViewCompletionBlock)completion
{
    PXAlertView *alertView = [[self alloc] initWithTitle:title
														message:message
													cancelTitle:cancelTitle
													 otherTitle:otherTitle
													contentView:view
													 completion:completion];
    [alertView show];
    return alertView;
}

#pragma mark - gestures

- (void)setupGestures
{
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [self.tap setNumberOfTapsRequired:1];
    [self.backgroundView setUserInteractionEnabled:YES];
    [self.backgroundView setMultipleTouchEnabled:NO];
    [self.backgroundView addGestureRecognizer:self.tap];
}

#pragma mark -

+ (CGRect)adjustLabelFrameHeight:(UILabel *)label
{
    CGFloat height;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize size = [label.text sizeWithFont:label.font
                             constrainedToSize:CGSizeMake(label.frame.size.width, FLT_MAX)
                                 lineBreakMode:NSLineBreakByWordWrapping];
        
        height = size.height;
        #pragma clang diagnostic pop
    } else {
        NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
        context.minimumScaleFactor = 1.0;
        CGRect bounds = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, FLT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:label.font}
                                        context:context];
        height = bounds.size.height;
    }
    
    return CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, height);
}

- (void)resizeViews
{
    CGFloat totalHeight = 0;
    for (UIView *view in [self.alertView subviews]) {
        if ([view class] != [UIButton class]) {
            totalHeight += view.frame.size.height + AlertViewVerticalElementSpace;
        }
    }
    totalHeight += AlertViewButtonHeight;
    totalHeight += AlertViewVerticalElementSpace;
    
    self.alertView.frame = CGRectMake(self.alertView.frame.origin.x,
                                      self.alertView.frame.origin.y,
                                      self.alertView.frame.size.width,
                                      totalHeight);
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

@end

@implementation PXAlertViewQueue

+ (instancetype)sharedInstance
{
    static PXAlertViewQueue *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[PXAlertViewQueue alloc] init];
        _sharedInstance.alertViews = [NSMutableArray array];
    });
    
    return _sharedInstance;
}

- (void)add:(PXAlertView *)alertView
{
    [self.alertViews addObject:alertView];
    [alertView showInternal];
    for (PXAlertView *av in self.alertViews) {
        if (av != alertView) {
            [av hide];
        }
    }
}

- (void)remove:(PXAlertView *)alertView
{
    [self.alertViews removeObject:alertView];
    PXAlertView *last = [self.alertViews lastObject];
    if (last) {
        [last showInternal];
    }
}

@end
