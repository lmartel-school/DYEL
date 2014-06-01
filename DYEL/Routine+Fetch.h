//
//  Routine+Fetch.h
//  DYEL
//
//  Created by Leo Martel on 6/1/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "Routine.h"

@interface Routine (Fetch)

- (void)populate:(NSMutableDictionary *)dict;
+ (NSFetchRequest *)fetchRequestForDay:(Day *)day;
+ (NSFetchRequest *)fetchRequest;

@end
