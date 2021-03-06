//
//  MAIRouteViewController.h
//  Itinerary
//
//  Created by marco attanasio on 15/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIBaseViewController.h"
#import <MapKit/MapKit.h>
#import "MAIItinerary.h"
#import "MAIRoutePolyline.h"

@interface MAIRouteViewController : MAIBaseViewController<MKMapViewDelegate, CLLocationManagerDelegate>

@end
