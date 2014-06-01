//
//  ExerciseAddViewController.h
//  DYEL
//
//  Created by Leo Martel on 6/1/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseAddViewController : UIViewController

@property (nonatomic, strong) void (^callback)(ExerciseAddViewController *modal);

@property (nonatomic, strong, readonly) NSString *dayName;
@property (nonatomic, readonly) int sets;
@property (nonatomic, readonly) int reps;

@end
