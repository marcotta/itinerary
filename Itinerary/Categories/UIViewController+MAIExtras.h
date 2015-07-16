//
//  UIViewController+MAIExtras.h
//  Itinerary
//
//  Created by marco attanasio on 14/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MAIExtras)

- (void) ext_showAlert:(NSString*)aTitle withMessage:(NSString *)aMessage andShowCancel:(bool)showCancel withOkHandler:(void (^)(UIAlertAction *action))okHandler withCancelHandler:(void (^)(UIAlertAction *action))cancelHandler;
- (void) ext_showActionSheet:(NSString *)aMessage withOkCopy:(NSString*)okCopy withOkHandler:(void (^)(UIAlertAction *action))okHandler withCancelHandler:(void (^)(UIAlertAction *action))cancelHandler withSender:(id)sender;
- (void) addFullScreenConstraints:(UIView*)holdingView innerView:(UIView*)innerView withMargins:(CGFloat)margin;
- (void) addFullScreenConstraints:(UIView*)holdingView innerView:(UIView*)innerView;

@end
