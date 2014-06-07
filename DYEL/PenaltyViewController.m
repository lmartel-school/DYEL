//
//  PenaltyViewController.m
//  DYEL
//
//  Created by Leo Martel on 6/6/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "PenaltyViewController.h"
#import "CoreData.h"
#import <StoreKit/StoreKit.h>

@interface PenaltyViewController () <SKProductsRequestDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) SKProduct *unlock;

@end

@implementation PenaltyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.spinner startAnimating];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"product_ids"
                                         withExtension:@"plist"];
    NSArray *productIdentifiers = [NSArray arrayWithContentsOfURL:url];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
                                          initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    
    // productsRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:[NSSet setWithObject:@"unlock"]];
    
    productsRequest.delegate = self;
    
    [productsRequest start];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    
    
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        NSLog(@"[Error] PenaltyViewController.m productsRequest:didReceiveResponse: invalid identifier %@", invalidIdentifier);
        [self failOutOfIAPWithAlert:true];
        return;
    }
    
    [self.spinner stopAnimating];
    self.unlock = products[0];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you even lift?"
                                                    message:[NSString stringWithFormat:@"You missed a workout yesterday. If you didn't have a genuine reason to skip, you should throw $%@ into the lazy jar.", self.unlock.price]
                                                   delegate:self
                                          cancelButtonTitle:@"No!"
                                          otherButtonTitles:@"Fine.", nil];
    [alert show];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"request - didFailWithError: %@", [[error userInfo] objectForKey:@"NSLocalizedDescription"]);
    [self failOutOfIAPWithAlert:true];
}

- (void)failOutOfIAPWithAlert:(BOOL)doAlert
{
    [self.spinner stopAnimating];
    if(doAlert){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you even lift?"
                                                        message:[NSString stringWithFormat:@"You missed a workout yesterday. You're supposed to pay a fine here, but something went wrong with the In-App Purchases pipeline."]
                                                       delegate:nil
                                              cancelButtonTitle:@"Whew!"
                                              otherButtonTitles:nil];
        [alert show];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:[CoreData LAZY]];
    [defaults synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != 1){
        [self failOutOfIAPWithAlert:false];
        return;
    }
    
    [self.spinner startAnimating];
    SKPayment *payment = [SKPayment paymentWithProduct:self.unlock];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

@end
