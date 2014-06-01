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

@interface CoreData()

@property (nonatomic, readwrite, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *callbacks;

@end

@implementation CoreData

// Public API

+ (NSArray *)dayNames
{
    return @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
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
#define EXPECTED_CALLBACKS 2

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
//                    [[NSFileManager defaultManager] removeItemAtPath:[url path] error:nil]; // TODO REMOVE AFTER TESTING
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
    // TODO ONLY SEED WHEN DB EMPTY
    [Exercise exerciseWithName:@"Squat" inManagedObjectContext:self.managedObjectContext];
    [Exercise exerciseWithName:@"Deadlift" inManagedObjectContext:self.managedObjectContext];
    [Exercise exerciseWithName:@"Bench Press" inManagedObjectContext:self.managedObjectContext];
    [Exercise exerciseWithName:@"Overhead Press" inManagedObjectContext:self.managedObjectContext];
    [Exercise exerciseWithName:@"Power Clean" inManagedObjectContext:self.managedObjectContext];
    [Exercise exerciseWithName:@"Pullup" inManagedObjectContext:self.managedObjectContext];
    [Exercise exerciseWithName:@"Chinup" inManagedObjectContext:self.managedObjectContext];
    
    NSArray *days = [CoreData dayNames];
    for (int i = 0; i < [days count]; i++) {
        [Day dayWithName:days[i] inManagedObjectContext:self.managedObjectContext];
    }
    
    [self.managedObjectContext save:nil];
}

@end
