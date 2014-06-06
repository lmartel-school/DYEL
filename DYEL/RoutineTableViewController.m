//
//  RoutineTableViewController.m
//  DYEL
//
//  Created by Leo Martel on 6/1/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "RoutineTableViewController.h"
#import "CoreData.h"
#import "Routine+Fetch.h"
#import "Exercise+Create.h"
#import "ExerciseDetailViewController.h"
#import "HistoryViewController.h"
#import "Day+Create.h"

@interface RoutineTableViewController () <UITabBarControllerDelegate>

@end

@implementation RoutineTableViewController

- (void)awakeFromNib
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.title = @"Routine";
    
    [CoreData createContextWithCompletionHandler:^(BOOL success) {
        if(success){
            self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[Routine fetchRequest]
                                                                                managedObjectContext:[CoreData context]
                                                                                  sectionNameKeyPath:@"day.index"
                                                                                           cacheName:nil];
        } else {
            self.fetchedResultsController = nil;
            NSLog(@"[Error] RoutineTableViewController awakeFromNib");
        }
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[CoreData context] save:nil];
    [self.tableView setEditing:YES animated:animated];
    self.tableView.allowsSelectionDuringEditing = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController sections][section] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    int index = [[[self.fetchedResultsController sections][section] name] intValue];
    return [CoreData dayNames][index % 7]; // TODO debug why this is needed
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    if(YES){ // TODO empty sections
        Routine *routine = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Routine Cell" forIndexPath:indexPath];
        cell.textLabel.text = routine.exercise.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@x%@", routine.sets, routine.reps];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Empty Routine Cell" forIndexPath:indexPath];
        cell.textLabel.text = @"Rest";
    }
    return cell;
}

#pragma mark - Table view delegate

// Disable index (thin bar on right-hand side)
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
}


// Enable editing
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ![[[tableView cellForRowAtIndexPath:indexPath] reuseIdentifier] isEqualToString:@"Empty Routine Cell"];
}

// Enable deleting (but not inserting) from view
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[CoreData context] deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Buttons

- (IBAction)expeditePressed:(UIBarButtonItem *)sender {
    NSArray *routines = [[CoreData context] executeFetchRequest:[Routine fetchRequest] error:nil];
    for(Routine *routine in routines){
        routine.day = [routine.day prev];
    }
}

- (IBAction)postponePressed:(UIBarButtonItem *)sender {
    NSArray *routines = [[CoreData context] executeFetchRequest:[Routine fetchRequest] error:nil];
    for(Routine *routine in routines){
        routine.day = [routine.day next];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    Exercise *ex = [Exercise exerciseWithName:sender.textLabel.text inManagedObjectContext:[CoreData context]];

    if([[segue identifier] isEqualToString:@"Selection"]){
        HistoryViewController *dest = [segue destinationViewController];
        dest.exercise = ex;
    } else if([[segue identifier] isEqualToString:@"Accessory"]){
        ExerciseDetailViewController *dest = [segue destinationViewController];
        dest.exercise = ex;
    } else {
        NSLog(@"[Error] RoutineTableViewController prepareForSegue");
    }
}

@end
