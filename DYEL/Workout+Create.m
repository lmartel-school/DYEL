//
//  Workout+Create.m
//  DYEL
//
//  Created by Leo Martel on 6/4/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "Workout+Create.h"
#import "CoreData.h"

@implementation Workout (Create)

+ (Workout *)workoutWithGym:(Gym *)gym
                   withDate:(NSDate *)date
     inManagedObjectContext:(NSManagedObjectContext *)context
{
    Workout *workout = nil;
    
    NSArray *workouts = [self findWorkoutsOnDate:date];
    if(!workouts){
        NSLog(@"[Error] Workout+Create.m");
    } else if (![workouts count]){
        workout = [NSEntityDescription insertNewObjectForEntityForName:@"Workout"
                                                inManagedObjectContext:context];
        workout.gym = gym;
        workout.date = date;
        [CoreData resetNotifications]; // Gym checkin disables nagging notification
    } else {
        workout = workouts.lastObject;
    }
    
    return workout;
}

+ (NSArray *)findWorkoutsOnDate:(NSDate *)date
{
    // Strip hours/minutes/seconds from date
    date = [CoreData stripTimeFromDate:date];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Workout"];
    request.predicate = nil;
    
    NSError *error;
    NSArray *matches = [[CoreData context] executeFetchRequest:request error:&error];
    matches = [CoreData filterArray:matches byDate:date withLeftovers:nil];
    
    if (error || !matches) {
        NSLog(@"[Error] Workout+Create.m findWorkoutsOnDate");
    } else {
        return matches;
    }
    
    return nil;

}

@end
