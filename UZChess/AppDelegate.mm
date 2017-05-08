//
//  AppDelegate.m
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/5.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import "AppDelegate.h"
#import "UZChessBoardViewController.h"
#import "UZChessGameController.h"

#include <mutex>
#include "../UZChess/ThirdSource/Stockfish/Chess/mersenne.h"
#include "../UZChess/ThirdSource/Stockfish/Chess/movepick.h"

using namespace Chess;

@interface AppDelegate ()

@property (nonatomic, weak) UZChessBoardViewController *boardViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UZChessBoardViewController *boardViewController = [[UZChessBoardViewController alloc] init];
    self.window.rootViewController = boardViewController;
    self.boardViewController = boardViewController;
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self performSelectorInBackground:@selector(inner_BackgroundInit) withObject:nil];
    
    return YES;
}

- (void)inner_BackgroundInit {
    @autoreleasepool {
        /* Chess init */
        init_mersenne();
        init_direction_table();
        init_bitboards();
        Position::init_zobrist();
        Position::init_piece_square_tables();
        MovePicker::init_phase_table();
        
        // Make random number generation less deterministic, for book moves
        int i = abs(get_system_time() % 10000);
        for (int j = 0; j < i; j++) {
            genrand_int32();
        }
        
        [self performSelectorOnMainThread:@selector(inner_BackgroundInitFinished)
                               withObject:nil
                            waitUntilDone:NO];
    }
}

- (void)inner_BackgroundInitFinished {
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
