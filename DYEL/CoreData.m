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

// TODO set sensibly before submit
+ (BOOL)EMPTY_DB { return false; }
+ (BOOL)RESEED_IF_EMPTY { return true; }

+ (NSString *)LAZY { return @"lazy"; }

+ (void)resetNotifications
{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                fromDate:[NSDate date]];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    
// TODO remove after testing
//    components.hour = 19;
//    components.minute = 47;
//    components.second = 0;
    
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
    NSDateComponents *components = [gregorianCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                        fromDate:date];
    return [gregorianCalendar dateFromComponents:components];
}

+ (NSArray *)filterArray:(NSArray *)array byDate:(NSDate *)date withLeftovers:(NSMutableArray *)leftovers
{
    NSMutableArray *match = [[NSMutableArray alloc] init];
    for(id<hasDate> thing in array){
        if([date compare:thing.date] == NSOrderedSame){
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
#define EXPECTED_CALLBACKS 3

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
                    [[NSFileManager defaultManager] removeItemAtPath:[url path] error:nil]; // TODO REMOVE AFTER TESTING
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

#define SEEDED @"db_seeded"

- (void)seed
{
    NSManagedObjectContext * context = self.managedObjectContext;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                
    if([CoreData EMPTY_DB]){
        // Delete all objects in database
        NSManagedObjectModel *model = [[self.managedObjectContext persistentStoreCoordinator]
                                       managedObjectModel];
        for(NSEntityDescription *entity in model.entities){
            NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:entity.name];
            fetch.sortDescriptors = @[];
            fetch.predicate = nil;
            NSArray *all = [context executeFetchRequest:fetch error:nil];
            for (id each in all){
                [context deleteObject:each];
            }
        }
        
        [context save:nil];
        [defaults removeObjectForKey:SEEDED];
    }
    
    
    
    if(![CoreData RESEED_IF_EMPTY] || [defaults objectForKey:SEEDED]) return;
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:SEEDED];
    
    // Seed fundamental data
    Exercise *squat = [Exercise exerciseWithName:@"Squat" inManagedObjectContext:context];
    Exercise *dl = [Exercise exerciseWithName:@"Deadlift" inManagedObjectContext:context];
    Exercise *bench = [Exercise exerciseWithName:@"Bench Press" inManagedObjectContext:context];
    Exercise *ohp = [Exercise exerciseWithName:@"Overhead Press" inManagedObjectContext:context];
    Exercise *pc = [Exercise exerciseWithName:@"Power Clean" inManagedObjectContext:context];
    Exercise *pullup = [Exercise exerciseWithName:@"Pullup" inManagedObjectContext:context];
    Exercise *chinup = [Exercise exerciseWithName:@"Chinup" inManagedObjectContext:context];
    
    NSArray *dayNames = [CoreData dayNames];
    NSMutableArray *days = [[NSMutableArray alloc] init];
    for (int i = 0; i < [dayNames count]; i++) {
        Day *day = [Day dayWithName:dayNames[i] inManagedObjectContext:context];
        [days addObject:day];
    }
    
   
    // Seed example data
    [Routine createRoutineWithExercise:squat day:days[1] sets:3 reps:5];
    [Routine createRoutineWithExercise:bench day:days[1] sets:5 reps:5];
    [Routine createRoutineWithExercise:pc day:days[1] sets:5 reps:3];
    [Routine createRoutineWithExercise:chinup day:days[1] sets:3 reps:12];
    
    Routine *r1 = [Routine createRoutineWithExercise:squat day:days[3] sets:3 reps:5];
    Routine *r2 = [Routine createRoutineWithExercise:ohp day:days[3] sets:5 reps:5];
    Routine *r3 = [Routine createRoutineWithExercise:dl day:days[3] sets:1 reps:5];
    Routine *r4 = [Routine createRoutineWithExercise:pullup day:days[3] sets:3 reps:12];
    
    [Routine createRoutineWithExercise:squat day:days[5] sets:3 reps:5];
    Routine *r5 = [Routine createRoutineWithExercise:bench day:days[5] sets:5 reps:5];
    Routine *r6 = [Routine createRoutineWithExercise:pc day:days[5] sets:5 reps:3];
    Routine *r7 = [Routine createRoutineWithExercise:chinup day:days[5] sets:3 reps:12];
    
    
    Gym *gym = [Gym gymWithCoordinate:CLLocationCoordinate2DMake(37.426240, -122.175036) // roble gym coords
                  withName:@"Roble Gym"
    inManagedObjectContext:context];
    
    NSDate *today = [CoreData stripTimeFromDate:[NSDate date]];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit
                                               fromDate:today];
    NSDateComponents *delta = [[NSDateComponents alloc] init];
    delta.day = - (7 + (components.weekday - 1) + 1);
    
    NSDate *lastMon = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:today options:0];
    
    delta = [[NSDateComponents alloc] init];
    delta.day = 2;
    
    NSDate *lastWed = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:lastMon options:0];
    NSDate *lastFri = [[NSCalendar currentCalendar] dateByAddingComponents:delta toDate:lastWed options:0];
    
    
    Workout *workout = [Workout workoutWithGym:gym
                   withDate:lastWed
     inManagedObjectContext:context];
    
    [Lift createLiftWithRoutine:r1 workout:workout reps:5 weight:145];
    [Lift createLiftWithRoutine:r2 workout:workout reps:5 weight:105];
    [Lift createLiftWithRoutine:r3 workout:workout reps:5 weight:225];
    [Lift createLiftWithRoutine:r4 workout:workout reps:12 weight:0];
    
    workout = [Workout workoutWithGym:gym
                                      withDate:lastFri
                        inManagedObjectContext:context];
    
    [Lift createLiftWithRoutine:r5 workout:workout reps:5 weight:155];
    [Lift createLiftWithRoutine:r6 workout:workout reps:3 weight:95];
    [Lift createLiftWithRoutine:r7 workout:workout reps:12 weight:0];
    
    [context save:nil];
    
}

@end
