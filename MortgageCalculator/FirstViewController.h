//
//  FirstViewController.h
//  MortgageCalculator
//
//  Created by mac on 4/23/15.
//  Copyright (c) 2015 edu.sjsu.cmpe277. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UIActionSheetDelegate,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource>

-(IBAction)showActionSheet:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *propertyTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *stateZip;
@property (weak, nonatomic) IBOutlet UITextField *loanAmount;
@property (weak, nonatomic) IBOutlet UITextField *downPayment;
@property (weak, nonatomic) IBOutlet UITextField *apr;
@property (weak, nonatomic) IBOutlet UITextField *terms;
@property (weak, nonatomic) IBOutlet UIPickerView *statePicker;
@end
