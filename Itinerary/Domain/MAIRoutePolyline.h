//
//  MAIRoutePolyline.h
//  Itinerary
//
//  Created by marco attanasio on 15/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MAIRoutePolyline : NSObject

@property (nonatomic) MKPolyline *polyline;
@property (nonatomic) CLLocationCoordinate2D topLeft;
@property (nonatomic) CLLocationCoordinate2D bottomRight;


-(MAIRoutePolyline*) initWithPolyline:(MKPolyline*)aPolyline withRegionTopLeftCoordinates:(CLLocationCoordinate2D)aTopLeftCoordinate withRegionBottomRightCoordinates:(CLLocationCoordinate2D)aBottomRightCoordinate;
@end
