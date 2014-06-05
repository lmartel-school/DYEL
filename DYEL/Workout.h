//
//  Workout.h
//  DYEL
//
//  Created by Leo Martel on 6/5/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Gym, Lift;

@interface Workout : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Gym *gym;
@property (nonatomic, retain) NSSet *lifts;
@end

@interface Workout (CoreDataGeneratedAccessors)

- (void)addLiftsObject:(Lift *)value;
- (void)removeLiftsObject:(Lift *)value;
- (void)addLifts:(NSSet *)values;
- (void)removeLifts:(NSSet *)values;

@end
