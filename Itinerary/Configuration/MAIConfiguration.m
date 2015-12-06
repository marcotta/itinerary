//
//  MAIConfiguration.m
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIConfiguration.h"

NSString * const kAppName = @"Itinerary";
NSString * const kAppId = @"hu2Io86XfXzpEzF0fjH3";
NSString * const kAppCode = @"aRA5LwpVvfydJYsIN6qpMg";

static NSString * authorizationHeader;

@implementation MAIConfiguration



+ (void)initialize
{
    if (self == [MAIConfiguration class])
	{
        //Combine AppId and AppCode separated by ':'
        NSString *header = [NSString stringWithFormat:@"%@:%@", kAppId, kAppCode];
        //Encode using base64
        NSString *base64Header = [[header dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
        
        //Add authorization method plus space
        authorizationHeader = [NSString stringWithFormat:@"Basic %@", base64Header];
    }
}

- (NSString*) getAuthorizationHeader
{
    return authorizationHeader;
}

@end
