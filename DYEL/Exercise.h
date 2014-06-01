//
//  Exercise.h
//  DYEL
//
//  Created by Leo Martel on 6/1/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Exercise : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *routines;
@end

@interface Exercise (CoreDataGeneratedAccessors)

- (void)addRoutinesObject:(NSManagedObject *)value;
- (void)removeRoutinesObject:(NSManagedObject *)value;
- (void)addRoutines:(NSSet *)values;
- (void)removeRoutines:(NSSet *)values;

@end
