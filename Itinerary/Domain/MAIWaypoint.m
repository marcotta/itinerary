//
//  MAILocation.m
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIWaypoint.h"


@implementation MAIWaypoint

- (MAIWaypoint*) initWithLocationId:(NSString*)aLocationId withName:(NSString*)aName withAddress:(NSString*)anAddress withPosition:(CLLocationCoordinate2D)aPosition {
    self = [super init];
    if (self) {
        _locationId = aLocationId;
        _name = aName;
        _address = anAddress;
        _position = aPosition;
    }
    return self;
}

- (MAIWaypoint*) initWithJson:(NSDictionary*)data {
    self = [super init];
    if (self) {
        NSDictionary *remoteLocation = (NSDictionary*)[data objectForKey:@"Location"];
        if(remoteLocation!=(id)[NSNull null]
           && ![[remoteLocation objectForKey:@"NavigationPosition"] isKindOfClass:[NSNull class]]
           && ![[remoteLocation objectForKey:@"Address"]isKindOfClass:[NSNull class]]
           ){
            
            NSArray *remoteNavigationPositions = [remoteLocation objectForKey:@"NavigationPosition"];
            if (remoteNavigationPositions && remoteNavigationPositions.count>0) {
                NSDictionary *remoteCoords = remoteNavigationPositions.firstObject;
                NSDictionary *remoteAddress = [remoteLocation objectForKey:@"Address"];
                
                NSString *aLocationId = [remoteLocation objectForKey:@"LocationId"]!=(id)[NSNull null]?[remoteLocation objectForKey:@"LocationId"]:nil;
                NSString *aName = [remoteLocation objectForKey:@"Name"]!=(id)[NSNull null]?[remoteLocation objectForKey:@"Name"]:nil;
                NSString *anAddress = @"";
                
                if(![[remoteAddress objectForKey:@"Label"] isKindOfClass:[NSNull class]]) {
                    anAddress = [remoteAddress objectForKey:@"Label"];
                }
                
                if(remoteCoords) {
                    float aLatitude = [[remoteCoords objectForKey:@"Latitude"] floatValue];
                    float aLongitude = [[remoteCoords objectForKey:@"Longitude"] floatValue];
                    CLLocationCoordinate2D aPosition = CLLocationCoordinate2DMake(aLatitude, aLongitude);
                    
                    self = [self initWithLocationId:aLocationId withName:aName withAddress:anAddress withPosition:aPosition];
                }
            }
        }
    }
    return self;
}

- (BOOL) isEqual:(id)object{
    if(!object) {
        return NO;
    }
    
    if(![object isKindOfClass:[MAIWaypoint class]]) {
        return NO;
    }
    
    MAIWaypoint *compareObject = (MAIWaypoint*)object;
    return [self.locationId isEqualToString:compareObject.locationId];
}

#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
    MAIWaypoint *newWaypoint = [[[self class] allocWithZone:zone] init];
    if(newWaypoint) {
        [newWaypoint setLocationId:self.locationId];
        [newWaypoint setName:self.name];
        [newWaypoint setAddress:self.address];
        [newWaypoint setPosition:self.position];
    }
    return newWaypoint;
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _locationId = [decoder decodeObjectForKey:@"locationId"];
    _name = [decoder decodeObjectForKey:@"name"];
    _address = [decoder decodeObjectForKey:@"address"];
    _position = CLLocationCoordinate2DMake([decoder decodeDoubleForKey:@"latitude"], [decoder decodeDoubleForKey:@"longitude"]);
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_locationId forKey:@"locationId"];
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_address forKey:@"address"];
    [encoder encodeDouble:_position.latitude forKey:@"latitude"];
    [encoder encodeDouble:_position.longitude forKey:@"longitude"];
}


@end
