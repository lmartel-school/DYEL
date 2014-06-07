//
//  HistoryViewController.m
//  DYEL
//
//  Created by Leo Martel on 6/6/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "HistoryViewController.h"
#import "LCLineChartView.h"
#import "Lift.h"
#import "Workout.h"
#import "CoreData.h"

@interface HistoryViewController ()

@property (strong, nonatomic) LCLineChartView *chartView;

@end

@implementation HistoryViewController

- (void)setExercise:(Exercise *)exercise
{
    _exercise = exercise;
    self.title = exercise.name;
    
    // First, we get the best set for each workout date
    NSArray *lifts = [exercise.lifts sortedArrayUsingDescriptors:@[
                                                  [NSSortDescriptor sortDescriptorWithKey:@"weight"
                                                                                ascending:NO],
                                                  [NSSortDescriptor sortDescriptorWithKey:@"reps"
                                                                                ascending:NO]
                                                  ]];
    NSMutableSet *dates = [[NSMutableSet alloc] init];

    lifts = [lifts filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Lift *evaluatedObject, NSDictionary *bindings) {
        NSDate *date = evaluatedObject.workout.date;
        if([dates containsObject:date]) return NO;
        [dates addObject:date];
        return YES;
    }]];

    NSDate *earliest;
    NSDate *latest;
    
    double lowest = NAN;
    double highest = NAN;
    
    for(Lift *lift in lifts){
        NSDate *next = lift.workout.date;
        double weight = [lift.weight doubleValue];
        if(!earliest || [next compare:earliest] == NSOrderedAscending) earliest = next;
        if(!latest || [next compare:latest] == NSOrderedDescending) latest = next;
        if(isnan(lowest) || weight < lowest) lowest = weight;
        if(isnan(highest) || weight > highest) highest = weight;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EE LLL dd"];
    
    LCLineChartData *dat = [LCLineChartData new];
    dat.xMin = -1;
    dat.xMax = [self.class daysBetween:earliest and:latest] + 1;
//    dat.title = @"Test";
    dat.color = [CoreData detailColor];
    dat.itemCount = lifts.count;
    dat.getData = ^LCLineChartDataItem *(NSUInteger item) {
        Lift *lift = lifts[item];
        return [LCLineChartDataItem dataItemWithX:[self.class daysBetween:earliest and:lift.workout.date]
                                                y:[lift.weight floatValue]
                                           xLabel:[dateFormatter stringFromDate:lift.workout.date]
                                        dataLabel:[NSString stringWithFormat:@" x%@", lift.reps]];
    };
    
//    self.view.autoresizesSubviews = UIViewAutoresizingFlexibleHeight;
    CGRect frame = self.view.bounds;
    frame.origin.y += 44 + 35;
    frame.size.height -= (44 + 49) + 35;
//    frame.size.height /= 2;
    self.chartView = [[LCLineChartView alloc] initWithFrame:frame];
    self.chartView.yMin = lowest - 5;
    self.chartView.yMax = highest + 5;
    self.chartView.ySteps = [self.class stepInIncrementsOf:5 from:lowest - 5 to:highest + 5];
    self.chartView.data = @[dat];
    
    self.chartView.xStepsCount = dat.xMax + 1;
    [self.chartView showLegend:NO animated:NO];
    
    [self.view addSubview:self.chartView];
}

+ (NSArray *)stepInIncrementsOf:(int)inc from:(double)min to:(double)max
{
    NSMutableArray *steps = [[NSMutableArray alloc] init];
    for(double x = min; x < max + inc; x += inc){
        [steps addObject:[[NSNumber numberWithDouble:x] stringValue]];
    }
    return steps;
}

+ (int)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2 {
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return [components day];
}

@end
