//
//  MAIItinerariesRepository.m
//  Itinerary
//
//  Created by marco attanasio on 14/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIItineraryRepository.h"
#import "NSString+MAIExtras.h"
#import "MAIItinerary.h"

@implementation MAIItineraryRepository

static NSString *filePath;

+ (void)initialize
{
	if (self == [MAIItineraryRepository class])
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		filePath = [documentsDirectory stringByAppendingPathComponent: @"itineraries.plist"];
	}
}

- (void)itineraryRepositoryGetSavedItineraries:(MAIItineraryRepository *)repository
						withSuccessDataHandler:(void (^)(NSArray *))successDataHandler
						withFailureDataHandler:(void (^)(NSString *))failureDataHandler
{
	NSArray *items = [[NSArray alloc] init];
	NSString *errorMessage = @"";
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:filePath])
	{
		items = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
	}
	
	if(![NSString ext_IsNullOrEmpty:errorMessage])
	{
		if(failureDataHandler)
		{
			failureDataHandler(errorMessage);
		}
		return;
	}
	
	if (successDataHandler)
	{
		successDataHandler(items);
	}
}

- (void)itineraryRepositorySaveItineraries:(MAIItineraryRepository *)repository
							   itineraries:(NSArray *)items
					withSuccessDataHandler:(void (^)(void))successDataHandler
					withFailureDataHandler:(void (^)(NSString *))failureDataHandler
{
	
	NSString *errorMessage = @"";
	[NSKeyedArchiver archiveRootObject:items toFile:filePath];
	
	if(![NSString ext_IsNullOrEmpty:errorMessage])
	{
		if(failureDataHandler)
		{
			failureDataHandler(errorMessage);
		}
		return;
	}
	
	if (successDataHandler)
	{
		successDataHandler();
	}
}

- (void)itineraryRepositorySaveItinerary:(MAIItineraryRepository *)repository
							   itinerary:(MAIItinerary *)anItinerary
				  withSuccessDataHandler:(void (^)(MAIItinerary *))successDataHandler
				  withFailureDataHandler:(void (^)(NSString *))failureDataHandler
{
	[repository itineraryRepositoryGetSavedItineraries:repository
								withSuccessDataHandler:^(NSArray *items) {
									NSMutableArray *savedItineraries = [[NSMutableArray alloc] initWithArray:items];
									
									//If an item with the same id already exists remove the item
									NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(itineraryId==%@)", anItinerary.itineraryId];
									NSArray *filtered = [savedItineraries filteredArrayUsingPredicate:predicate];
									if(filtered && filtered.count>0)
									{
										[savedItineraries removeObject:(MAIItinerary*)filtered.firstObject];
									}
									//Insert at index 0 so that latest always stays at the top of the list
									[savedItineraries insertObject:anItinerary atIndex:0];
									[repository itineraryRepositorySaveItineraries:repository
																	   itineraries:savedItineraries
															withSuccessDataHandler:^{
																if (successDataHandler)
																{
																	successDataHandler(anItinerary);
																}
															} withFailureDataHandler:^(NSString *errorMessage) {
																if(failureDataHandler)
																{
																	failureDataHandler(errorMessage);
																}
															}];
								}
								withFailureDataHandler:^(NSString *errorMessage) {
									if(failureDataHandler)
									{
										failureDataHandler(errorMessage);
									}
								}];
}


- (void)itineraryRepositoryDeleteItineraries:(MAIItineraryRepository *)repository
					  withSuccessDataHandler:(void (^)(void))successDataHandler
					  withFailureDataHandler:(void (^)(NSString *))failureDataHandler
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:filePath])
	{
		NSError *error;
		[fileManager removeItemAtPath:filePath error:&error];
		
		if(error)
		{
			if(failureDataHandler)
			{
				failureDataHandler([error localizedDescription]);
			}
		}
		else if (successDataHandler)
		{
			successDataHandler();
		}
	}
	else if(failureDataHandler)
	{
		failureDataHandler(@"No items found");
	}
}

@end
