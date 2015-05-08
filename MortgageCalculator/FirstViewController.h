//
//  FirstViewController.h
//  MortgageCalculator
//
//  Created by mac on 4/23/15.
//  Copyright (c) 2015 edu.sjsu.cmpe277. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

-(IBAction)showActionSheet:(id)sender;
-(IBAction)calculateMortgage:(id)sender;
-(IBAction)clearFields:(id)sender;

@end
