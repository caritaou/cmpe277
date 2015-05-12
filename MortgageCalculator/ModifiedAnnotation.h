//
//  ModifiedAnnotation.h
//  MortgageCalculator
//
//  Created by Thong Nguyen on 5/11/15.
//  Copyright (c) 2015 edu.sjsu.cmpe277. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ModifiedAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *property;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zip;

@property (nonatomic, copy) NSString *loan;
@property (nonatomic, copy) NSString *down;
@property (nonatomic, copy) NSString *apr;
@property (nonatomic, copy) NSString *terms;
@property (nonatomic, copy) NSString *payment;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;

//@property (nonatomic) double loan;
//@property (nonatomic) double down;
//@property (nonatomic) double apr;
//@property (nonatomic) int terms;
//@property (nonatomic) double payment;
//@property (nonatomic) double latitude;
//@property (nonatomic) double longitude;

- (void) updateDetails: (NSString *) location item:(MKMapItem *)item addr: (NSString*)addrName arr :(NSArray*)prop;
+ (MKAnnotationView *) createCustomizedAnnotation: (MKMapView *)mapView withAnnotation: (id <MKAnnotation>) annotation;

@end
