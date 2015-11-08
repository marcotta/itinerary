//
//  MAILocation.h
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MAIWaypoint : NSObject<NSCopying, NSCoding>

@property (copy, nonatomic, readonly) NSString *locationId;
@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *address;
@property (nonatomic, readonly)       CLLocationCoordinate2D position;


- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithLocationId:(NSString*)aLocationId
                          withName:(NSString*)aName
                       withAddress:(NSString*)anAddress
                      withPosition:(CLLocationCoordinate2D)aPosition NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithJson:(NSDictionary*)data;


@end
