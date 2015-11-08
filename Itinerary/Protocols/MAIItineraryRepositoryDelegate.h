//
//  MAIItinerariesRepositoryDelegate.h
//  Itinerary
//
//  Created by marco attanasio on 14/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAIItinerary.h"

@protocol MAIItineraryRepositoryDelegate <NSObject>

- (void)getSavedItineraries:(void (^)(NSArray *items))successDataHandler withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler;
- (void)saveItinerary:(MAIItinerary*)anItinerary withSuccessDataHandler:(void (^)(MAIItinerary *amendedItinerary))successDataHandler withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler;
- (void)saveItineraries:(NSArray*)items withSuccessDataHandler:(void (^)(void))successDataHandler withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler;
- (void)deleteItineraries:(void (^)(void))successDataHandler withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler;

@end
