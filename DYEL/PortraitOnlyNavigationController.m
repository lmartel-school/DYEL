//
//  PortraitOnlyNavigationController.m
//  DYEL
//
//  Created by Leo Martel on 6/6/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "PortraitOnlyNavigationController.h"

@interface PortraitOnlyNavigationController ()

@end

@implementation PortraitOnlyNavigationController

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
