//
//  FirstViewController.m
//  MortgageCalculator
//
//  Created by mac on 4/23/15.
//  Copyright (c) 2015 edu.sjsu.cmpe277. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController () <UIActionSheetDelegate>

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showActionSheet:(id)sender {
    NSString *house = @"House";
    NSString *apt = @"Apartment";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Choose Property Type"
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:house, apt, nil];
    [actionSheet showInView:self.view];}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (actionSheet.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0: //house
                    
                    break;
                case 1: //apt
                    break;
                default: //house
                    break;
            }
            break;
        }
        default:
            break;
    }
}
@end
