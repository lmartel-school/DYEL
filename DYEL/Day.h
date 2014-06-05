//
//  Day.h
//  DYEL
//
//  Created by Leo Martel on 6/5/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Routine;

@interface Day : NSManagedObject

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *routines;
@end

@interface Day (CoreDataGeneratedAccessors)

- (void)addRoutinesObject:(Routine *)value;
- (void)removeRoutinesObject:(Routine *)value;
- (void)addRoutines:(NSSet *)values;
- (void)removeRoutines:(NSSet *)values;

@end
