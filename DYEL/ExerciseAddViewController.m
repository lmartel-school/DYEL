//
//  ExerciseAddViewController.m
//  DYEL
//
//  Created by Leo Martel on 6/1/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "ExerciseAddViewController.h"
#import "CoreData.h"

@interface ExerciseAddViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) NSString *dayName;

@end

@implementation ExerciseAddViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return 7;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [CoreData dayNames][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    self.dayName = [CoreData dayNames][row];
}

@end
