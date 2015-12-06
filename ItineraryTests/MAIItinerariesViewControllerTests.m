//
//  MAIItinerariesViewControllerTests.m
//  Itinerary
//
//  Created by marco attanasio on 12/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OCMock.h"

#import "MAIItinerariesViewController.h"
#import "MAIItineraryViewController.h"
#import "MAIItinerary.h"

@interface MAIItinerariesViewController(UnderTest)

@property (nonatomic) IBOutlet  UITableView *mainTableView;
@property (nonatomic) IBOutlet  UIButton *createNewItineraryButton;

@end

@interface MAIItinerariesViewControllerTests : XCTestCase

@property (nonatomic) MAIItinerariesViewController *controller;

@end

@implementation MAIItinerariesViewControllerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.controller = [storyboard instantiateViewControllerWithIdentifier:@"Itineraries"];

	__unused UIView *controllerView = self.controller.view;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.controller = nil;
    [super tearDown];
}

- (void)testShowItineraries
{
    [self.controller showItineraries];
    XCTAssertFalse(self.controller.mainTableView.hidden, @"Table View not visible");
    XCTAssertTrue(self.controller.createNewItineraryButton.hidden, @"Create First item visible");
}

- (void)testShowCreateFirstItinerary
{
    [self.controller showCreateFirstItinerary];
    XCTAssertTrue(self.controller.mainTableView.hidden, @"Table View visible");
    XCTAssertFalse(self.controller.createNewItineraryButton.hidden, @"Create First item not visible");
}

- (void)testShowCreateNewItineraryWhenNoItinerariesSaved
{
    id controllerMock = OCMPartialMock(self.controller);
    [controllerMock setupDataSource:[[NSMutableArray alloc] initWithCapacity:0]];
    [controllerMock updateItineraryView];
    
    OCMVerify([controllerMock showCreateFirstItinerary]);
}

- (void)testShowItinerariesWhenAtLeastOneItineraryAvailable
{
    NSMutableArray *itineraries = [[NSMutableArray alloc] initWithCapacity:0];
    [itineraries addObject:[[MAIItinerary alloc] init]];
    
    id controllerMock = OCMPartialMock(self.controller);
    
    [controllerMock setupDataSource:itineraries];
    [controllerMock updateItineraryView];
    
    OCMVerify([controllerMock showItineraries]);
}

- (void)testSelectAnItinerary
{
    NSMutableArray *itineraries = [[NSMutableArray alloc] initWithCapacity:0];
    [itineraries addObject:[[MAIItinerary alloc] init]];
    id controllerMock = OCMPartialMock(self.controller);
    [controllerMock setupDataSource:itineraries];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [controllerMock tableView:self.controller.mainTableView didSelectRowAtIndexPath:indexPath];
   
    OCMVerify([controllerMock performSegueWithIdentifier:@"Itinerary" sender:[OCMArg any]]);
}

- (void)testCreateNewItinerary
{
    id controllerMock = OCMPartialMock(self.controller);
    [controllerMock setupDataSource:nil];
    [[controllerMock createNewItineraryButton] sendActionsForControlEvents: UIControlEventTouchUpInside];
    
    OCMVerify([controllerMock performSegueWithIdentifier:@"Create Itinerary" sender:nil]);
}

@end
