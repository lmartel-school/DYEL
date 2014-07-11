//
//  Exercise.h
//  DYEL
//
//  Created by Leo Martel on 6/5/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lift, Routine;

@interface Exercise : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *routines;
@property (nonatomic, retain) NSSet *lifts;
@end

@interface Exercise (CoreDataGeneratedAccessors)

- (void)addRoutinesObject:(Routine *)value;
- (void)removeRoutinesObject:(Routine *)value;
- (void)addRoutines:(NSSet *)values;
- (void)removeRoutines:(NSSet *)values;

- (void)addLiftsObject:(Lift *)value;
- (void)removeLiftsObject:(Lift *)value;
- (void)addLifts:(NSSet *)values;
- (void)removeLifts:(NSSet *)values;

@end
