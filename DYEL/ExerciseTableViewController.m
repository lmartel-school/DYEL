//
//  ExerciseTableViewController.m
//  DYEL
//
//  Created by Leo Martel on 5/31/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "ExerciseTableViewController.h"
#import "ExerciseDetailViewController.h"
#import "CoreData.h"
#import "Exercise+Create.h"


@interface ExerciseTableViewController ()

@end

@implementation ExerciseTableViewController

- (void)awakeFromNib
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.title = @"Exercises";
    
    [CoreData createContextWithCompletionHandler:^(BOOL success) {
        if(success){
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exercise"];
            request.predicate = [self makePredicate];
            request.sortDescriptors = [self makeSortDescriptors];
            
            self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                managedObjectContext:[CoreData context]
                                                                                  sectionNameKeyPath:nil
                                                                                           cacheName:nil];
        } else {
            self.fetchedResultsController = nil;
            NSLog(@"[Error] ExerciseTableViewController awakeFromNib");
        }

    }];
}

-(NSArray *)makeSortDescriptors
{
    return @[
             [NSSortDescriptor sortDescriptorWithKey:@"name"
                                           ascending:YES
                                            selector:@selector(localizedStandardCompare:)]
             ];
}

-(NSPredicate *)makePredicate
{
    return nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedResultsController.fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Exercise Cell" forIndexPath:indexPath];
    
    Exercise *exercise = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = exercise.name;
    
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    ExerciseDetailViewController *dest = [segue destinationViewController];
    dest.exercise = [Exercise exerciseWithName:sender.textLabel.text inManagedObjectContext:[CoreData context]];
}

@end
