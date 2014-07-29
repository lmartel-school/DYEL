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
            day.index = [NSNumber numberWithUnsignedInteger:[[CoreData dayNames] indexOfObject:name]];
        } else {
            day = [matches lastObject];
        }
    }
    
    return day;
}

+ (Day *)today
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone localTimeZone]];
    NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger index = [weekdayComponents weekday] - 1;
    return [self dayWithName:[CoreData dayNames][index] inManagedObjectContext:[CoreData context]];
}

- (Day *)next
{
    int i = [[CoreData dayNames] indexOfObject:self.name];
    i = (i + 1) % 7;
    return [Day dayWithName:[CoreData dayNames][i] inManagedObjectContext:[CoreData context]];
}

- (Day *)prev
{
    int i = [[CoreData dayNames] indexOfObject:self.name];
    i = (i + 6) % 7;
    return [Day dayWithName:[CoreData dayNames][i] inManagedObjectContext:[CoreData context]];
}

@end
