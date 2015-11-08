//
//  MAIWaypointTableViewCell.h
//  Itinerary
//
//  Created by marco attanasio on 12/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAIWaypoint.h"
#import "MAIItineraryDelegate.h"

typedef void (^AccessoryButtonTappedBlock)(id sender);

@interface MAIWaypointTableViewCell : UITableViewCell

- (void) bind:(MAIWaypoint*)aWaypoint withAcessoryButtonTappedBlock:(AccessoryButtonTappedBlock)addButtonBlock;

@end
