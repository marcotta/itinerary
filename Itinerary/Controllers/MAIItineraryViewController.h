//
//  MAIItineraryViewController.h
//  Itinerary
//
//  Created by marco attanasio on 12/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIBaseViewController.h"
#import "MAIItineraryDelegate.h"

@class MAIItinerary;

@interface MAIItineraryViewController : MAIBaseViewController<UITableViewDelegate,
															 MAIItineraryDelegate,
															  UITextFieldDelegate>

@property (nonatomic) MAIItinerary *itinerary;

- (IBAction) titleDidChange:(id)sender;
- (IBAction) showRoute:(id)sender;

- (void)setupDataSource:(MAIItinerary*)anItinerary;
- (void)setupResultsDataSource:(NSArray*)items;
- (void)saveItinerary;
@end
