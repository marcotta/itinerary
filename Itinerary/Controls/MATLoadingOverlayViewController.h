//
//  MATLoadingOverlayViewController.h
//
//
//  Created by Marco Attanasio on 27/02/2012.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MATLoadingOverlayViewController : UIViewController

- (void) showWithMessage:(NSString *)aMessage;
- (void) hideWithTick:(BOOL)showTick;
- (void) fadeDown;

@end
