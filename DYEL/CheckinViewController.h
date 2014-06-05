//
//  CheckinController.h
//  DYEL
//
//  Created by Leo Martel on 6/4/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol CheckinViewControllerDelegate; // forward declaration

@interface CheckinViewController : UIViewController
@property (nonatomic, weak) id <CheckinViewControllerDelegate> delegate;

@end

@protocol CheckinViewControllerDelegate <NSObject>
@optional
- (void)checkinViewController:(CheckinViewController *)sender didChooseAnnotation:(id <MKAnnotation>)annotation;
- (BOOL)checkinViewController:(CheckinViewController *)sender usesCalloutToChooseAnnotation:(id <MKAnnotation>)annotation;
@end
