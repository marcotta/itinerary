//
//  MAIItinerariesViewController.h
//  Itinerary
//
//  Created by marco attanasio on 12/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIBaseViewController.h"

@interface MAIItinerariesViewController : MAIBaseViewController<UITableViewDelegate>

- (void)updateItineraryView;
- (void)showItineraries;
- (void)showCreateFirstItinerary;
- (void)setupDataSource:(NSArray*)items;

@end
