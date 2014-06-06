//
//  ExerciseDetailViewController.m
//  DYEL
//
//  Created by Leo Martel on 5/31/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "ExerciseDetailViewController.h"
#import "ExerciseAddViewController.h"
#import "Routine+Fetch.h"
#import "CoreData.h"
#import "Day+Create.h"

@interface ExerciseDetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ExerciseDetailViewController

- (void)setExercise:(Exercise *)exercise
{
    _exercise = exercise;
    self.title = exercise.name;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.imageView.image = [UIImage
                            animatedImageNamed:[self.exercise.name stringByAppendingString:@"-"]
                            duration:2.5f];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)unused
{
    ExerciseAddViewController *dest = [segue destinationViewController];
    __weak ExerciseDetailViewController *weakself = self;
    dest.callback = ^void(ExerciseAddViewController *modal){
        [Routine createRoutineWithExercise:weakself.exercise
                                       day:[Day dayWithName:modal.dayName inManagedObjectContext:[CoreData context]]
                                      sets:modal.sets
                                      reps:modal.reps];
        [self.tabBarController setSelectedIndex:self.tabBarController.viewControllers.count - 1];
        [self dismissViewControllerAnimated:YES completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    };
    
}


@end
