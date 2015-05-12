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
#import "StreetViewController.h"

@implementation SecondViewController
{
    GMSMapView *mapView_;
    GMSPanoramaView *panoView_;
}

ModifiedAnnotation *marker;

@synthesize mapView;
#define SJSULat 37.3349732
#define SJSULon -121.880756

-(void) viewWillAppear:(BOOL)animated {
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"propertydb.sql"];
    [self loadData];
    [self listCalculatedMortage];
}

- (void)viewDidLoad {
    // Do any additional setup after loading the view, typically from a nib.
    // Create a GMSCameraPosition that tells the map to display the coordinate xxx
    // at zoom level 6;
//    
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

// Load data from database and store in memory
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

- (IBAction)displayPopover:(UIButton *)sender
{
    PopoverViewController * newView = [[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
    self.mortagePicker_popover = [[UIPopoverController alloc] initWithContentViewController:newView];
    
    [self.mortagePicker_popover setPopoverContentSize:CGSizeMake(200, 200)];
    [self.mortagePicker_popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}


// Use SJSU at default location
- (void)defaultLocation
{
    MKCoordinateRegion defaultRegion;
    defaultRegion.center.latitude = 37.3349732;
    defaultRegion.center.longitude = -121.880756;
    defaultRegion.span.latitudeDelta = 0.8;
    defaultRegion.span.longitudeDelta = 0.8;
    
    [self.mapView setRegion:defaultRegion animated:YES];
}

// load data from db and display on map
- (void)listCalculatedMortage
{
    // List existed data
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
        
        
        NSString * propertyTitle = @"";
        propertyTitle = [propertyTitle stringByAppendingString:@"  $"];
        propertyTitle = [propertyTitle stringByAppendingString:[NSString stringWithFormat:@"%0.2f ", loan]];
        propertyTitle = [propertyTitle stringByAppendingString: [NSString stringWithFormat:@"%0.2f ", apr ]];
        propertyTitle = [propertyTitle stringByAppendingString: [NSString stringWithFormat:@"%0.2f", payment]];
        
        
        NSString * _fulladdr = address;
        _fulladdr = [_fulladdr stringByAppendingString:@", "];
        _fulladdr = [_fulladdr stringByAppendingString:city];
        _fulladdr = [_fulladdr stringByAppendingString:@" "];
        _fulladdr = [_fulladdr stringByAppendingString:state];

        
        NSString * info_detail = address;
        info_detail = [_fulladdr stringByAppendingString:@"\r\n"];
        info_detail = [_fulladdr stringByAppendingString:city];
        info_detail = [_fulladdr stringByAppendingString:@"\r\n"];
        info_detail = [_fulladdr stringByAppendingString:state];
        
        MKLocalSearchRequest * request = [[MKLocalSearchRequest alloc] init];
        request.naturalLanguageQuery = _fulladdr;
        request.region = mapView.region;
        
        [mapView setRegion:request.region animated:YES];
        MKLocalSearch * search = [[MKLocalSearch alloc]initWithRequest:request];
        
        [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
            if (response.mapItems.count==0)
                NSLog(@"No Data");
            else
                NSLog(@"Response: ", response);
            for (MKMapItem * item in response.mapItems)
            {
                ModifiedAnnotation * annotation = [[ModifiedAnnotation alloc] init];
                [annotation updateDetails:propertyTitle item:item addr:info_detail arr:object];
                [mapView addAnnotation:annotation];
                [self defaultLocation];
            }
        }];
    }
    
//    CLLocationCoordinate2D sjsu_location;
//    sjsu_location.latitude = SJSULat;
//    sjsu_location.longitude = SJSULon;
//    
//    ModifiedAnnotation * annotation = [[ModifiedAnnotation alloc] init];
//    annotation.coordinate = sjsu_location;
//    annotation.title = @"San Jose State University";
//    annotation.subtitle = @"Located in San Jose, CA";
//    
//    [self.mapView addAnnotation:annotation];
//    
}

#pragma mark - MKMapViewDelegate Methods
- (void) mapView:(MKMapView *) mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated:YES];
}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[ModifiedAnnotation class]])
    {
        UIButton * btn_clicked = (UIButton *) control;
        NSLog(@"Clicked %@ Annotation", btn_clicked.currentTitle);
    }
}

// Override method from MapViewDelegate
// Modify annotation
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView * returnedView = nil;
    
    if ([annotation isKindOfClass:[ModifiedAnnotation class]])
    {
        returnedView = [ModifiedAnnotation createCustomizedAnnotation:self.mapView withAnnotation:annotation];
        
        UIButton * btn_streetView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn_streetView setTitle:@"Street\nView" forState:UIControlStateNormal];
        [btn_streetView addTarget:self action:@selector(openStreetView) forControlEvents:UIControlEventTouchUpInside];
        btn_streetView.frame = CGRectMake(0, 0, 60.0, 60.0);
        ((MKAnnotationView *) returnedView).rightCalloutAccessoryView = btn_streetView;
        
        UIButton * btn_delete = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn_delete setTitle:@"Delete" forState:UIControlStateNormal];
        [btn_delete addTarget:self action:@selector(deleteProperty) forControlEvents:UIControlEventTouchUpInside];
        btn_delete.frame = CGRectMake(0, 0, 60.0, 60.0);
        ((MKAnnotationView *)returnedView).leftCalloutAccessoryView = btn_delete;
        
    }
    
    return returnedView;
}

// event listener: catch annotation select event
- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[ModifiedAnnotation class]]) {
        marker = view.annotation;
        _click_addr = marker.subtitle;
        _clicked_latitude = marker.coordinate.latitude;
        _clicked_longtitude = marker.coordinate.longitude;
        
        _cproperty = marker.property;
        _caddress = marker.address;
        _ccity = marker.city;
        _cstate = marker. state;
        _czip = marker.zip;
        _cloan = marker.loan;
        _cdown = marker.down;
        _capr = marker.apr;
        _cterms = marker.terms;
        _cpayment = marker.payment;
        _clatitude = marker.latitude;
        _clongitude = marker.longitude;
        
        NSLog(@"%@ was clicked", _click_addr);
    }
}

// delete an entry from database
-(void)deleteProperty {
    // Prepare the query.
    NSString *query = [NSString stringWithFormat:@"delete from propertyInfo where property_type='%@' and address='%@' and city='%@' and state='%@' and zip=%@ and loan_amount=%@ and down_payment=%@ and apr=%@ and terms=%@ and mortgage_rate=%@ and latitude=%@ and longitude=%@" , _cproperty, _caddress, _ccity, _cstate, _czip, _cloan, _cdown, _capr, _cterms, _cpayment, _clatitude, _clongitude];
    
    // Execute the query.
    [self.dbManager executeQuery:query];

    // Remove all current annotation
    NSMutableArray * annotations = [[NSMutableArray alloc] init];
    for (id annotation in [mapView annotations])
    {
        [annotations addObject:annotation];
    }
    [mapView removeAnnotations:annotations];
    // Reload a new list of annotation
    [self loadData];
    [self listCalculatedMortage];
}


// Launch street view
- (void) openStreetView
{
    // TODO: initialize streetview
    StreetViewController * streetView = [[self storyboard] instantiateViewControllerWithIdentifier:@"StreetViewController"];
    streetView.latitude = _clicked_latitude;
    streetView.longtitude = _clicked_longtitude;
    [self.navigationController pushViewController:streetView animated:NO];
}

@end
