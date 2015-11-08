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

@property (nonatomic) NSArray *items;
@property (copy, nonatomic) NSString *cellIdentifier;
@property (copy, nonatomic) ConfigureCellBlock configureCellBlock;
@property (nonatomic, copy) DeleteCellBlock deleteCellBlock;
@property (nonatomic, copy) SortCellBlock sortCellBlock;
@property (nonatomic, getter=isEditable) BOOL editable;
@property (nonatomic, getter=isSortable) BOOL sortable;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithItems:(NSArray *)anItems
		   withCellIdentifier:(NSString *)aCellIdentifier
	   withConfigureCellBlock:(ConfigureCellBlock)aConfigureCellBlock;

- (instancetype)initWithItems:(NSArray *)anItems
		   withCellIdentifier:(NSString *)aCellIdentifier
	   withConfigureCellBlock:(ConfigureCellBlock)aConfigureCellBlock
		  withDeleteCellBlock:(DeleteCellBlock)aDeleteCellBlock
				  andEditable:(BOOL)canBeEdited;

- (instancetype)initWithItems:(NSArray *)anItems
		   withCellIdentifier:(NSString *)aCellIdentifier
	   withConfigureCellBlock:(ConfigureCellBlock)aConfigureCellBlock
		  withDeleteCellBlock:(DeleteCellBlock)aDeleteCellBlock
				  andEditable:(BOOL)canBeEdited
			withSortCellBlock:(SortCellBlock)aSortCellBlock
				  andSortable:(BOOL)canBeSorted NS_DESIGNATED_INITIALIZER;

- (id)itemAtIndexPath:(NSIndexPath*)indexPath;


@end
