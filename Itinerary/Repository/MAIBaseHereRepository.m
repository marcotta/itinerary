//
//  MAIBaseHereRepository.m
//  Itinerary
//
//  Created by marco attanasio on 16/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIBaseHereRepository.h"
#import "AFHTTPRequestOperationManager.h"

@implementation MAIBaseHereRepository

//TODO: This should be expanded to managed the various types of errors reported from the API
//ApplicationError | SystemError | PermissionError
- (NSString *)parseErrorMessage:(AFHTTPRequestOperation *)operation
					  withError:(NSError*)error
{
	if(operation &&
	   operation.responseObject &&
	   [operation.responseObject isKindOfClass:[NSDictionary class]] &&
	   operation.responseObject[@"details"] &&
	   ![operation.responseObject[@"details"] isKindOfClass:[NSNull class]]
	   )
	{
		NSMutableString *errorMessage = [[NSMutableString alloc] initWithString:operation.responseObject[@"details"]];
		if(operation.responseObject[@"additionalData"] &&
		   ![operation.responseObject[@"additionalData"] isKindOfClass:[NSNull class]])
		{
			if([operation.responseObject[@"additionalData"] isKindOfClass:[NSArray class]])
			{
				NSDictionary *remoteError = [operation.responseObject[@"additionalData"] firstObject];
				if(remoteError[@"value"] &&
				   ![remoteError[@"value"] isKindOfClass:[NSNull class]])
				{
					errorMessage = remoteError[@"value"];
				}
			}
			else
			{
				errorMessage = operation.responseObject[@"additionalData"];
			}
		}
		//convert any error code to human readable text in Localizable.strings
		return NSLocalizedString(((NSString*)errorMessage), nil);
	}
    
    return error.localizedDescription;
}

@end
