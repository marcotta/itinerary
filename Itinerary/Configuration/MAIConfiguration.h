//
//  MAIConfiguration.h
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_NAME @"Itinerary"
#define APP_ID @"hu2Io86XfXzpEzF0fjH3"
#define APP_CODE @"aRA5LwpVvfydJYsIN6qpMg"

////Switch production and testing environment endpoints based on release or debug mode
////When using basic authentication it must use httpS and not http.
//#ifdef DEBUG
//    #define PLACES_END_POINT "https://places.cit.api.here.com"
//    #define GEOCODER_END_POINT "https://geocoder.cit.api.here.com/6.2/geocode.json"
//#else
//    #define PLACES_END_POINT "https://places.api.here.com"
//    #define GEOCODER_END_POINT "https://geocoder.api.here.com/6.2/geocode.json"
//#endif




@interface MAIConfiguration : NSObject


- (NSString*) getAuthorizationHeader;

@end
