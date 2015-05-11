//
//  SecondViewController.m
//  MortgageCalculator
//
//  Created by mac on 4/23/15.
//  Copyright (c) 2015 edu.sjsu.cmpe277. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "SecondViewController.h"
#import "DBManager.h"
#import "PopoverViewController.h"
#import "ModifiedAnnotation.h"

@implementation SecondViewController
{
    GMSMapView *mapView_;
}
@synthesize mapView;

#define SJSULat 37.3349732
#define SJSULon -121.880756

- (void)viewDidLoad {
    // Do any additional setup after loading the view, typically from a nib.
    // Create a GMSCameraPosition that tells the map to display the coordinate xxx
    // at zoom level 6;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"propertydb.sql"];
    [self loadData];
    
    // for debug
    BOOL apple = YES;
    if (apple == YES)
    {
        CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
        self._locationManager = [[CLLocationManager alloc] init];
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        if (authStatus == kCLAuthorizationStatusAuthorizedAlways ||
            authStatus == kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            [self._locationManager requestWhenInUseAuthorization];
            [self._locationManager startUpdatingLocation];
        }
        else
        {
            [self._locationManager requestWhenInUseAuthorization];
        }
        [self.mapView setShowsUserLocation:YES];
        [self.mapView setDelegate:self];
        [self.view addSubview:self.mapView];
        [self.mapView setZoomEnabled:YES];
        [self.mapView setFrame:self.view.bounds];
        [self.mapView setAutoresizingMask: self.view.autoresizingMask];
        [self defaultLocation];
        [self listCalculatedMortage];
    }
    else
    {
        GMSCameraPosition * camera = [GMSCameraPosition cameraWithLatitude:37.3349732 longitude:-121.880756 zoom:15];
        mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        self.view = mapView_;
        
        //0:property, 1:address, 2:city, 3:state, 4:zip, 5:loan, 6:down, 7:apr, 8:terms, 9:rate, 10:latitude, 11:longitude
        for (id object in _arrPropertyInfo) {
            
            NSString *property = object[0];
            NSString *address = object[1];
            NSString *city = object[2];
            NSString *state = object[3];
            NSString *zip = object[4];
            double  loan = [object[5] doubleValue];
            double down = [object[6] doubleValue];
            double apr = [object[7] doubleValue];
            int terms = [object[8] intValue];
            double payment = [object[9] doubleValue];
            double latitude = [object[10] doubleValue];
            double longitude = [object[11] doubleValue];
            
            GMSCameraPosition * camera = [GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:15];
            
            mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
            self.view = mapView_;
            
            // Creates a maker in the center of the map.
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(latitude, longitude);
            marker.title = object[1];
            marker.snippet = [NSString stringWithFormat:@"property %@\raddress %@\rcity %@\rloan %f\rapr %f\rpayment %f", property, address, city, loan, apr, payment];
            marker.map = mapView_;
        }
        
        self.mortagePicker_popover = [[UIPopoverController alloc] init];
        self.mortagePicker_popover.delegate = self;
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:@"140 E San Carlos St, San Jose, CA 95112" completionHandler:^(NSArray *placemarks, NSError *error) {
            for (CLPlacemark * aPlacemark in placemarks) {
                NSString *latDest1 = [NSString stringWithFormat:@"%.4f", aPlacemark.location.coordinate.latitude];
                NSString *lngDest1 = [NSString stringWithFormat:@"%.4f", aPlacemark.location.coordinate.longitude];
                GMSMarker * aMarker = [[GMSMarker alloc] init];
                aMarker.position = CLLocationCoordinate2DMake([latDest1 doubleValue], [lngDest1 doubleValue]);
                aMarker.map = mapView_;
                
            }
        }];
    }
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from propertyInfo";
    
    // Get the results.
    if (self.arrPropertyInfo != nil) {
        self.arrPropertyInfo = nil;
    }
    self.arrPropertyInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"DEBUG: select from propertyInfo is %@", self.arrPropertyInfo);
}

-(void)deleteProperty:(NSArray*) info {
    NSString *property = info[0];
    NSString *address = info[1];
    NSString *city = info[2];
    NSString *state = info[3];
    NSString *zip = info[4];
    
    // Prepare the query.
    NSString *query = [NSString stringWithFormat:@"delete from propertyInfo where property=%@ and                       address=%@ and city=%@ and state=%@ and zip=%@", property, address, city, state, zip];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // Reload the table view.
    [self loadData];
}

- (IBAction)displayPopover:(UIButton *)sender
{
    PopoverViewController * newView = [[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
    self.mortagePicker_popover = [[UIPopoverController alloc] initWithContentViewController:newView];
    
    [self.mortagePicker_popover setPopoverContentSize:CGSizeMake(200, 200)];
    [self.mortagePicker_popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)defaultLocation
{
    MKCoordinateRegion defaultRegion;
    defaultRegion.center.latitude = 37.3349732;
    defaultRegion.center.longitude = -121.880756;
    defaultRegion.span.latitudeDelta = 0.8;
    defaultRegion.span.longitudeDelta = 0.8;
    
    [self.mapView setRegion:defaultRegion animated:YES];
}

- (void)listCalculatedMortage
{
//    MKLocalSearchRequest * request = [[MKLocalSearchRequest alloc] init];
////    request.naturalLanguageQuery = self.addressQuery;
//    request.region = self.mapView.region;
//    
//    MKLocalSearch * search = [[MKLocalSearch alloc] initWithRequest:request];
//    
//    NSString * foundLocation = @"Test location";
//    NSString * locationAddr = @"Test address";
//    
//    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
//        if (response.mapItems.count == 0) {
//            NSLog(@"No record...");
//        }
//        else
//            NSLog(@"Response: %@", response);
//        for (MKMapView * mapItem in response.mapItems)
//        {
////            ModifiedAnnotation * annotation = [[ModifiedAnnotation alloc] init];
////            [annotation updateDetails:foundLocation item:mapItem addr:locationAddr];
////            [mapView addAnnotation:annotation];
//            [self defaultLocation];
//        }
//    }];
    //0:property, 1:address, 2:city, 3:state, 4:zip, 5:loan, 6:down, 7:apr, 8:terms, 9:rate, 10:latitude, 11:longitude
    for (id object in _arrPropertyInfo)
    {
        NSString *property = object[0];
        NSString *address = object[1];
        NSString *city = object[2];
        NSString *state = object[3];
        NSString *zip = object[4];
        double  loan = [object[5] doubleValue];
        double down = [object[6] doubleValue];
        double apr = [object[7] doubleValue];
        int terms = [object[8] intValue];
        double payment = [object[9] doubleValue];
        double latitude = [object[10] doubleValue];
        double longitude = [object[11] doubleValue];
        
        
        
    }
    
    CLLocationCoordinate2D sjsu_location;
    sjsu_location.latitude = SJSULat;
    sjsu_location.longitude = SJSULon;
    
    ModifiedAnnotation * annotation = [[ModifiedAnnotation alloc] init];
    annotation.coordinate = sjsu_location;
    annotation.title = @"San Jose State University";
    annotation.subtitle = @"Located in San Jose, CA";
    
    [self.mapView addAnnotation:annotation];
    
}

#pragma mark - MKMapViewDelegate Methods
- (void) mapView:(MKMapView *) mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated:YES];
}

@end
