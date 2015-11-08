//
//  MAIBaseViewController.h
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MATLoadingOverlayViewController.h"

@interface MAIBaseViewController : UIViewController

- (void)showNetworkActivityWithMessage:(NSString*)message;
- (void)hideNetworkActivity;
@end

