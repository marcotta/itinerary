//
//  MAIRoutePolyline.m
//  Itinerary
//
//  Created by marco attanasio on 15/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIRoutePolyline.h"

@implementation MAIRoutePolyline


-(MAIRoutePolyline*) initWithPolyline:(MKPolyline*)aPolyline withRegionTopLeftCoordinates:(CLLocationCoordinate2D)aTopLeftCoordinate withRegionBottomRightCoordinates:(CLLocationCoordinate2D)aBottomRightCoordinate {
    self = [super init];
    if (self) {
        _polyline = aPolyline;
        _topLeft = aTopLeftCoordinate;
        _bottomRight = aBottomRightCoordinate;
    }
    return self;
}


@end
