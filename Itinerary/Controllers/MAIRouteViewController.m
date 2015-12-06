//
//  MAIRouteViewController.m
//  Itinerary
//
//  Created by marco attanasio on 15/07/2015.
//  Copyright (c) 2015 Marco Attanasio. All rights reserved.
//

#import "MAIRouteViewController.h"
#import "MAIService.h"
#import "MAIConfiguration.h"
#import "MAIAnnotation.h"
#import "MAIItinerary.h"
#import "MAIRoute.h"

#import "UIViewController+MAIExtras.h"
#import "UILabel+MAIExtra.h"

@interface MAIRouteViewController ()

@property (nonatomic) MAIItinerary *itinerary;
@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) MAIRoutePolyline *routePolyline;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL userLocationFound;
@property (nonatomic) IBOutlet UILabel *summaryLabel;

@end

@implementation MAIRouteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLocationManager:[[CLLocationManager alloc] init]];
    
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
	{
        [self.mapView setShowsUserLocation:NO];
        [self.locationManager setDelegate:self];
        [self.locationManager requestWhenInUseAuthorization];
    }
    else
	{
        [self.mapView setShowsUserLocation:YES];
    }
    
    [self setTitle:NSLocalizedString(@"Route", nil)];
    if(self.itinerary && self.itinerary.route && self.itinerary.route.summary)
	{
        [self.summaryLabel ext_setFomattedText:self.itinerary.route.summary];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.routePolyline)
	{
        if(self.itinerary && self.itinerary.route)
		{
            [self showNetworkActivityWithMessage:@"Calculating..."];
            __weak MAIRouteViewController *weakSelf = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[MAIService sharedInstance] getRoute:self.itinerary.route
							   withSuccessDataHandler:^(MAIRoutePolyline *routePolyline) {
									dispatch_async(dispatch_get_main_queue(), ^{
										[weakSelf setRoutePolyline:routePolyline];
										[weakSelf updateMap];
										[weakSelf hideNetworkActivity];
									});
								}
							   withFailureDataHandler:^(NSString *errorMessage) {
									dispatch_async(dispatch_get_main_queue(), ^{
										[weakSelf ext_showAlert:NSLocalizedString(@"APP_NAME", nil) withMessage:errorMessage andShowCancel:NO withOkHandler:nil withCancelHandler:nil];
										[weakSelf hideNetworkActivity];
									});
								}];
            });
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted)
	{
        // permission denied
        [self.mapView setShowsUserLocation:NO];
    }
    else if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways)
	{
        // permission granted
        [self.mapView setShowsUserLocation:YES];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //Update the user location only the first time
    //comment out this code if we want to update the user location on the movement and call updatemap all the times
    if(userLocation && userLocation.location && !_userLocationFound) {
        [self updateMap];
    }
}

#pragma mark - MAP -
- (void)updateMap
{
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    //Add Waypoints Markers with callout
    for(MAIWaypoint *waypoint in self.itinerary.waypoints)
    {
        MAIAnnotation * annotation = [[MAIAnnotation alloc] initWithWaypoint:waypoint];
        [self.mapView addAnnotation:annotation];
    }
    
    if(self.routePolyline)
	{
        //Add polyline as an overlay
        if(self.routePolyline.polyline)
		{
            [self.mapView addOverlay:self.routePolyline.polyline level:MKOverlayLevelAboveRoads];
        }
        
        CLLocationCoordinate2D topLeft = self.routePolyline.topLeft;
        CLLocationCoordinate2D bottomRight = self.routePolyline.bottomRight;
        
        //Update region to show user location
        if(self.mapView.showsUserLocation && self.mapView.userLocation && self.mapView.userLocation.location)
		{
            [self setUserLocationFound:YES];
            topLeft = CLLocationCoordinate2DMake(fmax(topLeft.latitude, self.mapView.userLocation.coordinate.latitude), fmin(topLeft.longitude, self.mapView.userLocation.coordinate.longitude));
            bottomRight = CLLocationCoordinate2DMake(fmin(bottomRight.latitude, self.mapView.userLocation.coordinate.latitude), fmax(bottomRight.longitude, self.mapView.userLocation.coordinate.longitude));
            
        }
        
        //Center region
        MKCoordinateRegion region;
        region.center.latitude = topLeft.latitude - (topLeft.latitude - bottomRight.latitude) * 0.5;
        region.center.longitude = topLeft.longitude + (bottomRight.longitude - topLeft.longitude) * 0.5;
        region.span.latitudeDelta = fabs(topLeft.latitude - bottomRight.latitude) * 1.1; // Add a little extra space on the sides
        region.span.longitudeDelta = fabs(bottomRight.longitude - topLeft.longitude) * 1.1; // Add a little extra space on the sides
        
        region = [self.mapView regionThatFits:region];
        [self.mapView setRegion:region animated:YES];
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView *routeLineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    
    routeLineView.fillColor = [UIColor blueColor];
    routeLineView.lineCap = kCGLineCapRound;
    routeLineView.lineJoin = kCGLineJoinRound;
    
    routeLineView.strokeColor = [UIColor blueColor];
    routeLineView.lineWidth = 5.0f;
    
    return routeLineView;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
	{
		return nil;
	}
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if(!annotationView)
	{
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
    }
    annotationView.image = [UIImage imageNamed:@"Marker"];
    annotationView.annotation = annotation;
    annotationView.draggable=NO;
    annotationView.canShowCallout = YES;
    return annotationView;
}

// UIAlertController has a leak on ios8 of 48 bytes
// http://www.openradar.appspot.com/20021758
- (IBAction)showOptions:(id)sender
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
	if([UIAlertController class])
	{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Options", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        //        //Car
        //        UIAlertAction *carModeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Route by car",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //            //Calculate route by car and set viewmode property
        //        }];
        //        [alert addAction:carModeAction];
        //
        //
        //        //Public transport
        //        UIAlertAction *publicTransportModeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Route by public transport",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //            //Calculate route by public transport and set viewmode property
        //        }];
        //        [alert addAction:publicTransportModeAction];
        //
        //        //Walk
        //        UIAlertAction *walkModeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Route by walk",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //            //Calculate route by public transport and set viewmode property
        //        }];
        //        [alert addAction:walkModeAction];
        
        //My location
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways)
		{
            if(self.mapView.showsUserLocation)
			{
                //Hide my location
                UIAlertAction *hideLocationAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Hide my location",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self.mapView setShowsUserLocation:NO];
                    [self updateMap];
                }];
                [alert addAction:hideLocationAction];
            }
            else
			{
                //Show my location
                UIAlertAction *showLocationAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Show my location",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self.mapView setShowsUserLocation:YES];
                    [self updateMap];
                }];
                [alert addAction:showLocationAction];
            }
        }
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel
                                                             handler:nil];
        [alert addAction:cancelAction];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
            if(sender)
			{
                alert.popoverPresentationController.sourceView = sender;
            }
            else
			{
                //Not attached to any control
                alert.popoverPresentationController.sourceView = self.view;
                //center it
                alert.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0);
            }
        }
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
