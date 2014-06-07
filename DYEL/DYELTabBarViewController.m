//
//  DYELTabBarViewController.m
//  DYEL
//
//  Created by Leo Martel on 6/6/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "DYELTabBarViewController.h"
#import "CoreData.h"

@interface DYELTabBarViewController () <UITabBarControllerDelegate>
@property (strong, nonatomic) NSArray *landscapeControllers;
@property (strong, nonatomic) NSArray *allControllers;

@end

@implementation DYELTabBarViewController

- (void)awakeFromNib
{
    self.delegate = self;
    self.allControllers = [self viewControllers];
    NSMutableArray *canRotate = [NSMutableArray arrayWithArray: self.allControllers];
    [canRotate removeObjectAtIndex: 1]; // TODO programmatically find
    self.landscapeControllers = canRotate;
    
    if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)){
        [self setViewControllers: self.landscapeControllers];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkForPenalty];
}

- (void)checkForPenalty
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:[CoreData LAZY]]){
         [self performSegueWithIdentifier:@"Penalty Segue" sender:self];
    }
}

// Allow individual view controllers to disable rotation
- (NSUInteger)supportedInterfaceOrientations
{
    if([self.selectedViewController respondsToSelector:@selector(supportedInterfaceOrientations)]){
        return [self.selectedViewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
        [self setViewControllers: self.landscapeControllers];
    } else {
        [self setViewControllers: self.allControllers];
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UINavigationController *current = (UINavigationController *)self.selectedViewController;
    [current popToRootViewControllerAnimated:NO];
}

@end
