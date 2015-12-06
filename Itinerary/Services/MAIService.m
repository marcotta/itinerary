//
//  MAISearchService.m
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIService.h"
#import "NSString+MAIExtras.h"

#import "MAIItinerary.h"

#import "MAIGeocoderRepository.h"
#import "MAIItineraryRepository.h"
#import "MAIRoutingRepository.h"

@implementation MAIService

+ (MAIService*)sharedInstance
{
    static dispatch_once_t once;
    static MAIService* sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (MAIService*)init
{
    self = [super init];
    if (self) {
        _geocoderRepository = [MAIGeocoderRepository new];
        _itineraryRepository = [MAIItineraryRepository new];
        _routingRepository = [MAIRoutingRepository new];
    }
    return self;
}

#pragma mark - Geocoder
//  Any other business logic will be added to this method, including caching or conditions checks
- (void)search:(NSString*)query
withDataSourceCompletionHandler:(void (^)(NSArray *))successDataHandler
withDataSourceErrorHandler:(void (^)(NSString *))failureDataHandler
{
    
    if(!self.geocoderRepository)
	{
        failureDataHandler(@"Repository cannot be nil.");
        return;
    }
    
    if([NSString ext_IsNullOrEmpty:query])
	{
        failureDataHandler(@"Query parameter cannot be empty.");
        return;
    }
    
    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
    //    NSLog(@"Language %@", language);
	
	[self.geocoderRepository geocoderRepositorySearch:self.geocoderRepository
												query:query
										 withLanguage:language
							   withSuccessDataHandler:^(NSArray *items){
								   if(successDataHandler)
								   {
									   successDataHandler(items);
								   }
							   }
							   withFailureDataHandler:^(NSString *errorMessage) {
								   if(failureDataHandler)
								   {
									   failureDataHandler(errorMessage);
								   }
							   }];
}

#pragma  mark Itinerary
- (void)getSavedItineraries:(void (^)(NSArray *items))successDataHandler
     withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler
{
	if(!self.itineraryRepository)
	{
		failureDataHandler(@"Repository cannot be nil.");
		return;
	}
	
	[self.itineraryRepository itineraryRepositoryGetSavedItineraries:self.itineraryRepository
											  withSuccessDataHandler:^(NSArray *items) {
												  if(successDataHandler)
												  {
													  successDataHandler(items);
												  }
											  }
											  withFailureDataHandler:^(NSString *errorMessage) {
												  if(failureDataHandler)
												  {
													  failureDataHandler(errorMessage);
												  }
											  }];
}

- (void)storeItinerary:(MAIItinerary *)anItinerary
withSuccessDataHandler:(void (^)(MAIItinerary *amendeItinerary))successDataHandler
withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler
{
	[self.itineraryRepository itineraryRepositorySaveItinerary:self.itineraryRepository
													 itinerary:anItinerary
										withSuccessDataHandler:^(MAIItinerary *amendedItinerary) {
											if(successDataHandler)
											{
												successDataHandler(amendedItinerary);
											}
										}
										withFailureDataHandler:^(NSString *errorMessage) {
											if(failureDataHandler)
											{
												failureDataHandler(errorMessage);
											}
										}];
}

- (void)saveItinerary:(MAIItinerary*)anItinerary
withSuccessDataHandler:(void (^)(MAIItinerary *amendeItinerary))successDataHandler
withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler
{
    if(!self.itineraryRepository)
	{
        failureDataHandler(@"Repository cannot be nil.");
        return;
    }
    
    if(!anItinerary)
	{
        failureDataHandler(@"Itinerary cannot be nil.");
        return;
    }
    
    //Everytime the itinerary changes and has more than 1 waypoint lets update the route info
    if(anItinerary.waypoints && anItinerary.waypoints.count>1)
	{
        [self calculateRoute:anItinerary
	  withSuccessDataHandler:^(MAIRoute *route) {
            anItinerary.route = route;
            [self storeItinerary:anItinerary withSuccessDataHandler:successDataHandler withFailureDataHandler:failureDataHandler];
        }
	  withFailureDataHandler:^(NSString *errorMessage) {
            if(failureDataHandler)
			{
                failureDataHandler(errorMessage);
            }
        }];
    }
    else
	{
        //Don't have enough waypoint to calculate route
        anItinerary.route = nil;
        [self storeItinerary:anItinerary
	  withSuccessDataHandler:successDataHandler
	  withFailureDataHandler:failureDataHandler];
    }
}

- (void)saveItineraries:(NSArray*)items
 withSuccessDataHandler:(void (^)(void))successDataHandler
 withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler
{
    
    if(!self.itineraryRepository)
	{
        failureDataHandler(@"Repository cannot be nil.");
        return;
    }
    
	[self.itineraryRepository itineraryRepositorySaveItineraries:self.itineraryRepository
													 itineraries:items
										  withSuccessDataHandler:^{
											  if(successDataHandler)
											  {
												  successDataHandler();
											  }
										  }
										  withFailureDataHandler:^(NSString *errorMessage) {
											  if(failureDataHandler)
											  {
												  failureDataHandler(errorMessage);
											  }
										  }];
}

- (void)deleteItineraries:(void (^)(void))successDataHandler
   withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler
{
    if(!self.itineraryRepository)
	{
        failureDataHandler(@"Repository cannot be nil.");
        return;
    }
    
	[self.itineraryRepository itineraryRepositoryDeleteItineraries:self.itineraryRepository
											withSuccessDataHandler:^{
												if(successDataHandler)
												{
													successDataHandler();
												}
											}
											withFailureDataHandler:^(NSString *errorMessage) {
												if(failureDataHandler)
												{
													failureDataHandler(errorMessage);
												}
											}];
}

#pragma mark - Routing
- (void)calculateRoute:(MAIItinerary*)anItinerary
withSuccessDataHandler:(void (^)(MAIRoute *route))successDataHandler
withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler
{
    if(!self.routingRepository)
	{
        failureDataHandler(@"Repository cannot be nil.");
        return;
    }
    
    if(!anItinerary)
	{
        failureDataHandler(@"Itinerary parameter cannot be nil.");
        return;
    }
    
    if(!anItinerary.waypoints || (anItinerary.waypoints && anItinerary.waypoints.count<2))
	{
        failureDataHandler(@"Must specify at least 2 waypoint.");
        return;
    }
    
    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
	[self.routingRepository routingRepositoryCalculateRoute:self.routingRepository
												  itinerary:anItinerary
											   withLanguage:language
									 withSuccessDataHandler:^(MAIRoute *route) {
										 if(successDataHandler)
										 {
											 successDataHandler(route);
										 }
									 }
									 withFailureDataHandler:^(NSString *errorMessage) {
										 if(failureDataHandler)
										 {
											 failureDataHandler(errorMessage);
										 }
									 }];
}

- (void)getRoute:(MAIRoute *)aRoute
withSuccessDataHandler:(void (^)(MAIRoutePolyline *routePolyline))successDataHandler
withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler
{
    if(!self.routingRepository)
	{
        failureDataHandler(@"Repository cannot be nil.");
        return;
    }
    
    if(!aRoute)
	{
        failureDataHandler(@"Route parameter cannot be nil.");
        return;
    }
    
    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
	
	[self.routingRepository routingRepositoryGetRoute:self.routingRepository
												route:aRoute withLanguage:language
							   withSuccessDataHandler:^(MAIRoutePolyline *routePolyline) {
								   if(successDataHandler)
								   {
									   successDataHandler(routePolyline);
								   }
							   }
							   withFailureDataHandler:^(NSString *errorMessage) {
								   if(failureDataHandler)
								   {
									   failureDataHandler(errorMessage);
								   }
							   }];
}

- (void)dealloc
{
    _geocoderRepository = nil;
    _itineraryRepository = nil;
    _routingRepository = nil;
}

@end
