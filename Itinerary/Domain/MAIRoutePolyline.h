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

@property (nonatomic, readonly) MKPolyline *polyline;
@property (nonatomic, readonly) CLLocationCoordinate2D topLeft;
@property (nonatomic, readonly) CLLocationCoordinate2D bottomRight;


- (instancetype)initWithPolyline:(MKPolyline*)aPolyline
   withRegionTopLeftCoordinates:(CLLocationCoordinate2D)aTopLeftCoordinate
withRegionBottomRightCoordinates:(CLLocationCoordinate2D)aBottomRightCoordinate;

@end
