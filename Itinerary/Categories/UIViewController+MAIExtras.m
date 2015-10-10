//
//  UIViewController+MAIExtras.m
//  Itinerary
//
//  Created by marco attanasio on 14/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "UIViewController+MAIExtras.h"

@implementation UIViewController (MAIExtras)

// UIAlertController has a leak on ios8 of 48 bytes
// http://www.openradar.appspot.com/20021758
- (void) ext_showAlert:(NSString*)aTitle withMessage:(NSString *)aMessage andShowCancel:(bool)showCancel withOkHandler:(void (^)(UIAlertAction *action))okHandler withCancelHandler:(void (^)(UIAlertAction *action))cancelHandler{
    if([UIAlertController class]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:aTitle message:aMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",nil) style:UIAlertActionStyleDefault
                                                         handler:okHandler];
        [alert addAction:okAction];
        
        if(showCancel)
        {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleDefault
                                                                 handler:cancelHandler];
            [alert addAction:cancelAction];
        }
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// UIAlertController has a leak on ios8 of 48 bytes
// http://www.openradar.appspot.com/20021758
- (void) ext_showActionSheet:(NSString *)aMessage withOkCopy:(NSString*)okCopy withOkHandler:(void (^)(UIAlertAction *action))okHandler withCancelHandler:(void (^)(UIAlertAction *action))cancelHandler withSender:(id)sender{
    if([UIAlertController class]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:aMessage preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:okCopy style:UIAlertActionStyleDefault
                                                         handler:okHandler];
        [alert addAction:okAction];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel
                                                             handler:cancelHandler];
        [alert addAction:cancelAction];
      
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            if(sender) {
                alert.popoverPresentationController.sourceView = sender;
            }
            else{
                //Not attached to any control
                alert.popoverPresentationController.sourceView = self.view;
                //center it
                alert.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0);
            }
        }
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (void)addFullScreenConstraints:(UIView*)holdingView innerView:(UIView*)innerView withMargins:(CGFloat)margin {
    [innerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:innerView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:0
                                                                        toItem:holdingView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:margin];
    [holdingView addConstraint:topConstraint];
    topConstraint = nil;
    
    
    NSLayoutConstraint *btmConstraint = [NSLayoutConstraint constraintWithItem:innerView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:0
                                                                        toItem:holdingView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:margin];
    [holdingView addConstraint:btmConstraint];
    btmConstraint = nil;
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:holdingView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:innerView
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.0
                                                                       constant:margin];
    [holdingView  addConstraint:leftConstraint];
    leftConstraint = nil;
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:innerView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:holdingView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.0
                                                                        constant:margin];
    [holdingView  addConstraint:rightConstraint];
    rightConstraint = nil;
}

- (void)addFullScreenConstraints:(UIView*)holdingView innerView:(UIView*)innerView {
    [self addFullScreenConstraints:holdingView innerView:innerView withMargins:0];
}
@end
