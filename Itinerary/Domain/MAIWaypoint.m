//
//  MAILocation.m
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIWaypoint.h"

@implementation MAIWaypoint

- (instancetype)initWithLocationId:(NSString*)aLocationId
                          withName:(NSString*)aName
                       withAddress:(NSString*)anAddress
                      withPosition:(CLLocationCoordinate2D)aPosition
{
	self = [super init];
	if (self)
	{
		_locationId = aLocationId;
		_name = aName;
		_address = anAddress;
		_position = aPosition;
	}
	return self;
}

- (instancetype)initWithJson:(NSDictionary*)data
{
	
	NSDictionary *remoteLocation = (NSDictionary*)data[@"Location"];
	if(remoteLocation!=(id)[NSNull null]
	   && ![remoteLocation[@"NavigationPosition"] isKindOfClass:[NSNull class]]
	   && ![remoteLocation[@"Address"] isKindOfClass:[NSNull class]]
	   )
	{
		NSArray *remoteNavigationPositions = remoteLocation[@"NavigationPosition"];
		if (remoteNavigationPositions && remoteNavigationPositions.count>0)
		{
			NSDictionary *remoteCoords = remoteNavigationPositions.firstObject;
			NSDictionary *remoteAddress = remoteLocation[@"Address"];
			
			NSString *aLocationId = remoteLocation[@"LocationId"]!=(id)[NSNull null] ? remoteLocation[@"LocationId"] : nil;
			NSString *aName = remoteLocation[@"Name"]!=(id)[NSNull null] ? remoteLocation[@"Name"] : nil;
			NSString *anAddress = @"";
			
			if(![remoteAddress[@"Label"] isKindOfClass:[NSNull class]])
			{
				anAddress = remoteAddress[@"Label"];
			}
			
			if(remoteCoords)
			{
				float aLatitude = [remoteCoords[@"Latitude"] floatValue];
				float aLongitude = [remoteCoords[@"Longitude"] floatValue];
				CLLocationCoordinate2D aPosition = CLLocationCoordinate2DMake(aLatitude, aLongitude);
				
				return [self initWithLocationId:aLocationId
									   withName:aName
									withAddress:anAddress
								   withPosition:aPosition];
			}
		}
	}
	return self;
}

- (BOOL)isEqual:(id)object
{
    if(!object)
	{
        return NO;
    }
    
    if(![object isKindOfClass:[MAIWaypoint class]])
	{
        return NO;
    }
    
    MAIWaypoint *compareObject = (MAIWaypoint*)object;
    return [self.locationId isEqualToString:compareObject.locationId];
}

#pragma mark NSCopying
- (instancetype)copyWithZone:(NSZone *)zone
{
    MAIWaypoint *newWaypoint = [[[self class] allocWithZone:zone] initWithLocationId:self.locationId
                                                                            withName:self.name
                                                                         withAddress:self.address
                                                                        withPosition:self.position];
    return newWaypoint;
}

#pragma mark NSCoding
- (instancetype)initWithCoder:(NSCoder *)decoder
{
	return [self initWithLocationId:[decoder decodeObjectForKey:@"locationId"]
						   withName:[decoder decodeObjectForKey:@"name"]
						withAddress:[decoder decodeObjectForKey:@"address"]
					   withPosition:CLLocationCoordinate2DMake([decoder decodeDoubleForKey:@"latitude"], [decoder decodeDoubleForKey:@"longitude"])];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.locationId forKey:@"locationId"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeDouble:self.position.latitude forKey:@"latitude"];
    [encoder encodeDouble:self.position.longitude forKey:@"longitude"];
}

@end
