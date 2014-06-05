//
//  Lift.h
//  DYEL
//
//  Created by Leo Martel on 6/5/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Exercise, Workout;

@interface Lift : NSManagedObject

@property (nonatomic, retain) NSNumber * reps;
@property (nonatomic, retain) Workout *workout;
@property (nonatomic, retain) Exercise *exercise;

@end
