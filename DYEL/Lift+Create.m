//
//  Lift+Create.m
//  DYEL
//
//  Created by Leo Martel on 6/6/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "Lift+Create.h"
#import "CoreData.h"
#import "Workout.h"
#import "Routine.h"

@implementation Lift (Create)

+ (Lift *)createLiftWithRoutine:(Routine *)routine workout:(Workout *)workout reps:(int)reps weight:(double)weight
{
    Lift *lift = [NSEntityDescription insertNewObjectForEntityForName:@"Lift"
                                               inManagedObjectContext:[CoreData context]];
    lift.reps = [NSNumber numberWithInt:reps];
    lift.weight = [NSNumber numberWithDouble:weight];
    lift.workout = workout;
    lift.routine = routine;
    lift.position = [NSNumber numberWithUnsignedInteger:routine.lifts.count - 1];
    
    // routines can be deleted, so we track our own reference to the exercise
    lift.exercise = routine.exercise;

    return lift;
}

@end
