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

- (void) updateDetails: (NSString *) location item:(MKMapItem *)item addr: (NSString*)addrName
{
    coordinate = item.placemark.coordinate;
    title = location;
    subtitle = addrName;
}

@end
