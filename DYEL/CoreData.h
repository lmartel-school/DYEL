//
//  CoreData.h
//  DYEL
//
//  Created by Leo Martel on 5/31/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreData : NSObject

+ (NSString *)LAZY;

+ (void)resetNotifications;

+ (UIColor *)detailColor;
+ (NSArray *)dayNames;
+ (NSDate *)stripTimeFromDate:(NSDate *)date;
+ (NSArray *)filterArray:(NSArray *)array byDate:(NSDate *)date withLeftovers:(NSMutableArray *)leftovers;

+ (void)createContextWithCompletionHandler:(void (^)(BOOL success))completionHandler;
+ (NSManagedObjectContext *)context;

@end
