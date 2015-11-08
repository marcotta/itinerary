//
//  MAIWaypointTableViewCell.m
//  Itinerary
//
//  Created by marco attanasio on 12/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIWaypointTableViewCell.h"

@interface MAIWaypointTableViewCell ()

@property (nonatomic) IBOutlet UILabel *headerLabel;
@property (nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic) IBOutlet NSLayoutConstraint *leftMargin;
@property (nonatomic) IBOutlet NSLayoutConstraint *rightMargin;
@property (copy, nonatomic)     AccessoryButtonTappedBlock onAccessoryButtonTappedBlock;

@end

@implementation MAIWaypointTableViewCell

- (void)awakeFromNib {
    // Initialization code
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [moreButton addTarget:self action:@selector(accessoryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.accessoryView = moreButton;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    if([self.headerLabel respondsToSelector:@selector(setPreferredMaxLayoutWidth:)]) {
        self.headerLabel.preferredMaxLayoutWidth = (self.contentView.frame.size.width - (self.leftMargin.constant+self.rightMargin.constant));
    }
    
    if([self.addressLabel respondsToSelector:@selector(setPreferredMaxLayoutWidth:)]) {
        self.addressLabel.preferredMaxLayoutWidth = (self.contentView.frame.size.width - (self.leftMargin.constant+self.rightMargin.constant));
    }
}

- (void)prepareForReuse {
    self.headerLabel.text = @"";
    self.addressLabel.text = @"";
    self.accessoryView.hidden = NO;
}

- (void)bind:(MAIWaypoint*)aWaypoint
withAcessoryButtonTappedBlock:(AccessoryButtonTappedBlock)addButtonBlock {
    if(addButtonBlock) {
        [self setOnAccessoryButtonTappedBlock:addButtonBlock];
    }
    else {
        self.accessoryView.hidden = YES;
    }
    self.headerLabel.text = aWaypoint.name;
    self.addressLabel.text = aWaypoint.address;
}

- (IBAction)accessoryButtonTapped:(id)sender {
    if(self.onAccessoryButtonTappedBlock) {
        self.onAccessoryButtonTappedBlock(sender);
    }
}

@end
