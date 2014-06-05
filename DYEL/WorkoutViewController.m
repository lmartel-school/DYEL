//
//  WorkoutViewController.m
//  DYEL
//
//  Created by Leo Martel on 6/4/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "WorkoutViewController.h"
#import "Workout+Create.h"
#import "CoreData.h"
#import "WorkoutView.h"

@interface WorkoutViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) Workout *workout;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) WorkoutView *workoutView;

@end

@implementation WorkoutViewController

- (void)setGym:(Gym *)gym
{
    self.workout = [Workout workoutWithGym:gym withDate:[NSDate date] inManagedObjectContext:[CoreData context]];
    NSLog(@"%@", self.workout);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.workoutView = [[WorkoutView alloc] init];
    // [self.scrollView addSubview:<#(UIView *)#>]
}

@end
