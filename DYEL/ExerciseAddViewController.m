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

@property (nonatomic, strong, readwrite) NSString *dayName;
@property (nonatomic, readwrite) int sets;
@property (nonatomic, readwrite) int reps;

@property (weak, nonatomic) IBOutlet UILabel *setsLabel;
@property (weak, nonatomic) IBOutlet UILabel *repsLabel;

@property (weak, nonatomic) IBOutlet UIButton *button;


@end

@implementation ExerciseAddViewController

+ (UIColor *)detailColor
{
    // Aqua crayon from InterfaceBuilder
    return [UIColor colorWithRed:5.0/255.0 green:133.0/255.0 blue:1.f alpha:1.f];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.button.backgroundColor = [UIColor whiteColor];
    
    self.button.clipsToBounds = YES;
    self.button.layer.cornerRadius = 40.0;
    
    self.button.layer.borderColor = [self.class detailColor].CGColor;
    self.button.layer.borderWidth = 1.0;
    
    self.dayName = [CoreData dayNames][0];
    self.sets = 1;
    self.reps = 1;
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

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [CoreData dayNames][row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[self.class detailColor]}];
    
    return attString;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    self.dayName = [CoreData dayNames][row];
}

#pragma mark - Steppers

- (IBAction)setsChanged:(UIStepper *)sender {
    self.sets = (int)[sender value];
    self.setsLabel.text = [NSString stringWithFormat:@"%d", self.sets];
}

- (IBAction)repsChanged:(UIStepper *)sender {
    self.reps = (int)[sender value];
    self.repsLabel.text = [NSString stringWithFormat:@"%d", self.reps];
}

#pragma mark - Button

- (IBAction)touchDown:(UIButton *)sender {
    self.button.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
}

- (IBAction)touchUp:(UIButton *)sender {
    self.button.backgroundColor = [UIColor whiteColor];
}


- (IBAction)buttonPressed:(UIButton *)sender {
    self.callback(self);
}


@end
