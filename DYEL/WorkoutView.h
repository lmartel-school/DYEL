//
//  WorkoutView.h
//  DYEL
//
//  Created by Leo Martel on 6/5/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"
#import "Routine.h"

@interface WorkoutView : UIView

@property (nonatomic, strong) Routine *routine;
@property (nonatomic, strong) Workout *workout;

@property (nonatomic, weak) id <UICollectionViewDelegate> delegate;
@property (nonatomic, weak) id <UICollectionViewDataSource> dataSource;

@end
