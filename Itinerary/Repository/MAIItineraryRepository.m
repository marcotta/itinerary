//
//  MAIItinerariesRepository.m
//  Itinerary
//
//  Created by marco attanasio on 14/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIItineraryRepository.h"
#import "NSString+MAIExtras.h"

@implementation MAIItineraryRepository

static NSString *filePath;

+ (void)initialize
{
    if (self == [MAIItineraryRepository class]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        filePath = [documentsDirectory stringByAppendingPathComponent: @"itineraries.plist"];
    }
}


- (void) getSavedItineraries:(void (^)(NSArray *items))successDataHandler withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler {
    
    NSArray *items = [[NSArray alloc] init];
    NSString *errorMessage = @"";
    
    @try {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:filePath])
        {
            items = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        }
    }
    @catch (NSException *exception) {
        errorMessage = [exception description];
    }
    
    if(![NSString ext_IsNullOrEmpty:errorMessage])
    {
        if(failureDataHandler)
        {
            failureDataHandler(errorMessage);
        }
        return;
    }
    
    if (successDataHandler) {
        successDataHandler(items);
    }
}

- (void) saveItineraries:(NSArray*)items withSuccessDataHandler:(void (^)(void))successDataHandler withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler {
    
    NSString *errorMessage = @"";
    @try {
        [NSKeyedArchiver archiveRootObject:items toFile:filePath];
    }
    @catch (NSException *exception) {
        errorMessage = [exception description];
    }
    
    if(![NSString ext_IsNullOrEmpty:errorMessage])
    {
        if(failureDataHandler)
        {
            failureDataHandler(errorMessage);
        }
        return;
    }
    
    if (successDataHandler) {
        successDataHandler();
    }
}

- (void) saveItinerary:(MAIItinerary*)anItinerary withSuccessDataHandler:(void (^)(MAIItinerary *amendedItinerary))successDataHandler withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler {
    [self getSavedItineraries:^(NSArray *items) {
        NSMutableArray *savedItineraries = [[NSMutableArray alloc] initWithArray:items];
        
        if ([NSString ext_IsNullOrEmpty:anItinerary.itineraryId]) {
            //New itinerary and we need to assign an ID
            [anItinerary setItineraryId:[NSString ext_GetGUID]];
        }
        else{
            //If an item with the same id already exists remove the item
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(itineraryId==%@)", anItinerary.itineraryId];
            NSArray *filtered = [savedItineraries filteredArrayUsingPredicate:predicate];
            if(filtered && filtered.count>0) {
                [savedItineraries removeObject:(MAIItinerary*)filtered.firstObject];
            }
        }
        //Insert at index 0 so that latest always stays at the top of the list
        [savedItineraries insertObject:anItinerary atIndex:0];
        
        [self saveItineraries:savedItineraries withSuccessDataHandler:^{
            if (successDataHandler) {
                successDataHandler(anItinerary);
            }
        } withFailureDataHandler:^(NSString *errorMessage) {
            if(failureDataHandler) {
                failureDataHandler(errorMessage);
            }
        }];
    } withFailureDataHandler:^(NSString *errorMessage) {
        if(failureDataHandler) {
            failureDataHandler(errorMessage);
        }
    }];
}

- (void) deleteItineraries:(void (^)(void))successDataHandler withFailureDataHandler:(void (^)(NSString *errorMessage))failureDataHandler {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath])
    {
        NSError *error;
        [fileManager removeItemAtPath:filePath error:&error];
        
        if(error) {
            if(failureDataHandler)
            {
                failureDataHandler([error localizedDescription]);
            }
        }
        else if (successDataHandler) {
            successDataHandler();
        }
    }
    else if(failureDataHandler) {
        failureDataHandler(@"No items found");
    }
}

@end
