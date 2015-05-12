//
//  StreetViewController.m
//  MortgageCalculator
//
//  Created by squall on 5/11/15.
//  Copyright (c) 2015 edu.sjsu.cmpe277. All rights reserved.
//

#import "StreetViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface StreetViewController () <GMSPanoramaViewDelegate>
@end


@implementation StreetViewController
{
    GMSPanoramaView * view_;
    BOOL configured;
}

- (void)viewDidLoad {
    // Do any additional setup after loading the view from its nib.
    // generate street view.
    view_ = [GMSPanoramaView panoramaWithFrame:CGRectZero nearCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longtitude)];
    view_.delegate = self;
    self.view = view_;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - GMSParonamaDelegate

- (void) panoramaView:(GMSPanoramaView *)panoramaView didMoveCamera:(GMSPanoramaCamera *)camera
{
    if (!configured)
    {
        GMSMarker * marker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(self.latitude, self.longtitude)];
        marker.panoramaView = view_;
        configured = YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
