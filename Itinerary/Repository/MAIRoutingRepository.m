//
//  MAIRoutingRepository.m
//  Itinerary
//
//  Created by marco attanasio on 15/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIRoutingRepository.h"
#import "MAIItinerary.h"
#import "MAIWaypoint.h"
#import "MAIRoute.h"
#import "MAiRoutePolyline.h"
#import "MAIConfiguration.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSString+MAIExtras.h"
#import <MapKit/MapKit.h>

//Switch production and testing environment endpoints based on release or debug mode
//When using basic authentication it must use httpS and not http.
#ifdef DEBUG
#define CALCULATE_ROUTE_END_POINT @"https://route.cit.api.here.com/routing/7.2/calculateroute.json"
#define GET_ROUTE_END_POINT @"http://route.cit.api.here.com/routing/7.2/getroute.json"
#else
#define CALCULATE_ROUTE_END_POINT @"https://route.api.here.com/routing/7.2/calculateroute.json"
#define GET_ROUTE_END_POINT @"http://route.api.here.com/routing/7.2/getroute.json"
#endif


@implementation MAIRoutingRepository



- (void)routingRepositoryCalculateRoute:(MAIRoutingRepository*)repository
							  itinerary:(MAIItinerary*)anItinerary
						   withLanguage:(NSString*)language
				 withSuccessDataHandler:(void (^)(MAIRoute *route))successDataHandler
				 withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler
{
	if(!anItinerary)
	{
		failureDataHandler(@"itinerary parameter cannot be nil.");
		return;
	}
	
	if(!anItinerary.waypoints || (anItinerary.waypoints && anItinerary.waypoints.count<2))
	{
		failureDataHandler(@"Must specify at least 2 waypoint.");
		return;
	}
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	
	NSString *url= [NSString stringWithFormat:@"%@", CALCULATE_ROUTE_END_POINT];
	NSMutableDictionary *parameters =
	  [[NSMutableDictionary alloc] initWithDictionary:@{@"app_id":kAppId,
													  @"app_code":kAppCode,
													  @"language":language,
													  @"instructionFormatType":@"txt",
													  @"routeAttributes":@"none,routeId,summary",
													  @"legAttributes":@"none",
													  @"mode":@"fastest;car"}];
	
	[anItinerary.waypoints enumerateObjectsUsingBlock:^(MAIWaypoint *waypoint, NSUInteger index, BOOL *stop) {
		if([NSString ext_IsNullOrEmpty:waypoint.name])
		{
			[parameters setValue:[NSString stringWithFormat:@"stopOver!%f,%f", waypoint.position.latitude, waypoint.position.longitude] forKey:[NSString stringWithFormat:@"waypoint%li", (long)index]];
		}
		else
		{
			[parameters setValue:[NSString stringWithFormat:@"stopOver!%f,%f;;%@", waypoint.position.latitude, waypoint.position.longitude, waypoint.name] forKey:[NSString stringWithFormat:@"waypoint%li", (long)index]];
		}
	}];
	
	[manager GET:url
	  parameters:parameters
		 success:^(AFHTTPRequestOperation *operation, id responseObject) {
			 NSDictionary *response = (NSDictionary*)[responseObject objectForKey:@"response"];
			 NSArray *remoteRoutes = [response objectForKey:@"route"];
			 NSDictionary *remoteRoute = [remoteRoutes firstObject];
			 
			 MAIRoute *route = [[MAIRoute alloc] initWithJson:remoteRoute];
			 
			 if(successDataHandler)
			 {
				 successDataHandler(route);
			 }
		 }
		 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			 if(failureDataHandler)
			 {
				 failureDataHandler([self parseErrorMessage:operation withError:error]);
			 }
		 }];
}

- (void)routingRepositoryGetRoute:(MAIRoutingRepository*)repository
							route:(MAIRoute*)aRoute
					 withLanguage:(NSString*)language
		   withSuccessDataHandler:(void (^)(MAIRoutePolyline *routePolyline))successDataHandler
		   withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler
{
	if(!aRoute)
	{
		failureDataHandler(@"route parameter cannot be nil.");
		return;
	}
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	//Disable NSURLCache and let the service handle caching
	[manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	
	NSString *url= [NSString stringWithFormat:@"%@", GET_ROUTE_END_POINT];
	NSDictionary *parameters = @{@"app_id":kAppId,
								 @"app_code":kAppCode,
								 @"language":language,
								 @"routeId": aRoute.routeId,
								 @"routeAttributes":@"none,shape,boundingBox",
								 @"mode":@"fastest;car"};
	
	[manager GET:url
	  parameters:parameters
		 success:^(AFHTTPRequestOperation *operation, id responseObject) {
			 NSDictionary *response = (NSDictionary*)[responseObject objectForKey:@"response"];
			 NSDictionary *remoteRoute = [response objectForKey:@"route"];
			 NSArray *shape = [remoteRoute objectForKey:@"shape"];
			 NSDictionary *boundingBox = [remoteRoute objectForKey:@"boundingBox"];
			 CLLocationCoordinate2D *polylineCoords = malloc(sizeof(CLLocationCoordinate2D) * shape.count);
			 [shape enumerateObjectsUsingBlock:^(NSString *coords, NSUInteger index, BOOL *stop) {
				 NSArray *coordParts = [coords componentsSeparatedByString:@","];
				 polylineCoords[index] =  CLLocationCoordinate2DMake([[coordParts objectAtIndex:0] floatValue], [[coordParts objectAtIndex:1] floatValue]);
		  }];
		  
			 MKPolyline *polyline = [MKPolyline polylineWithCoordinates:polylineCoords count:shape.count];
			 free(polylineCoords);
			 
			 CLLocationCoordinate2D topLeft = CLLocationCoordinate2DMake(-90, 180);
			 CLLocationCoordinate2D bottomRight = CLLocationCoordinate2DMake(90, 180);
			 
			 if(boundingBox && [boundingBox objectForKey:@"bottomRight"])
			 {
				 NSDictionary *remoteBottomRight = [boundingBox objectForKey:@"bottomRight"];
				 bottomRight = CLLocationCoordinate2DMake([[remoteBottomRight objectForKey:@"latitude"] floatValue], [[remoteBottomRight objectForKey:@"longitude"] floatValue]);
			 }
			 if(boundingBox && [boundingBox objectForKey:@"topLeft"])
			 {
				 NSDictionary *remoteTopLeft = [boundingBox objectForKey:@"topLeft"];
				 topLeft = CLLocationCoordinate2DMake([[remoteTopLeft objectForKey:@"latitude"] floatValue], [[remoteTopLeft objectForKey:@"longitude"] floatValue]);
			 }
			 
			 MAIRoutePolyline *routePolyline = [[MAIRoutePolyline alloc] initWithPolyline:polyline withRegionTopLeftCoordinates:topLeft withRegionBottomRightCoordinates:bottomRight];
			 
			 if(successDataHandler)
			 {
				 successDataHandler(routePolyline);
			 }
		 }
		 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			 if(failureDataHandler)
			 {
				 failureDataHandler([self parseErrorMessage:operation withError:error]);
			 }
		 }];
}

@end
