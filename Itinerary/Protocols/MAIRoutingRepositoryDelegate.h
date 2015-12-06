//
//  MAIRoutingRepositoryDelegate.h
//  Itinerary
//
//  Created by marco attanasio on 15/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAIRoutingRepository;
@class MAIItinerary;
@class MAIRoute;
@class MAIRoutePolyline;

@protocol MAIRoutingRepositoryDelegate <NSObject>

- (void)routingRepositoryCalculateRoute:(MAIRoutingRepository*)repository
							  itinerary:(MAIItinerary*)anItinerary
						   withLanguage:(NSString*)language
				 withSuccessDataHandler:(void (^)(MAIRoute *route))successDataHandler
				 withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler;

- (void)routingRepositoryGetRoute:(MAIRoutingRepository*)repository
							route:(MAIRoute*)aRoute
					 withLanguage:(NSString*)language
		   withSuccessDataHandler:(void (^)(MAIRoutePolyline *routePolyline))successDataHandler
		   withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler;

@end
