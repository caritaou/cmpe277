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
    
//    GMSCameraPosition * camera = [GMSCameraPosition cameraWithLatitude:37.3349732 longitude:-121.880756 zoom:15];
//    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    self.view = mapView_;
//        
//    // Creates a maker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(37.3349732, -121.880756);
//    marker.title = @"SJSU";
//    marker.snippet = @"San Jose State University";
//    marker.map = mapView_;
    
    //0:property, 1:address, 2:city, 3:state, 4:zip, 5:loan, 6:down, 7:apr, 8:terms, 9:rate, 10:latitude, 11:longitude
    for (id object in _arrPropertyInfo) {
//        for (int i = 0; i < [object count]; i++) {
//            NSLog(@"DEBUG: i is %d %@", i, object[i]);
//        }
        
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

@end
