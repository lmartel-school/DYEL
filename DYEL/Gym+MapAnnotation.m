//
//  Gym+MapAnnotation.m
//  DYEL
//
//  Created by Leo Martel on 6/4/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "Gym+MapAnnotation.h"
#import <MapKit/MapKit.h>

@implementation Gym (MapAnnotation)

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    return coordinate;
}

- (NSString *)title
{
    return self.name;
}

+ (Gym *)gymWithCoordinate:(CLLocationCoordinate2D)coordinate
                  withName:(NSString *)name
    inManagedObjectContext:(NSManagedObjectContext *)context
{
    Gym *gym = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Gym"];
    request.predicate = [NSPredicate predicateWithFormat:@"latitude = %f AND longitude = %f AND name = %@", coordinate.latitude, coordinate.longitude, name];
        
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
        
    if (error || !matches || ([matches count] > 1)) {
        NSLog(@"[Error] Gym+MapAnnotation.m");
    } else if (![matches count]) {
        gym = [NSEntityDescription insertNewObjectForEntityForName:@"Gym"
                                                     inManagedObjectContext:context];
        gym.latitude = [NSNumber numberWithDouble:coordinate.latitude];
        gym.longitude = [NSNumber numberWithDouble:coordinate.longitude];
        gym.name = name;
    } else {
        gym = [matches lastObject];
    }
    
    return gym;
}

@end
