//
//  LiftCollectionView.h
//  DYEL
//
//  Created by Leo Martel on 6/5/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"
#import "Routine.h"

@interface LiftCollectionView : UICollectionView

@property (nonatomic, strong) Workout *workout;
@property (nonatomic, strong) Routine *routine;

@end
