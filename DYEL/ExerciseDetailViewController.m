//
//  ExerciseDetailViewController.m
//  DYEL
//
//  Created by Leo Martel on 5/31/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "ExerciseDetailViewController.h"
#import "AnimatedGIFImageSerialization.h"

@interface ExerciseDetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ExerciseDetailViewController

- (void)setExercise:(Exercise *)exercise
{
    _exercise = exercise;
    self.title = exercise.name;
    
}

- (void)viewDidLoad
{
    self.imageView.image = [UIImage
                            animatedImageNamed:[self.exercise.name stringByAppendingString:@"-"]
                            duration:2.5f];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
