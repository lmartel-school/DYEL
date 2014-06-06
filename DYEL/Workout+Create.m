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
    
    // Strip hours/minutes/seconds from date
    date = [CoreData stripTimeFromDate:date];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Workout"];
    request.predicate = nil;
        
    NSError *error;
    
   
    NSArray *matches = [context executeFetchRequest:request error:&error];
    matches = [CoreData filterArray:matches byDate:date withLeftovers:nil];
        
    if (error || !matches || ([matches count] > 1)) {
        NSLog(@"[Error] Workout+Create.m");
    } else if (![matches count]) {
        workout = [NSEntityDescription insertNewObjectForEntityForName:@"Workout"
                                                 inManagedObjectContext:context];
        workout.gym = gym;
        workout.date = date;
    } else {
        workout = [matches lastObject];
    }
    
    return workout;

}

@end
