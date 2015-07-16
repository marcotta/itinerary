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

@property (nonatomic, copy) NSString *locationId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic)       CLLocationCoordinate2D  position;



- (MAIWaypoint*) initWithLocationId:(NSString*)aLocationId withName:(NSString*)aName withAddress:(NSString*)anAddress withPosition:(CLLocationCoordinate2D)aPosition;
- (MAIWaypoint*) initWithJson:(NSDictionary*)data;


@end
