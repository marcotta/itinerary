//
//  MAIItinerariesViewController.h
//  Itinerary
//
//  Created by marco attanasio on 12/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIBaseViewController.h"
#import "MAIArrayDataSource.h"

@interface MAIItinerariesViewController : MAIBaseViewController<UITableViewDelegate>{

}
@property (nonatomic) IBOutlet  UITableView         *mainTableView;
@property (nonatomic) IBOutlet  UIButton            *createNewItineraryButton;

@property (nonatomic)           MAIArrayDataSource  *dataSource;


- (void) updateItineraryView;
- (IBAction) onCreateItinerary:(id)sender;

- (void) showItineraries;
- (void) showCreateFirstItinerary;
- (void) setupDataSource:(NSArray*)items;

@end
