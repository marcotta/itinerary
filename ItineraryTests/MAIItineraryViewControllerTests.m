//
//  MAICreateItineraryViewControllerTests.m
//  Itinerary
//
//  Created by marco attanasio on 13/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OCMock.h"
#import "MAIItineraryViewController.h"
#import "NSString+MAIExtras.h"

@interface MAIItineraryViewControllerTests : XCTestCase{

}

@property (nonatomic) MAIItineraryViewController *controller;
@property (nonatomic) MAIItinerary *existingItinerary;
@property (nonatomic) MAIWaypoint *waypoint;

@end

@implementation MAIItineraryViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _controller = [storyboard instantiateViewControllerWithIdentifier:@"Itinerary"];
    [_controller performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
    _waypoint = [[MAIWaypoint alloc] initWithLocationId:@"test" withName:@"Eiffel Tower" withAddress:@"some address" withPosition:CLLocationCoordinate2DMake(0, 0)];
    
    _existingItinerary = [[MAIItinerary alloc] init];
    [_existingItinerary setFriendlyName:@"Friendly name"];
    [_existingItinerary setItineraryId:[NSString ext_GetGUID]];
    
    MAIWaypoint *eiffelTower = [[MAIWaypoint alloc] initWithLocationId:@"NT_CuBhf2en95t66RJnfmfMEC" withName:@"Eiffel Tower" withAddress:@"75007 Paris, France" withPosition:CLLocationCoordinate2DMake(48.85824, 2.2945)];
    MAIWaypoint *bigBen = [[MAIWaypoint alloc] initWithLocationId:@"NT_34G1aWqnuHYgLPfyx5A1xB" withName:@"Big Ben" withAddress:@"Bridge Street, London, SW1A 2, United Kingdom" withPosition:CLLocationCoordinate2DMake(51.50071, -0.12456)];
    MAIWaypoint *brandenburgGate = [[MAIWaypoint alloc] initWithLocationId:@"NT_9PS2YXSuI8zc1mOgut-H0A" withName:@"Brandenburg Gate" withAddress:@"Pariser Platz, 10117 Berlin, Germany" withPosition:CLLocationCoordinate2DMake(52.5163, 13.37769)];
    [_existingItinerary addItem:bigBen];
    [_existingItinerary addItem:eiffelTower];
    [_existingItinerary addItem:brandenburgGate];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _waypoint = nil;
    _existingItinerary = nil;
    _controller = nil;
    [[MAIService sharedInstance] deleteItineraries:nil withFailureDataHandler:nil];
    [super tearDown];
}

- (void) testAddWaypointToItineraryLaunchesActionSheet {
    [_controller setItinerary:_existingItinerary];
    [_controller viewDidLoad];
    
    id controllerMock = OCMPartialMock(_controller);
    [controllerMock onAddWaypoint:_waypoint withSender:nil];
 
    OCMVerify([controllerMock presentViewController:[OCMArg any] animated:YES completion:nil]);
}


- (void) testRemoveWaypointFromItinerary {
    id controllerMock = OCMPartialMock(_controller);
    [controllerMock setItinerary:_existingItinerary];
    [controllerMock viewDidLoad];
    NSUInteger waypointIndex = 0;
   
    XCTestExpectation *expectation = [self expectationWithDescription:@"Remove waypoints"];
    
    [controllerMock onRemoveWaypointAtIndex:waypointIndex];
    
    //The item will need to be removed from the itinerary
    OCMExpect([controllerMock saveItinerary]).andDo(^(NSInvocation *invocation) {
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void) testReorderWaypoints{
    id controllerMock = OCMPartialMock(_controller);
    [controllerMock setItinerary:_existingItinerary];
    [controllerMock viewDidLoad];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath* destinationIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Reorder waypoints"];
    
    [[controllerMock dataSource] tableView:[controllerMock mainTableView] moveRowAtIndexPath:indexPath toIndexPath:destinationIndexPath];

    //the items will also need to be swapped on the itinerary
    OCMExpect([controllerMock saveItinerary]).andDo(^(NSInvocation *invocation) {
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void) testCreateNewItinerary {
    [_controller viewDidLoad];
    
    XCTAssertNotNil(_controller.view, @"View not loaded");
    XCTAssertTrue([_controller.title isEqualToString:NSLocalizedString(@"New Itinerary", nil)], @"Wrong title");
    XCTAssertTrue([_controller.titleField.text isEqualToString:@""], @"Wrong title");
    XCTAssertEqual(_controller.dataSource.items.count, 0, @"Wrong number of waypoints");
    XCTAssertTrue(_controller.mapButton.hidden, @"Map Icon should be hidden in create mode");
}

- (void) testLoadExistingItinerary {
    [_controller setItinerary:_existingItinerary];
    [_controller viewDidLoad];
    
    XCTAssertNotNil(_controller.view, @"View not loaded");
    XCTAssertTrue([_controller.title isEqualToString:_existingItinerary.friendlyName], @"Wrong title");
    XCTAssertTrue([_controller.titleField.text isEqualToString:_existingItinerary.friendlyName], @"Wrong title");
    XCTAssertEqual(_controller.dataSource.items.count, _existingItinerary.waypoints.count, @"Wrong number of waypoints");
    XCTAssertTrue(_controller.mapButton.hidden == !_controller.itinerary.route, @"Map Icon should available only when there is a route");
}

@end
