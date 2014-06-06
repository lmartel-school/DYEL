//
//  Routine+Fetch.m
//  DYEL
//
//  Created by Leo Martel on 6/1/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "Routine+Fetch.h"
#import "CoreData.h"
#import "Day+Create.h"
#import "Lift.h"
#import "Exercise.h"

@implementation Routine (Create)

+ (Routine *)createRoutineWithExercise:(Exercise *)exercise day:(Day *)day sets:(int)sets reps:(int)reps
{
    Routine *routine = [NSEntityDescription insertNewObjectForEntityForName:@"Routine"
                                                     inManagedObjectContext:[CoreData context]];
    routine.exercise = exercise;
    routine.day = day;
    routine.sets = [NSNumber numberWithInt:sets];
    routine.reps = [NSNumber numberWithInt:reps];
    routine.position = [NSNumber numberWithUnsignedInteger:[[CoreData context] countForFetchRequest:[Routine fetchRequestForDay:routine.day] error:nil] - 1];
    
    return routine;
}

+ (NSFetchRequest *)fetchRequest
{
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Routine"
                                              inManagedObjectContext:[CoreData context]];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity.name];
    request.predicate = nil;
    request.sortDescriptors = [self makeSortDescriptors];
    
    return request;
}

+ (NSFetchRequest *)fetchRequestForDay:(Day *)day
{
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Routine"
                                              inManagedObjectContext:[CoreData context]];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity.name];
    request.predicate = [NSPredicate predicateWithFormat:@"day = %@", day];
    request.sortDescriptors = [self makeSortDescriptors];
    
    return request;
}

+ (NSArray *)makeSortDescriptors
{
    return @[
             [NSSortDescriptor sortDescriptorWithKey:@"day.index"
                                           ascending:YES],
             [NSSortDescriptor sortDescriptorWithKey:@"position"
                                           ascending:YES]
             ];
}

+ (NSPredicate *)makePredicate
{
    return nil;
}

- (NSNumber *)suggestWeight
{
    // First, we check if the same exercise (for same reps) has been done today
    NSDate *today = [CoreData stripTimeFromDate:[NSDate date]];
    
    NSArray *desc = @[
                      [NSSortDescriptor sortDescriptorWithKey:@"workout.date" ascending:NO],
                      [NSSortDescriptor sortDescriptorWithKey:@"weight" ascending:NO]
                      ];
    
    NSFetchRequest *weightNow = [NSFetchRequest fetchRequestWithEntityName:@"Lift"];
    weightNow.predicate = [NSPredicate predicateWithFormat:@"exercise = %@ AND reps = %@ AND workout.date = %@", self.exercise, self.reps, today];
    weightNow.sortDescriptors = desc;
    weightNow.fetchLimit = 1;
    
    NSError *error;
    NSArray *matches = [[CoreData context] executeFetchRequest:weightNow error:&error];
    
    if (error || !matches) {
        NSLog(@"[Error] Routine+Fetch.h suggestWeight");
    } else if ([matches count]) {
        Lift *last = matches[0];
        return last.weight;
    }

    // Then, we look at the last workout and increment the weight
    NSFetchRequest *weightLast = [NSFetchRequest fetchRequestWithEntityName:@"Lift"];
    weightLast.predicate = [NSPredicate predicateWithFormat:@"exercise = %@ AND reps = %@ AND workout.date != %@", self.exercise, self.reps, today];
    weightLast.sortDescriptors = desc;
    weightLast.fetchLimit = 1;

    matches = [[CoreData context] executeFetchRequest:weightLast error:&error];
    
    if (error || !matches) {
        NSLog(@"[Error] Routine+Fetch.h");
    } else if ([matches count]) {
        Lift *last = matches[0];
        int increment;
        if([last.exercise.name isEqualToString:@"Deadlift"]){
            increment = 10.0;
        } else {
            increment = 5.0;
        }
        return [NSNumber numberWithDouble:[last.weight doubleValue] + increment];
    }

    return nil;
}


@end
