//
//  MAISearchService.h
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAIGeocoderRepositoryDelegate.h"
#import "MAIItineraryRepositoryDelegate.h"
#import "MAIRoutingRepositoryDelegate.h"
#import "MAIRoutePolyline.h"

@interface MAIService : NSObject{

}

+ (MAIService*)sharedInstance;
@property (nonatomic, readonly) id<MAIGeocoderRepositoryDelegate> geocoderRepository;
@property (nonatomic, readonly) id<MAIItineraryRepositoryDelegate> itineraryRepository;
@property (nonatomic, readonly) id<MAIRoutingRepositoryDelegate> routingRepository;

#pragma mark Gecocoder
- (void) search:(NSString*)query withDataSourceCompletionHandler:(void (^)(NSArray *items))successDataHandler withDataSourceErrorHandler:(void (^)(NSString *errorMessage))failureDataHandler;

#pragma mark Itinerary
- (void) getSavedItineraries:(void (^)(NSArray *items))successDataHandler withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler;
- (void) saveItinerary:(MAIItinerary*)anItinerary withSuccessDataHandler:(void (^)(MAIItinerary *amendedItinerary))successDataHandler withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler;
- (void) saveItineraries:(NSArray*)items withSuccessDataHandler:(void (^)(void))successDataHandler withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler;
- (void) deleteItineraries:(void (^)(void))successDataHandler withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler;

#pragma mark Routing
- (void) calculateRoute:(MAIItinerary*)anItinerary withSuccessDataHandler:(void (^)(MAIRoute *route))successDataHandler withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler;
- (void) getRoute:(MAIRoute *)aRoute withSuccessDataHandler:(void (^)(MAIRoutePolyline *routePolyline))successDataHandler withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler;

@end
