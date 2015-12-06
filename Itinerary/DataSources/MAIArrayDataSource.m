//
//  MAIArrayDataSource.m
//  Itinerary
//
//  Created by marco attanasio on 12/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIArrayDataSource.h"

@implementation MAIArrayDataSource

- (instancetype)initWithItems:(NSArray *)anItems
		   withCellIdentifier:(NSString *)aCellIdentifier
	   withConfigureCellBlock:(ConfigureCellBlock)aConfigureCellBlock
		  withDeleteCellBlock:(DeleteCellBlock)aDeleteCellBlock
				  andEditable:(BOOL)canBeEdited
			withSortCellBlock:(SortCellBlock)aSortCellBlock
				  andSortable:(BOOL)canBeSorted
{
	self = [super init];
	if (self)
	{
		_items = anItems;
		_cellIdentifier = aCellIdentifier;
		_configureCellBlock = [aConfigureCellBlock copy];
		_deleteCellBlock = [aDeleteCellBlock copy];
		_editable = canBeEdited;
		_sortCellBlock =[aSortCellBlock copy];
		_sortable = canBeSorted;
	}
	return self;
}

- (instancetype)initWithItems:(NSArray *)anItems
		   withCellIdentifier:(NSString *)aCellIdentifier
	   withConfigureCellBlock:(ConfigureCellBlock)aConfigureCellBlock
{
	return [self initWithItems:anItems
			withCellIdentifier:aCellIdentifier
		withConfigureCellBlock:aConfigureCellBlock
		   withDeleteCellBlock:nil
				   andEditable:NO
			 withSortCellBlock:nil
				   andSortable:NO];
}

- (instancetype)initWithItems:(NSArray *)anItems
		   withCellIdentifier:(NSString *)aCellIdentifier
	   withConfigureCellBlock:(ConfigureCellBlock)aConfigureCellBlock
		  withDeleteCellBlock:(DeleteCellBlock)aDeleteCellBlock
				  andEditable:(BOOL)canBeEdited
{
	return [self initWithItems:anItems
			withCellIdentifier:aCellIdentifier
		withConfigureCellBlock:aConfigureCellBlock
		   withDeleteCellBlock:aDeleteCellBlock
				   andEditable:canBeEdited
			 withSortCellBlock:nil
				   andSortable:NO];
}

- (id)itemAtIndexPath:(NSIndexPath*)indexPath
{
    return [self.items objectAtIndex:(NSUInteger)indexPath.row];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    id cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    if(self.configureCellBlock)
	{
        self.configureCellBlock(cell,item);
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES if you want the specified item to be editable.
    return [self isEditable];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete && self.deleteCellBlock)
	{
        self.deleteCellBlock(self.items[indexPath.row], indexPath.row);
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self isSortable];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if(self.sortCellBlock)
	{
        self.sortCellBlock(self.items[sourceIndexPath.row], sourceIndexPath.row, destinationIndexPath.row);
    }
}

@end
