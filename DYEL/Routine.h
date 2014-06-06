//
//  Routine.h
//  DYEL
//
//  Created by Leo Martel on 6/5/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Day, Exercise, Lift;

@interface Routine : NSManagedObject

@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSNumber * reps;
@property (nonatomic, retain) NSNumber * sets;
@property (nonatomic, retain) Day *day;
@property (nonatomic, retain) Exercise *exercise;
@property (nonatomic, retain) NSSet *lifts;
@end

@interface Routine (CoreDataGeneratedAccessors)

- (void)addLiftsObject:(Lift *)value;
- (void)removeLiftsObject:(Lift *)value;
- (void)addLifts:(NSSet *)values;
- (void)removeLifts:(NSSet *)values;

@end
