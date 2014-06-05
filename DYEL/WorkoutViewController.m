//
//  WorkoutViewController.m
//  DYEL
//
//  Created by Leo Martel on 6/4/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "WorkoutViewController.h"
#import "Workout+Create.h"
#import "CoreData.h"
#import "WorkoutView.h"
#import "Routine+Fetch.h"
#import "Day+Create.h"

@interface WorkoutViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) Workout *workout;
@property (nonatomic, strong) NSArray *routines;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *pageViews;

@end

// I read a ScrollView tutorial at http://www.raywenderlich.com/10518/how-to-use-uiscrollview-to-scroll-and-zoom-content
@implementation WorkoutViewController

- (void)setGym:(Gym *)gym
{
    self.workout = [Workout workoutWithGym:gym withDate:[NSDate date] inManagedObjectContext:[CoreData context]];
    self.routines = [[CoreData context] executeFetchRequest:[Routine fetchRequestForDay:[Day today]]
                                                      error:nil
                     ];
    NSLog(@"%@", self.routines);
    NSLog(@"%@", self.workout);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)updateCurrentPage
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    self.pageControl.currentPage = page;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize navBarSize = self.navigationController.navigationBar.bounds.size;
    CGPoint origin = CGPointMake( navBarSize.width/2, navBarSize.height/2 );
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(origin.x, origin.y,
                                                                       0, 0)];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [CoreData detailColor];
    
    self.pageViews = [[NSMutableArray alloc] init];
    for(int i = 0; i < self.routines.count; i++){
        CGRect frame = self.scrollView.bounds;
        frame.origin = CGPointMake(frame.size.width * i, 0.0f);
        
        WorkoutView *newView = [[NSBundle mainBundle] loadNibNamed:@"WorkoutView" owner:self options:nil][0];
        newView.workout = self.workout;
        newView.routine = self.routines[i];
        newView.frame = frame;
        newView.backgroundColor = [CoreData detailColor];
        self.pageViews[i] = newView;
        [self.scrollView addSubview:newView];
    }
    self.pageControl.numberOfPages = self.pageViews.count;
    
    [self.navigationController.navigationBar addSubview:self.pageControl];
    
    // We set the contentHeight to 1px to prevent vertical scrolling
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.pageViews.count, 1);
    
    [self updateCurrentPage];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.pageControl removeFromSuperview];
    self.pageControl = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateCurrentPage];
}


@end
