//
//  DYELAppDelegate.m
//  DYEL
//
//  Created by Leo Martel on 5/31/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//


#import "DYELAppDelegate.h"
#import "DYELTabBarViewController.h"
#import "CoreData.h"
#import <StoreKit/StoreKit.h>

@interface DYELAppDelegate() <SKPaymentTransactionObserver>

@end


@implementation DYELAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    UILocalNotification *notif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(notif) [self application:application reactToNotification:notif];
    
    [CoreData resetNotifications];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Notifications
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [self application:application reactToNotification:notification];
}

- (void)application:(UIApplication *)application reactToNotification:(UILocalNotification *)notification
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:[CoreData LAZY]];
    [defaults synchronize];
    DYELTabBarViewController *root = (DYELTabBarViewController *)[application keyWindow].rootViewController;
    [root checkForPenalty];
    
    [application cancelLocalNotification:notification];
    [CoreData resetNotifications];
}

#pragma mark - Transactions
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState) {
                // Call the appropriate custom method.
            case SKPaymentTransactionStatePurchased:
                break;
            case SKPaymentTransactionStateFailed:
                // Meh they tried, we'll give it to 'em
                break;
            case SKPaymentTransactionStateRestored:
                break;
            default:
                return;
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:[CoreData LAZY]];
        [defaults synchronize];
        
        [queue finishTransaction:transaction];
        
        DYELTabBarViewController *root = (DYELTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [root.selectedViewController dismissViewControllerAnimated:YES completion:^{
            if(transaction.transactionState != SKPaymentTransactionStateFailed){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You definitely lift!"
                                                                message:[NSString stringWithFormat:@"Thanks for your honesty. You'll crush it next time!"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"I'm great!"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

@end
