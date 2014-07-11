//
//  Gym+MapAnnotation.h
//  DYEL
//
//  Created by Leo Martel on 6/4/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "Gym.h"
#import <MapKit/MapKit.h>

@interface Gym (MapAnnotation) <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

+ (Gym *)gymWithCoordinate:(CLLocationCoordinate2D)coordinate
                  withName:(NSString *)name
    inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSArray *)allinManagedObjectContext:(NSManagedObjectContext *)context;

@end
