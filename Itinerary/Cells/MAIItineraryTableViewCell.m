//
//  MAIItineraryTableViewCell.m
//  Itinerary
//
//  Created by marco attanasio on 14/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIItineraryTableViewCell.h"

@implementation MAIItineraryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void) layoutSubviews {
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    if([self.headerLabel respondsToSelector:@selector(setPreferredMaxLayoutWidth:)]) {
        [self.headerLabel setPreferredMaxLayoutWidth:(self.contentView.frame.size.width - (self.leftMargin.constant+self.rightMargin.constant))];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) prepareForReuse{
    [self.headerLabel setText:@""];
}

- (void) bind:(MAIItinerary*)anItinerary {
    [self.headerLabel setText:anItinerary.friendlyName];
}



@end