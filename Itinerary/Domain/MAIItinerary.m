//
//  MAIItinerary.m
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIItinerary.h"
#import "MAIWaypoint.h"

#import "NSString+MAIExtras.h"

@interface MAIItinerary()

@property (copy, nonatomic, readwrite) NSString *itineraryId;

@end

@implementation MAIItinerary

static dispatch_queue_t _queue;

+ (void)initialize
{
    _queue = dispatch_queue_create("com.marcoattanasio.itinerary", DISPATCH_QUEUE_CONCURRENT);
}

- (instancetype)init
{
	return [self initWithItineraryId:[NSString ext_GetGUID]];
}

- (instancetype)initWithItineraryId:(NSString *)itineraryId
{
	self = [super init];
	if (self)
	{
		_itineraryId = itineraryId;
		_waypoints = [[NSMutableArray alloc] initWithCapacity:0];
	}
	return self;
}

- (void)generateItineraryId
{
	if ([NSString ext_IsNullOrEmpty:self.itineraryId])
	{
		self.itineraryId = [NSString ext_GetGUID];
	}
}

- (NSMutableArray*)waypoints
{
    __block id obj = nil;
    dispatch_sync(_queue, ^{
        obj = _waypoints;
    });
    return obj;
}

- (void)addItem:(MAIWaypoint *)waypoint
{
    dispatch_barrier_async(_queue, ^{
        [_waypoints addObject:[waypoint copy]];
    });
}

- (void)removeItemAtIndex:(NSUInteger)index
{
    dispatch_barrier_async(_queue, ^{
        if(index<_waypoints.count)
		{
            [_waypoints removeObjectAtIndex:index];
        }
    });
}

- (void)moveItemAtIndex:(NSUInteger)sourceIndex
                toIndex:(NSUInteger)destinationIndex
{
    dispatch_barrier_async(_queue, ^{
        if(sourceIndex<_waypoints.count)
		{
            MAIWaypoint *waypoint = [[_waypoints objectAtIndex:sourceIndex] copy];
            [_waypoints removeObjectAtIndex:sourceIndex];
            if(destinationIndex<_waypoints.count)
			{
                [_waypoints insertObject:waypoint atIndex:destinationIndex];
            }
            else
			{
                [_waypoints addObject:waypoint];
            }
        }
    });
}

#pragma mark NSCopying
- (instancetype)copyWithZone:(NSZone *)zone
{
    MAIItinerary *newItinerary = [[[self class] allocWithZone:zone] init];
    if(newItinerary)
	{
        [newItinerary setItineraryId:self.itineraryId];
        [newItinerary setFriendlyName:self.friendlyName];
        //AddItem takes care of making a copy of the waypoint
        for(MAIWaypoint *waypoint in self.waypoints)
		{
            [newItinerary addItem:waypoint];
        }
    }
    return newItinerary;
}

- (BOOL)isEqual:(id)object
{
    if(!object)
	{
        return NO;
    }
    
    if(![object isKindOfClass:[MAIItinerary class]])
	{
        return NO;
    }
    
    MAIItinerary *compareObject = (MAIItinerary*)object;
    return [self.itineraryId isEqualToString:compareObject.itineraryId];
}

#pragma mark NSCoding
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (!self)
	{
        return nil;
    }
    
    dispatch_sync(_queue, ^{
        _itineraryId = [decoder decodeObjectForKey:@"itineraryId"];
        _friendlyName = [decoder decodeObjectForKey:@"friendlyName"];
        _waypoints = [decoder decodeObjectForKey:@"waypoints"];
        _route  = [decoder decodeObjectForKey:@"route"];
    });
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Make sure it always has an id
    if([NSString ext_IsNullOrEmpty:_itineraryId])
	{
        _itineraryId = [NSString ext_GetGUID];
    }
    dispatch_sync(_queue, ^{
        [encoder encodeObject:_itineraryId forKey:@"itineraryId"];
        [encoder encodeObject:_friendlyName forKey:@"friendlyName"];
        [encoder encodeObject:_waypoints forKey:@"waypoints"];
        [encoder encodeObject:_route forKey:@"route"];
    });
}

@end
