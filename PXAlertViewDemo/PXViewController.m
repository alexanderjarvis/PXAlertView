//
//  PXViewController.m
//  PXAlertViewDemo
//
//  Created by Alex Jarvis on 25/09/2013.
//  Copyright (c) 2013 Panaxiom Ltd. All rights reserved.
//

#import "PXViewController.h"
#import "PXAlertView+Customization.h"

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

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)showSimpleAlertView:(id)sender
{
    [PXAlertView showAlertWithTitle:@"Hello World"
                            message:@"Oh my this looks like a nice message."
                        cancelTitle:@"Ok"
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             if (cancelled) {
                                 NSLog(@"Simple Alert View cancelled");
                             } else {
                                 NSLog(@"Simple Alert View dismissed, but not cancelled");
                             }
                         }];
}

- (IBAction)showSimpleCustomizedAlertView:(id)sender
{
    PXAlertView *alert = [PXAlertView showAlertWithTitle:@"Hello World"
                                                 message:@"Oh my this looks like a nice message."
                                             cancelTitle:@"Ok"
                                              completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                  if (cancelled) {
                                                      NSLog(@"Simple Customised Alert View cancelled");
                                                  } else {
                                                      NSLog(@"Simple Customised Alert View dismissed, but not cancelled");
                                                  }
                                              }];
    [alert setWindowTintColor:[UIColor colorWithRed:94/255.0 green:196/255.0 blue:221/255.0 alpha:0.25]];
    [alert setBackgroundColor:[UIColor colorWithRed:255/255.0 green:206/255.0 blue:13/255.0 alpha:1.0]];
    [alert setCancelButtonBackgroundColor:[UIColor redColor]];
    [alert setTitleFont:[UIFont fontWithName:@"Zapfino" size:15.0f]];
    [alert setTitleColor:[UIColor darkGrayColor]];
    [alert setCancelButtonBackgroundColor:[UIColor redColor]];
}


- (IBAction)showLargeAlertView:(id)sender
{
    [PXAlertView showAlertWithTitle:@"Why this is a larger title! Even larger than the largest large thing that ever was large in a very large way."
                            message:@"Oh my this looks like a nice message. Yes it does, and it can span multiple lines... all the way down.\n\nBut what's this? Even more lines? Why yes, now we can have even more content to show the world. Why? Because now you don't have to worry about the text overflowing off the screen. If text becomes too long to fit on the users display, it'll simply overflow and allow for the user to scroll. So now you're free to write however much you wish to write in an alert. A novel? An epic? Doesn't matter, because it can all now fit*. \n\n\n*Disclaimer: Within hardware and technical limitations, of course.\n\n To demonstrate, watch here:\nHere is a line.\nAnd here is another.\nAnd another.\nAnd another.\nAaaaaaand another.\nOh lookie here, AND another.\nAnd here's one more.\nFor good measure.\nAnd hello, newline.\n\n\nFeel free to expand your textual minds."
                        cancelTitle:@"Ok thanks, that's grand"
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             if (cancelled) {
                                 NSLog(@"Larger Alert View cancelled");
                             } else {
                                 NSLog(@"Larger Alert View dismissed, but not cancelled");
                             }
                         }];
}

- (IBAction)showTwoButtonAlertView:(id)sender
{
    PXAlertView *alert = [PXAlertView showAlertWithTitle:@"The Matrix"
                            message:@"Pick the Red pill, or the blue pill"
                        cancelTitle:@"Blue"
                         otherTitle:@"Red"
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             if (cancelled) {
                                 NSLog(@"Cancel (Blue) button pressed");
                             } else {
                                 NSLog(@"Other (Red) button pressed");
                             }
                         }];
    
    UIColor *blueNormal = [UIColor blueColor];
    UIColor *blueSelected = [UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:1];
    [alert setCancelButtonNonSelectedBackgroundColor:blueNormal];
    [alert setCancelButtonBackgroundColor:blueSelected];
    
    UIColor *redNormal = [UIColor redColor];
    UIColor *redSelected = [UIColor colorWithRed:1 green:0.5 blue:0.5 alpha:1];
    [alert setOtherButtonNonSelectedBackgroundColor:redNormal];
    [alert setOtherButtonBackgroundColor:redSelected];
    
    [alert setAllButtonsTextColor:[UIColor whiteColor]];
}

