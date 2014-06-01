//
//  Day+Create.m
//  DYEL
//
//  Created by Leo Martel on 6/1/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "Day+Create.h"
#import "CoreData.h"

@implementation Day (Create)

+ (Day *)dayWithName:(NSString *)name
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Day *day = nil;
    
    if ([name length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Day"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (error || !matches || ([matches count] > 1)) {
            NSLog(@"[Error] Day+Create.h");
        } else if (![matches count]) {
            day = [NSEntityDescription insertNewObjectForEntityForName:@"Day"
                                                     inManagedObjectContext:context];
            day.name = name;
            day.index = [NSNumber numberWithUnsignedInteger:
                         [[CoreData context]
                            countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"Day"]
                            error:nil] - 1
                         ];
        } else {
            day = [matches lastObject];
        }
    }
    
    return day;
}

@end
