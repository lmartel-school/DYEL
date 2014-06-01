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
#import "Exercise.h"

@interface RoutineTableViewController ()

@property (nonatomic, strong) NSMutableDictionary *resultsByDay;

@end

@implementation RoutineTableViewController

- (NSDictionary *)resultsByDay
{
    if(!_resultsByDay){
        _resultsByDay = [[NSMutableDictionary alloc] init];
    }
    return _resultsByDay;
}

- (void)awakeFromNib
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.title = @"Exercises";
    
    [CoreData createContextWithCompletionHandler:^(BOOL success) {
        if(success){
            self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[Routine fetchRequest]
                                                                                managedObjectContext:[CoreData context]
                                                                                  sectionNameKeyPath:nil
                                                                                           cacheName:nil];
//            [[self.fetchedResultsController fetchedObjects] makeObjectsPerformSelector:@selector(populate:) withObject:self.resultsByDay];
        } else {
            self.fetchedResultsController = nil;
            NSLog(@"[Error] RoutineTableViewController awakeFromNib");
        }
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[CoreData dayNames] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *dayName = [CoreData dayNames][section];
    return [[[self.fetchedResultsController fetchedObjects] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"day.name = %@", dayName]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [CoreData dayNames][section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Routine Cell" forIndexPath:indexPath];
    
    NSString *dayName = [CoreData dayNames][indexPath.section];
    Routine *routine = [[self.fetchedResultsController fetchedObjects] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"day.name = %@", dayName]][indexPath.row];
    
    cell.textLabel.text = routine.exercise.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@x%@", routine.sets, routine.reps];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
