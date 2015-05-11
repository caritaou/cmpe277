//
//  SecondViewController.m
//  MortgageCalculator
//
//  Created by mac on 4/23/15.
//  Copyright (c) 2015 edu.sjsu.cmpe277. All rights reserved.
//
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "SecondViewController.h"
#import "DBManager.h"

@interface SecondViewController ()

//@property (nonatomic, retain) CLLocationManager * locationManager;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrPropertyInfo;

@end

@implementation SecondViewController
{
    GMSMapView *mapView_;
}

- (void)viewDidLoad {
    // Do any additional setup after loading the view, typically from a nib.
    // Create a GMSCameraPosition that tells the map to display the coordinate xxx
    // at zoom level 6;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"propertydb.sql"];
    [self loadData];
    
//    self._locationManager = [[CLLocationManager alloc] init];
//    self._locationManager.distanceFilter = kCLDistanceFilterNone;
//    self._locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [self._locationManager startUpdatingLocation];
    
//    GMSCameraPosition * camera = [GMSCameraPosition cameraWithTarget:currLocation zoom:11];
    
    GMSCameraPosition * camera = [GMSCameraPosition cameraWithLatitude:37.3349732 longitude:-121.880756 zoom:13];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    mapView_.myLocationEnabled = YES; // enable current location
//    NSLog(@"Current location: %@", mapView_.myLocation.coordinate);
    self.view = mapView_;
        
    // Creates a maker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
//    marker.position = currLocation;
    marker.position = CLLocationCoordinate2DMake(37.3349732, -121.880756);
    marker.title = @"SJSU";
    marker.snippet = @"San Jose State University";
    marker.map = mapView_;
    
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

@end
