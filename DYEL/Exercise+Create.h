//
//  Exercise+Exercise_Create.h
//  DYEL
//
//  Created by Leo Martel on 5/31/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "Exercise.h"

@interface Exercise (Create)

+ (Exercise *)exerciseWithName:(NSString *)name
        inManagedObjectContext:(NSManagedObjectContext *)context;

@end
