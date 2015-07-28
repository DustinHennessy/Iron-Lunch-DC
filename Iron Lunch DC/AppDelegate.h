//
//  AppDelegate.h
//  Iron Lunch DC
//
//  Created by Dustin Hennessy on 6/18/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Searches.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Searches *searchManager;

@end

