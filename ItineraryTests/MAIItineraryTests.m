//
//  MAIItineraryTests.m
//  Itinerary
//
//  Created by marco attanasio on 11/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MAIItinerary.h"
#import "MAIWaypoint.h"

@interface MAIItineraryTests : XCTestCase

@property (nonatomic) MAIItinerary *existingItinerary;
@property (nonatomic) MAIWaypoint *waypoint;

@end

@implementation MAIItineraryTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _existingItinerary = [[MAIItinerary alloc] init];
    _waypoint = [[MAIWaypoint alloc] initWithLocationId:@"test" withName:@"Eiffel Tower" withAddress:@"some address" withPosition:CLLocationCoordinate2DMake(0, 0)];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _existingItinerary = nil;
    [super tearDown];
}

- (void)testAddWaypointToItineary
{
    NSInteger numberOfItemsBeforeAddition = _existingItinerary.waypoints.count;
    [_existingItinerary addItem:_waypoint];
    NSInteger numberOfItemsAfterAddition = _existingItinerary.waypoints.count;
    XCTAssertEqual(numberOfItemsBeforeAddition+1, numberOfItemsAfterAddition, @"Waypoint list wrong size");
}

- (void)testRemoveWaypointFromItineary
{
    //Add one item that can be removed
    [_existingItinerary addItem:_waypoint];
    
    NSInteger numberOfItemsBeforeRemoving = _existingItinerary.waypoints.count;
    [_existingItinerary removeItemAtIndex:0];
    NSInteger numberOfItemsAfterRemoving = _existingItinerary.waypoints.count;
    XCTAssertEqual(numberOfItemsBeforeRemoving-1, numberOfItemsAfterRemoving, @"Waypoint list wrong size");
}

- (void)testRemoveWaypointThatDoesNotExistInItineary
{
    NSInteger numberOfItemsBeforeRemoving = _existingItinerary.waypoints.count;
    [_existingItinerary removeItemAtIndex:10];
    NSInteger numberOfItemsAfterRemoving = _existingItinerary.waypoints.count;
    XCTAssertEqual(numberOfItemsBeforeRemoving, numberOfItemsAfterRemoving, @"Waypoint list wrong size");
}

- (void)testChangeWaypointOrderInItineary
{
    //Add one item that can be removed
    MAIWaypoint *itemToBeMoved = [[MAIWaypoint alloc] initWithLocationId:@"To be moved" withName:@"To be moved" withAddress:@"To be moved" withPosition:CLLocationCoordinate2DMake(0, 0)];
    [_existingItinerary addItem:itemToBeMoved];
    [_existingItinerary addItem:_waypoint];
    [_existingItinerary addItem:_waypoint];
    [_existingItinerary addItem:_waypoint];
   
    [_existingItinerary moveItemAtIndex:0 toIndex:3];
    
    MAIWaypoint *itemAtIndex3 = [_existingItinerary.waypoints objectAtIndex:3];
    
    XCTAssertTrue([itemAtIndex3.name isEqualToString:@"To be moved"], @"Waypoint wrong positiong");
}

- (void)testMoveWaypointOutOfBoundary
{
    //Add one item that can be removed
    MAIWaypoint *itemToBeMoved = [[MAIWaypoint alloc] initWithLocationId:@"To be moved" withName:@"To be moved" withAddress:@"To be moved" withPosition:CLLocationCoordinate2DMake(0, 0)];
    [_existingItinerary addItem:itemToBeMoved];
    [_existingItinerary addItem:_waypoint];
    [_existingItinerary addItem:_waypoint];
    [_existingItinerary addItem:_waypoint];
    
    [_existingItinerary moveItemAtIndex:0 toIndex:_existingItinerary.waypoints.count+1];
    
    MAIWaypoint *lastItem = [_existingItinerary.waypoints lastObject];
    
    XCTAssertTrue([lastItem.name isEqualToString:@"To be moved"], @"Waypoint wrong positiong");
}

- (void)testTryMovingWaypointThatDoesNotExistInItinerary
{
    [_existingItinerary addItem:_waypoint];
    [_existingItinerary addItem:_waypoint];
    [_existingItinerary addItem:_waypoint];
    
    NSInteger numberOfItemsBeforeMoving = _existingItinerary.waypoints.count;
    [_existingItinerary moveItemAtIndex:_existingItinerary.waypoints.count+1 toIndex:0];
    NSInteger numberOfItemsAfterMoving = _existingItinerary.waypoints.count;
    
    XCTAssertEqual(numberOfItemsBeforeMoving, numberOfItemsAfterMoving, @"Waypoint wrong size");
}

@end
