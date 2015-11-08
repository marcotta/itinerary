//
//  MAIBaseHereRepository.m
//  Itinerary
//
//  Created by marco attanasio on 16/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIBaseHereRepository.h"

@implementation MAIBaseHereRepository

//TODO: This should be expanded to managed the various types of errors reported from the API
//ApplicationError | SystemError | PermissionError
- (NSString *)parseErrorMessage:(AFHTTPRequestOperation *)operation withError:(NSError*)error {
    if(operation &&
       operation.responseObject &&
       [operation.responseObject isKindOfClass:[NSDictionary class]] &&
       [operation.responseObject objectForKey:@"details"] &&
       ![[operation.responseObject objectForKey:@"details"] isKindOfClass:[NSNull class]]
       ) {
        NSMutableString *errorMessage = [[NSMutableString alloc] initWithString:[operation.responseObject objectForKey:@"details"]];
        if([operation.responseObject objectForKey:@"additionalData"] &&
           ![[operation.responseObject objectForKey:@"additionalData"] isKindOfClass:[NSNull class]])
        {
            if([[operation.responseObject objectForKey:@"additionalData"] isKindOfClass:[NSArray class]]) {
                NSDictionary *remoteError = [[operation.responseObject objectForKey:@"additionalData"] firstObject];
                if([remoteError objectForKey:@"value"] &&
                   ![[remoteError objectForKey:@"value"] isKindOfClass:[NSNull class]])
                {
                    errorMessage = [remoteError objectForKey:@"value"];
                }
            }
            else {
                errorMessage = [operation.responseObject objectForKey:@"additionalData"];
            }
        }
        //convert any error code to human readable text in Localizable.strings
        return NSLocalizedString(((NSString*)errorMessage), nil);
    }
    
    return error.localizedDescription;
}

@end
