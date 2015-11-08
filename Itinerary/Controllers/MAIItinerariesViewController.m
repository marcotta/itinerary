//
//  MAIItinerariesViewController.m
//  Itinerary
//
//  Created by marco attanasio on 12/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIItinerariesViewController.h"
#import "MAIArrayDataSource.h"
#import "MAIItinerary.h"
#import "MAIItineraryViewController.h"
#import "MAIService.h"

@interface MAIItinerariesViewController ()

@property (nonatomic) IBOutlet UITableView         *mainTableView;
@property (nonatomic) IBOutlet UIButton            *createNewItineraryButton;
@property (nonatomic)           MAIArrayDataSource  *dataSource;

@end

@implementation MAIItinerariesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *cellIdentifier = @"ItineraryCell";
    [self.mainTableView registerNib:[UINib nibWithNibName:@"MAIItineraryTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    
    ConfigureCellBlock configureCell = ^(UITableViewCell *cell, MAIItinerary *itinerary) {
        [cell.textLabel setText:itinerary.friendlyName];
    };
    self.dataSource = [[MAIArrayDataSource alloc] initWithItems:nil
                                             withCellIdentifier:cellIdentifier
                                         withConfigureCellBlock:configureCell];
    self.mainTableView.dataSource = self.dataSource;
    
    
    [self.createNewItineraryButton setTitle:NSLocalizedString(@"Create your first itinerary", nil) forState:UIControlStateNormal];
    [self setTitle:NSLocalizedString(@"My Itineraries", nil)];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onCreateItinerary:)];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    [self setupDataSource:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showNetworkActivityWithMessage:@"Loading"];
    
    __weak MAIItinerariesViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[MAIService sharedInstance] getSavedItineraries:^(NSArray *items) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [weakSelf setupDataSource:items];
                [weakSelf hideNetworkActivity];
            });
        } withFailureDataHandler:^(NSString *errorMessage) {
            //Hide spinner
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [weakSelf hideNetworkActivity];
            });
        }];
    });
}

- (void)setupDataSource:(NSArray*)items {
    [self.dataSource setItems:items];
    [self updateItineraryView];
}

- (void) updateItineraryView {
    if(self.dataSource && self.dataSource.items && self.dataSource.items.count>0) {
        [self showItineraries];
    }
    else{
        [self showCreateFirstItinerary];
    }
}

- (void) showItineraries {
    [self.createNewItineraryButton setHidden:YES];
    [self.mainTableView setHidden:NO];
    [self.mainTableView reloadData];
}

- (void) showCreateFirstItinerary {
    [self.createNewItineraryButton setHidden:NO];
    [self.mainTableView setHidden:YES];
}

- (IBAction) onCreateItinerary:(id)sender {
    [self performSegueWithIdentifier:@"Create Itinerary" sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"Itinerary"])
    {
        ((MAIItineraryViewController*)segue.destinationViewController).itinerary = (MAIItinerary*)sender;
    }
}


#pragma mark - UITableView Delegate methods

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //  Show Itinerary Details screen
    MAIItinerary *selectedItinerary = [self.dataSource.items objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"Itinerary" sender:selectedItinerary];
}

@end
