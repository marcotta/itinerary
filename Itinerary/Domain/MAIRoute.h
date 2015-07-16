//
//  MAIRoute.h
//  Itinerary
//
//  Created by marco attanasio on 15/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAIRoute : NSObject<NSCopying, NSCoding> {

}

@property (nonatomic, copy) NSString *routeId;
@property (nonatomic, copy) NSString *summary;


- (MAIRoute*) initWithRouteId:(NSString*)aRouteId withSummary:(NSString*)aSummary;
- (MAIRoute*) initWithJson:(NSDictionary*)data;

@end
