//
//  MAISearchTests.m
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MAIService.h"
#import "MAIItinerary.h"
#import "MAIWaypoint.h"
#import "MAIRoute.h"
#import "MAIRoutePolyline.h"

#import "NSString+MAIExtras.h"

@interface MAIServiceTests : XCTestCase

@property (nonatomic) NSMutableArray *itineraries;

@end

@implementation MAIServiceTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _itineraries = [[NSMutableArray alloc] initWithCapacity:0];
    
    MAIItinerary *anItinerary = [[MAIItinerary alloc] init];
    [anItinerary setFriendlyName:@"Test"];
    [anItinerary addItem:[[MAIWaypoint alloc]
						  initWithLocationId:@"LocationId"
						  withName:@"Test"
						  withAddress:@"Address"
						  withPosition:CLLocationCoordinate2DMake(0, 0)]];
    [_itineraries addObject:anItinerary];
    
    [[MAIService sharedInstance] saveItineraries:_itineraries
						  withSuccessDataHandler:nil
						  withFailureDataHandler:nil];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [[MAIService sharedInstance] deleteItineraries:nil withFailureDataHandler:nil];
    [super tearDown];
}

#pragma mark - Geocoder
- (void)DISABLED_testSearchAddresses
{
    //Make sure service can return results and api call are correctly built
    XCTestExpectation *expectation = [self expectationWithDescription:@"Search Addresses"];
   
    [[MAIService sharedInstance] search:@"200 Randolph Street, Chicago"
		withDataSourceCompletionHandler:^(NSArray* items){
				XCTAssert(items.count>0);
				[expectation fulfill];
			}
			 withDataSourceErrorHandler:^(NSString* errorMessage){
				XCTFail(@"%@", errorMessage);
				[expectation fulfill];
			}];
	
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Timeout Error:%@", error);
        }
    }];
}

- (void)DISABLED_testSearchPlaces
{
    // This is an example of a functional test case.
    //Make sure service can return results and api call are correctly built
    XCTestExpectation *expectation = [self expectationWithDescription:@"Search Places"];
    
    [[MAIService sharedInstance] search:@"Eiffel Tower"
		withDataSourceCompletionHandler:^(NSArray* items){
				XCTAssert(items.count>0);
				[expectation fulfill];
			}
			 withDataSourceErrorHandler:^(NSString* errorMessage){
				XCTFail(@"%@", errorMessage);
				[expectation fulfill];
			}];
	
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Timeout Error:%@", error);
        }
    }];
}

#pragma mark - Itinerary
- (void)DISABLED_testGetItineraries
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Find saved itineraries"];
    
    [[MAIService sharedInstance] getSavedItineraries:^(NSArray *items)
								{
									XCTAssertTrue(items.count==1);
									[expectation fulfill];
								}
							  withFailureDataHandler:^(NSString *errorMessage) {
									XCTFail(@"%@", errorMessage);
									[expectation fulfill];
								}];
	
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Timeout Error:%@", error);
        }
    }];
}

- (void)DISABLED_testSaveNewItinerary
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Save New Itinerary"];
    
    MAIItinerary *anItinerary = [[MAIItinerary alloc] init];
    [anItinerary setFriendlyName:@"Test Add"];
    [anItinerary addItem:[[MAIWaypoint alloc] initWithLocationId:@"LocationId" withName:@"Test" withAddress:@"Address" withPosition:CLLocationCoordinate2DMake(0, 0)]];
    
    [[MAIService sharedInstance] saveItinerary:anItinerary
						withSuccessDataHandler:^(MAIItinerary *amendedItinerary)
						{
							XCTAssertFalse([amendedItinerary.itineraryId isEqualToString:@""]);
							[expectation fulfill];
						}
						withFailureDataHandler:^(NSString *errorMessage) {
							XCTFail(@"%@", errorMessage);
							[expectation fulfill];
						}];
	
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Timeout Error:%@", error);
        }
    }];
}

- (void)DISABLED_testSaveExistingItinerary
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Save Existing Itinerary"];
    
    MAIItinerary *anItinerary = [[MAIItinerary alloc] init];
    [anItinerary setFriendlyName:@"Test Add"];
    [anItinerary addItem:[[MAIWaypoint alloc] initWithLocationId:@"LocationId" withName:@"Test" withAddress:@"Address" withPosition:CLLocationCoordinate2DMake(0, 0)]];
    
    [[MAIService sharedInstance] saveItinerary:anItinerary
						withSuccessDataHandler:^(MAIItinerary *amendedItinerary){
							XCTAssertTrue([amendedItinerary.itineraryId isEqualToString:anItinerary.itineraryId]);
							[expectation fulfill];
						}
						withFailureDataHandler:^(NSString *errorMessage) {
							XCTFail(@"%@", errorMessage);
							[expectation fulfill];
						}];
	
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Timeout Error:%@", error);
        }
    }];
}

