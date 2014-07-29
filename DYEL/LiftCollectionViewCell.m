//
//  LiftCollectionViewCell.m
//  DYEL
//
//  Created by Leo Martel on 6/5/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "LiftCollectionViewCell.h"
#import "Routine.h"
#import "CoreData.h"

@interface LiftCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *repsLabel;

@end

@implementation LiftCollectionViewCell

- (void)awakeFromNib
{

    self.weightLabel.textAlignment = NSTextAlignmentCenter;
    self.repsLabel.textAlignment = NSTextAlignmentCenter;
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 10.0;
    
    
    [self addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self
                                             action:@selector(cellTapped:)]];
}

- (void)setLift:(Lift *)lift
{
    _lift = lift;
    UIColor *color;
    int delta = [lift.reps intValue] - [lift.routine.reps intValue];
    if(delta > 0 || [lift.position intValue] >= [lift.routine.sets intValue]){
        color = [UIColor greenColor];
    } else if(delta < 0){
        color = [UIColor redColor];
    } else {
        color = [UIColor blackColor];
    }
    
    self.weightLabel.text = [NSString stringWithFormat:@"%@", lift.weight];
    self.repsLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", lift.reps]
                                                                    attributes:[NSDictionary dictionaryWithObject:color
                                                                                                           forKey:NSForegroundColorAttributeName]];
    
}

- (void)cellTapped:(UITapGestureRecognizer *)sender {
    __weak LiftCollectionViewCell *this = self;
    [UIView animateWithDuration:0.25
                     animations:^{ this.alpha = 0.0; }
                     completion:^(BOOL finished) {
                         [[CoreData context] deleteObject:this.lift];
                         [(UICollectionView *)[this superview] reloadData];
                     }
     ];
}

@end
