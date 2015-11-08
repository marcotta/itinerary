//
//  MAIItineraryDelegate.h
//  Itinerary
//
//  Created by marco attanasio on 13/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAIWaypoint.h"

@protocol MAIItineraryDelegate <NSObject>

- (void)onAddWaypoint:(MAIWaypoint*)waypoint withSender:(id) sender;
- (void)onRemoveWaypointAtIndex:(NSUInteger)index;
- (void)onMoveWaypointAtIndex:(NSUInteger)sourceIndex toIndex:(NSUInteger)destinationIndex;

@end
