//
//  MATLoadingOverlayViewController.m
//
//
//  Created by Marco Attanasio on 27/02/2012.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MATLoadingOverlayViewController.h"

@interface MATLoadingOverlayViewController ()

@property (nonatomic) IBOutlet UIView *square;
@property (nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) IBOutlet UIImageView *tick;
@property (nonatomic) IBOutlet UILabel *message;
@property (nonatomic) IBOutlet UIView *bg;

@end

@implementation MATLoadingOverlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setAlpha:0];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.square.layer setCornerRadius:10.0f];
}


- (void) showWithMessage:(NSString *)aMessage {
    [self.activityIndicator setHidden:NO];
    [self.tick setHidden:YES];
    [self.message setText:aMessage];
    [self.message setHidden:NO];
    [self.view setAlpha:1];
}

- (void) hideWithTick:(BOOL)showTick {
    
    [self.activityIndicator setHidden:YES];
    [self.tick setHidden:!showTick];
    [self.message setHidden:YES];
    if (showTick) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf fadeDown];
        });
    } else {
        [self fadeDown];
    }
}

- (void) fadeDown {
    [UIView beginAnimations:NULL context:nil];
    [self.view setAlpha:0];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
@end
