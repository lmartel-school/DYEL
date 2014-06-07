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
#import "Exercise.h"

@implementation Lift (Create)

- (NSDate *)date
{
    return self.workout.date;
}

+ (Lift *)createLiftWithRoutine:(Routine *)routine workout:(Workout *)workout reps:(int)reps weight:(double)weight
{
    Lift *lift = [NSEntityDescription insertNewObjectForEntityForName:@"Lift"
                                               inManagedObjectContext:[CoreData context]];
    lift.reps = [NSNumber numberWithInt:reps];
    lift.weight = [NSNumber numberWithDouble:weight];
    lift.workout = workout;
    lift.routine = routine;
    
    // routines can be deleted, so we track our own reference to the exercise
    lift.exercise = routine.exercise;

    lift.position = [NSNumber numberWithUnsignedInt:[self liftsForRoutine:routine inWorkout:workout].count - 1];

    return lift;
}

+ (NSArray *)liftsForRoutine:(Routine *)routine inWorkout:(Workout *)workout
{
    return [self fetchWithPredicate:[NSPredicate predicateWithFormat:@"workout = %@ AND routine = %@", workout, routine]];
}

+ (NSArray *)liftsForExercise:(Exercise *)exercise inWorkout:(Workout *)workout
{
    return [self fetchWithPredicate:[NSPredicate predicateWithFormat:@"workout = %@ AND exercise = %@", workout, exercise]];
}

+ (NSArray *)fetchWithPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Lift"];
    request.predicate = predicate;
    request.sortDescriptors = @[
                                [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES]
                                ];
    return [[CoreData context] executeFetchRequest:request error:nil];
}

@end
