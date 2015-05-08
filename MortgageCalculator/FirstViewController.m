//
//  FirstViewController.m
//  MortgageCalculator
//
//  Created by mac on 4/23/15.
//  Copyright (c) 2015 edu.sjsu.cmpe277. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController () <UIActionSheetDelegate> {
    NSArray *states;
}
@property (weak, nonatomic) IBOutlet UILabel *propertyTypeLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end

@implementation FirstViewController

NSString *property;

NSString *house = @"House";
NSString *apt = @"Apartment";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    states=@[@"AL",@"CA", @"NY", @"WYY"];
    self.picker = [[UIPickerView alloc]init];
    self.picker.dataSource = self;
    self.picker.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showActionSheet:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Choose Property Type"
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:house, apt, nil];
    [actionSheet showInView:self.view];}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: //house
            self.propertyTypeLabel.text = house;
            property = house;
            break;
        case 1: //apt
            self.propertyTypeLabel.text = apt;
            property = apt;
            break;
        default: //house
            property = house;
        break;
    }
}

- (long)numberOfComponentsInPickerView:(UIPickerView *) pickerView {
    return 1;
}

- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return states.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return states[row];
}

//Capture selection
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    
//}

@end
