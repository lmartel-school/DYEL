//
//  HistoryViewController.m
//  DYEL
//
//  Created by Leo Martel on 6/6/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)setExercise:(Exercise *)exercise
{
    _exercise = exercise;
    self.title = exercise.name;
}

@end
