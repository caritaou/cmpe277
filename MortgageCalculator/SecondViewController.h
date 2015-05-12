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


@property (nonatomic, copy) NSString *cproperty;
@property (nonatomic, copy) NSString *caddress;
@property (nonatomic, copy) NSString *ccity;
@property (nonatomic, copy) NSString *cstate;
@property (nonatomic, copy) NSString *czip;

@property (nonatomic, copy) NSString *cloan;
@property (nonatomic, copy) NSString *cdown;
@property (nonatomic, copy) NSString *capr;
@property (nonatomic, copy) NSString *cterms;
@property (nonatomic, copy) NSString *cpayment;
@property (nonatomic, copy) NSString *clatitude;
@property (nonatomic, copy) NSString *clongitude;

//@property (nonatomic) double cloan;
//@property (nonatomic) double cdown;
//@property (nonatomic) double capr;
//@property (nonatomic) int cterms;
//@property (nonatomic) double cpayment;
//@property (nonatomic) double clatitude;
//@property (nonatomic) double clongtitude;

@end

