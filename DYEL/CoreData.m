//
//  CoreData.m
//  DYEL
//
//  Created by Leo Martel on 5/31/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "CoreData.h"
#import "Exercise+Create.h"
#import "Day+Create.h"
#import "Routine+Fetch.h"
#import "Gym+MapAnnotation.h"
#import "Workout+Create.h"
#import "Lift+Create.h"

@interface CoreData()

@property (nonatomic, readwrite, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *callbacks;

@end

@protocol hasDate <NSObject>
- (NSDate *)date;
@end

@implementation CoreData

// Public API

+ (NSString *)LAZY { return @"lazy"; }

+ (void)resetNotifications
{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone localTimeZone]];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                fromDate:[NSDate date]];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    
    [CoreData createContextWithCompletionHandler:^(BOOL success) {
        NSDate *deadline = [gregorian dateFromComponents:components];
        BOOL shouldWorkout = [[CoreData context] executeFetchRequest:[Routine fetchRequestForDay:[Day today]] error:nil].count > 0;
        
        // If the user worked out today (or didn't need to), postpone notification until tomorrow
        if(!shouldWorkout || [Workout findWorkoutsOnDate:deadline].count){
            NSDateComponents *delta = [[NSDateComponents alloc] init];
            delta.day = 1;
            deadline = [gregorian dateByAddingComponents:delta toDate:deadline options:0];
        }
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        UILocalNotification *notif = [[UILocalNotification alloc] init];
        notif.fireDate = deadline;
        notif.alertAction = @"Did you even lift?";
        notif.alertBody = @"You missed a workout! Don't make a habit of it.";
        notif.repeatInterval = NSDayCalendarUnit;
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    }];
}

+ (UIColor *)detailColor
{
    // Aqua crayon from InterfaceBuilder
    return [UIColor colorWithRed:5.0/255.0 green:133.0/255.0 blue:1.f alpha:1.f];
}

+ (NSArray *)dayNames
{
    return @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
}

+ (NSDate *)stripTimeFromDate:(NSDate *)date
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorianCalendar setTimeZone:[NSTimeZone localTimeZone]];
    NSDateComponents *components = [gregorianCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                        fromDate:date];
    return [gregorianCalendar dateFromComponents:components];
}

+ (NSArray *)filterArray:(NSArray *)array byDate:(NSDate *)date withLeftovers:(NSMutableArray *)leftovers
{
    NSMutableArray *match = [[NSMutableArray alloc] init];
    for(id<hasDate> thing in array){
        if([date compare:[CoreData stripTimeFromDate:thing.date]] == NSOrderedSame){
            [match addObject:thing];
        } else {
            [leftovers addObject:thing];
        }
    }
    return match;
}

+ (void)createContextWithCompletionHandler:(void (^)(BOOL success))completionHandler
{
    [self instanceWithCompletionHandler:completionHandler];
}

+ (NSManagedObjectContext *)context
{
    return ((CoreData *)[self instance]).managedObjectContext;
}

// Private

#define FILE_NAME @"DYEL_Data"
#define EXPECTED_CALLBACKS 4

+ (instancetype)instance
{
    return [self instanceWithCompletionHandler:nil];
}

+ (instancetype)instanceWithCompletionHandler:(void (^)(BOOL success))completionHandler
{
    static NSMutableArray *callbacks;
    static id instance;
    
    if(!callbacks){
        callbacks = [[NSMutableArray alloc] initWithCapacity:EXPECTED_CALLBACKS];
    }
    
    if(!instance){
        [callbacks addObject:completionHandler];
        if([callbacks count] == EXPECTED_CALLBACKS){
            instance = [[self alloc] initWithCompletionHandler:^(BOOL success){
                for (int i = 0; i < [callbacks count]; i++) {
                    void (^callback)(BOOL success) = callbacks[i];
                    callback(success);
                }
            }];
        }
        
    }
    return instance;
}

- (instancetype)initWithCompletionHandler:(void (^)(BOOL success))completionHandler
{
    self = [super init];
    if(self){
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                             inDomains:NSUserDomainMask] firstObject];
        url = [url URLByAppendingPathComponent:FILE_NAME];
        UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
            [document openWithCompletionHandler:^(BOOL success) {
                if (success){
                    self.managedObjectContext = document.managedObjectContext;
                    [self seed];
                } else {
                    // [[NSFileManager defaultManager] removeItemAtPath:[url path] error:nil];
                }
                completionHandler(success);
            }];
        } else {
            [document saveToURL:url
               forSaveOperation:UIDocumentSaveForCreating
              completionHandler:^(BOOL success) {
                  if (success) {
                      self.managedObjectContext = document.managedObjectContext;
                      [self seed];
                  }
                  completionHandler(success);
              }];
        }
        
    }
    return self;

}

- (void)seed
{
    NSManagedObjectContext * context = self.managedObjectContext;
    
    // Create exercises (if they don't exist)
    [Exercise exerciseWithName:@"Squat" inManagedObjectContext:context];
    [Exercise exerciseWithName:@"Deadlift" inManagedObjectContext:context];
    [Exercise exerciseWithName:@"Bench Press" inManagedObjectContext:context];
    [Exercise exerciseWithName:@"Overhead Press" inManagedObjectContext:context];
    [Exercise exerciseWithName:@"Power Clean" inManagedObjectContext:context];
    [Exercise exerciseWithName:@"Pullup" inManagedObjectContext:context];
    [Exercise exerciseWithName:@"Chinup" inManagedObjectContext:context];
    
    // Create days (if they don't exist)
    NSArray *dayNames = [CoreData dayNames];
    for (int i = 0; i < [dayNames count]; i++) {
        [Day dayWithName:dayNames[i] inManagedObjectContext:context];
    }
    
    // Hardcode the Dropbox gym (TODO: "add gym" button)
    [Gym gymWithCoordinate:CLLocationCoordinate2DMake(37.776534, -122.392107)
                             withName:@"Dropbox Gym"
               inManagedObjectContext:context];
    
    [context save:nil];
}

@end