- (IBAction)showTwoStackedButtonAlertView:(id)sender
{
    PXAlertView *alert = [PXAlertView showAlertWithTitle:@"The Matrix"
                                                 message:@"Pick the Red pill, or the blue pill"
                                             cancelTitle:@"Blue"
                                              otherTitle:@"Red"
                                      buttonsShouldStack:YES
                                              completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                  if (cancelled) {
                                                      NSLog(@"Cancel (Blue) button pressed");
                                                  } else {
                                                      NSLog(@"Other (Red) button pressed");
                                                  }
                                              }];
    
    UIColor *blueNormal = [UIColor blueColor];
    UIColor *blueSelected = [UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:1];
    [alert setCancelButtonNonSelectedBackgroundColor:blueNormal];
    [alert setCancelButtonBackgroundColor:blueSelected];
    
    UIColor *redNormal = [UIColor redColor];
    UIColor *redSelected = [UIColor colorWithRed:1 green:0.5 blue:0.5 alpha:1];
    [alert setOtherButtonNonSelectedBackgroundColor:redNormal];
    [alert setOtherButtonBackgroundColor:redSelected];
    
    [alert setAllButtonsTextColor:[UIColor whiteColor]];
}

- (IBAction)showMultiButtonAlertView:(id)sender
{
    PXAlertView *alert = [PXAlertView showAlertWithTitle:@"Porridge"
                            message:@"How would you like it?"
                        cancelTitle:@"No thanks"
                        otherTitles:@[ @"Too Hot", @"Luke Warm", @"Quite nippy" ]
                                      buttonsShouldStack:YES
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             if (cancelled) {
                                 NSLog(@"Cancel button pressed");
                             } else {
                                 NSLog(@"Button with index %li pressed", (long)buttonIndex);
                             }
                         }];
    [alert setAllButtonsBackgroundColor:[UIColor greenColor]];
}

- (IBAction)showAlertViewWithContentView:(id)sender
{
    [PXAlertView showAlertWithTitle:@"A picture should appear below"
                            message:@"Yay, it works!"
                        cancelTitle:@"Ok"
                         otherTitle:nil
                        contentView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ExampleImage.png"]]
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                         }];
}

- (IBAction)show5StackedAlertViews:(id)sender
{
    for (int i = 1; i <= 5; i++) {
        [PXAlertView showAlertWithTitle:[NSString stringWithFormat:@"Hello %@", @(i)]
                                message:@"Oh my this looks like a nice message."
                            cancelTitle:@"Ok"
                             completion:^(BOOL cancelled, NSInteger buttonIndex) {}];
    }
}

- (IBAction)showNoTapToDismiss:(id)sender
{
    PXAlertView *alertView = [PXAlertView showAlertWithTitle:@"Tap"
                                                     message:@"Try tapping around the alert view to dismiss it. This should NOT work on this alert."];
    [alertView setTapToDismissEnabled:NO];
}

- (IBAction)dismissWithNoAnimationAfter1Second:(id)sender
{
    PXAlertView *alertView = [PXAlertView showAlertWithTitle:@"No Animation" message:@"When dismissed"];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
    });
}

- (IBAction)showAlertInsideAlertCompletion:(id)sender
{
    [PXAlertView showAlertWithTitle:@"Alert Inception"
                            message:@"After pressing ok, another alert should appear"
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             [PXAlertView showAlertWithTitle:@"Woohoo"];
                         }];
}

- (IBAction)showCopyOfUIAlertView:(id)sender
{
    PXAlertView *alertView = [PXAlertView showAlertWithTitle:@"Some really long title that should wrap to two lines at least. But does it cut off after a certain number of lines? Does it? Does it really? And then what? Does it truncate? Nooo it still hasn't cut off yet. Wow this AlertView can take a lot of characters."
                                                     message:@"How long does the standard UIAlertView stretch to? This should give a good estimation"
                                                 cancelTitle:@"Cancel"
                                                  otherTitle:@"Ok"
                                                 contentView:nil
                                                  completion:nil];
    [alertView useDefaultIOS7Style];
}

- (IBAction)showLargeUIAlertView:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Some really long title that should wrap to two lines at least. But does it cut off after a certain number of lines? Does it? Does it really? And then what? Does it truncate? Nooo it still hasn't cut off yet. Wow this AlertView can take a lot of characters."
                               message:@"How long does the standard UIAlertView stretch to? This should give a good estimation"
                              delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Ok", nil];
    [alertView show];
}

@end
