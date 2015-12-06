//
//  MAICreateItineraryViewController.m
//  Itinerary
//
//  Created by marco attanasio on 12/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIItineraryViewController.h"
#import "MAIService.h"
#import "MAIArrayDataSource.h"
#import "MAIItinerary.h"
#import "MAIWaypoint.h"
#import "MAIWaypointTableViewCell.h"
#import "MAIConfiguration.h"
#import "UITableViewCell+MAIExtra.h"
#import "NSString+MAIExtras.h"
#import "UIViewController+MAIExtras.h"

@interface MAIItineraryViewController ()

@property (nonatomic) MAIArrayDataSource *dataSource;
@property (nonatomic) MAIArrayDataSource *resultsDataSource;
@property (nonatomic) IBOutlet UIButton *mapButton;
@property (nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) IBOutlet UITextField *titleField;
@property (nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) IBOutlet UITableView *searchResultsTableView;
@property (nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation MAIItineraryViewController

static NSString * const cellIdentifier = @"WaypointCell";


#pragma mark  - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self configureUI:self.itinerary];
    
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"MAIWaypointTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.searchResultsTableView registerNib:[UINib nibWithNibName:@"MAIWaypointTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    ConfigureCellBlock configureCell = ^(MAIWaypointTableViewCell *cell, MAIWaypoint *waypoint) {
        [cell bind:waypoint withAcessoryButtonTappedBlock:nil];
    };
    
    __weak MAIItineraryViewController *weakSelf = self;
    ConfigureCellBlock configureResultCell = ^(MAIWaypointTableViewCell *cell, MAIWaypoint *waypoint) {
        __weak MAIWaypoint *weakWaypoint = waypoint;
        [cell bind:waypoint withAcessoryButtonTappedBlock:^(id sender) {
			[weakSelf itineraryDidAddWaypoint:self.itinerary waypoint:weakWaypoint withSender:sender];
        }];
    };
    DeleteCellBlock deleteCellBlock = ^(MAIWaypoint *waypoint, NSUInteger index) {
		[weakSelf itineraryDidRemoveWaypoint:self.itinerary atIndex:index];
    };
    SortCellBlock sortCellBlock = ^(MAIWaypoint *waypoint, NSUInteger fromIndex, NSUInteger toIndex) {
		[weakSelf itineraryDidMoveWaypoint:self.itinerary fromIndex:fromIndex toIndex:toIndex];
    };
    
    self.dataSource = [[MAIArrayDataSource alloc] initWithItems:self.itinerary.waypoints
                                             withCellIdentifier:cellIdentifier
                                         withConfigureCellBlock:configureCell
                                            withDeleteCellBlock:deleteCellBlock
                                                    andEditable:YES
                                              withSortCellBlock:sortCellBlock
                                                    andSortable:YES];
    self.mainTableView.dataSource = self.dataSource;
    [self.mainTableView setEditing:YES animated:YES];
    
    self.resultsDataSource = [[MAIArrayDataSource alloc] initWithItems:nil
                                                    withCellIdentifier:cellIdentifier
                                                withConfigureCellBlock:configureResultCell];
    self.searchResultsTableView.dataSource = self.resultsDataSource;
    
    [self.titleLabel setText:NSLocalizedString(@"Title", nil)];
    [self.titleField setPlaceholder:NSLocalizedString(@"Title", nil)];
    [self.infoLabel setText:NSLocalizedString(@"Search for addresses or places and add them to your itinerary", nil)];
}

#pragma mark - IBActions

- (IBAction)titleDidChange:(id)sender
{
	[_itinerary setFriendlyName:self.titleField.text];
	[self saveItinerary];
}

- (IBAction)showRoute:(id)sender
{
	[self performSegueWithIdentifier:@"Route" sender:_itinerary];
}

#pragma mark - Public
- (void)saveItinerary
{
	if([self.searchBar isFirstResponder])
	{
		[self hideSearchResults:self.searchBar];
	}
	
	if([NSString ext_IsNullOrEmpty:_itinerary.friendlyName])
	{
		[_itinerary setFriendlyName:NSLocalizedString(@"No Title", nil)];
	}
	
	[self showNetworkActivityWithMessage:@"Saving"];
	
	__weak MAIItineraryViewController *weakSelf = self;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[[MAIService sharedInstance] saveItinerary:_itinerary
							withSuccessDataHandler:^(MAIItinerary *amendedItinerary) {
								dispatch_async(dispatch_get_main_queue(), ^{
									[weakSelf setupDataSource:amendedItinerary];
									[weakSelf hideNetworkActivity];
								});
							}
							withFailureDataHandler:^(NSString *errorMessage) {
								NSLog(@"%@", errorMessage);
								dispatch_async(dispatch_get_main_queue(), ^{
									[weakSelf ext_showAlert:NSLocalizedString(@"APP_NAME", nil) withMessage:errorMessage andShowCancel:NO withOkHandler:nil withCancelHandler:nil];
									[weakSelf hideNetworkActivity];
								});
							}];
	});
}

