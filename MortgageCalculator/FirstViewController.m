//
//  FirstViewController.m
//  MortgageCalculator
//
//  Created by mac on 4/23/15.
//  Copyright (c) 2015 edu.sjsu.cmpe277. All rights reserved.
//

#import "FirstViewController.h"
#import "DBManager.h"

@interface FirstViewController ()
    
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation FirstViewController

NSArray *_statePickerData;

NSString *property;
NSString *state;
NSString *address;
NSString *city;
int zip;
double loan;
double down;
double apr;
int terms;
double rate;

NSString *house = @"House";
NSString *apt = @"Apartment";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"propertydb.sql"];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    property = house;
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
    address = _address.text;
    city = _city.text;
    zip = [_stateZip.text intValue];
    loan = [_loanAmount.text doubleValue];
    down = [_downPayment.text doubleValue];
    apr = [_apr.text doubleValue];
    terms = [_terms.text intValue];
    
    
    //TODO: error checking on input
    NSLog(@"DEBUG: address is %@", address);
    NSLog(@"DEBUG: city is %@", city);
    NSLog(@"DEBUG: zip is %d", zip);
    NSLog(@"DEBUG: loan amount is %f", loan);
    NSLog(@"DEBUG: down payment is %f", down);
    NSLog(@"DEBUG: apr is %f", apr);
    NSLog(@"DEBUG: terms in years is %d", terms);

    //equation
    //monthly payment = p ( [i(1+i)^n]/[(1+i)^n - 1] )
    double p = loan - down;
    double i = apr / 12;
    double n = terms / 12;
    
    rate = amount;
    //display mortgage rate in label
    self.paymentLabel.text = [NSString stringWithFormat:@"$%0.2f", amount];
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

//sqlite3
- (IBAction)saveProperty:(id)sender {
//    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
    // Prepare the query string.
    
    NSLog(@"DEBUG: property is %@", property);
    NSLog(@"DEBUG: address is %@", address);
    NSLog(@"DEBUG: city is %@", city);
    NSLog(@"DEBUG: state is %@", state);
    NSLog(@"DEBUG: zip is %d", zip);
    NSLog(@"DEBUG: loan amount is %f", loan);
    NSLog(@"DEBUG: down payment is %f", down);
    NSLog(@"DEBUG: apr is %f", apr);
    NSLog(@"DEBUG: terms in years is %d", terms);
    NSLog(@"DEBUG: rate is %f", rate);
    
    NSString *query = [NSString stringWithFormat:@"insert into propertyInfo values('%@', '%@', '%@', '%@', %d, %f, %f, %f, %d, %f)", property, address, city, state, zip, loan, down, apr, terms, rate];
    
    NSLog(@"DEBUG: query is %@", query);
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}

@end
