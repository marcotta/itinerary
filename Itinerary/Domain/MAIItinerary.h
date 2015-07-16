//
//  MAIItinerary.h
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAIWaypoint.h"
#import "MAIRoute.h"

@interface MAIItinerary : NSObject<NSCopying, NSCoding>{

}

@property (nonatomic, copy)             NSString        *itineraryId;
@property (nonatomic, copy)             NSString        *friendlyName;
@property (nonatomic, readonly)         NSMutableArray  *waypoints;
@property (nonatomic, copy)             MAIRoute        *route;

- (MAIItinerary*)init;

- (void) addItem:(MAIWaypoint*)waypoint;
- (void) removeItemAtIndex:(NSUInteger)index;
- (void) moveItemAtIndex:(NSUInteger)sourceIndex toIndex:(NSUInteger)destinationIndex;
@end