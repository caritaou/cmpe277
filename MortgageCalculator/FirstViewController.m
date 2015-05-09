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
NSString *state;

NSString *house = @"House";
NSString *apt = @"Apartment";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    _city.delegate = self;
    _stateZip.delegate = self;
    _loanAmount.delegate = self;
    _downPayment.delegate = self;
    _apr.delegate = self;
    _terms.delegate = self;
    _statePickerData = @[ @"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming"];
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
    state = _statePickerData[row];
    NSLog(@"DEBUG: state chosen is %@", state);
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

- (IBAction)calculateMortgage:(id)sender {
    double amount = 1234.0;
    
    //read input from textfields
    NSString *address = _address.text;
    NSString *city = _city.text;
    int zip = [_stateZip.text intValue];
    double loanAmount = [_loanAmount.text doubleValue];
    double downPayment = [_downPayment.text doubleValue];
    double apr = [_apr.text doubleValue];
    int terms = [_terms.text intValue];
    
    
    NSLog(@"DEBUG: address is %@", address);
    NSLog(@"DEBUG: city is %@", city);
    NSLog(@"DEBUG: zip is %d", zip);
    NSLog(@"DEBUG: loan amount is %f", loanAmount);
    NSLog(@"DEBUG: down payment is %f", downPayment);
    NSLog(@"DEBUG: apr is %f", apr);
    NSLog(@"DEBUG: terms in years is %d", terms);

    
    //display mortgage rate in label
    self.paymentLabel.text = [NSString stringWithFormat:@"$%f", amount];
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

// hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)dismissKeyboard
{
    [_address resignFirstResponder];
    [_city resignFirstResponder];
    [_stateZip resignFirstResponder];
    [_loanAmount resignFirstResponder];
    [_downPayment resignFirstResponder];
    [_apr resignFirstResponder];
    [_terms resignFirstResponder];
}

@end
