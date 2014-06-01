//
//  Routine+Fetch.m
//  DYEL
//
//  Created by Leo Martel on 6/1/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "Routine+Fetch.h"
#import "CoreData.h"
#import "Day.h"

@implementation Routine (Fetch)

- (void)populate:(NSMutableDictionary *)dict
{
    NSMutableArray *routines = [dict objectForKey:self.day.index];
    if(!routines){
        routines = [[NSMutableArray alloc] init];
    }
    [routines addObject:self];
    [dict setObject:routines forKey:self.day.index];
}

+ (NSFetchRequest *)fetchRequest{
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Routine"
                                              inManagedObjectContext:[CoreData context]];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity.name];
    request.predicate = nil;
    request.sortDescriptors = [self makeSortDescriptors];
    
    return request;
}

+ (NSFetchRequest *)fetchRequestForDay:(Day *)day{
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
             [NSSortDescriptor sortDescriptorWithKey:@"position"
                                           ascending:YES]
             ];
}

+ (NSPredicate *)makePredicate
{
    return nil;
}


@end
