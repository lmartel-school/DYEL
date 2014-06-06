//
//  Lift+Create.h
//  DYEL
//
//  Created by Leo Martel on 6/6/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "Lift.h"

@interface Lift (Create)

+ (Lift *)createLiftWithRoutine:(Routine *)routine workout:(Workout *)workout reps:(int)reps weight:(double)weight;

@end
