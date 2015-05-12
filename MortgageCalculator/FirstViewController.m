//
//  FirstViewController.m
//  MortgageCalculator
//
//  Created by mac on 4/23/15.
//  Copyright (c) 2015 edu.sjsu.cmpe277. All rights reserved.
//

#import "FirstViewController.h"
#import "DBManager.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FirstViewController ()
    
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation FirstViewController
UIPickerView *statePicker;
NSArray *_statePickerData;

NSString *property;
NSString *state = @"";
NSString *address;
NSString *city;
int zip;
double loan;
double down;
double apr;
int terms;
double rate;
double latitude;
double longitude;

//initialize error messages
NSString *errorAddress = @"";
NSString *errorCity = @"";
NSString *errorZip = @"";
NSString *errorLoan = @"";
NSString *errorDown = @"";
NSString *errorAPR = @"";
NSString *errorTerm = @"";
NSString *errorRate = @"";

NSString *house = @"House";
NSString *apt = @"Apartment";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"propertydb.sql"];
    //CREATE TABLE propertyInfo(property_type text, address text, city text, state, zip integer, loan_amount numeric, down_payment numeric, apr numeric, terms int, mortgage_rate numeric, latitude numeric, longitude numeric);
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    [_address.layer setBorderColor:[[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] CGColor]];
    _address.layer.cornerRadius = 5.0;
    [_address.layer setBorderWidth:1.0];
    
    property = house;
    _city.delegate = self;
    _stateZip.delegate = self;
    _loanAmount.delegate = self;
    _downPayment.delegate = self;
    _apr.delegate = self;
    _terms.delegate = self;
    _statePickerData = @[ @"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming"];
    
    statePicker = [[UIPickerView alloc] init];
    statePicker.delegate = self;
    statePicker.dataSource = self;
    self.statePickField.inputView = statePicker;
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
    [_statePickField setText:[_statePickerData objectAtIndex:row]];
    [[self view] endEditing:YES];
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.textColor = [UIColor blackColor];
    return YES;
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
    bool correct = true;
    NSString *errorTitle = @"Invalid Arguments";
    NSString *errorMessage = @"";
    
    //read input from textfields
    address = [self formatAddress:_address.text];
    city = _city.text;
    zip = [_stateZip.text intValue];
    loan = [_loanAmount.text doubleValue];
    down = [_downPayment.text doubleValue];
    apr = [_apr.text doubleValue];
    terms = [_terms.text intValue];
    
    correct = [self errorCheck];
    
    //equation
    //monthly payment = p ( [i(1+i)^n]/[(1+i)^(n - 1)] )
    double p = loan - down;
    double i = (apr/100) / 12;
    double n = terms * 12;
    
    rate = p * (
        (i * pow(1+i, n))
                /
        (pow(1+i, n) - 1)
    );
    
    //display mortgage rate in label
    self.paymentLabel.text = [NSString stringWithFormat:@"$%0.2f", rate];
    
    if (isnan(rate)) {
        correct = false;
        errorRate = @"Invalid Rate, make sure values entered for loan, downpayment and apr are correct\r";
    }
    
    if (!correct) {
        errorMessage = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@ %@", errorAddress,errorCity,errorZip,errorLoan,errorDown,errorAPR,errorTerm,errorRate];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorTitle
                                                  message:errorMessage
                                                  delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self.saveButton setEnabled:YES];
    }
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
    
    //check if address is a valid location, format address to remove whitespace
    NSString *createAddress = [NSString stringWithFormat:@"%@ %@ %@ %@", address, city, state, _stateZip.text];
    NSString *fullAddress = [self formatAddress:createAddress];
    NSLog(@"DEBUG: full address is %@", fullAddress);
    
    CLLocationCoordinate2D myCoordinate = kCLLocationCoordinate2DInvalid;
    myCoordinate = [self getLocationFromAddressString:fullAddress];
    
    if(state == @"") {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Save"
                                                        message:@"The state cannot be empty"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if(CLLocationCoordinate2DIsValid(myCoordinate)) {
        latitude = myCoordinate.latitude;
        longitude = myCoordinate.longitude;
        
        NSString *query = [NSString stringWithFormat:@"insert into propertyInfo values('%@', '%@', '%@', '%@', %d, %f, %f, %f, %d, %f, %f, %f)", property, address, city, state, zip, loan, down, apr, terms, rate, latitude, longitude];
        
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
        
        
        //test select to verify data inserted into table
        //    NSString *select = @"select * from propertyInfo";
        //
        //    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:select]];
        //    NSLog(@"DEBUG: select from propertyInfo is %@", results);
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Address"
                                                  message:@"The address entered did not return valid coordinates"
                                                  delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)reset:(id)sender {
    
    self.propertyTypeLabel.text = house;
    property = house;
    self.paymentLabel.text = @"0.0";
    _address.text = @"";
    _city.text = @"";
    _stateZip.text = @"";
    _loanAmount.text = @"0.0";
    _downPayment.text = @"0.0";
    _apr.text = @"0.0";
    _terms.text = @"0";
    [self.saveButton setEnabled:NO];
}

//simple error checking for user input
- (bool) errorCheck {
    bool correct = true;
    NSLog(@"DEBUG: address is %@", address);
    if(_address.text.length == 0) {
        correct = false;
        _address.textColor = [UIColor redColor];
        errorAddress = @"Address cannot be empty.\r";
    }
    
    NSLog(@"DEBUG: city is %@", city);
    if(_city.text.length == 0) {
        correct = false;
        _city.textColor = [UIColor redColor];
        errorCity = @"City cannot be empty.\r";
    }
    NSLog(@"DEBUG: zip is %d", zip);
    if(_stateZip.text.length != 5) {
        correct = false;
        _stateZip.textColor = [UIColor redColor];
        errorZip = @"Zip code must be 5 digits.\r";
    }
    NSLog(@"DEBUG: loan amount is %f", loan);
    if ([self stringIsNumeric:_loanAmount.text] == false) {
        correct = false;
        _loanAmount.textColor = [UIColor redColor];
        errorZip = @"Loan Amount is not a valid number.\r";
    }
    NSLog(@"DEBUG: down payment is %f", down);
    if ([self stringIsNumeric:_downPayment.text] == false) {
        correct = false;
        _downPayment.textColor = [UIColor redColor];
        errorZip = @"Down Payment is not a valid number.\r";
    }
    NSLog(@"DEBUG: apr is %f", apr);
    if ([self stringIsNumeric:_apr.text] == false) {
        correct = false;
        _apr.textColor = [UIColor redColor];
        errorZip = @"APR is not a valid number.\r";
    }
    NSLog(@"DEBUG: terms in years is %d", terms);
    if((_terms.text.length < 1) || (terms == 0)) {
        correct = false;
        _terms.textColor = [UIColor redColor];
        errorTerm = @"Term must be at least 1 year.\r";
    }
    
    return correct;
}

//checks if the input string is a number
-(BOOL) stringIsNumeric:(NSString *) str {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:str];
    return !!number; // If the string is not numeric, number will be nil
}

-(NSString *) formatAddress:(NSString *) str {
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    
    NSArray *parts = [str componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    str = [filteredArray componentsJoinedByString:@" "];
    return str;
}

-(CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr {
    
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}

@end
