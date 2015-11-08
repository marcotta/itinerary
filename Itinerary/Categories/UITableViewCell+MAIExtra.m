//
//  UITableViewCell+Extra.m
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//


#import "UITableViewCell+MAIExtra.h"

@implementation UITableViewCell (MAIExtra)


-(void) ext_resizeToMatchTableWidth:(UITableView*)tableView {
    
    //HACK: IMPORTANT FOR IPHONE 6 and 6+ cell reports the wrong width and gets caluclations wrong.
    CGRect cellFrame = self.frame;
    cellFrame.size.width = tableView.frame.size.width;
    [self setFrame:cellFrame];
}

@end
