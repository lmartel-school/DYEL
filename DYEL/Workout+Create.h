//
//  Workout+Create.h
//  DYEL
//
//  Created by Leo Martel on 6/4/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "Workout.h"
#import "Gym.h"

@interface Workout (Create)

+ (Workout *)workoutWithGym:(Gym *)gym
                   withDate:(NSDate *)date
     inManagedObjectContext:(NSManagedObjectContext *)context;

@end
