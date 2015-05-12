//
//  SecondViewController.h
//  MortgageCalculator
//
//  Created by mac on 4/23/15.
//  Copyright (c) 2015 edu.sjsu.cmpe277. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "DBManager.h"

@interface SecondViewController : UIViewController <MKMapViewDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrPropertyInfo;
@property (strong, nonatomic) UIPopoverController * mortagePicker_popover;
@property (nonatomic, retain) CLLocationManager * _locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) NSString * click_addr;
@property (nonatomic) double clicked_latitude;
@property (nonatomic) double clicked_longtitude;

@end

