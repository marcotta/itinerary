//
//  MAIItineraryTableViewCell.h
//  Itinerary
//
//  Created by marco attanasio on 14/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MAIItinerary;

@interface MAIItineraryTableViewCell : UITableViewCell

- (void)bind:(MAIItinerary*)anItinerary;

@end
