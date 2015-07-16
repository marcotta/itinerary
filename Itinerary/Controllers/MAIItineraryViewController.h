//
//  MAIItineraryViewController.h
//  Itinerary
//
//  Created by marco attanasio on 12/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIBaseViewController.h"
#import "MAIArrayDataSource.h"
#import "MAIService.h"
#import "MAIItineraryDelegate.h"
#import "MAIItinerary.h"

@interface MAIItineraryViewController : MAIBaseViewController<UITableViewDelegate, MAIItineraryDelegate, UITextFieldDelegate>{

}

@property (nonatomic)           MAIItinerary         *itinerary;

@property (nonatomic)           MAIArrayDataSource   *dataSource;
@property (nonatomic)           MAIArrayDataSource   *resultsDataSource;

@property (nonatomic) IBOutlet  UIButton             *mapButton;

@property (nonatomic) IBOutlet  UILabel              *titleLabel;
@property (nonatomic) IBOutlet  UITextField          *titleField;
@property (nonatomic) IBOutlet  UILabel              *infoLabel;
@property (nonatomic) IBOutlet  UISearchBar          *searchBar;
@property (nonatomic) IBOutlet  UITableView          *searchResultsTableView;
@property (nonatomic) IBOutlet  UITableView          *mainTableView;


- (void)setupDataSource:(MAIItinerary*)anItinerary;
- (void)setupResultsDataSource:(NSArray*)items;


- (IBAction) titleDidChange:(id)sender;
- (IBAction) showRoute:(id)sender;
- (void) saveItinerary;
@end
