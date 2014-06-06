//
//  WorkoutView.m
//  DYEL
//
//  Created by Leo Martel on 6/5/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "WorkoutView.h"
#import "CoreData.h"
#import "Exercise.h"
#import "Lift+Create.h"
#import "LiftCollectionView.h"
#import "Routine+Fetch.h"

@interface WorkoutView()

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UITextField *weightField;

@property (weak, nonatomic) IBOutlet LiftCollectionView *liftCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIStepper *repStepper;

@end

@implementation WorkoutView

#pragma mark Initialization

- (void)awakeFromNib
{
    self.weightField.keyboardType = UIKeyboardTypeDecimalPad;
    
    // Toolbar with help from https://stackoverflow.com/questions/584538/how-to-show-button-done-on-number-pad-on-iphone
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.weightField.inputAccessoryView = numberToolbar;
    
    self.button.clipsToBounds = YES;
    self.button.layer.cornerRadius = 40.0;
    self.button.layer.borderColor = [UIColor blackColor].CGColor;
    self.button.layer.borderWidth = 1.0;
    self.button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.liftCollectionView registerNib:[UINib nibWithNibName:@"LiftCollectionViewCell" bundle:nil]
              forCellWithReuseIdentifier:@"Lift Cell"];
}

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate
{
    _delegate = delegate;
    self.liftCollectionView.delegate = delegate;
}

- (void)setDataSource:(id<UICollectionViewDataSource>)dataSource
{
    _dataSource = dataSource;
    self.liftCollectionView.dataSource = dataSource;
}

- (void)setRoutine:(Routine *)routine
{
    _routine = routine;
    self.liftCollectionView.routine = routine;
    
    self.headerLabel.text = [NSString stringWithFormat:@"%@ %@x%@", routine.exercise.name, routine.sets, routine.reps];
    [self updateProgressAnimated:NO];
    
    NSNumber *suggestion = [routine suggestWeight];
    if(suggestion) self.weightField.text = [suggestion stringValue];
    
    self.repStepper.value = [routine.reps doubleValue];
    [self repsChanged:self.repStepper];
}

- (void)setWorkout:(Workout *)workout
{
    _workout = workout;
    self.liftCollectionView.workout = self.workout;
}

- (void)updateProgressAnimated:(BOOL)animate
{
    double progress = [Lift liftsForRoutine:self.routine inWorkout:self.workout].count / [self.routine.sets doubleValue];
    [self.progress setProgress:progress
                      animated:animate];
}

#pragma mark NumberPad

- (void)cancelNumberPad
{
    [self.weightField resignFirstResponder];
    self.weightField.text = @"";
}

- (void)doneWithNumberPad
{
    [self.weightField resignFirstResponder];
}

#pragma mark Buttons

- (IBAction)repsChanged:(UIStepper *)unused {
    [self.button setTitle:[NSString stringWithFormat:@"%d", (int) self.repStepper.value]
                 forState:UIControlStateNormal];
}

- (IBAction)touchDown:(UIButton *)unused {
    self.button.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
}

- (IBAction)touchUp:(UIButton *)unused {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.button.backgroundColor = [UIColor whiteColor];
    });
}


- (IBAction)buttonPressed:(UIButton *)unused {

    if(![self.weightField.text length]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"What do you even lift?"
                                                        message:@"You need to set the amount of weight you're lifting before you can start checking off sets."
                                                       delegate:nil
                                              cancelButtonTitle:@"Lightweight baby!"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    Lift *lift = [Lift createLiftWithRoutine:self.routine
                                     workout:self.workout
                                        reps:(int) self.repStepper.value
                                      weight:self.weightField.text.doubleValue];
    
    [self.liftCollectionView reloadData];
    [self.liftCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[lift.position integerValue]
                                                                        inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    [self updateProgressAnimated:YES];
}


@end
