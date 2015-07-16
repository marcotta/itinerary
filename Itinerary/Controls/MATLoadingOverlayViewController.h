//
//  MATLoadingOverlayViewController.h
//  
//
//  Created by Marco Attanasio on 27/02/2012.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MATLoadingOverlayViewController : UIViewController {

}

@property (nonatomic) IBOutlet UIView *square;
@property (nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) IBOutlet UIImageView *tick;
@property (nonatomic) IBOutlet UILabel *message;
@property (nonatomic) IBOutlet UIView *bg;

- (void) showWithMessage:(NSString *)aMessage;
- (void) hideWithTick:(BOOL)showTick;
- (void) fadeDown;

@end
