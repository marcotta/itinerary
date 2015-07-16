//
//  MAIItineraryTableViewCell.h
//  Itinerary
//
//  Created by marco attanasio on 14/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAIItinerary.h"

@interface MAIItineraryTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet  UILabel *headerLabel;
@property (nonatomic) IBOutlet  NSLayoutConstraint *leftMargin;
@property (nonatomic) IBOutlet  NSLayoutConstraint *rightMargin;

- (void) bind:(MAIItinerary*)anItinerary;


@end
