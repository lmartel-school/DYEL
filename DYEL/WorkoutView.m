//
//  WorkoutView.m
//  DYEL
//
//  Created by Leo Martel on 6/5/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "WorkoutView.h"
#import "CoreData.h"

@interface WorkoutView()

@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UITextField *weightField;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation WorkoutView

- (void)awakeFromNib
{
    self.weightField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.button.clipsToBounds = YES;
    self.button.layer.cornerRadius = 40.0;
    self.button.layer.borderColor = [UIColor blackColor].CGColor;
    self.button.layer.borderWidth = 1.0;
    
    // Toolbar with help from https://stackoverflow.com/questions/584538/how-to-show-button-done-on-number-pad-on-iphone
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.weightField.inputAccessoryView = numberToolbar;
}

- (void)cancelNumberPad
{
    [self.weightField resignFirstResponder];
    self.weightField.text = @"";
}

- (void)doneWithNumberPad
{
    NSString *num = self.weightField.text;
    NSLog(@"%@", num);
    [self.weightField resignFirstResponder];
}


- (IBAction)doneClicked:(id)sender
{
    NSLog(@"Done Clicked.");
    [self.weightField endEditing:YES];
}






- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
