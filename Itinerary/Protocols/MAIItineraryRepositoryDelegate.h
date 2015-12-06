//
//  MAIItinerariesRepositoryDelegate.h
//  Itinerary
//
//  Created by marco attanasio on 14/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAIItineraryRepository;
@class MAIItinerary;

@protocol MAIItineraryRepositoryDelegate <NSObject>

- (void)itineraryRepositoryGetSavedItineraries:(MAIItineraryRepository *)repository
						withSuccessDataHandler:(void (^)(NSArray *items))successDataHandler
						withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler;
- (void)itineraryRepositorySaveItinerary:(MAIItineraryRepository *)repository
							   itinerary:(MAIItinerary*)anItinerary
				  withSuccessDataHandler:(void (^)(MAIItinerary *amendedItinerary))successDataHandler
				  withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler;
- (void)itineraryRepositorySaveItineraries:(MAIItineraryRepository *)repository
							   itineraries:(NSArray*)items
					withSuccessDataHandler:(void (^)(void))successDataHandler
					withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler;
- (void)itineraryRepositoryDeleteItineraries:(MAIItineraryRepository *)repository
					  withSuccessDataHandler:(void (^)(void))successDataHandler
					  withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler;

@end
