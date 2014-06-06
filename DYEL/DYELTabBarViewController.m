//
//  DYELTabBarViewController.m
//  DYEL
//
//  Created by Leo Martel on 6/6/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "DYELTabBarViewController.h"

@interface DYELTabBarViewController ()
@property (strong, nonatomic) NSArray *landscapeControllers;
@property (strong, nonatomic) NSArray *allControllers;

@end

@implementation DYELTabBarViewController

- (void)awakeFromNib
{
    self.allControllers = [self viewControllers];
    NSMutableArray *canRotate = [NSMutableArray arrayWithArray: self.allControllers];
    [canRotate removeObjectAtIndex: 1]; // TODO programmatically find
    self.landscapeControllers = canRotate;
    
    if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)){
        [self setViewControllers: self.landscapeControllers];
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

@end
