//
//  PXViewController.h
//  PXAlertViewDemo
//
//  Created by Alex Jarvis on 25/09/2013.
//  Copyright (c) 2013 Panaxiom Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PXAlertView.h"

@interface PXViewController : UIViewController

- (IBAction)showSimpleAlertView:(id)sender;
- (IBAction)showLargeAlertView:(id)sender;
- (IBAction)showTwoButtonAlertView:(id)sender;
- (IBAction)showMultiButtonAlertView:(id)sender;
- (IBAction)showAlertViewWithContentView:(id)sender;
- (IBAction)show5StackedAlertViews:(id)sender;
- (IBAction)showAlertInsideAlertCompletion:(id)sender;

- (IBAction)showLargeUIAlertView:(id)sender;

@end