- (void)DISABLED_testSaveItineraries
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Save itineraries"];
   
    MAIItinerary *anItinerary = [[MAIItinerary alloc] init];
    [anItinerary setFriendlyName:@"Test Add"];
    [anItinerary addItem:[[MAIWaypoint alloc] initWithLocationId:@"LocationId" withName:@"Test" withAddress:@"Address" withPosition:CLLocationCoordinate2DMake(0, 0)]];
    [_itineraries addObject:anItinerary];
    
    [[MAIService sharedInstance] saveItineraries:_itineraries
						  withSuccessDataHandler:^void{
								[expectation fulfill];
							}
						  withFailureDataHandler:^(NSString *errorMessage) {
								XCTFail(@"%@", errorMessage);
								[expectation fulfill];
							}];
	
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Timeout Error:%@", error);
        }
    }];
}

#pragma mark - Routing
- (void)DISABLED_testCalculateRoute
{
    MAIItinerary *routeItinerary = [[MAIItinerary alloc] init];
    [routeItinerary setFriendlyName:@"European Tour"];
    MAIWaypoint *eiffelTower = [[MAIWaypoint alloc] initWithLocationId:@"NT_CuBhf2en95t66RJnfmfMEC" withName:@"Eiffel Tower" withAddress:@"75007 Paris, France" withPosition:CLLocationCoordinate2DMake(48.85824, 2.2945)];
    MAIWaypoint *bigBen = [[MAIWaypoint alloc] initWithLocationId:@"NT_34G1aWqnuHYgLPfyx5A1xB" withName:@"Big Ben" withAddress:@"Bridge Street, London, SW1A 2, United Kingdom" withPosition:CLLocationCoordinate2DMake(51.50071, -0.12456)];
    MAIWaypoint *brandenburgGate = [[MAIWaypoint alloc] initWithLocationId:@"NT_9PS2YXSuI8zc1mOgut-H0A" withName:@"Brandenburg Gate" withAddress:@"Pariser Platz, 10117 Berlin, Germany" withPosition:CLLocationCoordinate2DMake(52.5163, 13.37769)];
    [routeItinerary addItem:bigBen];
    [routeItinerary addItem:eiffelTower];
    [routeItinerary addItem:brandenburgGate];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Calculate Itinerary Route"];
    [[MAIService sharedInstance] calculateRoute:routeItinerary
						 withSuccessDataHandler:^(MAIRoute *route) {
								XCTAssertNotNil(route);
								XCTAssertNotNil(route.routeId);
								XCTAssertNotNil(route.summary);
								[expectation fulfill];
							}
						 withFailureDataHandler:^(NSString *errorMessage) {
								XCTFail(@"%@", errorMessage);
								[expectation fulfill];
							}];
	
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Timeout Error:%@", error);
        }
    }];
}

- (void)DISABLED_testGetRoute
{
    MAIRoute *route = [[MAIRoute alloc] initWithRouteId:@"AAQBCAAAAB4AAAA6AAAApAAAAFcBAAB42mMIZ2RgYmIAgrKkl/UnSuanMEDBr/ueYt/YXKwZ/v+HCHzYz4AEuID48x0vAyaGrtDmzu8+EakwmYRFoWL72O1t8Gi0bo7mZ2RgYGJgZxBgcAIKZAJxOhArADGIDzIsD8ouAuJEKD8FSS4JiEuh8jC97lC1JVB1IOArW7i8mJmBgZGFQVCBgdWBwZGBBSgs0NPOoMMI1NQgsODghiYmNqAY0E1eTEzKGxlYHIJAahiEGRj4gCoYOngcGQQEGhgFGBg4HBxAMn7JTAwCCQ4McgcYGRwYFCQCGBkCDEBKgQGgxeASwAoANTkzYXGDQBk=" withSummary:@""];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Get Route"];
    [[MAIService sharedInstance] getRoute:route
				   withSuccessDataHandler:^(MAIRoutePolyline *routePolyline) {
						XCTAssertNotNil(routePolyline);
						XCTAssertNotNil(routePolyline.polyline);
						[expectation fulfill];
					}
				   withFailureDataHandler:^(NSString *errorMessage) {
						XCTFail(@"%@", errorMessage);
						[expectation fulfill];
					}];
	
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Timeout Error:%@", error);
        }
    }];
}

@end
