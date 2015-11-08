//
//  MAIAnnotation.h
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MAIWaypoint.h"

@interface MAIAnnotation : NSObject <MKAnnotation>

@property (nonatomic)           MAIWaypoint              *waypoint;

- (id)initWithWaypoint:(MAIWaypoint*)aWaypoint;

@end