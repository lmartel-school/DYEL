//
//  CoreData.h
//  DYEL
//
//  Created by Leo Martel on 5/31/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreData : NSObject

+ (NSArray *)dayNames;
+ (void)createContextWithCompletionHandler:(void (^)(BOOL success))completionHandler;
+ (NSManagedObjectContext *)context;

@end
