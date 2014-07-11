//
//  Routine+Fetch.h
//  DYEL
//
//  Created by Leo Martel on 6/1/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "Routine.h"

@interface Routine (Create)

+ (Routine *)createRoutineWithExercise:(Exercise *)exercise day:(Day *)day sets:(int)sets reps:(int)reps;
+ (NSFetchRequest *)fetchRequestForDay:(Day *)day;
+ (NSFetchRequest *)fetchRequest;

- (NSNumber *)suggestWeight;

@end
