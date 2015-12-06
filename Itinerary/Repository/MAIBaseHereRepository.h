//
//  MAIBaseHereRepository.h
//  Itinerary
//
//  Created by marco attanasio on 16/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPRequestOperation;

@interface MAIBaseHereRepository : NSObject

- (NSString *)parseErrorMessage:(AFHTTPRequestOperation *)operation
					  withError:(NSError*)error;

@end
