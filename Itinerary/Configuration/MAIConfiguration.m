//
//  MAIConfiguration.m
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIConfiguration.h"

static NSString *_authorizationHeader;

@implementation MAIConfiguration



+ (void)initialize
{
    if (self == [MAIConfiguration class])
	{
        //Combine AppId and AppCode separated by ':'
        NSString *header = [NSString stringWithFormat:@"%@:%@", APP_ID, APP_CODE];
        //Encode using base64
        NSString *base64Header = [[header dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
        
        //Add authorization method plus space
        _authorizationHeader = [NSString stringWithFormat:@"Basic %@", base64Header];
    }
}

- (NSString*) getAuthorizationHeader
{
    return _authorizationHeader;
}

@end
