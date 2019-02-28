//
//  AppDelegate.m
//  PasswordManager
//
//  Created by J.H on 13-12-30.
//  Copyright (c) 2013年 J.H. All rights reserved.
//

#import "AppDelegate.h"
#import "HuxbCommon.h"
#import "MainPageViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UIViewController alloc] init];
    
    [self fingerLoginAction];
    
    // 安装完首次登陆，需设置密码
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"visited"])
    {
        // 弹出密码设置框
        UIAlertView* alt = [[UIAlertView alloc] initWithTitle:@"\n请设置密码\n" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alt.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [[alt textFieldAtIndex:0] setPlaceholder:@"请输入密码"];
        [[alt textFieldAtIndex:0] setSecureTextEntry:YES];
        [[alt textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeAlphabet];
        [[alt textFieldAtIndex:1] setPlaceholder:@"请再输入一次"];
        [[alt textFieldAtIndex:1] setKeyboardType:UIKeyboardTypeAlphabet];
        alt.tag = 0;
        
        [alt show];
    }
    // 非首次登陆需输入密码
    else
    {
        // 弹出密码输入框
        UIAlertView* alt = [[UIAlertView alloc] initWithTitle:@"\n请输入密码\n" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alt.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [[alt textFieldAtIndex:0] setPlaceholder:@"请输入密码"];
        alt.tag = 1;
        
        [alt show];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

// 指纹登录
- (void)fingerLoginAction
{
    //首先判断版本
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        NSLog(@"系统版本不支持TouchID");
        return;
    }
    
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"输入密码";
    if (@available(iOS 10.0, *)) {
        //        context.localizedCancelTitle = @"22222";
    } else {
        // Fallback on earlier versions
    }
    NSError *error = nil;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"TouchID 验证成功");
                    
                    //                    MainPageViewController* mainPageViewController = [[MainPageViewController alloc] init];
                    //                    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:mainPageViewController];
                    //                    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
                    //
                    //                    self.window.rootViewController = nav;
                });
            }else if(error){
                
                switch (error.code) {
                    case LAErrorAuthenticationFailed:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 验证失败");
                        });
                        break;
                    }
                    case LAErrorUserCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被用户手动取消");
                        });
                    }
                        break;
                    case LAErrorUserFallback:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"用户不使用TouchID,选择手动输入密码");
                        });
                    }
                        break;
                    case LAErrorSystemCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                        });
                    }
                        break;
                    case LAErrorPasscodeNotSet:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无法启动,因为用户没有设置密码");
                        });
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无法启动,因为用户没有设置TouchID");
                        });
                    }
                        break;
                    case LAErrorTouchIDNotAvailable:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无效");
                        });
                    }
                        break;
                    case LAErrorTouchIDLockout:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)");
                        });
                    }
                        break;
                    case LAErrorAppCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                        });
                    }
                        break;
                    case LAErrorInvalidContext:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                        });
                    }
                        break;
                    default:
                        break;
                }
            }
        }];
        
    }else{
        NSLog(@"当前设备不支持TouchID");
    }
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(0 == buttonIndex && 0 == alertView.tag)
    {
        if ([[[alertView textFieldAtIndex:0] text] length] == 0 || [[[alertView textFieldAtIndex:1] text] length] == 0)
        {
            // 重新弹出密码设置框
            UIAlertView* alt = [[UIAlertView alloc] initWithTitle:@"\n请设置密码\n" message:@"密码不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alt.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            [[alt textFieldAtIndex:0] setPlaceholder:@"请输入密码"];
            [[alt textFieldAtIndex:0] setSecureTextEntry:YES];
            [[alt textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeAlphabet];
            [[alt textFieldAtIndex:1] setPlaceholder:@"请再输入一次"];
            [[alt textFieldAtIndex:1] setKeyboardType:UIKeyboardTypeAlphabet];
            alt.tag = 0;
            
            [alt show];
        }
        else if(![[[alertView textFieldAtIndex:0] text] isEqualToString:[[alertView textFieldAtIndex:1] text]])
        {
            // 重新弹出密码设置框
            UIAlertView* alt = [[UIAlertView alloc] initWithTitle:@"\n请设置密码\n" message:@"密码不一致,请重输!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alt.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            [[alt textFieldAtIndex:0] setPlaceholder:@"请输入密码"];
            [[alt textFieldAtIndex:0] setSecureTextEntry:YES];
            [[alt textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeAlphabet];
            [[alt textFieldAtIndex:1] setPlaceholder:@"请再输入一次"];
            [[alt textFieldAtIndex:1] setKeyboardType:UIKeyboardTypeAlphabet];
            alt.tag = 0;
            
            [alt show];
        }
        else
        {
            // 置已访问标志
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"visited"];
            // 设置用户密码
            [[NSUserDefaults standardUserDefaults] setObject:[[alertView textFieldAtIndex:0] text] forKey:@"usrPasswd"];
            
            loadingAlt = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"你的密码是%@,请牢记！",[[NSUserDefaults standardUserDefaults] objectForKey:@"usrPasswd"], nil] delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            
            [loadingAlt show];
            
            // 2秒后移除提示框
            [self performSelector:@selector(dismissAlt) withObject:nil afterDelay:2.0f];
        }
    }
    else if(0 == buttonIndex || 1 == alertView.tag)
    {
        if([[[alertView textFieldAtIndex:0] text] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"usrPasswd"]])
        {
            loadingAlt = [[UIAlertView alloc] initWithTitle:@"" message:@"密码正确，正在切换界面..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            
            [loadingAlt show];
            
            //移除提示框
            [self performSelector:@selector(dismissAlt) withObject:nil afterDelay:0.0f];
        }
        else
        {
            // 重新弹出密码输入框
            UIAlertView* alt = [[UIAlertView alloc] initWithTitle:@"\n请输入密码\n" message:@"密码不正确，请重输!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alt.alertViewStyle = UIAlertViewStyleSecureTextInput;
            [[alt textFieldAtIndex:0] setPlaceholder:@"请输入密码"];
            alt.tag = 1;
            
            [alt show];
        }
    }
}

//切换等待界面
- (void)dismissAlt
{
    [loadingAlt dismissWithClickedButtonIndex:0 animated:YES];
    
    MainPageViewController* mainPageViewController = [[MainPageViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:mainPageViewController];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
//    //去除阴影
//    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    
    self.window.rootViewController = nav;
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

@end
