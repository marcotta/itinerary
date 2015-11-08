//
//  MAIArrayDataSource.h
//  Itinerary
//
//  Created by marco attanasio on 12/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ConfigureCellBlock)(id cell, id item);
typedef void (^DeleteCellBlock)(NSUInteger index);
typedef void (^SortCellBlock)(NSUInteger sourceIndex, NSUInteger destinationIndex);

@interface MAIArrayDataSource : NSObject<UITableViewDataSource>

@property (nonatomic)       NSArray                     *items;
@property (copy, nonatomic) NSString                    *cellIdentifier;
@property (copy, nonatomic) ConfigureCellBlock configureCellBlock;
@property (nonatomic, copy) DeleteCellBlock deleteCellBlock;
@property (nonatomic, copy) SortCellBlock sortCellBlock;
@property (nonatomic, getter=isEditable)       BOOL editable;
@property (nonatomic, getter=isSortable)       BOOL sortable;

- (id)initWithItems:(NSArray *)anItems
 withCellIdentifier:(NSString *)aCellIdentifier
withConfigureCellBlock:(ConfigureCellBlock)aConfigureCellBlock;

- (id)initWithItems:(NSArray *)anItems
 withCellIdentifier:(NSString *)aCellIdentifier
withConfigureCellBlock:(ConfigureCellBlock)aConfigureCellBlock
withDeleteCellBlock:(DeleteCellBlock)aDeleteCellBlock
        andEditable:(BOOL)canBeEdited;

- (id)initWithItems:(NSArray *)anItems
 withCellIdentifier:(NSString *)aCellIdentifier
withConfigureCellBlock:(ConfigureCellBlock)aConfigureCellBlock
withDeleteCellBlock:(DeleteCellBlock)aDeleteCellBlock
        andEditable:(BOOL)canBeEdited
  withSortCellBlock:(SortCellBlock)aSortCellBlock
        andSortable:(BOOL)canBeSorted;

- (id)itemAtIndexPath:(NSIndexPath*)indexPath;


@end
