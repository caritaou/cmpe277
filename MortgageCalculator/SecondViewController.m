//
//  SecondViewController.m
//  MortgageCalculator
//
//  Created by mac on 4/23/15.
//  Copyright (c) 2015 edu.sjsu.cmpe277. All rights reserved.
//
#import <GoogleMaps/GoogleMaps.h>
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
    
    self._locationManager = [[CLLocationManager alloc] init];
    self._locationManager.distanceFilter = kCLDistanceFilterNone;
    self._locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self._locationManager startUpdatingLocation];
    
    CLLocationCoordinate2D currLocation = self._locationManager.location.coordinate;
    
    GMSCameraPosition * camera = [GMSCameraPosition cameraWithTarget:currLocation zoom:11];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    NSLog(@"User's location: %@", self._locationManager.location);
    self.view = mapView_;
    
    // Creates a maker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.position = currLocation;
    marker.title = @"Home";
    marker.snippet = @"Current Location";
    marker.map = mapView_;
    
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
