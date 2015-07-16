//
//  MAIRoute.m
//  Itinerary
//
//  Created by marco attanasio on 15/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIRoute.h"

@implementation MAIRoute

- (MAIRoute*) initWithRouteId:(NSString*)aRouteId withSummary:(NSString*)aSummary {
    self = [super init];
    if (self) {
        _routeId = aRouteId;
        _summary = aSummary;
    }
    return self;
}

- (MAIRoute*) initWithJson:(NSDictionary*)data {
    self = [super init];
    if (self) {
        if(data && data!=(id)[NSNull null]
           && ![[data objectForKey:@"routeId"] isKindOfClass:[NSNull class]]
           ) {
        
            NSString *remoteRouteId = [data objectForKey:@"routeId"];
            NSDictionary *remoteSummary = [data objectForKey:@"summary"];
            NSString *remoteSummaryDescription=@"";
            
            if(remoteSummary && ![[remoteSummary objectForKey:@"text"] isKindOfClass:[NSNull class]]) {
                remoteSummaryDescription = [remoteSummary objectForKey:@"text"];
            }
            
            self = [self initWithRouteId:remoteRouteId withSummary:remoteSummaryDescription];
        }
    }
    return self;
}

- (BOOL) isEqual:(id)object{
    if(!object) {
        return NO;
    }
    
    if(![object isKindOfClass:[MAIRoute class]]) {
        return NO;
    }
    
    MAIRoute *compareObject = (MAIRoute*)object;
    return [self.routeId isEqualToString:compareObject.routeId];
}

#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
    MAIRoute *newRoute = [[[self class] allocWithZone:zone] init];
    if(newRoute) {
        [newRoute setRouteId:self.routeId];
        [newRoute setSummary:self.summary];
    }
    return newRoute;
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _routeId = [decoder decodeObjectForKey:@"routeId"];
    _summary = [decoder decodeObjectForKey:@"summary"];
 
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_routeId forKey:@"routeId"];
    [encoder encodeObject:_summary forKey:@"summary"];
}

@end
