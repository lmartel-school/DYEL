//
//  Day+Create.h
//  DYEL
//
//  Created by Leo Martel on 6/1/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "Day.h"

@interface Day (Create)

+ (Day *)today;
+ (Day *)dayWithName:(NSString *)name
inManagedObjectContext:(NSManagedObjectContext *)context;

- (Day *)next;
- (Day *)prev;

@end
