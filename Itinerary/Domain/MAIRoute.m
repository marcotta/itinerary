//
//  MAIRoute.m
//  Itinerary
//
//  Created by marco attanasio on 15/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIRoute.h"

@implementation MAIRoute

- (instancetype)initWithRouteId:(NSString*)aRouteId withSummary:(NSString*)aSummary
{
	self = [super init];
	if (self)
	{
		_routeId = aRouteId;
		_summary = aSummary;
	}
	return self;
}

- (instancetype)initWithJson:(NSDictionary*)data
{
	if(data && data!=(id)[NSNull null]
	   && ![[data objectForKey:@"routeId"] isKindOfClass:[NSNull class]]
	   )
	{
		NSString *remoteRouteId = [data objectForKey:@"routeId"];
		NSDictionary *remoteSummary = [data objectForKey:@"summary"];
		NSString *remoteSummaryDescription=@"";
		
		if(remoteSummary && ![[remoteSummary objectForKey:@"text"] isKindOfClass:[NSNull class]])
		{
			remoteSummaryDescription = [remoteSummary objectForKey:@"text"];
		}
		
		self = [self initWithRouteId:remoteRouteId withSummary:remoteSummaryDescription];
	}
	return self;
}

- (BOOL)isEqual:(id)object
{
	if(!object)
	{
		return NO;
	}
	
	if(![object isKindOfClass:[MAIRoute class]])
	{
		return NO;
	}
	
	MAIRoute *compareObject = (MAIRoute*)object;
	return [self.routeId isEqualToString:compareObject.routeId];
}

#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone
{
	return [[[self class] allocWithZone:zone] initWithRouteId:self.routeId withSummary:self.summary];
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder
{
	return [self initWithRouteId:[decoder decodeObjectForKey:@"routeId"]
					 withSummary:[decoder decodeObjectForKey:@"summary"]];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.routeId forKey:@"routeId"];
	[encoder encodeObject:self.summary forKey:@"summary"];
}

@end
