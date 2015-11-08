//
//  MAIRoutingRepositoryDelegate.h
//  Itinerary
//
//  Created by marco attanasio on 15/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAIItinerary.h"
#import "MAIRoute.h"
#import "MAIRoutePolyline.h"

@protocol MAIRoutingRepositoryDelegate <NSObject>

- (void)calculateRoute:(MAIItinerary*)anItinerary
          withLanguage:(NSString*)language
withSuccessDataHandler:(void (^)(MAIRoute *route))successDataHandler
withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler;

- (void)getRoute:(MAIRoute*)aRoute
    withLanguage:(NSString*)language
withSuccessDataHandler:(void (^)(MAIRoutePolyline *routePolyline))successDataHandler
withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler;

@end
