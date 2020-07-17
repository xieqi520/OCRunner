//
//  AppDelegate.m
//  OCRunnerDemo
//
//  Created by Jiang on 2020/5/23.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "AppDelegate.h"
#import <OCRunner/OCRunner.h>
#import <objc/message.h>
#import <OCRunner/ORSearchedFunction.h>
#import <OCRunner/ORCoreFunction.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

void testRegister1(ffi_cif *types, void* ret, void **args, void *userdata){
    *(int *)ret = 1;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    char *args[2] = {"i","d"};
    int (*func)(int a, float b) = register_function(&testRegister1, 2, args, "i");
    int res = func(100, 0.1);
    printf("%d",res);
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ViewController1" ofType:nil];
    NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [ORInterpreter excute:data];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary <NSString *, ORSearchedFunction *>*table = [ORSearchedFunction functionTableForNames:@[@"NSLog"]];
        void (*testLog)(NSString *format,...);
        testLog = table[@"NSLog"].pointer;
        testLog(@"%@",@"hahah");
    });

    
#if __x86_64__  &&  TARGET_OS_SIMULATOR  &&  !TARGET_OS_IOSMAC
    NSLog(@"SIMULATOR");
#endif
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