- (void)setupDataSource:(MAIItinerary*)anItinerary
{
	[self configureUI:anItinerary];
	if(self.navigationItem.rightBarButtonItem)
	{
		[self.navigationItem.rightBarButtonItem setEnabled:(anItinerary.waypoints!=nil && anItinerary.waypoints.count>0)];
	}
	[self.dataSource setItems:anItinerary.waypoints];
	[self.mainTableView reloadData];
}

- (void)setupResultsDataSource:(NSArray*)items
{
	[self.resultsDataSource setItems:items];
	[self.searchResultsTableView reloadData];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if([segue.identifier isEqualToString:@"Route"])
	{
		[segue.destinationViewController setItinerary:(MAIItinerary*)sender];
	}
}

#pragma mark - Private

- (void)configureUI:(MAIItinerary *)anItinerary
{
    if (!anItinerary)
	{
		self.itinerary = [MAIItinerary new];
	}
	
	if([NSString ext_IsNullOrEmpty:anItinerary.friendlyName])
	{
		self.title = NSLocalizedString(@"New Itinerary", nil);
    }
    else
	{
		self.title = anItinerary.friendlyName;
		[self.titleField setText:anItinerary.friendlyName];
    }
    [self.mapButton setHidden:!anItinerary.route];
}


#pragma mark - Search Methods
- (void)hideSearchResults:(UISearchBar *)aSearchBar
{
    [aSearchBar setText:@""];
    [aSearchBar setShowsCancelButton:NO animated:YES];
    [aSearchBar resignFirstResponder];
    [self setupResultsDataSource:nil];
    [self.searchResultsTableView setHidden:YES];
    [self.mainTableView setHidden:NO];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar*)aSearchBar
{
    [aSearchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar*)aSearchBar textDidChange:(NSString *)searchText
{
    if([searchText isEqualToString:@""])
    {
        [self setupResultsDataSource:nil];
        [self.searchResultsTableView setHidden:YES];
        [self.mainTableView setHidden:NO];
    }
    else
    {
        __weak MAIItineraryViewController *weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[MAIService sharedInstance] search:searchText withDataSourceCompletionHandler:^(NSArray *items) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [weakSelf setupResultsDataSource:items];
                    [weakSelf.searchResultsTableView setHidden:NO];
                    [weakSelf.mainTableView setHidden:YES];
                });
            } withDataSourceErrorHandler:^(NSString *errorMessage) {
                //Do nothing;
                NSLog(@"%@", errorMessage);
            }];
        });
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar*)aSearchBar
{
    [self hideSearchResults:aSearchBar];
}


#pragma mark - UITableViewDelegate

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

//TODO: Cache the height in both landscape and portrait for better scrolling
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MAIWaypointTableViewCell *cell = (MAIWaypointTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    [cell ext_resizeToMatchTableWidth:tableView];
    
    MAIWaypoint *item = nil;
    
    if(tableView==self.searchResultsTableView)
	{
        item = [self.resultsDataSource itemAtIndexPath:indexPath];
    }
    else
	{
        item = [self.dataSource itemAtIndexPath:indexPath];
    }
    [cell bind:item withAcessoryButtonTappedBlock:nil];
    [cell layoutIfNeeded];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField== self.titleField)
	{
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - MAIItineraryDelegate
- (void)itineraryDidAddWaypoint:(MAIItinerary*)itinerary waypoint:(MAIWaypoint *)waypoint withSender:(id)sender
{
    NSLog(@"Waypoint selected %@", waypoint.address);
    
    [self ext_showActionSheet:self.title withOkCopy:NSLocalizedString(@"Add to itinerary", nil)
				withOkHandler:^(UIAlertAction *action){
					[itinerary addItem:waypoint];
					[self setupDataSource:itinerary];
					[self hideSearchResults:self.searchBar];
					[self saveItinerary];
				}
			withCancelHandler:nil withSender:sender];
}

- (void)itineraryDidRemoveWaypoint:(MAIItinerary*)itinerary
						   atIndex:(NSUInteger)index
{
    __weak MAIItineraryViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [itinerary removeItemAtIndex:index];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setupDataSource:itinerary];
            [weakSelf saveItinerary];
        });
    });
}

- (void)itineraryDidMoveWaypoint:(MAIItinerary*)itinerary
			  fromIndex:(NSUInteger)fromIndex
				toIndex:(NSUInteger)toIndex
{
    __weak MAIItineraryViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [itinerary moveItemAtIndex:fromIndex toIndex:toIndex];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setupDataSource:itinerary];
            [weakSelf saveItinerary];
        });
    });
}

@end
