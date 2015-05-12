//
//  ModifiedAnnotation.m
//  MortgageCalculator
//
//  Created by Thong Nguyen on 5/11/15.
//  Copyright (c) 2015 edu.sjsu.cmpe277. All rights reserved.
//

#import "ModifiedAnnotation.h"

@implementation ModifiedAnnotation
@synthesize coordinate, title, subtitle;
@synthesize property, address, city, state, zip, loan, down, apr, terms, payment, latitude, longitude;

- (void) updateDetails: (NSString *) location item:(MKMapItem *)item addr: (NSString*)addrName arr:(NSArray *)prop
{
    coordinate = item.placemark.coordinate;
    title = location;
    subtitle = addrName;
    
    property = prop[0];
    address = prop[1];
    city = prop[2];
    state = prop[3];
    zip = prop[4];
    loan = prop[5];
    down = prop[6];
    apr = prop[7];
    terms = prop[8];
    payment = prop[9];
    latitude = prop[10];
    longitude = prop[11];
    
//    loan = [prop[5] doubleValue];
//    down = [prop[6] doubleValue];
//    apr = [prop[7] doubleValue];
//    terms = [prop[8] intValue];
//    payment = [prop[9] doubleValue];
//    latitude = [prop[10] doubleValue];
//    longitude = [prop[11] doubleValue];

}

+ (MKAnnotationView *) createCustomizedAnnotation:(MKMapView *)mapView withAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView * _ret_annotation = [mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([ModifiedAnnotation class])];
    
    if (_ret_annotation == nil)
    {
        _ret_annotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        ((MKAnnotationView *)_ret_annotation).canShowCallout=YES;
    }
    
    return _ret_annotation;
}

@end
