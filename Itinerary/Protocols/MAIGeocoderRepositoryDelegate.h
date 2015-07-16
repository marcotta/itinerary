//
//  MAIGeocoderRepositoryDelegate.h
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MAIGeocoderRepositoryDelegate <NSObject>


- (void) search:(NSString*)query withLanguage:(NSString*)language withSuccessDataHandler:(void (^)(NSArray *items))successDataHandler withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler;

@end
