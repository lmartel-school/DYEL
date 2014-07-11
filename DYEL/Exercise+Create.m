//
//  Exercise+Exercise_Create.m
//  DYEL
//
//  Created by Leo Martel on 5/31/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "Exercise+Create.h"

@implementation Exercise (Create)

+ (Exercise *)exerciseWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    Exercise *exercise = nil;
    
    if ([name length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exercise"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (error || !matches || ([matches count] > 1)) {
            NSLog(@"[Error] Exercise+Create.h");
        } else if (![matches count]) {
            exercise = [NSEntityDescription insertNewObjectForEntityForName:@"Exercise"
                                                         inManagedObjectContext:context];
            exercise.name = name;
        } else {
            exercise = [matches lastObject];
        }
    }
    
    return exercise;
}

@end
