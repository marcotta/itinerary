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
#import "MAIArrayDataSource.h"
#import "MAIService.h"
#import "MAIItinerary.h"
#import "MAIWaypoint.h"

#import "NSString+MAIExtras.h"

@interface MAIItineraryViewController()

@property (nonatomic) MAIArrayDataSource *dataSource;
@property (nonatomic) UITableView *mainTableView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UITextField *titleField;
@property (nonatomic) UIButton *mapButton;

@end

@interface MAIItineraryViewControllerTests : XCTestCase{

}

@property (nonatomic) MAIItineraryViewController *controller;
@property (nonatomic) MAIItinerary *existingItinerary;
@property (nonatomic) MAIWaypoint *waypoint;

@end

@implementation MAIItineraryViewControllerTests

- (void)setUp
{
    [super setUp];
    self.waypoint = [[MAIWaypoint alloc] initWithLocationId:@"test" withName:@"Eiffel Tower" withAddress:@"some address" withPosition:CLLocationCoordinate2DMake(0, 0)];
    
    self.existingItinerary = [[MAIItinerary alloc] init];
    self.existingItinerary.friendlyName = @"Friendly name";
	
    MAIWaypoint *bigBen = [[MAIWaypoint alloc] initWithLocationId:@"NT_34G1aWqnuHYgLPfyx5A1xB" withName:@"Big Ben" withAddress:@"Bridge Street, London, SW1A 2, United Kingdom" withPosition:CLLocationCoordinate2DMake(51.50071, -0.12456)];
    [self.existingItinerary addItem:bigBen];
	
	MAIWaypoint *eiffelTower = [[MAIWaypoint alloc] initWithLocationId:@"NT_CuBhf2en95t66RJnfmfMEC" withName:@"Eiffel Tower" withAddress:@"75007 Paris, France" withPosition:CLLocationCoordinate2DMake(48.85824, 2.2945)];
    [self.existingItinerary addItem:eiffelTower];
	
	MAIWaypoint *brandenburgGate = [[MAIWaypoint alloc] initWithLocationId:@"NT_9PS2YXSuI8zc1mOgut-H0A" withName:@"Brandenburg Gate" withAddress:@"Pariser Platz, 10117 Berlin, Germany" withPosition:CLLocationCoordinate2DMake(52.5163, 13.37769)];
	[self.existingItinerary addItem:brandenburgGate];
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	self.controller = [storyboard instantiateViewControllerWithIdentifier:@"Itinerary"];
	[self.controller setItinerary:self.existingItinerary];
	
	
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.waypoint = nil;
    self.existingItinerary = nil;
    self.controller = nil;
    [[MAIService sharedInstance] deleteItineraries:nil withFailureDataHandler:nil];
    [super tearDown];
}

- (void)testAddWaypointToItineraryLaunchesActionSheet
{
	[self.controller setItinerary:self.existingItinerary];
	__unused UIView *controllerView = self.controller.view;
	
    id controllerMock = OCMPartialMock(self.controller);
	[controllerMock itineraryDidAddWaypoint:self.existingItinerary waypoint:self.waypoint withSender:nil];
 
    OCMVerify([controllerMock presentViewController:[OCMArg any] animated:YES completion:nil]);
}


- (void)testRemoveWaypointFromItinerary
{
	[self.controller setItinerary:self.existingItinerary];
	__unused UIView *controllerView = self.controller.view;
	
    id controllerMock = OCMPartialMock(self.controller);
    NSUInteger waypointIndex = 0;
   
    XCTestExpectation *expectation = [self expectationWithDescription:@"Remove waypoints"];
    
	[controllerMock itineraryDidRemoveWaypoint:self.existingItinerary atIndex:waypointIndex];
    
    //The item will need to be removed from the itinerary
    OCMExpect([controllerMock saveItinerary]).andDo(^(NSInvocation *invocation) {
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testReorderWaypoints
{
	[self.controller setItinerary:self.existingItinerary];
	__unused UIView *controllerView = self.controller.view;
	
    MAIItineraryViewController *controllerMock = OCMPartialMock(self.controller);
	
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath* destinationIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Reorder waypoints"];
    
    [controllerMock.dataSource tableView:controllerMock.mainTableView
					  moveRowAtIndexPath:indexPath
							 toIndexPath:destinationIndexPath];

    //the items will also need to be swapped on the itinerary
    OCMExpect([controllerMock saveItinerary]).andDo(^(NSInvocation *invocation) {
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testCreateNewItinerary
{
	[self.controller setItinerary:[MAIItinerary new]];
	__unused UIView *controllerView = self.controller.view;
	
    XCTAssertNotNil(self.controller.view, @"View not loaded");
    XCTAssertTrue([self.controller.title isEqualToString:NSLocalizedString(@"New Itinerary", nil)], @"Wrong title");
    XCTAssertTrue([self.controller.titleField.text isEqualToString:@""], @"Wrong title");
    XCTAssertEqual(self.controller.dataSource.items.count, 0, @"Wrong number of waypoints");
    XCTAssertTrue(self.controller.mapButton.hidden, @"Map Icon should be hidden in create mode");
}

- (void)testLoadExistingItinerary
{
	[self.controller setItinerary:self.existingItinerary];
	__unused UIView *controllerView = self.controller.view;
	
	XCTAssertNotNil(self.controller.view, @"View not loaded");
	XCTAssertTrue([self.controller.title isEqualToString:self.existingItinerary.friendlyName], @"Wrong title");
	XCTAssertTrue([self.controller.titleField.text isEqualToString:self.existingItinerary.friendlyName], @"Wrong title");
	XCTAssertEqual(self.controller.dataSource.items.count, self.existingItinerary.waypoints.count, @"Wrong number of waypoints");
	XCTAssertTrue(self.controller.mapButton.hidden == !self.controller.itinerary.route, @"Map Icon should available only when there is a route");
}

@end
