//
//  Day+Create.h
//  DYEL
//
//  Created by Leo Martel on 6/1/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "Day.h"

@interface Day (Create)

+ (Day *)dayWithName:(NSString *)name
inManagedObjectContext:(NSManagedObjectContext *)context;

@end
