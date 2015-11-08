//
//  MAIGeocoderRepository.m
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//
//  This class only responsibility is to retrieve data and hand it back

#import "MAIGeocoderRepository.h"
#import "MAIConfiguration.h"
#import "AFHTTPRequestOperationManager.h"
#import "MAIWaypoint.h"
#import "NSString+MAIExtras.h"

//Switch production and testing environment endpoints based on release or debug mode
//When using basic authentication it must use httpS and not http.
#ifdef DEBUG
#define GEOCODER_END_POINT @"https://geocoder.cit.api.here.com/6.2/search.json"
#else
#define GEOCODER_END_POINT @"https://geocoder.api.here.com/6.2/search.json"
#endif

@implementation MAIGeocoderRepository


#pragma mark MAIGeocoderRepositoryDelegate

- (void) search:(NSString*)query withLanguage:(NSString*)language withSuccessDataHandler:(void (^)(NSArray *))successDataHandler withFailureDataHandler:(void (^)(NSString *))failureDataHandler {
    if([NSString ext_IsNullOrEmpty:query])
    {
        failureDataHandler(@"Query parameter cannot be empty.");
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //Disable NSURLCache and let the service handle caching
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    //Setting the header does not seem to work, will be passing appid and appcode as parameters, which works fine
    //    [manager.requestSerializer setValue:[[MAIConfiguration alloc] getAuthorizationHeader] forHTTPHeaderField:@"Authorization"];
    //    NSDictionary *parameters = @{@"searchtext": query,
    //                                 @"language":language,
    //                                 @"gen":@"8"};
    //    NSLog(@"Headers: %@", [manager.requestSerializer HTTPRequestHeaders]);
    
    NSString *url= [NSString stringWithFormat:@"%@", GEOCODER_END_POINT];
    NSDictionary *parameters = @{@"searchtext": query,
                                 @"app_id":APP_ID,
                                 @"app_code":APP_CODE,
                                 @"language":language,
                                 @"gen":@"8"};
    
    [manager GET:url
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //              NSLog(@"JSON: %@", responseObject);
             
             NSDictionary *response = (NSDictionary*)[responseObject objectForKey:@"Response"];
             NSArray *view = [response objectForKey:@"View"];
             NSArray *results = [[view firstObject] objectForKey:@"Result"];
             
             __block NSMutableArray *remoteLocations = [[NSMutableArray alloc] initWithCapacity:0];
             [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                 MAIWaypoint *newLocation = [[MAIWaypoint alloc] initWithJson:obj];
                 [remoteLocations addObject:newLocation];
                 newLocation = nil;
             }];
             
             if(successDataHandler) {
                 successDataHandler(remoteLocations);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if(failureDataHandler) {
                 failureDataHandler([self parseErrorMessage:operation withError:error]);
             }
         }];
}

@end
