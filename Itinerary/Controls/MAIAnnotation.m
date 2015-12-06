//
//  MAIAnnotation.h
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIAnnotation.h"
#import "MAIWaypoint.h"

#import "NSString+MAIExtras.h"

@implementation MAIAnnotation

- (id)initWithWaypoint:(MAIWaypoint*)aWaypoint
{
    if (self = [super init])
	{
        _waypoint = aWaypoint;
    }
    return self;
}

- (NSString*) title
{
    if([NSString ext_IsNullOrEmpty:self.waypoint.name] && ![NSString ext_IsNullOrEmpty:self.waypoint.address])
	{
        return self.waypoint.address;
    }
    
    return self.waypoint.name;
}

- (NSString*) subtitle
{
    //address would have been returned as a title;
    if([NSString ext_IsNullOrEmpty:self.waypoint.name])
	{
        return @"";
    }
    
    return self.waypoint.address;
}

- (CLLocationCoordinate2D) coordinate
{
    return self.waypoint.position;
}

@end
