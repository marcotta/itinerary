//
//  MAIArrayDataSourceTests.m
//  Itinerary
//
//  Created by marco attanasio on 12/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OCMock.h"
#import "MAIArrayDataSource.h"
#import "MAIWaypoint.h"

@interface MAIArrayDataSourceTests : XCTestCase

@property (nonatomic) MAIArrayDataSource *dataSource;

@end

@implementation MAIArrayDataSourceTests

- (void)testInitializeWithParameters
{
    ConfigureCellBlock configureBlock = ^(UITableViewCell *aCell, id item){};
    id obj1 = [[MAIArrayDataSource alloc] initWithItems:@[]
                                      withCellIdentifier:@"foo"
                                  withConfigureCellBlock:configureBlock];
    
    XCTAssertNotNil(obj1, @"Pass.");
}

- (void)testInitializeWithEditableParameters
{
    ConfigureCellBlock configureBlock = ^(UITableViewCell *aCell, id item){};
    DeleteCellBlock deleteBlock = ^(MAIWaypoint *waypoint, NSUInteger index){};
    id obj1 = [[MAIArrayDataSource alloc] initWithItems:@[]
                                     withCellIdentifier:@"foo"
                                 withConfigureCellBlock:configureBlock
                                    withDeleteCellBlock:deleteBlock
                                            andEditable:YES];
    
    XCTAssertNotNil(obj1, @"Pass.");
}

- (void)testInitializeWithEditableAndSortableParameters
{
    ConfigureCellBlock configureBlock = ^(UITableViewCell *aCell, id item){};
    DeleteCellBlock deleteBlock = ^(MAIWaypoint *waypoint, NSUInteger index){};
    SortCellBlock sortBlock = ^(MAIWaypoint *waypoint, NSUInteger fromIndex, NSUInteger toIndex){};
    id obj1 = [[MAIArrayDataSource alloc] initWithItems:@[]
                                     withCellIdentifier:@"foo"
                                 withConfigureCellBlock:configureBlock
                                    withDeleteCellBlock:deleteBlock
                                            andEditable:YES
                                      withSortCellBlock:sortBlock
                                            andSortable:YES];
    
    XCTAssertNotNil(obj1, @"Pass.");
}

- (void)testCellConfiguration
{
    NSArray *items = @[@"a", @"b", @"c"];
    
    __block UITableViewCell *configuredCell = nil;
    __block id configuredObject = nil;
    
    ConfigureCellBlock block = ^(UITableViewCell *a, id b){
        configuredCell = a;
        configuredObject = b;
    };
    self.dataSource = [[MAIArrayDataSource alloc] initWithItems:items
                                            withCellIdentifier:@"foo"
                                        withConfigureCellBlock:block];
    
    id mockTableView = [OCMockObject mockForClass:[UITableView class]];
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    //Return cell on dequeueReusableCellWithIdentifier
    [[[mockTableView expect] andReturn:cell]
     dequeueReusableCellWithIdentifier:@"foo"
     forIndexPath:indexPath];
    
    id result = [self.dataSource tableView:mockTableView
                cellForRowAtIndexPath:indexPath];
    
    XCTAssertEqual(result, cell, @"Should return the dummy cell.");
    XCTAssertEqual(configuredCell, cell, @"This should have been passed to the block.");
    XCTAssertEqualObjects(configuredObject, [items objectAtIndex:indexPath.row], @"This should have been passed to the block.");
    
    [mockTableView verify];
}

- (void)testCellDeletion
{
    
    NSArray *items = @[@"a", @"b", @"c"];
    
    __block UITableViewCell *configuredCell = nil;
    __block id configuredObject = nil;
    
    __block NSInteger deletedObjectIndex = -1;
    
    
    ConfigureCellBlock configureBlock = ^(UITableViewCell *a, id b){
        configuredCell = a;
        configuredObject = b;
    };
    DeleteCellBlock deleteBlock = ^(MAIWaypoint *waypoint, NSUInteger index){
        deletedObjectIndex = (NSInteger)index;
    };
    self.dataSource = [[MAIArrayDataSource alloc] initWithItems:items
                                         withCellIdentifier:@"foo"
                                     withConfigureCellBlock:configureBlock
                                        withDeleteCellBlock:deleteBlock
                                                andEditable:YES];
    
    id mockTableView = [OCMockObject mockForClass:[UITableView class]];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    
    
    [self.dataSource tableView:mockTableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    XCTAssertEqual(deletedObjectIndex, indexPath.row, @"This should have been passed to the block.");
}

- (void)testCellSorting
{
    NSArray *items = @[@"a", @"b", @"c"];
    
    __block UITableViewCell *configuredCell = nil;
    __block id configuredObject = nil;
    
    __block NSInteger deletedObjectIndex = -1;
    
    __block NSInteger movedObjectSourceIndex = -1;
    __block NSInteger movedObjectDestinationIndex = -1;
    
    
    ConfigureCellBlock configureBlock = ^(UITableViewCell *aCell, id item){
        configuredCell = aCell;
        configuredObject = item;
    };
    DeleteCellBlock deleteBlock = ^(MAIWaypoint *waypoint, NSUInteger index){
        deletedObjectIndex = (NSInteger)index;
    };
    SortCellBlock sortBlock = ^(MAIWaypoint *waypoint, NSUInteger fromIndex, NSUInteger toIndex){
        movedObjectSourceIndex = (NSInteger)fromIndex;
        movedObjectDestinationIndex = (NSInteger)toIndex;
    };
    self.dataSource = [[MAIArrayDataSource alloc] initWithItems:items
                                         withCellIdentifier:@"foo"
                                     withConfigureCellBlock:configureBlock
                                        withDeleteCellBlock:deleteBlock
                                                andEditable:YES
                                          withSortCellBlock:sortBlock
                                                andSortable:YES];
    
    id mockTableView = [OCMockObject mockForClass:[UITableView class]];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath* destinationIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    
    [self.dataSource tableView:mockTableView moveRowAtIndexPath:indexPath toIndexPath:destinationIndexPath];
   
    XCTAssertEqual(movedObjectSourceIndex, indexPath.row, @"This should have been passed to the block.");
    XCTAssertEqual(movedObjectDestinationIndex, destinationIndexPath.row, @"This should have been passed to the block.");
}

@end
