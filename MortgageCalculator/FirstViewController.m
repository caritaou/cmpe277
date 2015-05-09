//
//  FirstViewController.m
//  MortgageCalculator
//
//  Created by mac on 4/23/15.
//  Copyright (c) 2015 edu.sjsu.cmpe277. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController (){
NSArray *_statePickerData;
}
@end

@implementation FirstViewController

NSString *property;
NSString *address;
NSString *city;
NSString *state;
NSString *zip;

NSNumber *loanAmount;
NSNumber *downPayment;
NSNumber *apr;
NSNumber *terms; //number of years to pay off

NSString *house = @"House";
NSString *apt = @"Apartment";

- (void)viewDidLoad {
    [super viewDidLoad];
    _city.delegate = self;
    _stateZip.delegate = self;
    _loanAmount.delegate = self;
    _downPayment.delegate = self;
    _apr.delegate = self;
    _terms.delegate = self;
    _statePickerData = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5", @"Item 6"];
    self.statePicker.dataSource= self;
    self.statePicker.delegate=self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    NSLog(@"DEBUG: got here 2 %@",_statePickerData[row]);
}

// The number of columns of data
- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _statePickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _statePickerData[row];
}

- (IBAction)showActionSheet:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Choose Property Type"
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:house, apt, nil];
    [actionSheet showInView:self.view];
}

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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
