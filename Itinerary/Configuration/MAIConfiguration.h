//
//  MAIConfiguration.h
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAIConfiguration : NSObject

extern NSString * const kAppName;
extern NSString * const kAppId;
extern NSString * const kAppCode;

- (NSString*) getAuthorizationHeader;

@end
