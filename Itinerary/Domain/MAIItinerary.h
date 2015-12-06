//
//  MAIItinerary.h
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAIWaypoint;
@class MAIRoute;

@interface MAIItinerary : NSObject<NSCopying, NSCoding>{
    NSMutableArray  *_waypoints;
}

@property (copy, nonatomic, readonly) NSString *itineraryId;
@property (copy, nonatomic) NSString *friendlyName;
@property (nonatomic, readonly) NSMutableArray *waypoints;
@property (copy, nonatomic) MAIRoute *route;

- (instancetype)initWithItineraryId:(NSString *)itineraryId NS_DESIGNATED_INITIALIZER;

- (void)generateItineraryId;
- (void)addItem:(MAIWaypoint*)waypoint;
- (void)removeItemAtIndex:(NSUInteger)index;
- (void)moveItemAtIndex:(NSUInteger)sourceIndex
                toIndex:(NSUInteger)destinationIndex;
@end
