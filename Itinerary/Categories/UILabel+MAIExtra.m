//
//  UILabel+MAIExtra.m
//  Itinerary
//
//  Created by marco attanasio on 16/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "UILabel+MAIExtra.h"

@implementation UILabel (MAIExtra)


- (void)ext_setFomattedText:(NSString*)htmlText
{
    if([self respondsToSelector:@selector(setAttributedText:)])
	{
		NSString *html = [NSString stringWithFormat:@"<html><head><style type=\"text/css\">body"
						  @"{padding:0, margin:0; font-size: %lipx; font-family:Helvetica; color: #595959; }"
						  @"span { font-weight:bold; } </style></head><body>%@</body></html>",
						  (long)[self.font pointSize], htmlText];
        NSError *err = nil;
		NSMutableAttributedString *formattedText =
		[[NSMutableAttributedString alloc]
		 initWithData: [html dataUsingEncoding:NSUTF8StringEncoding]
		 options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding) }
		 documentAttributes: nil
		 error: &err];
		if(err)
		{
			[self setText:htmlText];
		}
        else
		{
            [self setAttributedText:formattedText];
        }
    }
    else
	{
        [self setText:htmlText];
    }
}

@end
