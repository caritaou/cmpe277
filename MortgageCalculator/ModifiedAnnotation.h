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
@property (nonatomic) double lattitude;
@property (nonatomic) double longtitude;

- (void) updateDetails: (NSString *) location item:(MKMapItem *)item addr: (NSString*)addrName;
+ (MKAnnotationView *) createCustomizedAnnotation: (MKMapView *)mapView withAnnotation: (id <MKAnnotation>) annotation;

@end
