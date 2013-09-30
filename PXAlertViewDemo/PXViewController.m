//
//  PXViewController.m
//  PXAlertViewDemo
//
//  Created by Alex Jarvis on 25/09/2013.
//  Copyright (c) 2013 Panaxiom Ltd. All rights reserved.
//

#import "PXViewController.h"

@interface PXViewController ()

@end

@implementation PXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showSimpleAlertView:(id)sender
{
    [PXAlertView showAlertWithTitle:@"Hello World"
                            message:@"Oh my this looks like a nice message."
                        cancelTitle:@"Ok"
                         otherTitle:nil
                         completion:^(BOOL cancelled) {
                             if (cancelled) {
                                 NSLog(@"Simple Alert View cancelled");
                             } else {
                                 NSLog(@"Simple Alert View dismissed, but not cancelled");
                             }
                         }];
}

- (IBAction)showLargerAlertView:(id)sender
{
    [PXAlertView showAlertWithTitle:@"Why this is a larger title!"
                            message:@"Oh my this looks like a nice message. Yes it does, and it can span multiple lines... all the way down."
                        cancelTitle:@"Ok thanks, that's grand"
                         otherTitle:nil
                         completion:^(BOOL cancelled) {
                             if (cancelled) {
                                 NSLog(@"Larger Alert View cancelled");
                             } else {
                                 NSLog(@"Larger Alert View dismissed, but not cancelled");
                             }
                         }];
}

- (IBAction)showTwoButtonAlertView:(id)sender
{
    [PXAlertView showAlertWithTitle:@"The Matrix"
                            message:@"Pick the Red pill, or the blue pill"
                        cancelTitle:@"Blue"
                         otherTitle:@"Red"
                         completion:^(BOOL cancelled) {
                             if (cancelled) {
                                 NSLog(@"Cancel (Blue) button pressed");
                             } else {
                                 NSLog(@"Other (Red) button pressed");
                             }
                         }];
}

@end
