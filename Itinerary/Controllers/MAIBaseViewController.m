//
//  MAIBaseViewController.m
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIBaseViewController.h"
#import "UIViewController+MAIExtras.h"
#import "NSString+MAIExtras.h"

@interface MAIBaseViewController ()

@property (nonatomic) MATLoadingOverlayViewController   *loadingOverlay;

@end

@implementation MAIBaseViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self addLoadingOverlay];
	
}

- (void)addLoadingOverlay
{
	self.loadingOverlay = [MATLoadingOverlayViewController new];
	[self.view addSubview:self.loadingOverlay.view];
	[self addFullScreenConstraints:self.view innerView:self.loadingOverlay.view];
}

- (void)showNetworkActivityWithMessage:(NSString*)message
{
	if([NSString ext_IsNullOrEmpty:message])
	{
		message = @"Loading";
	}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[self.loadingOverlay showWithMessage:NSLocalizedString(message, nil)];
}

- (void)hideNetworkActivity
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self.loadingOverlay hideWithTick:NO];
}

@end
