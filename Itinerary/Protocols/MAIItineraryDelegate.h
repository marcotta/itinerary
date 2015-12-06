//
//  MAIItineraryDelegate.h
//  Itinerary
//
//  Created by marco attanasio on 13/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAIItinerary;
@class MAIWaypoint;

@protocol MAIItineraryDelegate <NSObject>

- (void)itineraryDidAddWaypoint:(MAIItinerary *)itinerary
					   waypoint:(MAIWaypoint *)waypoint
					 withSender:(id)sender;
- (void)itineraryDidRemoveWaypoint:(MAIItinerary *)itinerary atIndex:(NSUInteger)index;
- (void)itineraryDidMoveWaypoint:(MAIItinerary *)itinerary
			  fromIndex:(NSUInteger)fromIndex
				toIndex:(NSUInteger)toIndex;

@end
