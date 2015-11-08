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

@property (nonatomic) IBOutlet  UITableView         *mainTableView;
@property (nonatomic) IBOutlet  UIButton            *createNewItineraryButton;

@end

@interface MAIItinerariesViewControllerTests : XCTestCase

@property (nonatomic) MAIItinerariesViewController *controller;

@end

@implementation MAIItinerariesViewControllerTests



- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _controller = [storyboard instantiateViewControllerWithIdentifier:@"Itineraries"];
    [_controller performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _controller = nil;
    [super tearDown];
}

- (void) testShowItineraries{
    [_controller showItineraries];
    XCTAssertFalse(_controller.mainTableView.hidden, @"Table View not visible");
    XCTAssertTrue(_controller.createNewItineraryButton.hidden, @"Create First item visible");
}

- (void) testShowCreateFirstItinerary{
    [_controller showCreateFirstItinerary];
    XCTAssertTrue(_controller.mainTableView.hidden, @"Table View visible");
    XCTAssertFalse(_controller.createNewItineraryButton.hidden, @"Create First item not visible");
}

- (void)testShowCreateNewItineraryWhenNoItinerariesSaved {
    id controllerMock = OCMPartialMock(_controller);
    [controllerMock setupDataSource:[[NSMutableArray alloc] initWithCapacity:0]];
    [controllerMock updateItineraryView];
    
    OCMVerify([controllerMock showCreateFirstItinerary]);
}

- (void)testShowItinerariesWhenAtLeastOneItineraryAvailable {
    
    NSMutableArray *itineraries = [[NSMutableArray alloc] initWithCapacity:0];
    [itineraries addObject:[[MAIItinerary alloc] init]];
    
    [_controller viewDidLoad];
    id controllerMock = OCMPartialMock(_controller);
    
    [controllerMock setupDataSource:itineraries];
    [controllerMock updateItineraryView];
    
    OCMVerify([controllerMock showItineraries]);
}

- (void) testSelectAnItinerary{
    NSMutableArray *itineraries = [[NSMutableArray alloc] initWithCapacity:0];
    [itineraries addObject:[[MAIItinerary alloc] init]];
    [_controller viewDidLoad];
    id controllerMock = OCMPartialMock(_controller);
    [controllerMock setupDataSource:itineraries];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [controllerMock tableView:_controller.mainTableView didSelectRowAtIndexPath:indexPath];
   
    OCMVerify([controllerMock performSegueWithIdentifier:@"Itinerary" sender:[OCMArg any]]);
}

- (void) testCreateNewItinerary{
    id controllerMock = OCMPartialMock(_controller);
    [controllerMock setupDataSource:nil];
    [[controllerMock createNewItineraryButton] sendActionsForControlEvents: UIControlEventTouchUpInside];
    
    OCMVerify([controllerMock performSegueWithIdentifier:@"Create Itinerary" sender:nil]);
}

@end
