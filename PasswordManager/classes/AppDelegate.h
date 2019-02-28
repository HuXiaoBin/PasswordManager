//
//  AppDelegate.h
//  PasswordManager
//
//  Created by J.H on 13-12-30.
//  Copyright (c) 2013年 J.H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>
{
    UIAlertView* loadingAlt;
}

@property (strong, nonatomic) UIWindow *window;

@end
