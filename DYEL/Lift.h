//
//  Lift.h
//  DYEL
//
//  Created by Leo Martel on 6/5/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Exercise, Routine, Workout;

@interface Lift : NSManagedObject

@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSNumber * reps;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) Exercise *exercise;
@property (nonatomic, retain) Routine *routine;
@property (nonatomic, retain) Workout *workout;

@end
