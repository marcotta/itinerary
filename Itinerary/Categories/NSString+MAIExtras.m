//
//  NSString+MAIExtras.m
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "NSString+MAIExtras.h"

@implementation NSString (MATExtras)

+ (BOOL)ext_IsNullOrEmpty:(NSString*)obj
{
	if(obj==nil)
	{
		return YES;
	}
	
	if([obj isEqual:[NSNull null]])
	{
		return YES;
	}
	
	if([self ext_IsEmpty:obj])
	{
		return YES;
	}
	
	return NO;
}

+ (BOOL)ext_IsEmpty:(NSString *)obj
{
    if([obj isEqualToString:@""])
	{
		return YES;
	}
	
    return NO;
}

+ (NSString*)ext_GetGUID
{
    return [[NSUUID UUID] UUIDString];
}

@end
