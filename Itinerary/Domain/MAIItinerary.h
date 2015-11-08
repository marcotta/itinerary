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
    NSMutableArray  *_waypoints;
}

@property (copy, nonatomic)                                 NSString        *itineraryId;
@property (copy, nonatomic)                                 NSString        *friendlyName;
@property (nonatomic, readonly)                             NSMutableArray  *waypoints;
@property (copy, nonatomic)                                 MAIRoute        *route;

- (MAIItinerary*)init;

- (void)addItem:(MAIWaypoint*)waypoint;
- (void)removeItemAtIndex:(NSUInteger)index;
- (void)moveItemAtIndex:(NSUInteger)sourceIndex
                toIndex:(NSUInteger)destinationIndex;
@end
