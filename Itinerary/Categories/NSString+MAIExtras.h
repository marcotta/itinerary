//
//  NSString+MAIExtras.h
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MAIExtras)

+ (BOOL)ext_IsNullOrEmpty:(NSString*)obj;
+ (BOOL)ext_IsEmpty:(NSString*)obj;
+ (NSString*)ext_GetGUID;

@end
